---
layout: page
title: "A/D Converter (ADC) documentation"
permalink: /hardware/sh7305/adc.html
author: Yatis
---

This module is really close to the SH7705 but with additional feature (like the SH7731?).
Unfortunately, I couldn't find all the features that this module offer but I have
the main part of this module: interruption, scan mode and channel informations.

<u>Features</u>
* 10-bit resolution
* Four input channels (Only the Channel can be used here)
* Minimum conversion time: 8.5 μs per channel (Pφ = 33 MHz operation)
* Three conversion modes
 	* Single mode: A/D conversion on one channel
	* Multi mode: A/D conversion on one to four channels
	* Scan mode: Continuous A/D conversion on one to four channels
* 16-bit data registers
* A/D conversion results are transferred for storage into 16-bit data registers corresponding
to the channels.
* Sample-and-hold function
* Interrupt source
 	* At the end of A/D conversion, an A/D conversion end interrupt (ADI) can be requested.
	* The interruption ADI set 0x560 int the INTEVT register.
* Module standby mode can be set

__Chapters:__<br>
1. [ADC registers documentation<br>](#adc-registers-documentation)
2. [Module Operations](#module-operations)
	* [Single mode](#single-mode)
	* [Multi mode](#milti-mode)
	* [Scan mode](#scan-mode)
3. [Other notes](#other-notes)
4. [Small C-code ADC driver implementation](#small-c-code-adc-driver-implementation)

---


## ADC registers documentation

After many tests, there is all register with their bits field.
Many feature is still unknown bacause Casio's do not use it and it's pretty complicated
to find informations.

[Registers list:]({{ site.baseurl }}/hardware/sh7305/registers_list.html#adc---analogdigital-converter)
* [(0xa4610080) ADDRA - A/D Data Registers A](#ad-data-registers-a-to-d-addra-to-addrd)
* [(0xa4610082) ADDRB - A/D Data Registers B](#ad-data-registers-a-to-d-addra-to-addrd)
* [(0xa4610084) ADDRC - A/D Data Registers C](#ad-data-registers-a-to-d-addra-to-addrd)
* [(0xa4610086) ADDRD - A/D Data Registers D](#ad-data-registers-a-to-d-addra-to-addrd)
* [(0xa4610088) ADCSR - A/D Control/Status Registers](#ad-controlstatus-registers-adcsr-address0xa4610088--bitmask0x70f3)
* [(0xa461008a) ADCCSR - A/D Custom Control Registers](#ad-custom-control-adccsr-address0xa461008a--bitmask0x63ff)
* [(0xa461008c) ADCUST - A/D Control Registers](#ad-control-adcust-address0xa461008c--bitmask0x8001)
* [(0xa461008e) ADPCTL - A/D Port control](#ad-port-control-adpctl-address0xa461008e--bitmask0xf0ff)

<br>

## A/D Data Registers A to D (ADDRA to ADDRD)

The four A/D data registers (ADDRA to ADDRD) are 16-bit read-only registers that store the
results of A/D conversion.

An A/D conversion produces 10-bit data, which is transferred for storage into bits 15 to 6 in the
A/D data register corresponding to the selected channel. Bits 5 to 0 of an A/D data register are
reserved bits that are always read as 0.

The A/D data registers are initialized to H'0000.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 15 to 6  | AD       | All 0         | R   | 10-bit data                                                                      |
| 5 to 0   | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |

NOTE:
* Only Channel C can be used, otherwise the "Scalle-error"(0x3ff) will be read each time.
* Data resolution: 0,01157894737 volts per bits

<br>


## A/D Control/Status Registers (ADCSR: address=0xa4610088 && bitmask=0x70F3)

ADCSR is a 16-bit readable/writable register that selects the mode and controls the A/D converter.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 15       | ADF      | 0             | R/W | A/D Interrupt End Flag                                                           |
| 14       | ADIE     | 0             | R/W | A/D Interrupt Enable                                                             |
| 13       | ADST     | 0             | R/W | A/D Start convertion                                                             |
| 12       | DMASL    | 0             | R/W | DMAC Select(?)                                                                   |
| 11 to 8  | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 7, 6     | CKS      | 0b01          | R/W | Clock Select. Selects the A/D conversion time.                                   |
| 5, 4     | MULTI    | 0b00          | R/W | Mode Select: single mode, multi mode, or scan mode.                              |
| 3, 2     | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 1, 0     | CH       | 0b00          | R/W | Channel Select                                                                   |

<u>Bit 15: ADF</u><br>
Indicates the end of A/D conversion.
* Setting conditions
	* Single mode: A/D conversion ends
	* Multi mode: A/D conversion ends cycling through the selected channels
	* Scan mode: A/D conversion ends cycling through the selected channels
* Clearing conditions
	1. Reading ADF while ADF = 1, then writing 0 to ADF
	2. DMAC is activated by ADI interrupt and ADDR is read

Note: * Clear this bit by writing 0. Writing 1 is ignored.

<u>Bit 14: ADIE</u><br>
Enables or disables the interrupt (ADI, 0x560) requested by ADF.
Set the ADIE bit while the ADST bit is 0.
* 0: Interrupt (ADI, 0x560) requested by ADF is disabled
* 1: Interrupt (ADI, 0x560) requested by ADF is enabled

<u>Bit 13: ADST</u><br>
Starts or stops A/D conversion. The ADST bit remains set to
1 during A/D conversion.
* 0: A/D conversion is stopped.
* 1: A/D conversion is processing.
	* Single mode:<br>
		A/D conversion starts; ADST is automatically cleared to 0 when
		conversion ends on selected channels.
	* Multi mode:<br>
		A/D conversion starts; when conversion is completed cycling through
		the selected channels, ADST is automatically cleared.
	* Scan mode:<br>
		A/D conversion starts and continues, A/D conversion is continuously
		performed until ADST is cleared to 0 by software, by a reset, or
		by a transition to standby mode.

<u>Bit 12: DMASL(?)</u><br>
Selects an interrupt due to ADF or activation of the DMAC.
Set the DMASL bit while the ADST bit is 0.
* 0: An interrupt by ADF is selected.
* 1: Activation of the DMAC by ADF is selected.
NOTE: No tested yet !

<u>Bit 7, 6: CLKS</u><br>
Selects the A/D conversion time. Clear the ADST bit to 0
before changing the conversion time.
* 00: Conversion time = 151 states (maximum) at Pφ/4
* 01: Conversion time = 285 states (maximum) at Pφ/8
* 10: Conversion time = 545 states (maximum) at Pφ/16
* 11: Setting prohibited (but the emulator use like 10, so 545 states (maximum) at Pφ/16)

Note: If the minimum conversion time is not satisfied,
lack of accuracy or abnormal operation may
occur.

<u>Bit 5, 4: MULTI</u><br>
Selects single mode, multi mode, or scan mode.
* 00: Single mode
* 01: Setting prohibited
* 10: Multi mode
* 11: Scan mode


<u>Bit 1, 0: CH</u><br>
These bits and the MULTI bit select the analog input
channels. Clear the ADST bit to 0 before changing the
channel selection.
* Single mode:
	* 00: ADDRA
	* 01: ADDRB
	* 10: ADDRC
	* 11: ADDRD
* Multi mode:
	* 00: ADDRA
	* 01: ADDRA, ADDRB
	* 10: ADDRA to ADDRC
	* 11: ADDRA to ADDRD
* Scan mode:
	* 00: ADDRA
	* 01: ADDRA, ADDRB
	* 10: ADDRA to ADDRC
	* 11: ADDRA to ADDRD

<br>


## A/D Custom control (ADCCSR: address=0xa461008a && bitmask=0x63ff)

ADCSR is a 16-bit readable/writable register that selects the mode and controls the A/D converter.

Seems to be used to start the ADC using external trigger like DMA(?), TMU(?) or CMT(?).
Casio do not use this register unless in their ADC interruption handler which they clear the interrupt flags and the wait flags(?)

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 15       | ADF      | 0             | R/W | A/D Interrupt Trigger End Flag                                                   |
| 14       | ADIE     | 0             | R/W | A/D Interrupt Trigger Enable                                                     |
| 13       | ADST     | 0             | R/W | A/D Wait trigger convertion(?)                                                   |
| 12 to 10 | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 9 to 8   | CKS      | 0             | R/W | Clock Select. Selects the A/D conversion time.                                   |
| 7 to 0   | unknown  | 0             | R/W | Unknown, seems linked with the clock configuration. (clock multiplicator?)       |

<u>Bit 15: ADF</u><br>
Indicates the end of A/D conversion.
* Setting conditions
	* Single mode: A/D conversion ends
	* Multi mode: A/D conversion ends cycling through the selected channels
	* Scan mode: A/D conversion ends cycling through the selected channels
* Clearing conditions
	1. Reading ADF while ADF = 1, then writing 0 to ADF

<u>Bit 14: ADIE</u></br>
Enables or disables the interrupt (ADI, 0x560) requested by ADF.
Set the ADIE bit while the ADST bit is 0.
* 0: Interrupt (ADI, 0x560) requested by ADF is disabled
* 1: Interrupt (ADI, 0x560) requested by ADF is enabled

<u>Bit 9 to 8</u><br>
Selects the A/D conversion time. Clear the ADST bit to 0
before changing the conversion time.
* 00: Conversion time = <unknown>
* 01: Conversion time = <unknown>
* 10: Conversion time = <unknown>
* 11: Setting prohibited

Note: If the minimum conversion time is not satisfied,
lack of accuracy or abnormal operation may
occur.

<u>Bit 7 to 0</u></br>
Really unknown for now, seems used like clock multiplicator...(TODO)

<br>


## A/D Control (ADCUST: address=0xa461008c && bitmask=0x8001)

ADCSR is a 16-bit readable/writable register used to control the ADC (handle
the reset and the mode).

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 15       | MODE     | 0             | R/W | Selects the mode                                                                 |
| 14 to 1  | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 0        | RESET    | 0             | R/W | Reset the ADC                                                                    |

<u>Bit 15: MODE</u>
Mode selector:
* 0 = select the ADCSR (ADCCSR is not taken into account)
* 1 = selecte the ADCCSR (ADCSR is not taken into account)

<u>Bit 0: RESET</u>
Reset the register ADCSR, ADCCSR and ADPCTL (set to 0).
Automatically, cleared to 0 when the ADM is completelly reseted.

<u>Note</u>
* Casio set all bit to 0

<br>


## A/D Port control (ADPCTL: address=0xa461008e && bitmask=0xf0ff)

ADCSR is a 16-bit readable/writable register used to ????

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 15 to 12 | unknown  | ??????        | R/W | Unknown                                                                          |
| 11 to 8  | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 7  to 0  | unknown  | ??????        | R/W | Unknown                                                                          |

<u>Note</u>
* Casio set all bit to 0

<br>

---

## Module Operations

The A/D converter operates by successive approximations with 10-bit resolution.
It has three operating modes: single mode, multi mode, and scan mode.
To avoid malfunction, switch operating modes while the ADST bit of ADCSR is 0.
Changing operating modes and channels and setting the ADST bit can be performed
simultaneously.

## Single Mode

Single mode should be selected when only one A/D conversion on one channel is required.
1. A/D conversion of the selected channel starts when the ADST bit of ADCSR is set
to 1 by software.
2. When conversion ends, the conversion results are transmitted to the A/D data
register that corresponds to the channel.
3. When conversion ends, the ADF bit of ADCSR is set to 1. If the ADIE bit is also
set to 1, an ADI interrupt is requested at this time.
4. The ADST bit holds 1 during A/D conversion. When A/D conversion is completed, the ADST
bit is cleared to 0 and the A/D converter becomes idle. When the ADST bit is cleared to 0
during A/D conversion, the conversion is halted and the A/D converter becomes idle.
To clear the ADF flag to 0, first read ADF, then write 0 to ADF.

## Multi Mode

Multi mode should be selected when performing A/D conversions on one or more channels.
1. When the ADST bit is set to 1 by software, A/D conversion starts with the smaller
number of the analog input channel in the group (for instance, ADDRA, and ADDRB to ADDRD).
2. When conversion of each channel ends, the conversion results are transmitted
to the A/D data register that corresponds to the channel.
3. When conversion of all selected channels ends, the ADF bit of ADCSR is set to 1.
If the ADIE bit is also set to 1, an ADI interrupt is requested at this time.
4. When A/D conversion is completed, the ADST bit is cleared to 0 and the A/D converter
becomes idle. When the ADST bit is cleared to 0 during A/D conversion, the conversion is
halted and the A/D converter becomes idle.
To clear the ADF flag to 0, first read ADF, then write 0 to ADF.

## Scan Mode

Scan mode should be selected when performing A/D conversions of analog inputs on one or more
specified channels. Scan mode is useful for monitoring analog inputs.
1. When the ADST bit is set to 1 by software, A/D conversion starts with the smaller
number of the analog input channel in the group (for instance, ADDRA, and ADDRB to ADDRD).
2. When conversion of each channel ends, the conversion results are transmitted
to the A/D data register that corresponds to the channel.
3. When conversion of all selected channels ends, the ADF bit of ADCSR is set to 1.
If the ADIE bit is also set to 1, an ADI interrupt is requested at this time. A/D
conversion then starts with the smaller number of the analog input channel.
4. The ADST bit is not automatically cleared to 0. When the ADST bit is set to 1,
steps 2 and 3 above are repeated. When the ADST bit is cleared to 0, the conversion
is halted and the A/D converter becomes idle.
To clear the ADF flag to 0, first read ADF, then write 0 to ADF.

<br>

---

## Other notes

1. Interruption informations:
	* event code: 0x560
	* Interrupt level (disable): INTC.IPRB & 0x0fff
	* Interrupt level (set): INT.IPRB \| 0xc000
	* Interrupt mask: INTC.IMR4 \| 0x08
	* Interrupt clear mask: INTC.IMCR4 \| 0x08
2. Casio's informations:
	* Use Single mode with interruption
	* Use channel C
	* Use interrupt level 14
	* Seem to use the Channel B for internal testing(?)
		* not used by the device Graph75 - OS:01.00.0000
	* Seem start convertion each time GetKeyWait() is involved(?)
	* Seem use only the ADCSR register
	* baterry levels (in volt):

		| Device name | OS version | Full       | middle     | low       |
		|-------------|------------|------------|------------|-----------|
		| graph75     | 01.00.0000 | ] -, 4.4[  | [4.4, 4.2] | ]4.2, - [ |
		| graph35+E   | 02.05.2201 | ] -, 4.4[  | [4.4, 4.2] | ]4.2, - [ |
		| graph35+EII | 03.00.2200 | ] -, 4.4[  | [4.4, 4.2] | ]4.2, - [ |

---

## Small C-code ADC driver implementation

Based on Casio's syscall `0x49C: int Battery_GetStatus()` and Casio's interrupt
handler that I have disassembled to understand the module.

This little piece of code will scan the battery status (channel C) and display
the battery voltage.
```c
#include "tests.h"
#include "utils.h"
#include "hardware/sh7305/adc.h"
#include "hardware/sh7305/power.h"
#include "hardware/sh7305/intc.h"

void adc_interrupt_handler(void)
{
	// mask ADC interruption
	SH7305_INTC.IMR4.ADC = 1;
	SH7305_INTC.IPRB.ADC = 0b0000;

	// Clear interrupts flags
	// @note: Casio clear the 2 end flags but only the ADCSR.ADIF can be cleared here
	SH7305_ADC.ADCSR.ADF = 0;
	SH7305_ADC.ADCCSR.ADF = 0;

	// DEBUG: Display baterry tention
	uint32_t baterry = SH7305_ADC.ADDRC.AD * 11578;
	printk(
		"battery = %d,%d V\n",
		baterry / 1000000,
		baterry - ((baterry / 1000000) * 1000000)
	);

	// Enable ADC interruption
	SH7305_INTC.IPRB.ADC = 0b1000;
	SH7305_INTC.IMCR4.ADC = 1;
}

void test_adc(void)
{
	// mask ADC interruption
	SH7305_INTC.IMR4.ADC = 1;
	SH7305_INTC.IPRB.ADC = 0b0000;

	// power up the ADC module
	SH7305_POWER.MSTPCR2.ADC = 0;

	// default initialization of the ADC module
	SH7305_ADC.ADCSR.WORD = 0x0000;
	SH7305_ADC.ADCCSR.WORD = 0x0000;
	SH7305_ADC.ADCUST.WORD = 0x0000;
	SH7305_ADC.ADPCTL.WORD = 0x0000;

	// Enable ADC interruption
	SH7305_INTC.IPRB.ADC = 0b1000;
	SH7305_INTC.IMCR4.ADC = 1;

	// Set up the ADC to scan the channel C
	SH7305_ADC.ADCSR.MULTI = 0b11;	// select the scan mode
	SH7305_ADC.ADCSR.CH = 0b10;	// select the channel C (ADDRC)
	SH7305_ADC.ADCSR.CKS = 0b00;	// select Pφ/4
	SH7305_ADC.ADCSR.ADIE = 1;	// enable ADI interrupt (0x560)
	SH7305_ADC.ADCSR.ADST = 1;	// start ADC convertion

	// log and wait
	printk("ADC initialized, wait interruption...\n");
	while (1);
}
```
