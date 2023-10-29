---
layout: page
title: "FIFO-Buffered Serial Interface (FSI) documentation"
permalink: /hardware/sh7305/fsi.html
author: Yatis
---

# TODO - Documentation

Seems to be the same as the SH7724(?)

---

## Power up protocol


```c
void fsi_init(void)
{
	// This FSI depending on the SPU module, so turn on in the same time
	// @note:
	// * SPU and FSI have their own clock controller, you need to start manually each clock
	// * You can adjust each module clock with the clock divisor ratio DIV. (not tested yet)
	SH7305_CPG.SPUCLKCR.CLKSTP = 0;
	SH7305_CPG.FSICLKCR.CLKSTP = 0;

	// Turn on the "DSP part" of the SH7305
	// @note: it will start SPU and FSI modules
	SH7305_POWER.MSTPCR2.DSP = 0;

	//
	// You can use the FSI here
	// Casio seems use the FSI on the Graph35+E, Graph35+EII and Graph90+E
	// during the cold boot procedure (?)
	//

}

```

---

### Casio protocole

Casio seems used the FSI and SPU module with the HUDI. You can find a small driver implementation in the OS.

Casio’s protocole:
```c
include "tests.h"
#include "utils.h"

// Based on Casio's protocole
// TODO: correct slow module access !
void test_fsi(void)
{
	// Check Port Q
	// @note: UNDOCUMENTED for now...
	// @info: PQDR & 4 == TMS (HUDI Test mode select signal input pin)
	if ((*(volatile uint16_t*)0xa405013a & 4) != 0)
	{
		*(volatile uint16_t*)0xa405013a &= 0xfcff;
		*(volatile uint16_t*)0xa405013a |= 0x0100;
	} else {
		*(volatile uint16_t*)0xa405013a &= 0xfcff;
	}

	// Block Interrupt from DSP0, DSP1
	// @note: or SPU and FSI ?
	*(volatile uint8_t*)0xa408008c |= 0b00001100;
	*(volatile uint16_t *)0xa4080008 &= 0xfff0;

	// Stop SPU / FSI Clock
	*(volatile uint32_t*)0xa415003c = 0x00000103; // SPU
	*(volatile uint32_t*)0xa4150008 = 0x00000100; // FSI

	// Start FSI and SPU
	*(volatile uint32_t*)0xa4150008 &= 0xfffffeff; // FSI
	*(volatile uint32_t*)0xa415003c &= 0xfffffeff; // SPU

	// Power-on DSP part (SPU + FSI modules)
	*(volatile uint32_t*)0xa4150038 &= 0xfffffdff;

	// Mask interrupt form SPU.DSP0 and SPU.DSP1
	*(volatile uint32_t*)0xfe2ffd1c = 0x00001000; // DSP0
	*(volatile uint32_t*)0xfe3ffd1c = 0x00001000; // DSP1


	// FSI initialize
	// @note: use slow write because it's not using the Po
	*(volatile uint32_t*)0xfe3c0210 = 0x00000001;	// FSI.CLK_RST
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe3c0214 = 0x00000011;	// FSI.SOFT_RST
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe3c0214 = 0x00000111;	// FSI.SOFT_RST
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe3c0214 = 0x00000110;	// FSI.SOFT_RST
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe3c0214 = 0x00000111;	// FSI.SOFT_RST
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe3c0000 = 0x00000020;	// FSI.A_DO_FMT
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe3c000c = 0x00000020;	// FSI.A_DI_FMT
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe3c0018 = 0x00001111;	// FSI.A_CLKG1
	for (int i = 0 ; i < 1000 ; ++i);


	// SPU initialize
	*(volatile uint32_t*)0xfe2ffc24 &= 0xfffffffe; // software reset clear flags
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe2ffc24 |= 0x00000001; // software reset
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe2ffc00 = 0xffffffff;
	*(volatile uint32_t*)0xfe2ffc04 = 0x0000ff00;
	*(volatile uint32_t*)0xfe2ffc10 = 0xffffffff;
	*(volatile uint32_t*)0xfe2ffc14 = 0x0000ff00;


	// Reset DSPx
	*(volatile uint32_t*)0xfe2ffd04 = 1;
	*(volatile uint32_t*)0xfe3ffd04 = 1;
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe2ffd00 = 0;
	*(volatile uint32_t*)0xfe3ffd00 = 0;

	//
	// Casio seems dumped / used the DSPx extra RAM area during the boot
	//
}
```
