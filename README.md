# CHAPTER–1 DESIGN OVERVIEW


 ## 1.1 INTRODUCTION
 ```
      The ARM Advanced Microcontroller Bus Architecture (AMBA) is an open-standard, on-chip interconnect specification used for connecting and managing functional blocks within system- 
      on-a-chip (SoC) designs. It provides a standardized framework for high-performance communications in 16-bit and 32-bit microcontrollers, signal processors, and complex peripheral 
      devices. The AMBA specification is built around a Master-Slave protocol, enabling efficient communication and control between different components on the chip.
   ```



## 1.2 FEATURES OF THE APB
  ```
     -Low Power Consumption: APB uses very little power, making it perfect for battery-powered devices and simple applications.
     -Simple Protocol: It has an easy communication method, making it simple to connect to other devices.
     -Single-Transaction Interface: APB processes one task at a time, which simplifies control for basic devices.
     -Wide Compatibility: Since it's part of the AMBA system, APB works well in many ARM-based devices.
     -No Burst Transfers: APB focuses on single transfers instead of handling multiple tasks at once, keeping things straightforward.
     -Easier Implementation: Its simple design makes it easier to build and connect peripheral devices.
   ```



## 1.3 DESIGN SPECIFICATION

```
The design consists of a single APB master controlled by external signals, communicating with two connected slaves. The master selects one slave at a time based on the least significant bit of the paddress. The APB is enabled only when the transfer signal is high; otherwise, it remains disabled.
1.Parallel bus operation. All the data will be captured at rising edge clock.
2.Two slave design based on 9th bit of apb_write_paddress bit it will elect the slave1 and slave2.
3.Signal priority: 1.PRESET (active low) 2. PSEL (active high) 3. PENABLE (active high) 4. PREADY (active high) 5. PWRITE
4.Data width 8 bit and address width 9 bit.
5.PWRITE=1 indicates write PWDATA to slave. PWRITE=0 indicates read PRDATA from slave.
6.Start of data transmission is indicated when PENABLE changes from low to high. End of transmission is indicated by PREADY changes from high to low.
```

## 1.3 SIGNAL DESCRIPTION OF APB



1.3.1 BLOCK DIAGRAM

![image](https://github.com/user-attachments/assets/eb0daefe-2f2a-447c-adec-b30a69f3bff8)











1.3.2 PIN DESCRIPTION 

| SIGNAL   | DESCRIPTION | WIDTH |
|----------|-------------|-------|
| Transfer | APB enable signal. If high APB is activated else APB is disabled | 1 |
| PCLK | The rising edge of PCLK is used to time all transfers on the APB. | 1 |
| PRESETn | The APB bus reset signal is active LOW and this signal will normally be connected directly to the system bus reset signal. | 1 |
| PADDR | This is the APB address bus, which may be up to 32-bits wide and is driven by the peripheral bus bridge unit. | 9 |
| PSEL1 | This signal indicates that the slave device is selected and a data transfer is required. | 1 |
| PENABLE | The enable signal is used to indicate the second cycle of an APB transfer. The rising edge of PENABLE occurs in the middle of the APB transfer. | 1 |
| PWRITE | When HIGH this signal indicates an APB write access and when LOW a read access. | 1 |
| PREADY | This is an input from Slave. It is used to enter the access state. | 1 |
| PSLVERR | This indicates a transfer failure by the slave. | 1 |
| PRDATA | The read data bus is driven by the selected slave during read cycles (when PWRITE is LOW). The read data bus can be up to 32-bits wide. | 8 |
| PWDATA | The write data bus is driven by the peripheral bus bridge unit during write cycles (when PWRITE is HIGH). The write data bus can be up to 32-bits wide. | 8 |


## 1.4 STATE DIAGRAM

![image](https://github.com/user-attachments/assets/1ab5a869-0810-4747-910a-bfb93fac0712)






Transitions:


```
IDLE → SETUP: Happens when a transfer is initiated (PREADY = 1 and transfer request occurs).

SETUP → ACCESS: Happens when PREADY = 0, meaning the system is still preparing to transfer.

ACCESS → IDLE: Happens when PREADY = 1 and the transfer completes.

IDLE (No Transfer): The system remains idle if no transfer is initiated (PREADY = 1 and no transfer).


```



1.4.1 IDLE STATE:

```

PSELx = 0, PENABLE = 0

This is the default or inactive state. No transfer is initiated here.

The system will remain in the IDLE state if PREADY = 1 and no transfer is required.

Transition occurs to the SETUP state if a transfer request is initiated (trigger not explicitly shown but implied by the transition arrow).

```



1.4.2. SETUP STATE:


```
PSELx = 1, PENABLE = 0

In this state, the peripheral select signal (PSELx) is asserted, indicating the target peripheral is selected for communication.

The system is preparing for the actual data transfer.

Transition to the ACCESS state occurs when PREADY = 0, meaning the bus is not yet ready to complete the transfer.


```

1.4.3. ACCESS STATE:


```
PSELx = 1, PENABLE = 1

This state represents the active transfer phase, where both PSELx and PENABLE are asserted.

The data transfer occurs during this state.

If PREADY = 1, indicating the bus is ready, and the transfer completes, the system transitions back to the IDLE state.

If PREADY = 0, the system stays in the ACCESS state, waiting for the bus to be ready.

```




# CHAPTER–2 ARCHITECTURE




## 2.1 STANDARD ARCHITECTURE



![image](https://github.com/user-attachments/assets/868ef8ba-c393-45f1-854e-7f85f31cc8cf)








## 2.2 APB ARCHITECTURE



![image](https://github.com/user-attachments/assets/182680cc-e577-4642-ab5f-2d03eaec64b1)


## 2.3 APB Design Specification Architecture: 



![image](https://github.com/user-attachments/assets/b3dafd5e-1e2d-4487-b965-ac5024ec4035)


## 2.4 Testbench Components: 

```
2.4.1 Interface(apb_interface.sv) 
• Interface name: apb_inf 
• Signal Declaration 
• Clocking blocks for apb_driver, apb_monitor 
• Modports for apb_driver, apb_monitor
```


```
2.4.2 Sequence_item(apb_seq_item.sv): 
• Class name: apb_seq_item 
• Derived from uvm_sequence_item 
• Input variables are declared as rand and output variables are as non-rand 
• Consists of constraints
```


```
2.4.3 Sequence(apb_sequence.sv): 
• Class name: apb_sequence 
• Derived from uvm_sequence 
• Consists of 6 methods 
• They are as follows: 
(f) Create_item 
(f) Wait_for_grant() 
(f) Randomize() 
(f) Send_request() 
(f) Wait_for_item_done() 
(f) Get_response() 
```

```
2.4.4 Sequencer(apb_sequencer.sv): 
• Class name: apb_sequencer 
• Derived from uvm_sequencer 
• Use of uvm macros for factory registration 
• Use of class constructor 
```

```
2.4.5 Driver(apb_driver.sv): 
• Class name: apb_driver 
• Virtual interface handle 
• A function build_phase(): 
 `uvm_config_db is used to bring back a configuration setting from the UVM 
configuration database 
• A task run_phase(): 
 Methods to retrieve the next sequence item from the sequencer: 
 seq_item_port to connect driver to the sequencer 
 get_next_item() to fetch the next sequence item from the sequencer 
queue 
 drive() task is called 
 item_done() method indicates to the sequencer that the current sequence 
item processing has been completed 
• Virtual task drive() 
 drive()  task is used to drive the values of the sequence item onto the DUT through 
the interface
```

```
2.4.6 Input Monitor (apb_input_monitor.sv): 
• Class name: apb_input_monitor 
• User-defined monitor class extended from uvm_monitor and register it in the uvm factory 
• Analysis port to broadcast the sequence items or transactions 
• Virtual interface handle to retrieve actual interface handle 
• Standard class constructor to create an instance for sequence_item  
• Use build_phase, and retrieve the interface handle from the configuration table 
• Create transactions by implementing run_phase to a sample DUT interface using a virtual 
interface handle 
• The write() method sends transactions to the collector component
• In apb_ip_mon, input signals are captured

```


```
2.4.7 Output Monitor (apb_output_monitor.sv): 
• Class name: apb_output_monitor 
• User-defined monitor class extended from uvm_monitor and register it in the uvm factory 
• Analysis port to broadcast the sequence items or transactions 
• Virtual interface handle to retrieve actual interface handle 
• Standard class constructor to create an instance for sequence_item  
• Use build_phase, and retrieve the interface handle from the configuration table 
• Create transactions by implementing run_phase to a sample DUT interface using a virtual 
interface handle 
• The write() method sends transactions to the collector component 
• In apb_op_mon, DUT signals are captured
```

```
2.4.8 Scoreboard(apb_scoreboard.sv): 
• Class name: apb_scoreboard 
• Derived from uvm_scoreboard 
• Establish a fifo to hold the value apb_seq_item 
• The analysis port "item_collected_export" is where the sequence items are transferred 
to the analysis component of the apb_scoreboard. 
• function build_phase () 
 creates an instance of the uvm_analysis_imp class 
• Virtual function write () 
 function used to handle the incoming mem_sequence_item objects ( transactions) 
• Virtual task run_phase ()
```

```
2.4.9 Coverage(apb_coverage.sv): 
• Class name:apb_coverage 
• This class extended from uvm_subscriber  
• Define a coverage group that contains coverpoints and cross coverage 
• Coverage group constructor is created to initialize the coverage group 
• write() method to collect data  
• Register the apb_coverage class with the UVM factory
```

```
2.4.10 Agent_Active(apb_agent_active.sv): 
• Class name:apb_agent_active 
• Define  apb_agt_active class 
 Extend apb_agt_active from uvm_agent 
 Usage of macros to register the apb_agent_active with uvmfactory 
 Creating  a class constructor 
• Declaration of an handle for apb_sequencer, apb_monitor and apb_driver
• Declartion of a flag “is_active” to determine whether the agent is active or passive 
• Implement the build phase() 
  Instantiate the monitor and sequencer 
 The build_phase of the agent class checks this flag and decides whether to 
instantiate the driver 
• Implement the connect phase() 
 Connect sequencer to driver  
 Connect monitor’s analysis port
```

```
2.4.11 Agent_Passive(apb_agent_passive.sv): 
• Class name:apb_agent_passive 
• Define  apb_agt_passive class 
 Extend apb_agt_passive from uvm_agent 
 Usage of macros to register the apb_agent_passive with uvm factory 
 Creating  a class constructor 
• Declaration of an handle for apb_sequencer, apb_monitor and apb_driver 
• Declaration of a flag “is_active” to determine whether the agent is active or passive 
• Implement the build phase() 
  Instantiate the monitor and sequencer 
 The build_phase of the agent class checks this flag and decides whether to 
instantiate the driver 
• Implement the connect phase() 
 Connect monitor’s analysis port
```

```
2.4.12 Environment(apb_env.sv): 
• Class name:apb_env 
• Define alu_env class 
 Extend apb_env from uvm_environment 
 Usage of  macros to register the apb_env with uvm factory 
 Create a class constructor 
• Declare and Instantiate agents 
   Declaration of a handle for active agent (apb_agent_active) and passive agent 
(apb_agent_passive) 
• Declare and Instantiate scoreboard 
• Declare and Instantiate coverage  
• Implement the build phase () 
  Creating an instance of all the components 
• Implement the connect phase() 
   Connecting agents and scoreboard 
Setup analysis port to transfer data from monitor to scoreboard and coverage
```

```
2.4.13 Test(apb_test.sv): 
• Class name: apb_test 
• Define apb_test class 
 Extend apb_test from uvm_test 
 Usage of macros to register the apb_test with uvm factory 
 Creating a class constructor 
 Declaration of a handle for apb_env 
• Implement the build Phase() 
 Instantiation of the apb_env in the build phase 
• Check for the end of elaboration 
• Implement the report Phase  
 Generate report 
 Print summary
```

```
2.4.14 Top(apb_top.sv): 
• Module name:apb_top 
• Includes uvm packages 
• Include uvm macros 
• Instantiation of the DUT 
• Creating Virtual Interface(vif) 
 Instantiation of vif 
 Pass the VIF to the UVM environment using `uvm_config_db. 
• Clock and reset generation  
• Start the uvm test [run_test()] 
• Waveform generation 
 ```  
 
 










