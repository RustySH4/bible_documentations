---
layout: page
title: "CPG - Clock Pulse Generator documentation"
permalink: /hardware/sh7305/cpg.html
author: Yatis
---

# Clock Pulse Generator (CPG)

Special thanks to [Sentaro21][1] for his documentation about the CPG. This part
of the bible will be based on his work and my additional tests to determine all
register's structure.

The clock pulse generator generates the clocks used in this LSI and consists of
a PLL circuit, a FLL circuit, dividers, and the associated control circuit.

[1]: https://www.planet-casio.com/Fr/compte/voir_profil.php?membre=sentaro21

<u>Features</u>
* Generation of the various clocks for LSI internal operations:
	* (Iφ) CPU clock: Operating clock for the CPU core
	* (Sφ) S clock: Operating clock for the SuperHyway bus and DBSC
	* (Pφ) Peripheral clock : Operating clock for peripheral modules on the HPB (peripheral bus).
	* (Rφ) RCLK: Operating clock only for peripheral modules and clock source for FLL circuit.
	* (SPUφ) SPU clock: Operating clock for SPU.
	* (Bφ) Bus clock: Operating clock for the BSC. Operating clock for peripheral modules on the SuperHyway bus

* Generation of clocks for external interfaces
	* Bus clock (CKO): Clock for the BSC bus interface (same as Bφ)
	* SDRAM clock (MCLK): Clock for the SDRAM interface (same as Sφ)
	* FSI clock (FSICLK): Clock for the FSI external interface
	* USB clock (USBCLK): Clock for the USB 2 interface
	* DD clock (DDCLK): Clock for the CmodX (Custom specification module) interface

* Frequency-change function
	> The frequency of each clock can be changed independently by using the PLL circuit, FLL
	> circuit, or dividers within the CPG. Frequencies are changed under software control by register
	> settings.

* Clock mode
	> The clock mode pin setting selects external inputs (EXTAL or RCLK) or crystal oscillator as
	> the clock source. In addition, the PLL and FLL can be turned on or off by the clock mode pin
	> setting after a power-on reset.

* Power-down mode control
	> The clocks are stopped in sleep mode, software standby mode, R-standby mode, and U-
	> standby mode; clocks for specific modules can be stopped by using the module standby
	> function.

__Chapter:__<br>
[I\] CPG Registers documentation<br>](#cpg-registers-documentation)
[II\] Get the main internal clocks frequencies in C<br>](#get-the-main-internal-clocks-frequencies-in-c)
[III\] C header implementation<br>](#c-header-implementation)

---

## CPG Registers documentation

After some tests, there is all register with bits field.<br>
Thanks again to Sentaro21 which as documented a part of the CPG module with
[FtuneX][1] and [PtuneX][2]

[Registers list:][3]
* [(0xa4150000) FRQCR - Frequency control](#frqcr---frequency-control-address-0xa4150000--bitmask-0xbfffffff)
* [(0xa4150008) FSICLKCR - Fifo Serial Interface Clock control](#fsiclkcr---fifo-serial-interface-clock-control-address-0xa4150008--bitmask-0x0000fdff)
* [(0xa4150010) DDCLKCR - DD Clock Control](#ddclkcr---dd-clock-control-address-0xa4150010--bitmask-0x000001bf)
* [(0xa4150014) USBCLKCR - USB Clock control](#usbclkcr---usb-clock-control-address-0xa4150014--bitmask-0x0000100)
* [(0xa4150024) PLLCR - PLL1 control](#pllcr---pll1-control-address-0xa4150024--bitmask-0x00005006)
* [(0xa4150024) PLL2CR - PLL2 control](#pll2cr---pll2-control-address-0xa4150028--bitmask-0xbf000000)
* [(0xa415003c) SPUCLKCR - SPU Clock control](#spuclkcr---spu-clock-control-address-0xa415003c--bitmask-0x000001bf)
* [(0xa4150044) SSCGCR - Spread spectrum control](#sscgcr---spread-spectrum-control-address-0xa4150044--bitmask-0x00000001)
* [(0xa4150050) FLLFRQ - FLL Multiplication control](#fllfrq---fll-multiplication-control-address-0xa4150050--bitmask-0x000007ff)
* [(0xa4150060) LSTATS - Frequency change status](#lstats---frequency-change-status-address-0xa4150060--bitmask-0x00000001)


[1]: https://www.planet-casio.com/Fr/programmes/programme3872-1-ftune3-sentaro21-utilitaires-add-ins.html
[2]: https://www.planet-casio.com/Fr/programmes/programme3710-1-ptune3-sentaro21-utilitaires-add-ins.html
[3]: {{ site.baseurl }}/hardware/sh7305/registers_list.html#clock---clock-generation

---


## FRQCR - Frequency control (address: 0xa4150000 && bitmask: 0xbfffffff)

The FRQCR register is really close of the FRQCRA of the SH7724.

FRQCR is a 32-bit readable/writable register used to specify the frequency
multiplication ratio of the PLL circuit, and the frequency division ratio of the
CPU clock(Iφ), S clock(Sφ), bus clock, SDRAM clock(MCLK), and peripheral clock(Pφ).

FRQCR can be accessed only in longwords. The initial values of the frequency
multiplication rate and division ratio are determined by the clock mode.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31       | KICK     | 0             | R/W | Kick bits.                                                                       |
| 30       | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 29 to 24 | STC      | unknown       | R/W | PLL circuit multiplication ratio.                                                |
| 23 to 20 | IFC      | unknown       | R/W | CPU clock frequency division ratio.                                              |
| 19 to 16 | -        | unknown       | R   | Reserved.<br>This bit is read as initial value.                                  |
| 15 to 12 | SFC      | unknown       | R/W | S clock frequency division ratio.                                                |
| 11 to 8  | BFC      | unknown       | R/W | Bus clock frequency division ration.                                             |
| 7 to 4   | -        | unknown       | R   | Reserved.<br>This bit is read as initial value.                                  |
| 3 to 0   | PFC      | unknown       | R/W | Peripheral clock frequency division ratio.                                       |

<u>Bit 31: KICK</u>
* 0: this bit is cleared automatically after “1” writing.
* 1: validate the values of FRQCR.

<u>Bits 29 to 24: STC</u>
* Multiplication Ratio: fll_freq * (FRQCR.STC + 1)
* Casio's use FLL * 16 (235.93Mhz)

<u>Bits 23 to 20: IFC</u>
* Division ratio: pll_freq / (1 << (FRQCR.IFC + 1))
* Casio use PLL / 8 (29.49Mhz)

<u>Bits 19 to 16:</u>
* The write value should always be the same as read value.

<u>Bits 15 to 12: SFC</u>
* Division ratio: pll_freq / (1 << (FRQCR.SFC + 1))
* Casio use PLL / 8 (29.49Mhz)

<u>Bits 11 to 8: BFC</u>
* Division ratio: pll_freq / (1 << (FRQCR.BFC + 1))
* Casio use PLL / 8 (29.49Mhz)

<u>Bits 7 to 4</u>
* The write value should always be the same as read value.

<u>Bits 3 to 0: PFC</u>
* Division ratio: pll_freq / (1 << (FRQCR.PFC + 1))
* Casio use PLL / 16 (14.75Mhz)

<u>Other note:</u>
* Casio's configuration: 0x0f212213

---


## FSICLKCR - Fifo Serial Interface Clock control (address: 0xa4150008 && bitmask: 0x0000fdff)

FSICLKCR is a 32-bit readable/writable register that controls the FSI clock frequency.
FSICLKCR can be accessed only in longwords.

Specify the value of DIVA[5:0] and DIVB[15:10] in FSICLKCR not to exceed 41.7 MHz(?)

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31 to 16 | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 15 to 10 | DIVB     | 0b111111      | R/W | Division Ratio for port B (or A?)                                                |
| 9        | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 8        | CLKSTP   | 0             | R/W | Clock Stop                                                                       |
| 7 to 6   | SRC      | 0b00          | R/W | Clock Source Select                                                              |
| 5 to 0   | DIVA     | 0b111111      | R/W | Division Ratio for port A (or B?)                                                |

<u>Bits 15 to 10: DIVB</u><br>
These bits set the frequency division ratio of the FSICLK clock for the port B.<br>
The specified division ratio is ×1 / (setting + 1).

<u>Bits 8: CLKSTP</u><br>
* 0: FSICLK is supplied
* 1: FSICLK is halted

<u>Bits 7, 6: SRC:</u><br>
Clock Source Select<br>
Selects the FSICLK clock source.
 * 00: PLL circuit output clock × 1/3
 * 10: External input clock (FSICLK)
 * Other settings are prohibited.

 <u>Bits 5 to 0: DIVA</u><br>
 These bits set the frequency division ratio of the FSICLK clock for the port A.<br>
 The specified division ratio is ×1 / (setting + 1).

<u>Other note:</u>
* Casio's configuration: 0x00000157

---


## DDCLKCR - DD Clock Control (address: 0xa4150010 && bitmask: 0x000001bf)

DDCLKCR is a 32-bit readable/writable register that controls the DD clock frequency.
DDCLKCR can be accessed only in longwords.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31 to 9  | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 8        | CLKSTP   | 0             | R/W | Clock Stop.                                                                      |
| 7        | unknown  | unknown       | R/W | Unknown.                                                                         |
| 6        | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 5 to 0   | DIV      | 0b111111      | R/W | Division Ratio                                                                   |

<u>Bits 8: CLKSTP</u><br>
* 0: DDCLK is supplied
* 1: DDCLK is halted

<u>Bit 7</u>
Really unknown for now...

<u>Bits 5 to 0: DIV</u><br>
These bits set the frequency division ratio of the DDCLK clock.<br>
The specified division ratio is ×1 / (setting + 1).

<u>Other note:</u>
* Casio's configuration: 0x00000198

---


## USBCLKCR - USB Clock control (address: 0xa4150014 && bitmask: 0x0000100)

USBCLKCR is a 32-bit readable/writable register that controls the DD clock frequency.
USBCLKCR can be accessed only in longwords.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31 to 9  | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 8        | CLKSTP   | 0             | R/W | Clock Stop.                                                                      |
| 7 to 0   | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |

<u>Bits 8: CLKSTP</u><br>
* 0: USBCLK is supplied
* 1: USBCLK is halted

<u>Other note:</u>
* Casio's configuration: 0x00000100

---


## PLLCR - PLL1 control (address: 0xa4150024 && bitmask: 0x00005006)

PLLCR is a 32-bit readable/writable register used to turn on or off the PLL circuit and FLL circuit.
PLLCR can be accessed only in longwords.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31 to 15 | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 14       | PLLE     | unknown       | R/W | PLL Enable (or FLL Enable?).                                                     |
| 13       | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 12       | FLLE     | unknown       | R/W | FLL Enable (or PLL Enable?).                                                     |
| 11 to 3  | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 2 to 1   | SRC      | 0b00          | R/W | Unknown, Clock Source Select for ???                                             |
| 0        | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |

<u>Bits 14: PLLE (or FLLE?)</u><br>
Turns on or off the PLL circuit.
* 0: PLL circuit is off
* 1: PLL circuit is on

<u>Bits 13: FLLE (or PLLE?)</u><br>
Turns on or off the FLL circuit.
* 0: FLL circuit is off
* 1: FLL circuit is on

<u>Bits 2 to 1:SRC</u><br>
Really unknown, probably the CKOFF bit with something ?

<u>Other note:</u>
* Casio's configuration: 0x00005000

---


## PLL2CR - PLL2 control (address: 0xa4150028 && bitmask: 0xbf000000)

PLL2CR is a 32-bit readable/writable register that control ????
PLL2CR can be accessed only in longwords.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31       | CLKSTP   | 0             | R/W | Clock Stop for ???                                                               |
| 30       | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 29 to 24 | DIV      | 0b111111      | R/W | Division Ratio for ???                                                           |
| 23 to 0  | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |

<u>Bit 31: CLKSTP</u><br>
* 0: ???CLK is supplied
* 1: ???CLK is halted

<u>Bits 29 to 24: DIV</u><br>
These bits set the frequency division ratio of the ???CLK clock.<br>
The specified division ratio is ×1 / (setting + 1).

<u>Other note:</u>
* Casio's configuration: 0x00000000

---


## SPUCLKCR - SPU Clock control (address: 0xa415003c && bitmask: 0x000001bf)

SPUCLKCR is a 32-bit readable/writable register that controls the SPU clock frequency.
SPUCLKCR can be accessed only in longwords.

Specify the value of DIV[5:0] in SPUCLKCR not to exceed 83.4 MHz.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31 to 9  | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 8        | CLKSTP   | 0             | R/W | Clock Stop                                                                       |
| 7        | UNKNOWN  | unknown       | R/W | Unknown                                                                          |
| 6        | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 5 to 0   | DIV      | 0b111111      | R/W | Division Ratio.                                                                  |

<u>Bit 31: CLKSTP</u><br>
* 0: SPUCLK is supplied
* 1: SPUCLK is halted

<u>Bits 29 to 24: DIV</u><br>
These bits set the frequency division ratio of the SPUCLK clock.<br>
The specified division ratio is ×1 / (setting + 1).

<u>Other note:</u>
* Casio's configuration: 0x00000103

---


## SSCGCR - Spread spectrum control (address: 0xa4150044 && bitmask: 0x00000001)

SSCGCR is a 32-bit readable/writable register that enable the Spread Spetrum.
SSCGCR can be accessed only in longwords.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31       | ENABLE   | 0             | R/W | Enable / disable Spread Spectrum                                                 |
| 30 to 0  | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |

<u>Bit 0: ENABLE</u><br>
* 0: Disable Spread Spectrum
* 1: Enable Spread Spectrum

<u>Other note:</u>
* On the Casio's emulator the ENABLE bitmask is 0x00000001
* Casio's configuration:
	* 0x00000000 for monochrom calculator
	* 0x80000000 for prizm calculator

---


## FLLFRQ - FLL Multiplication control (address: 0xa4150050 && bitmask: 0x000007ff)

FLLFRQ is a 32-bit readable/writable register used to specify the frequency
multiplication ratio of the FLL circuit.
FLLFRQ can be accessed only in longwords.

Specify the value of DLF[10:0] in the range from 20 to 33.4 MHz.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31 to 16 | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 15 to 14 | SELXM    | 0b00          | R/W | FLL output division                                                              |
| 13 to 11 | UNKNOWN  | unknown       | R/W | Unknown                                                                          |
| 10 to 0  | FLF      | 0x3F9         | R/W | FLL Multiplication Ratio                                                         |

<u>Bits 15 to 14: SELX</u><br>
FLL output division
* 00: FLL output × 1
* 01: FLL output × 1/2
Other settings are prohibited.

<u>Bits 13 to 11</u><br>
Really unknown for now...

<u>Bits 10 to 0: FLF</u><br>
These bits specify the frequency multiplication ratio of the FLL circuit.<br>
Multiplication is performed with a ratio of setting.<br>

<u>Other note:</u>
* Casio's configuration: 0x00004384
* The emulator use the register like this: FLLFRQ = (new & 0x7ff) | 0x4000 so
	the SELX can not in the FLL output × 1 state ?

---


## LSTATS - Frequency change status (address: 0xa4150060 && bitmask: 0x00000001)

LSTATS is a 32-bit read only register to indicate the status of frequency changing.
LSTATS can be accessed only in longwords.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31 to 1  | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 0        | FRQF     | 0             | R   | Frequency changing status flag                                                   |

<u>Bit 0: FRQF</u><br>
* 0: Not on frequency changing status
* 1: On frequency changing status

<u>Other note:</u>
* Casio's configuration: 0x00000000

---


## Get the main internal clocks frequencies in C
```c
void cpg_display_frequencies(void)
{
	uint32_t fll_freq;
	uint32_t pll_freq;
	uint32_t cpu_freq;
	uint32_t bus_freq;
	uint32_t per_freq;
	uint32_t s_freq;

	// Calculate FLL frequency (Khz)
	// @note: FFL circuit is based on the RCLK which is equal to 32 768 Hz on the SH7724
	fll_freq  = (SH7305_CPG.FLLFRQ.FLF * 32768) / (1 << SH7305_CPG.FLLFRQ.SELXM);

	// Calculate PLL frequency (Khz)
	pll_freq = fll_freq * (SH7305_CPG.FRQCRA.STC + 1);

	// Calculate CPU clock (Iφ) frequency (Khz)
	cpu_freq = pll_freq / (1 << (SH7305_CPG.FRQCRA.IFC + 1));

	// Calculate BUS clock (Bφ) frequency (Khz)
	bus_freq = pll_freq / (1 << (SH7305_CPG.FRQCRA.BFC + 1));

	// Calculate Peripheral clock (Pφ) frequency (Khz)
	per_freq = pll_freq / (1 << (SH7305_CPG.FRQCRA.PFC + 1));

	// Calculate the S Clock (Sφ) frequency (Khz)
	s_freq = pll_freq / (1 << (SH7305_CPG.FRQCRA.SFC + 1));

	// Display
	printk(
		"* FLL freq: %d.%d Mhz\n"
		"* PLL freq: %d.%d Mhz\n"
		"* CPU freq: %d.%d Mhz\n"
		"* BUS freq: %d.%d Mhz\n"
		"* Per freq: %d.%d Mhz\n"
		"* S   freq: %d.%d Mhz\n",
		fll_freq / 1000000, (((fll_freq - ((fll_freq / 1000000)) * 1000000)) + 999) / 1000,
		pll_freq / 1000000, (((pll_freq - ((pll_freq / 1000000)) * 1000000)) + 999) / 1000,
		cpu_freq / 1000000, (((cpu_freq - ((cpu_freq / 1000000)) * 1000000)) + 999) / 1000,
		bus_freq / 1000000, (((bus_freq - ((bus_freq / 1000000)) * 1000000)) + 999) / 1000,
		per_freq / 1000000, (((per_freq - ((per_freq / 1000000)) * 1000000)) + 999) / 1000
		s_freq / 1000000, (((s_freq - ((s_freq / 1000000)) * 1000000)) + 999) / 1000
	);
}
```

---


## C header implementation
```c
#ifndef __KERNEL_HARDWARE_CPG_H__
# define __KERNEL_HARDWARE_CPG_H__

#include <stddef.h>
#include <stdint.h>

// Define packed union / struct for long word
#define long_union(name, fields)			\
	union {						\
		uint32_t LONG_WORD;			\
		struct {				\
			fields				\
		} __attribute__((packed, aligned(4)));	\
	} __attribute__((packed, aligned(4))) name


// Generate "anonyme name" for each gaps.
#define gap_name2(name)	_##name
#define gap_name(name)	gap_name2(name)
#define GAPS(bytes)	const uint8_t gap_name(__COUNTER__)[bytes]


struct __sh7305_cpg
{
	// Frequency control
	volatile long_union(FRQCR,
		uint32_t KICK		: 1;	/* Kick bits */
		uint32_t const		: 1;	/* All 0 */
		uint32_t STC		: 6;	/* PLL circuit multiplication ratio */
		uint32_t IFC		: 4;	/* CPU clock frequency division ratio */
		uint32_t const		: 4;	/* All 0 */
		uint32_t SFC		: 4;	/* S clock frequency division ratio */
		uint32_t BFC		: 4;	/* Bus clock frequency division ration */
		uint32_t const		: 4;	/* All 0 */
		uint32_t PFC		: 4;	/* Peripheral clock frequency division ratio */
	);
	GAPS(0x04);

	// FSI Clock control
	// @note: NOT SURE, CHECK BEFORE USE !
	volatile long_union(FSICLKCR,
		uint32_t const		: 16;	/* All 0 */
		uint32_t DIVB		: 6;	/* Division ratio for port B(?) */
		uint32_t const		: 1;	/* All 0 */
		uint32_t CLKSTP		: 1;	/* Clock Stop */
		uint32_t SRC		: 2;	/* Clock Source Select */
		uint32_t DIVA		: 6;	/* Division ratio for port A(?) */
	);
	GAPS(0x04);

	// DD Clock control
	// @note: NOT SURE, CHECK BEFORE USE !
	volatile long_union(DDCLKCR,
		uint32_t const		: 23;	/* All 0 */
		uint32_t CLKSTP		: 1;	/* Clock Stop(?) */
		uint32_t unknown	: 1;	/* Unknown */
		uint32_t const		: 1; 	/* All 0 */
		uint32_t DIV		: 6;	/* Division Ration(?) */
	);
	// USB Clock control
	volatile long_union(USBCLKCR,
		uint32_t const		: 16;	/* All 0 */
		uint32_t CLKSTP		: 1;	/* Clock control */
		uint32_t const		: 15;	/* All 0 (can be written?) */
	);
	GAPS(0x0c);

	// PLL1 control
	// @note: NOT SURE, CHECK BEFORE USE !
	volatile long_union(PLLCR,
		uint32_t const		: 17;	/* All 0 */
		uint32_t PLLE		: 1;	/* PLL Enable(?) */
		uint32_t const		: 1;	/* All 0 */
		uint32_t FLLE		: 1;	/* FLL Enable(?) */
		uint32_t const		: 9;	/* All 0 */
		uint32_t SRC		: 2;	/* Source Selector(?) */
		uint32_t const		: 1;	/* All 0 */
	);
	// PLL2 control
	// @note: NOT SURE, CHECK BEFORE USE !
	volatile long_union(PLL2CR,
		uint32_t CLKSTP		: 1;	/* Clock Stop(?) */
		uint32_t const		: 1;	/* All 0 */
		uint32_t DIV		: 6;	/* Division Ration(?) */
		uint32_t const		: 24;	/* All 0 */
	);
	GAPS(0x10);

	// SPU Clock control
	volatile long_union(SPUCLKCR,
		uint32_t const		: 23;	/* All 0 */
		uint32_t CKSTP		: 1;	/* Clock Stop */
		uint32_t unknown	: 1;	/* Unknown */
		uint32_t const		: 1;	/* All 0 */
		uint32_t DIV		: 6;	/* Division Ratio */
	);
	GAPS(0x04);

	// Spread spectrum control
	volatile long_union(SSCGCR,
		uint32_t const		: 31;	/* All 0 */
		uint32_t ENABLE		: 1;	/* Enable(?) */
	);
	GAPS(0x08);

	// FLL Multiplication control
	volatile long_union(FLLFRQ,
		uint32_t const		: 16;	/* All 0 */
		uint32_t SELXM		: 2;    /* FLL output division */
		uint32_t unknown	: 3;	/* Unknown */
		uint32_t FLF		: 11;	/* FLL Multiplication Ratio */
	);
	GAPS(0x0c);

	// Frequency change status
	volatile long_union(LSTATS,
		uint32_t const		: 31;	/* All 0 */
		uint32_t const FQRF	: 1;	/* Frequency change status */
	);
};


#define SH7305_CPG	(*(volatile struct __sh7305_cpg	*)0xa4150000)
#endif /*__KERNEL_HARDWARE_CPG_H__*/

```
<br>
