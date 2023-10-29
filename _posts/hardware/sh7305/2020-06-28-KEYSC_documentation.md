---
layout: page
title: "KEYSC - Key Scan documentation"
permalink: /hardware/sh7305/keysc.html
author: Yatis
---

# Key Scan documentation

The SH7305 have a key scan interface (KEYSC) that can set the input or output bit
numbers to be programmable. Unfortunately, there are no documentation about this
KEYSC (and the documentation on SH7724 is absolutely unusable for this part).

This section of the bible is what I could find after many tests and when I have
disassembled the Casio's interrupt handler and, precisely, the KEYSC's interrupt
(0xbe0) handler.

## WARING: I don't understand yet some register actions, so be careful!

__Chapter:__<br>
[I\] Power management of the KEYSC module<br>](#power-management-of-the-KEYSC-module)
[II\] How to handle KEYSC hardware interruption<br>](#how-to-handle-keysc-hardware-interruptions-0xbe0)
[III\] KEYSC Registers documentation<br>](#keysc-registers-documentation)

---


## Power-on / setup of the KEYSC module

Normally, you don't have to power-on manually the KEYSC module because Casio
always use it but there is a small example of (pseudo) C code to power-on the mode.

Note:<br>
You can use the KEYSC as you want because each syscall who have an action on the
keyboard setup manually the module each time and even the interuption handler
force setup the KEYSC :)

TODO: Check Port N !!!

```c
void keysc_init(void)
{
	// block KEYSC interruption
	IMR5.KEYSC = 1;				// Mask KEYSC interrupt.
 	IPRF.KEYSC = 0;				// Disable KEYSC interrupt.

	// power-on the KEYSC module
	// @note: KEYSC is using the bit 6 of the MSTPCR0 on SH7305
	MSTPCR0.KEYSC = 0;

	//TODO: set KOUTx to ouput, port N

	// Initialize KEYSC module
	// @note: this is a exemple of KEYSC configuration which scan all keys
	// and raise interupt when any keys falling, pressed, rising edge with
	// no delay on each interrupt.
	KEYSC.KIUCNTREG.KEYIE		= 1;		// enable KEYSC interrupt.
	KEYSC.KIUCNTREG.KEYIMD		= 0b00;		// use default (?) interrupt mode.
	KEYSC.KIAUTOFIXREG.ENABLE	= 1;		// enable key bounce fix (?)
	KEYSC.KIAUTOFIXREG.UNKNOWN0	= 0b100;	// unknown, use Casio's value. (autofix)
	KEYSC.KIAUTOFIXREG.UNKNOWN1 	= 0b10;		// unknown, use Casio's value. (autofix)
	KEYSC.KIUMODEREG.UNKNOWN	= 0b001;	// unknown, use Casio's value. (scan mode)
	KEYSC.KIUINTREG.KYCPU_IE	= 0b000;	// unknown, use Casio's value. (CPU interrupt request)
	KEYSC.KIUINTREG.KEYIR 		= 0b0010;	// falling + pressed + rising.
	KEYSC.KIUWSETREG.TIME		= 0x00;		// no delay between each interrupt.
	KEYSC.KIUINTERVALREG		= 0x98;		// unknown, use Casio's value. (scan interval)
	KEYSC.KYINDR.KSE7 = 0;				// do not scan this pin because it's useless.
	KEYSC.KYINDR.KSE6 = 1;				// scan: [F1],[SHIFT],[ALPHA],[x,o,T],[div],[7],[4],[1],[0]
	KEYSC.KYINDR.KSE5 = 1;				// scan: [F2],[OPT],[^2],[log],[FD],[8],[5],[2],[.]
	KEYSC.KYINDR.KSE4 = 1;				// scan: [F3],[VAR],[^],[ln],[(],[9],[6],[3],[x10]
	KEYSC.KYINDR.KSE3 = 1;				// scan: [F4],[MENU],[EXIT],[sin],[)],[DEL],[x],[+],[(-)]
	KEYSC.KYINDR.KSE2 = 1;				// scan: [F5],[left],[down],[cos],[,],[%],[-],[EXE]
	KEYSC.KYINDR.KSE1 = 1;				// scan: [F6],[up],[right],[tan],[->]
	KEYSC.KYINDR.KSE0 = 1;				// scan: [AC/ON]

	// unblock KEYSC interruption
	IPRF.KEYSC = 12;			// Set the KEYSC interrupt priority (ex: 10 / 15)
	IMCR5.KEYSC = 1;			// Clear KEYSC interrupt mask.
}
```


---


## How to handle KEYSC hardware interruptions (0xbe0)

When I have disassembly the KEYSC handler, I don't found the KEYIF bit (Key interrupt flag on SH7724)
but I found a method to erase the interruption loop and handle the KEYSC.<br>
This is typically how Casio handle the KEYSC (pseudo C code).

```c
void keysc_handler(void)
{
	// block KEYSC interruption
	IMR5.KEYSC = 1;				// Mask KEYSC interrupt.
	iprf_save = IPRF.KEYSC;			// Save IPRF configuration.
 	IPRF.KEYSC = 0;				// Disable KEYSC interrupt.

	// handle the KIUDATAx, get which key(s) has been pressed.

	// clear interruption
	// @note: It's the only way to erase interrupt loop !
	KEYSC.KIUINTREG = KEYSC.KIUINTREG;

	// unblock KEYSC interruption
	IPRF.KEYSC = iprf_save;			// Restore KEYSC interrupt priority.
	IMCR5.KEYSC = 1;			// Clear KEYSC interrupt mask.
}
```
<br>

---


## KEYSC registers documentation

After multiple tests, there is all register with bits field.
I don't understand some registers actions, so be careful !

[Registers list:]({{ site.baseurl }}/hardware/sh7305/registers_list.html#key---key-interface-unit)
* (0xa44b0000): KIUDATA0 - key input data 0
* (0xa44b0002): KIUDATA1 - key input data 1
* (0xa44b0004): KIUDATA2 - key input data 2
* (0xa44b0006): KIUDATA3 - key input data 3
* (0xa44b0008): KIUDATA4 - key input data 4
* (0xa44b000a): KIUDATA5 - key input data 5
* [(0xa44b000c); KIUCNTREG - Scan control](#kiucntreg---scan-control-address-0xa44b000c--bitmask-0x8003)
* [(0xa44b000e): KIAUTOFIXREG - Automatic key bounce setting](#kiautofixreg---automatic-key-bounce-setting-address-0xa44b000e--bitmask-0x8077)
* [(0xa44b0010): KIUMODEREG - Scan mode setting](#kiumodereg---scan-mode-setting-address-0xa44b0010--bitmask-0x0e00)
* [(0xa44b0012): KIUSTATEREG - Scan state](#kiustatereg---scan-state-address-044b0012--bitmask-0x03ff)
* [(0xa44b0014): KIUINTREG - Interrupt setting](#kiuintreg---interrupt-setting-address-0xa44b0014--bitmask-0xef7f)
* [(0xa44b0016): KIUWSETREG - Scan wait time setting](#kiuwsetreg---scan-wait-time-setting-address-0xa44b0016--bitmask-0xefff)
* [(0xa44b0018): KIUINTERVALREG - Scan interval time setting](#kiuintervalreg---scan-interval-time-setting-address-0xa44b0018--bitmask-0xffff)
* [(0xa44b001a): KOUTPINSET - KOUT line function setting](#koutpinset---kout-line-function-setting-address-0xa44b001a--bitmask-0x0fff)
* [(0xa44b001c): KINPINSET - KIN line function setting](#kinpinset---kin-line-function-setting-address-0xa44b001c--bitmask-0x00ff)


---

### KIUCNTREG - Scan control (address: 0xa44b000c && bitmask: 0x8003)

KIUCNTREG is a 16-bit readable/writable register which specifies whether or not
to use key scan interface function.

| Bit     | Bit name | Initial Value | R/W |Description                                                                       |
|---------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 15      | KEYIE    | undefined     | R/W | Key Interrupt.                                                                   |
| 14 to 2 | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 1, 0    | KEYIMD   | undefined     | R/W | Interrupt mode? (see note)                                                       |

<u>Bit 15:</u><br>
Key Scan interrupt enable:<br>
0: Disable KEYSC interrupt<br>
1: Enable KEYSC interrupt<br>

<u>Bits 1 to 0:</u><br>
Interrupt Mode:<br>
00: Interrupt works normally (and can be cleared).<br>
01: ???? (instant loop and visibly, the interrupt can not cleared...).<br>
10: ???? (wait the fist falling edge then loop; visibly, the interrupt can not cleared...).<br>
11: ???? (instant loop and visibly, the interrupt can not be cleared...).<br>

<u>Other note:</u>
* KEYSC interruption:  0x0be0
* Casio configuration: 0x8000

---


## KIAUTOFIXREG - Automatic key bounce setting (address: 0xa44b000e && bitmask: 0x8077)

KIAUTOFIXREG is a 16-bit readable/writable register which try to avoid key
bouncing (by changing internal sampling method ?).

| Bit     | Bit name | Initial Value | R/W |Description                                                                       |
|---------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 15      | KEYBE    | undefined     | R/W | Automatic key bounce function enable.              |
| 14 to 7 | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 6 to 4  | UNKNWON0 | undefined     | R/W | unknown                                                                          |
| 3       | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 2 to 0  | UNKNOWN1 | undefined     | R/W | unknown                                                                          |

<u>Bit 15:</u><br>
0: Disable key bounce auto-fix function<br>
1: Enable key bouncing auto-fix function<br>

<u>Bits 6 to 4:</u><br>
Really unknown, use Casio's configuration (0b100).<br>

<u>Bits 2 to 0:</u><br>
Really unknown, use Casio's configuration (0b010).<br>

<u>Other note:</u>
* Casio configuration: 0x8042

---


## KIUMODEREG - Scan mode setting (address: 0xa44b0010 && bitmask: 0x0e00)

KIAUTOFIXREG is a 16-bit readable/writable register which can determine module's
action when the MPU turn to sleep(?)

| Bit     | Bit name | Initial Value | R/W |Description                                                                       |
|---------|----------|---------------|:---:|----------------------------------------------------------------------------------|
| 15 to 12| -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 11 to 9 | UNKNOWN1 | undefined     | R/W | unknown, can probably be influenced by the interrupt configuration(?)            |
| 8 to 0  | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |

<u>Bit 11 and 9:</u><br>
Unknown but specially checked by the emulator's dll:<br>
001 ??? (KEYSC interrupt occur, Casio use this one)<br>
010 ??? (No interrupt)<br>
100 ??? (No interrupt)<br>
Other setting are prohibited(?)<br>

<u>Other note:</u>
* Casio configuration: 0x0200

---


## KIUSTATEREG - Scan state (address: 044b0012 && bitmask: 0x03ff)

KIUSTATEREG is a 16-bit read-only(?) register which indicate pin state(?)

| Bit     | Bit name | Initial Value | R/W |Description                                                                         |
|---------|----------|---------------|:-----:|----------------------------------------------------------------------------------|
| 15 to 10| -        | All 0         | R     | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 9 to 0  | UNKNOWN  | All 0         | R(/W?)| unknown, read only(?)                                                            |

<u>Bit 9~0:</u><br>
Really unknown, only 0 can be written ?<br>

---


## KIUINTREG - Interrupt setting (address: 0xa44b0014 && bitmask: 0xef7f)

KIUINTREG is a register that specifies the various interrupt masks. On detecting
the interrupt corresponding to the bit in this register to which software has
set 1, this module generates the KEYSC interrupt (0x0be0).

This module sets 1 to each status bit in KEYIST when a detection condition of
the corresponding interrupt source has been satisfied regardless of the set value
in KEYIR and KYCPU_IE (regardless of whether the interrupt output is enabled or disabled).

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|----------|---------------|:---:|----------------------------------------------------------------------------------|
| 15 to 13 | KYCPU_IE | unknown       | R/W | unknown                                                                          |
| 12       | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 11 to 8  | KEYIR    | unknown       | R/W | unknown                                                                          |
| 7        | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 6 to 0   | KEYIST   | unknown       | R   | Indicate what kind of interrupt occur. |

<u>Bits 15 to 13:</u>
Really unknown, seems to influence the KEYIR action.
* 000: ??? (used by Casio)
* 001: ???
* 010: ???
* 100: ???

<u>Bits 11 to 8:</u>
Enable or disable internal interrupt requests to the CPU when there is key input.
Most of all configurations will generate interuptions when a key falling edge + pressed + rising edge (multiple key enabled).
This list is not complete, but they are some important configurations:
* 0000: Disable interrupt.
* 0001: Falling edge (Generate interrupt when no key are currently pressed; the key's pressed is show only on the next interupt).
* 0010: Falling edge + pressed + rising edge (multiple key enabled).
* 0100: Falling edge + rising edge. (multiple key enabled)
* 1000: Falling edge THEN falling edge + rising edge THEN falling edge THEN falling + rising... (TODO: multiple key ?)

<u>Bits 6 to 0:</u><br>
Indicate what kind of interrupt has occured:<br>
I didn't succed to determine bit partten because some interrupt configuration<br>
(mainly 000 0001) generate not the same information than other, so pay attention).<br>
This is the list of all patern that I found:<br>
* 000 0001: First falling edge.
* 000 1110: Multiple rising edge.
* 110 0110: All key is released.
* 000 0110: One key has been released.
* 000 1111: Release or pressed (???).
* 001 0000: Multiple interruption error.

There is a list of many test that I have do to try to understand this part of
the register:
* Mode used: Falling edge. (KEYIR = 0b0001)
	* 000 0010:	One or multiple key is pressed.
	* 001 0000:	Indicate that one key has been released AND one key has
			been pressed OR indicate that the KEYSC's data is retarded
			by one (or more) interrupt.

* Mode used: Falling edge + rising edge. (KEYIR = 0b0100)
	* 000 1000:	Single key is pressed.
	* 000 0110:	One key's release but some keys is currently pressed.
	* 110 0110:	Last keys's release.
	* 000 1111:	First key is pressed.

* When I try to press and release keys during the interruption:
	* 111 0110: ??? (release or pressed)
	* 111 1110: ??? (release or like 0x06).
	* 111 1111: ??? (release or key pressed quickly).<br>
	So we can affirme that the bit 0001 0000 is used to indicate a multiple
	interruption error.

<u>Other note:</u>
* Casio configuration: 0x4800
* KEYSC interruption:  0x0be0

---


## KIUWSETREG - Scan wait time setting (address: 0xa44b0016 && bitmask: 0xefff)

KIUSTATEREG is a 16-bit readable/writable register which allow delay management
between each scan / interruption(?)

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|----------|---------------|:---:|----------------------------------------------------------------------------------|
| 15       | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 14 to 0  | KEYTIME  | unknown       | R/W | Time between each interupt(?), based on Po / RTCLK? Divisor? |

<u>Bits 14 to 0:</u>
Set the scan frequency ? (based on RTCCLK ?)<br>
Unknown for now but you can roughly refine the time between each interruption by
increasing the KEYTIME value.<br>

TODO: Find clock is used for the KEYSC (probably the RTC)<br>
TODO: Find the correlation between KEYTIME and the clock<br>
TODO: Check overclocking !<br>

<u>Other note:</u>
* Casio configuration: 0x0000

---


## KIUINTERVALREG - Scan interval time setting (address: 0xa44b0018 && bitmask: 0xffff)

KIUINTERVALREG is a 16-bit readable/writable register which allow delay
management for ????

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|----------|---------------|:---:|----------------------------------------------------------------------------------|
| 15 to 0  | unknown  | unknown       | R/W | Set the interval time befor each keyboard scan(?) |

<u>Bits 15 to 0:</u><br>
Really unknown, use Casio's configuration (0x0098)<br>

<u>Other note:</u>
* Casio configuration: 0x0098

---


## KOUTPINSET - KOUT line function setting (address: 0xa44b001a && bitmask: 0x0fff)

KYOUTDR is a 16-bit readable/writable register that stores the output data for pins
K06 to KO11. Bits KYO5DT to KYO0DT correspond respectively to pins KO11 to KO0

In order to use the key scan interface functions, the pin function controller
should be used to set the pin function settings to the key scan interface pin side.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|----------|---------------|:---:|----------------------------------------------------------------------------------|
| 15 to 12 | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 11 to 10 | KYO5DT   | 0b11          | R/W | Control output data of pin KEYOUT5.                                              |
| 9 to 8   | KYO4DT   | 0b11          | R/W | Control output data of pin KEYOUT4.                                              |
| 7 to 6   | KYO3DT   | 0b11          | R/W | Control output data of pin KEYOUT3.                                              |
| 5 to 4   | KYO2DT   | 0b11          | R/W | Control output data of pin KEYOUT2.                                              |
| 3 to 2   | KYO1DT   | 0b11          | R/W | Control output data of pin KEYOUT1.                                              |
| 1 to 0   | KYO0DT   | 0b11          | R/W | Control output data of pin KEYOUT0.                                              |

<u>KYOnDT:</u><br>
00: Low-level output<br>
01: High-level output<br>
10: High-impedance state<br>
11: High-impedance state<br>

<u>Other note:</u>
* Casio configuration: 0x0fff
* SH7724 have similar register (KEYSC.KYOUTDR)

---


### KINPINSET - KIN line function setting (address: 0xa44b001c && bitmask: 0x00ff)

KINPINSET enables or disables the key input via the KEY7 to KEY0 pins.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|----------|---------------|:---:|----------------------------------------------------------------------------------|
| 15 to 8  | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 7        | KSE7     | 0             | R/W | Key Scan Input/Output Enable 7                                                   |
| 6        | KSE6     | 0             | R/W | Key Scan Input/Output Enable 6                                                   |
| 5        | KSE5     | 0             | R/W | Key Scan Input/Output Enable 5                                                   |
| 4        | KSE4     | 0             | R/W | Key Scan Input/Output Enable 4                                                   |
| 3        | KSE3     | 0             | R/W | Key Scan Input/Output Enable 3                                                   |
| 2        | KSE2     | 0             | R/W | Key Scan Input/Output Enable 2                                                   |
| 1        | KSE1     | 0             | R/W | Key Scan Input/Output Enable 1                                                   |
| 0        | KSE0     | 0             | R/W | Key Scan Input/Output Enable 0                                                   |

<u>KEYINx bit enables or disables the key input via the KEYx pin:</u><br>
0: disables key input<br>
1: enable key input<br>

<u>Key list:</u><br>
* KSE7: Nothing<br>
* KSE6: [F1], [SHIFT], [ALPHA], [x,o,T], [div], [7],   [4], [1],  [0]<br>
* KSE5: [F2], [OPT],   [²],     [log],   [FD],  [8],   [5], [2],  [.]<br>
* KSE4: [F3], [var],   [^],     [ln],    [(],   [9],   [6], [3],  [expo]<br>
* KSE3: [F4], [MENU],  [EXIT],  [sin],   [)],   [DEL], [x], [+],  [(-)]<br>
* KSE2: [F5], [<],     [down],  [cos],   [,],   [%],   [-], [EXE]<br>
* KSE1: [F6], [^],     [>],     [tan],   [->]<br>
* KSE0: [AC/ON]<br>

<u>Other note:</u>
* Casio configuration: 0x00ff
* SH7231 have similar register (KEYSC.KSCR2)

<br>
