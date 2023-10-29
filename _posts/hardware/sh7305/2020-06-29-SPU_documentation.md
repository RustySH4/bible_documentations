---
layout: page
title: "SPU - Sound Processing Unit documentation"
permalink: /hardware/sh7305/spu.html
author: Yatis
---

# SPU notes

The object of this documentation is to check if the SPU RAMs area exist.
Because if they exits then we can have more than 800ko of RAM for free use !

| Name | Address  | Size     | Az  | Description              |
|------|----------|----------|-----|--------------------------|
|PRAM0 | fe200000 | 00028000 | u32 | DSP0 Program RAM (160ko) |
|XRAM0 | fe240000 | 00038000 | u32 | DSP0 XRAM (224ko)        |
|YRAM0 | fe280000 | 0000a000 | u32 | DSP0 YRAM (40ko)         |
|PRAM1 | fe300000 | 00028000 | u32 | DSP1 Program RAM (160ko) |
|XRAM1 | fe340000 | 00038000 | u32 | DSP1 XRAM (224ko)        |
|YRAM1 | fe380000 | 0000a000 | u32 | DSP1 YRAM (40ko)         |


Unfortunately, the DSP-X/Y RAMs can be read / write *only* in 24bits mode and use
4-aligned address to avoid complicated access with this area so:
* DSP-X RAM: 172ko instead of 224ko.
* DSP-Y RAM: 30ko instead of 40ko.

DSP-XRAM memory map exemple:
```
<fe240000> 0x00, 0x00, 0x00, <can not be write or read>
<fe240004> 0x00, 0x00, 0x00, <can not be write or read>
<fe240008> 0x00, 0x00, 0x00, <can not be write or read>
<fe24000a> 0x00, 0x00, 0x00, <can not be write or read>
```

---

## Power up protocol

Set the bit 10 of the MSTPCR2 to 1 to power on the module then start manually the
SPU clock by setting the bit 8 of the FRQCRA to 0.


```c
#include "tests.h"
#include "utils.h"

// Based on Casio's protocole
void test_spu(void)
{
	// Block Interrupt from DSP0, DSP1
	// @note: or SPU and FSI ?
	*(volatile uint8_t*)0xa408008c |= 0b00001100;
	*(volatile uint16_t *)0xa4080008 &= 0xfff0;

	// Stop SPU / FSI Clock
	*(volatile uint32_t*)0xa415003c = 0x00000103; // SPU
	*(volatile uint32_t*)0xa4150008 = 0x00000100; // FSI

	// Start FSI and SPU
	// @note: Should alway be in this order ?
	*(volatile uint32_t*)0xa4150008 &= 0xfffffeff; // FSI
	*(volatile uint32_t*)0xa415003c &= 0xfffffeff; // SPU

	// Power-on DSP part (SPU + FSI modules)
	*(volatile uint32_t*)0xa4150038 &= 0xfffffdff;

	// Mask interrupt form SPU.DSP0 and SPU.DSP1
	*(volatile uint32_t*)0xfe2ffd1c = 0x00001000; // DSP0
	*(volatile uint32_t*)0xfe3ffd1c = 0x00001000; // DSP1


	// SPU initialize
	*(volatile uint32_t*)0xfe2ffc24 &= 0xfffffffe; // software reset clear flags
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe2ffc24 |= 0x00000001; // software reset
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe2ffc00 = 0xffffffff;
	*(volatile uint32_t*)0xfe2ffc04 = 0xffffffff;
	*(volatile uint32_t*)0xfe2ffc10 = 0xffffffff;
	*(volatile uint32_t*)0xfe2ffc14 = 0xffffffff;


	// Reset DSPx
	*(volatile uint32_t*)0xfe2ffd04 = 1;
	*(volatile uint32_t*)0xfe3ffd04 = 1;
	for (int i = 0 ; i < 1000 ; ++i);
	*(volatile uint32_t*)0xfe2ffd00 = 0;
	*(volatile uint32_t*)0xfe3ffd00 = 0;

	//
	// You can access to:
	// * DSP-P RAMs: 32 bits (R/W)
	// * DSP-X/Y RAM: 24 bits (R/W)
	//


	// Some tests
	printk("try to use the RAM form DSP0...\n");
	*(volatile uint32_t*)0xfe200000 = 0xffffffff;
	*(volatile uint32_t*)0xfe240000 = 0xffffffff;
	*(volatile uint32_t*)0xfe280000 = 0xffffffff;
	printk("SPU2.PRAM0: %x\n", *(volatile uint32_t*)0xfe200000);
	printk("SPU2.XRAM0: %x\n", *(volatile uint32_t*)0xfe240000);
	printk("SPU2.YRAM0: %x\n", *(volatile uint32_t*)0xfe280000);

	printk("try to use the RAM form DSP1...\n");
	*(volatile uint32_t*)0xfe300000 = 0xffffffff;
	*(volatile uint32_t*)0xfe340000 = 0xffffffff;
	*(volatile uint32_t*)0xfe380000 = 0xffffffff;
	printk("SPU2.PRAM1: %x\n", *(volatile uint32_t*)0xfe300000);
	printk("SPU2.XRAM1: %x\n", *(volatile uint32_t*)0xfe340000);
	printk("SPU2.YRAM1: %x\n", *(volatile uint32_t*)0xfe380000);
	while (1);
}


```

---
