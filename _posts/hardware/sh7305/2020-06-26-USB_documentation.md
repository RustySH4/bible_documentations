---
layout: post
title: "USB 2 documentation"
date: 2020-06-26
permalink: /hardware/sh7305/usb.html
author: Yatis
---

# USB hardware documentation (*TODO*)
---

Interrupts Enable Register 1 (INTENB1) not exist because it's concern only the Host Function.<br>
Interrupt Status Register 1 (INTSTS1) not exist because it's concern only Host Function.

---

## How to power-up the USB module ?

After many tests and a lot of hours in retro-engineering on Casio USB driver, I’m able
to power-on the USB hardware module, read/write and handle some interruptions.

But I cannot notify the host and the VBUS interrupt never occur, probably a mistake
during the power-up procedure? Or a missing pin configuration?

There is my USB power-up code:
```c
#include "drivers/usb.h"
#include "hardware/sh7305/intc.h"
#include "hardware/sh7305/usb.h"
#include "hardware/sh7305/power.h"
#include "hardware/sh7305/cpg.h"
#include "utils.h"

int usb_init(void)
{
	//mask USB interrrupts
	// @note: same as SH7724
	SH7305_INTC.IMR9.USI = 1;
	SH7305_INTC.IPRF.USB = 0b0000;


	// start external clock supply (XTAL_USB) and module clock
	//TODO -> SH7305_PFC.MSELCRA.USB = 0b00;
	//TODO -> SH7305_PFC.MSELCRB.XTAL_USB = 0b00;
	*(volatile uint16_t*)0xa4050182 &= 0x3fff;	// XTAL_USB
	*(volatile uint16_t*)0xa4050180 &= 0xff3f; 	// start external module clock (for write)
	SH7305_CPG.USBCLKCR.CLKSTP = 0;			// start module clock


	// setup USB power supplie
	// @note: indicate at Section 31.5.1 USB - System control
	SH7305_POWER.MSTPCR2.USB = 0;
	SH7305_UPONCR.UPON = 0b11;


	// enable (or set?) ?????
	// @note: Casio's protocol
	*(volatile uint16_t *)0xa4d800c2 = 0x0020;


	// set the waiting cycle to be inserted before an access
	// to this module (15 cycles).
	// @note: based on Section 31.4.2 USB - CPU Bus waiting
	while (SH7305_USB.BUSWAIT.BWAIT != 0b1111)
		SH7305_USB.BUSWAIT.BWAIT = 0b1111;

	// default USB configuration
	// @note: based on Section 31.4.1 USB - System Configuration Control Register
	do { SH7305_USB.SYSCFG.WORD  = 0; } while (SH7305_USB.SYSCFG.WORD  != 0);
	do { SH7305_USB.SYSCFG.SCKE  = 1; } while (SH7305_USB.SYSCFG.SCKE  != 1);

	// reset device state control
	do { SH7305_USB.DVSTCTR.WORD = 0; } while (SH7305_USB.DVSTCTR.WORD != 0);

	// reset interruption
	do { SH7305_USB.INTENB0.WORD = 0; } while (SH7305_USB.INTENB0.WORD != 0);

	// reset buffers interruption
	do { SH7305_USB.BRDYENB.WORD = 0; } while (SH7305_USB.BRDYENB.WORD != 0);
	do { SH7305_USB.NRDYENB.WORD = 0; } while (SH7305_USB.NRDYENB.WORD != 0);
	do { SH7305_USB.BEMPENB.WORD = 0; } while (SH7305_USB.BEMPENB.WORD != 0);

	// wipe DCP configuration
	do { SH7305_USB.DCPCFG.DIR = 0; } while (SH7305_USB.DCPCFG.DIR != 0);
	do { SH7305_USB.DCPMAXP.DEVSEL = 0b0000; } while (SH7305_USB.DCPMAXP.DEVSEL != 0b0000);

	// wipe SOF control register
	do { SH7305_USB.SOFCFG.enable = 1; } while (SH7305_USB.SOFCFG.enable != 1);


	// USB initialisation
	do { SH7305_USB.SYSCFG.DRPD  = 0; } while (SH7305_USB.SYSCFG.DRPD  != 0);
	do { SH7305_USB.SYSCFG.DPRPU = 0; } while (SH7305_USB.SYSCFG.DPRPU != 0);
	do { SH7305_USB.SYSCFG.HSE   = 1; } while (SH7305_USB.SYSCFG.HSE   != 1);
	do { SH7305_USB.SYSCFG.DCFM  = 0; } while (SH7305_USB.SYSCFG.DCFM  != 0);
	do { SH7305_USB.SYSCFG.USBE  = 1; } while (SH7305_USB.SYSCFG.USBE  != 1);


	// Interruption setup
	do { SH7305_USB.INTENB0.VBSE = 1; } while (SH7305_USB.INTENB0.VBSE != 1);
	do { SH7305_USB.INTENB0.RSME = 1; } while (SH7305_USB.INTENB0.RSME != 1);
	do { SH7305_USB.INTENB0.SOFE = 0; } while (SH7305_USB.INTENB0.SOFE != 0);
	do { SH7305_USB.INTENB0.DVSE = 1; } while (SH7305_USB.INTENB0.DVSE != 1);
	do { SH7305_USB.INTENB0.CTRE = 1; } while (SH7305_USB.INTENB0.CTRE != 1);
	do { SH7305_USB.INTENB0.BEMPE = 0; } while (SH7305_USB.INTENB0.BEMPE != 0);
	do { SH7305_USB.INTENB0.NRDYE = 0; } while (SH7305_USB.INTENB0.NRDYE != 0);
	do { SH7305_USB.INTENB0.BRDYE = 1; } while (SH7305_USB.INTENB0.BRDYE != 1);


	// enable USB interrrupts
	SH7305_INTC.IPRF.USB = 0b1111;
	SH7305_INTC.IMCR9.USI = 1;
	return (0);
}
```

---

USB disasemble note: (0S 02.05.2201)


`USB.SYSCFG (0xa4d80000)`

| Bits     | Name  | R/W | Descriptions                                                                     |
|----------|-------|-----|----------------------------------------------------------------------------------|
| 15 to 11 | -     | R   | Reserved.<br>These bits are always read as 0. The write value should always be 0.|
| 10       | SCKE  | R/W | USB clock module controller (0=disable 48Mhz clock, 1=enable)                    |
| 9 to 8   | -     | R   | Reserved.<br>These bits are always read as 0. The write value should always be 0.|
| 7        | HSR   | R/W | High-speed operations enable. (0=disable, 1=enable).                             |
| 6        | DCFM  | R/W | Function Controller (0=function, 1=host).                                        |
| 5        | DRPD  | R/W | D-/+ Resistor Control (Host only) (0=pulling up disable, 1=pulling up enable)    |
| 4        | DRPU  | R/W | D+ Resistor Control (0=pulling up disable, 1=pulling up enable)                  |
| 3 to 1   | -     | R   | Reserved.<br>These bits are always read as 0. The write value should always be 0.|
| 0        | USBE  | R/W | USB module Operation Enable.                                                     |



<pre>
USB.BUSWAIT (0xa4d80002)
8 to 15		All 0		Reserved.
7		?????		Unkonown.
6		All 0		Reserved.
5		?????		Unknown.
4		All 0		Reserved.
0 to 3		BWAIT		CPU Bus Wait.

USB.SYSSTS (0xa4d80004)
11 to 15	All 0		Reserved.
10		All 1		Reserved.
2 to 9		All 0		Reserved.
0 to 1		LNST	(R)	USB Data Line Status.

USB.DVTCTR (0xa4d80008)
Unable to determine architecture for now.

USB.TESTMODE (0xa4d8000c)
Unable to determine correct architecture for now.
9 to 15		All 0		Reserved.
8		?????		Unkonown.
4 to 7		All 0		Reserved.
0 to 3		UTST (?) 	Test Mode

USB.CFIFO, USB.D0FIFO, USB.D1FIFO (0xa4d80014, 0xad80018, 0xa4d8001c)
Unable to determine architecture for now.

USB.CFIFO: (0xad80014)  -> 0x00000000
USB.D0FIFO: (0xad80018) -> 0x18303030
USB.D0FIFO: (0xad80100) -> 0x18303030
USB.D0FIFO: (0xad80120) -> 0x00000000
USB.D1FIFO: (0xad8001c) -> 0x00000000

(0xad80000) -> 0x06f1
(0xad80020) -> 0x8906
(0xad80022) -> 0x2000
(0xad80028) -> 0x8904
(0xad8002a) -> 0x0000
(0xad8002c) -> 0x8103
(0xad8002e) -> 0x2000
(0xad80030) -> 0x9d00
(0xad80036) -> 0x0010
(0xad80028) -> 0x
(0xad80028) -> 0x
(0xad80028) -> 0x






USB.CFIFOSEL (0xa4d80020)
15		RCNT		Read count mode.
12 to 14	All 0		Reserved.

0 to 3 (?)	CURPIPE		CFIFO Port Access Pipe Specification.

USB.D0FIFOSEL, USB.D1FIFOSEL (0xa4d8)



USB.INTENB0 (0xad80030)
15		VBSE		VBUS interrupt enable. (?)
14,13		All 0		Reserved.
12		DVSE		Device State Transition Interrupt Enable.
11		CTRE		Control Transfert Stage.
10		BEMPE		Buffer Empty Interrupt Enable.
9		All 0		Reserved.
8		BRDYE		Buffer Ready Interrupt Enable.
7 to 0		All 0		Reserved.




Global used by Casio:
* 0x88007400 - Indicate if the USB or the SCIF is used or not (0: not used, 1 yes)
* 0x88007402 - Indicate if USB or SCIF is currently used.
* 0x8800657c - ???? (Used by the USB handler, callback argument ?)
* 0x88006578 - ???? (Used by USB handler, USB callback ??)
* 0x88006580 - ???? (indicate USB state ?)
* 0x88004b78 - ???? (set to 0 at start of USB_init())
* 0x8800b260 - ???? (use by USB_close())
* 0x880065a4 - ???? (size = 48o)
* 0x88004850 - ???? (used by USB interrupt handler ?)

USB_open(void): (syscall 0x2ab)
	located at <0x800451d6>
	return:
		* 4  - if the USB or the SCIF is already used is already used.
		* 5  -
		* 10 -

	Use PFC.MSELCRA &= 0xff3f to disable ???


int USB_initialize(void): (syscall 0x4e3)
	Located at <0x8006d574>
	Return:
		3	If the timer 4 can not be started.

int USB_close(void): (syscall 0x4a5)
	Located at <0x8006d79e>
	Return:
		Always 0.

</pre>
