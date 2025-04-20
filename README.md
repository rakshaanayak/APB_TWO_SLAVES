CHAPTER–1 DESIGN OVERVIEW


1.1 INTRODUCTION

The ARM Advanced Microcontroller Bus Architecture (AMBA) is an open-standard, on-chip interconnect specification used for connecting and managing functional blocks within system-on-a-chip (SoC) designs. It provides a standardized framework for high-performance communications in 16-bit and 32-bit microcontrollers, signal processors, and complex peripheral devices. The AMBA specification is built around a Master-Slave protocol, enabling efficient communication and control between different components on the chip.

1.2 FEATURES OF THE APB

Low Power Consumption: APB uses very little power, making it perfect for battery-powered devices and simple applications.

Simple Protocol: It has an easy communication method, making it simple to connect to other devices.

Single-Transaction Interface: APB processes one task at a time, which simplifies control for basic devices.

Wide Compatibility: Since it's part of the AMBA system, APB works well in many ARM-based devices.

No Burst Transfers: APB focuses on single transfers instead of handling multiple tasks at once, keeping things straightforward.

Easier Implementation: Its simple design makes it easier to build and connect peripheral devices.



1.3 SIGNAL DESCRIPTION OF APB


1.3.1 BLOCK DIAGRAM









1.3.2 PIN DESCRIPTION 

                                      SIGNALS	                       DESCRIPTION	WIDTH
Transfer
Transfer signal	APB enable signal. If high APB is activated else APB is disabled	1
PCLK
Bus clock	The rising edge of PCLK is used to time all transfers on the APB.	1
PRESETn
APB reset	The APB bus reset signal is active LOW and this signal will normally be connected directly to the system bus reset signal.	1
PADDR
APB address bus	This is the APB address bus, which may be up to 32-bits wide and is driven by the peripheral bus bridge unit.	9
PSEL1
APB select	 This signal indicates that the slave device is selected and a data transfer is required. 	1
PENABLE
APB enable	The enable signal is used to indicate the second cycle of an APB transfer. The rising edge of PENABLE occurs in the middle of the APB transfer.	1
PWRITE
APB transfer direction	When HIGH this signal indicates an APB write access and when LOW a read access.	1
PREADY
APB ready	This is an input from Slave. It is used to enter the access state.	1
PSLVERR
APB slave error	This indicates a transfer failure by the slave.	1
PRDATA
APB read data bus	The read data bus is driven by the selected slave during read cycles (when PWRITE is LOW). The read data bus can be up to 32-bits wide.	8
PWDATA
APB write data bus	The write data bus is driven by the peripheral bus bridge unit during write cycles (when PWRITE is HIGH). The write data bus can be up to 32-bits wide.	8


1.4 STATE DIAGRAM



Transitions:
IDLE → SETUP: Happens when a transfer is initiated (PREADY = 1 and transfer request occurs).
SETUP → ACCESS: Happens when PREADY = 0, meaning the system is still preparing to transfer.
ACCESS → IDLE: Happens when PREADY = 1 and the transfer completes.
IDLE (No Transfer): The system remains idle if no transfer is initiated (PREADY = 1 and no transfer).


1.4.1 IDLE STATE:
PSELx = 0, PENABLE = 0
This is the default or inactive state. No transfer is initiated here.
The system will remain in the IDLE state if PREADY = 1 and no transfer is required.
Transition occurs to the SETUP state if a transfer request is initiated (trigger not explicitly shown but implied by the transition arrow).
1.4.2. SETUP STATE:
PSELx = 1, PENABLE = 0
In this state, the peripheral select signal (PSELx) is asserted, indicating the target peripheral is selected for communication.
The system is preparing for the actual data transfer.
Transition to the ACCESS state occurs when PREADY = 0, meaning the bus is not yet ready to complete the transfer.
1.4.3. ACCESS STATE:
PSELx = 1, PENABLE = 1
This state represents the active transfer phase, where both PSELx and PENABLE are asserted.
The data transfer occurs during this state.
If PREADY = 1, indicating the bus is ready, and the transfer completes, the system transitions back to the IDLE state.
If PREADY = 0, the system stays in the ACCESS state, waiting for the bus to be ready.



















