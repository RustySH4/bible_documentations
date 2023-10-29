---
layout: page
title: "SH7305 - registers list"
permalink: /hardware/sh7305/registers_list.html
author: Yatis
---

# SuperH 7305 - registers list

The object of this page is to list all features of the SuperH7305 processor to
avoid some mistake with registers addresses and "real" available modules.

Simon Lothar have found [this list][1] a long time ago, but he never documented
how he obtained the knowledge. Lephenixnoir have asked him on several occasions,
but he never revealed much about it (and he eventually retired around 2019).

But recently, Lephenixnoir finally rediscovered these lists while decompiling the
emulator's CPU73050.dll. There is absolutely no doubt that Simon found the
register list here. (see his note [here][2])

This page is entirely based on the information that Lephenixnoir have found with
the emulator's DLL. So, we are practically sure that we have a complete and
reliable list of the SH7305 processor's registers addresses.

[1]: http://www.casiopeia.net/forum/viewtopic.php?f=11&t=1756#p14588
[2]: https://bible.planet-casio.com/lephenixnoir/resource-compendium.html

Module list:
* [[CPU] - CPU 7355](#cpu---cpu-73050-for-casio)
* [[PFC] - Port function control](#pfc---port-function-control)
* [[IO] - Port I/O](#io---port-io)
* [[INT] - Interrupt](#int---interrupt-controler)
* [[DMA] - DMA Controller](#dma---dma-controller)
* [[MMU] - Memory Manager](#mmu---memory-manager)
* [[Cache] - Cache control](#cache---cache-control)
* [[BSC] - Bus control](#bsc---bus-control)
* [[Clock] - Clock generation](#clock---clock-generation)
* [[RTC] - Real-time clock](#rtc---real-time-clock)
* [[WDT] - Watchdog timer](#wdt---watchdog-timer)
* [[Power] - Power-down modes](#power---power-down-modes)
* [[TMU0] - Timer unit 0](#tmu0---timer-unit-0)
* [[TMU1] - Timer unit 1](#tmu1---timer-unit-1)
* [[TMU2] - Timer unit 2](#tmu2---timer-unit-2)
* [[CMT] - Compare match timer](#cmt---compare-match-timer)
* [[SCIF] - Serial communication](#scif---serial-communication)
* [[IIC] - I2C communication](#iic---i2c-communication)
* [[USB] - USB 2 control](#usb---usb-2-control)
* [[FLCTL] - NAND Flash controller](#flctl---nand-flash-controller)
* [[ECC] - ECC unit](#ecc---ecc-unit)
* [[ADC] - Analog/Digital converter](#adc---analogdigital-converter)
* [[Cmod] - C-specification module](#cmod---c-specification-module)
* [[Cmod2A] - C-specification module 2A](#cmod2a---c-specification-module-2a)
* [[RAM] - On-chip RAM](#ram---on-chip-ram)
* [[UBC] - User break controller](#ubc---user-break-controller)
* [[HUDI] - User debugging interface](#hudi---user-debugging-interface)
* [[SDC] - SD Card controller](#sdc---sd-card-controller)
* [[MMC] - MMC controller](#mmc---mmc-controller)
* [[SHway] - Super Hyway Bus](#shway---super-hyway-bus)
* [[KEY] - Key interface unit](#key---key-interface-unit)
* [[MSIOF0] - Sync serial interface 0](#msiof0---sync-serial-interface-0)
* [[MSIOF1] - Sync serial interface 1](#msiof1---sync-serial-interface-1)
* [[SPU2] - Sound processing unit 2](#spu2---sound-processing-unit-2)
* [[SPU2DSP0] - DSP 0 for sound processing unit 2](#spu2dsp0---dsp-0-for-sound-processing-unit-2)
* [[SPU2DSP1] - DSP 1 for sound processing unit 2](#spu2dsp1---dsp-1-for-sound-processing-unit-2)
* [[SPU2RAM] - Sound processing unit 2 RAM](#spu2ram---sound-processing-unit-2-ram)
* [[FSI] - FIFO serial interface](#fsi---fifo-serial-interface)


---

# [CPU] - CPU 73050 for CASIO

| Name    | Address  | Data size | Access size |  Description                |
|---------|----------|-----------|-------------|-----------------------------|
| TRA     | ff000020 | u32       | u32         |  Trap event                 |
| EXPEVT  | ff000024 | u32       | u32         |  Exception event            |
| EXPMASK | ff2f0004 | u32       | u32         |  Nonsupport exception event |
| CPUOPM  | ff2f0000 | u32       | u32         |  CPU operation mode         |
| PVR     | ff000030 | u32       | u32         |  Processor version          |
| PRR     | ff000044 | u32       | u32         |  Product version            |

<br>

---

# [PFC] - Port function control

| Name      | Address  | Data size | Access size | Description                 |
|-----------|----------|-----------|-------------|-----------------------------|
| PACR      | a4050100 | u16       | u16         | Port A Control              |
| PBCR      | a4050102 | u16       | u16         | Port B Control              |
| PCCR      | a4050104 | u16       | u16         | Port C Control              |
| PDCR      | a4050106 | u16       | u16         | Port D Control              |
| PECR      | a4050108 | u16       | u16         | Port E Control              |
| PFCR      | a405010a | u16       | u16         | Port F Control              |
| PGCR      | a405010c | u16       | u16         | Port G Control              |
| PHCR      | a405010e | u16       | u16         | Port H Control              |
| PJCR      | a4050110 | u16       | u16         | Port J Control              |
| PKCR      | a4050112 | u16       | u16         | Port K Control              |
| PLCR      | a4050114 | u16       | u16         | Port L Control              |
| PMCR      | a4050116 | u16       | u16         | Port M Control              |
| PNCR      | a4050118 | u16       | u16         | Port N Control              |
| PPCR      | a405014c | u16       | u16         | Port P Control              |
| PQCR      | a405011a | u16       | u16         | Port Q Control              |
| PRCR      | a405011c | u16       | u16         | Port R Control              |
| PSCR      | a405011e | u16       | u16         | Port S Control              |
| PTCR      | a4050140 | u16       | u16         | Port T Control              |
| PUCR      | a4050142 | u16       | u16         | Port U Control              |
| PVCR      | a4050144 | u16       | u16         | Port V Control              |
| PSELA     | a405014e | u16       | u16         | Pin group A select          |
| PSELB     | a4050150 | u16       | u16         | Pin group B select          |
| PSELC     | a4050152 | u16       | u16         | Pin group C select          |
| PSELD     | a4050154 | u16       | u16         | Pin group D select          |
| PSELE     | a4050156 | u16       | u16         | Pin group E select          |
| PSELF     | a405015e | u16       | u16         | Pin group F select          |
| PSELG     | a40501c8 | u16       | u16         | Pin group G select          |
| PSELH     | a40501d6 | u16       | u16         | Pin group H select          |
| HIZCRA    | a4050158 | u16       | u16         | Data pin Hi-Z control A     |
| HIZCRB    | a405015a | u16       | u16         | Data pin Hi-Z control B     |
| HIZCRC    | a405015c | u16       | u16         | Data pin Hi-Z control C     |
| MSELCRA   | a4050180 | u16       | u16         | Module function select A    |
| MSELCRB   | a4050182 | u16       | u16         | Module function select B    |
| DRVCRA    | a4050186 | u16       | u16         | Buffer drive control A      |
| DRVCRB    | a4050188 | u16       | u16         | Buffer drive control B      |
| DRVCRC    | a405018a | u16       | u16         | Buffer drive control C      |
| DRVCRD    | a4050184 | u16       | u16         | Buffer drive control D      |
| PULCRBSC  | a40501c3 | u8        | u8          | BSC pull-up/down control    |
| PULCRTRST | a40501c5 | u8        | u8          | TRST pull-up/down select    |
| PULCRA    | a4050190 | u8        | u8          | Port A pull-up/down control |
| PULCRB    | a4050191 | u8        | u8          | Port B pull-up/down control |
| PULCRC    | a4050192 | u8        | u8          | Port C pull-up/down control |
| PULCRD    | a4050193 | u8        | u8          | Port D pull-up/down control |
| PULCRE    | a4050194 | u8        | u8          | Port E pull-up/down control |
| PULCRF    | a4050195 | u8        | u8          | Port F pull-up/down control |
| PULCRG    | a4050196 | u8        | u8          | Port G pull-up/down control |
| PULCRH    | a4050197 | u8        | u8          | Port H pull-up/down control |
| PULCRJ    | a4050198 | u8        | u8          | Port J pull-up/down control |
| PULCRK    | a4050199 | u8        | u8          | Port K pull-up/down control |
| PULCRL    | a405019a | u8        | u8          | Port L pull-up/down control |
| PULCRM    | a405019b | u8        | u8          | Port M pull-up/down control |
| PULCRN    | a405019c | u8        | u8          | Port N pull-up/down control |
| PULCRP    | a40501c6 | u8        | u8          | Port P pull-up/down control |
| PULCRQ    | a405019d | u8        | u8          | Port Q pull-up/down control |
| PULCRR    | a405019e | u8        | u8          | Port R pull-up/down control |
| PULCRS    | a405019f | u8        | u8          | Port S pull-up/down control |
| PULCRT    | a40501c0 | u8        | u8          | Port T pull-up/down control |
| PULCRU    | a40501c1 | u8        | u8          | Port U pull-up/down control |
| PULCRV    | a40501c2 | u8        | u8          | Port V pull-up/down control |

<br>

---

# [IO] - Port I/O

| Name | Address  | Data size | Access size | Description |
|------|----------|-----------|-------------|-------------|
| PADR | a4050120 | u8        | u8          | Port A data |
| PBDR | a4050122 | u8        | u8          | Port B data |
| PCDR | a4050124 | u8        | u8          | Port C data |
| PDDR | a4050126 | u8        | u8          | Port D data |
| PEDR | a4050128 | u8        | u8          | Port E data |
| PFDR | a405012a | u8        | u8          | Port F data |
| PGDR | a405012c | u8        | u8          | Port G data |
| PHDR | a405012e | u8        | u8          | Port H data |
| PJDR | a4050130 | u8        | u8          | Port J data |
| PKDR | a4050132 | u8        | u8          | Port K data |
| PLDR | a4050134 | u8        | u8          | Port L data |
| PMDR | a4050136 | u8        | u8          | Port M data |
| PNDR | a4050138 | u8        | u8          | Port N data |
| PPDR | a405016a | u8        | u8          | Port P data |
| PQDR | a405013a | u8        | u8          | Port Q data |
| PRDR | a405013c | u8        | u8          | Port R data |
| PSDR | a405013e | u8        | u8          | Port S data |
| PTDR | a4050160 | u8        | u8          | Port T data |
| PUDR | a4050162 | u8        | u8          | Port U data |
| PVDR | a4050164 | u8        | u8          | Port V data |

<br>

---

# [INT] - Interrupt Controler

| Name        | Address  | Data size | Access size | Description                  |
|-------------|----------|-----------|-------------|------------------------------|
| IPRA        | a4080000 | u16       | u16         | Interrupt priority A         |
| IPRB        | a4080004 | u16       | u16         | Interrupt priority B         |
| IPRC        | a4080008 | u16       | u16         | Interrupt priority C         |
| IPRD        | a408000c | u16       | u16         | Interrupt priority D         |
| IPRE        | a4080010 | u16       | u16         | Interrupt priority E         |
| IPRF        | a4080014 | u16       | u16         | Interrupt priority F         |
| IPRG        | a4080018 | u16       | u16         | Interrupt priority G         |
| IPRH        | a408001c | u16       | u16         | Interrupt priority H         |
| IPRI        | a4080020 | u16       | u16         | Interrupt priority I         |
| IPRJ        | a4080024 | u16       | u16         | Interrupt priority J         |
| IPRK        | a4080028 | u16       | u16         | Interrupt priority K         |
| IPRL        | a408002c | u16       | u16         | Interrupt priority L         |
| ICR0        | a4140000 | u16       | u16         | Interrupt control 0          |
| ICR1        | a414001c | u16       | u16         | Interrupt control 1          |
| INTPRI00    | a4140010 | u32       | u32         | Interrupt priority for IRQ   |
| INTREQ00    | a4140024 | u8        | u8          | Interrupt request for IRQ    |
| INTMSK00    | a4140044 | u8        | u8          | Interrupt mask for IRQ       |
| INTMSKCLR00 | a4140064 | u8        | u8          | Interrupt mask clear for IRQ |
| NMIFCR      | a41400c0 | u16       | u16         | Interrupt control for NMI    |
| USERIMASK   | a4700000 | u32       | u32         | User interrupt mask          |
| INTEVT      | ff000028 | u32       | u32         | Interrupt event              |
| PINTCRA     | a40501dc | u16       | u16         | PINT control A               |
| PINTCRB     | a40501de | u16       | u16         | PINT control B               |
| PINTSRA     | a40501ea | u8        | u8          | PINT status A                |
| PINTSRB     | a40501ec | u8        | u8          | PINT status B                |
| PINTSRC     | a40501ee | u8        | u8          | PINT status C                |
| PINTSRD     | a40501fa | u8        | u8          | PINT status D                |
| IMR0        | a4080080 | u8        | u8          | Interrupt mask 0             |
| IMCR0       | a40800c0 | u8        | u8          | Interrupt mask clear 0       |
| IMR1        | a4080084 | u8        | u8          | Interrupt mask 1             |
| IMCR1       | a40800c4 | u8        | u8          | Interrupt mask clear 1       |
| IMR2        | a4080088 | u8        | u8          | Interrupt mask 2             |
| IMCR2       | a40800c8 | u8        | u8          | Interrupt mask clear 2       |
| IMR3        | a408008c | u8        | u8          | Interrupt mask 3             |
| IMCR3       | a40800cc | u8        | u8          | Interrupt mask clear 3       |
| IMR4        | a4080090 | u8        | u8          | Interrupt mask 4             |
| IMCR4       | a40800d0 | u8        | u8          | Interrupt mask clear 4       |
| IMR5        | a4080094 | u8        | u8          | Interrupt mask 5             |
| IMCR5       | a40800d4 | u8        | u8          | Interrupt mask clear 5       |
| IMR6        | a4080098 | u8        | u8          | Interrupt mask 6             |
| IMCR6       | a40800d8 | u8        | u8          | Interrupt mask clear 6       |
| IMR7        | a408009c | u8        | u8          | Interrupt mask 7             |
| IMCR7       | a40800dc | u8        | u8          | Interrupt mask clear 7       |
| IMR8        | a40800a0 | u8        | u8          | Interrupt mask 8             |
| IMCR8       | a40800e0 | u8        | u8          | Interrupt mask clear 8       |
| IMR9        | a40800a4 | u8        | u8          | Interrupt mask 9             |
| IMCR9       | a40800e4 | u8        | u8          | Interrupt mask clear 9       |
| IMR10       | a40800a8 | u8        | u8          | Interrupt mask 10            |
| IMCR10      | a40800e8 | u8        | u8          | Interrupt mask clear 10      |
| IMR11       | a40800ac | u8        | u8          | Interrupt mask 11            |
| IMCR11      | a40800ec | u8        | u8          | Interrupt mask clear 11      |
| IMR12       | a40800b0 | u8        | u8          | Interrupt mask 12            |
| IMCR12      | a40800f0 | u8        | u8          | Interrupt mask clear 12      |

<br>

---

# [DMA] - DMA Controller

| Name   | Address  | Data size | Access size | Description           |
|--------|----------|-----------|-------------|-----------------------|
| SAR0   | fe008020 | u32       | u32         | DMA0 Source address   |
| DAR0   | fe008024 | u32       | u32         | DMA0 Dest address     |
| TCR0   | fe008028 | u32       | u32         | DMA0 Count            |
| CHCR0  | fe00802c | u32       | u32         | DMA0 Control          |
| SAR1   | fe008030 | u32       | u32         | DMA1 Source address   |
| DAR1   | fe008034 | u32       | u32         | DMA1 Dest address     |
| TCR1   | fe008038 | u32       | u32         | DMA1 Count            |
| CHCR1  | fe00803c | u32       | u32         | DMA1 Control          |
| SAR2   | fe008040 | u32       | u32         | DMA2 Source address   |
| DAR2   | fe008044 | u32       | u32         | DMA2 Dest address     |
| TCR2   | fe008048 | u32       | u32         | DMA2 Count            |
| CHCR2  | fe00804c | u32       | u32         | DMA2 Control          |
| SAR3   | fe008050 | u32       | u32         | DMA3 Source address   |
| DAR3   | fe008054 | u32       | u32         | DMA3 Dest address     |
| TCR3   | fe008058 | u32       | u32         | DMA3 Count            |
| CHCR3  | fe00805c | u32       | u32         | DMA3 Control          |
| DMAOR  | fe008060 | u16       | u16         | DMA Operation         |
| SAR4   | fe008070 | u32       | u32         | DMA4 Source address   |
| DAR4   | fe008074 | u32       | u32         | DMA4 Dest address     |
| TCR4   | fe008078 | u32       | u32         | DMA4 Count            |
| CHCR4  | fe00807c | u32       | u32         | DMA4 Control          |
| SAR5   | fe008080 | u32       | u32         | DMA5 Source address   |
| DAR5   | fe008084 | u32       | u32         | DMA5 Dest address     |
| TCR5   | fe008088 | u32       | u32         | DMA5 Count            |
| CHCR5  | fe00808c | u32       | u32         | DMA5 Control          |
| SARB0  | fe008120 | u32       | u32         | DMA0 Source address B |
| DARB0  | fe008124 | u32       | u32         | DMA0 Dest address B   |
| TCRB0  | fe008128 | u32       | u32         | DMA0 Count B          |
| SARB1  | fe008130 | u32       | u32         | DMA1 Source address B |
| DARB1  | fe008134 | u32       | u32         | DMA1 Dest address B   |
| TCRB1  | fe008138 | u32       | u32         | DMA1 Count B          |
| SARB2  | fe008140 | u32       | u32         | DMA2 Source address B |
| DARB2  | fe008144 | u32       | u32         | DMA2 Dest address B   |
| TCRB2  | fe008148 | u32       | u32         | DMA2 Count B          |
| SARB3  | fe008150 | u32       | u32         | DMA3 Source address B |
| DARB3  | fe008154 | u32       | u32         | DMA3 Dest address B   |
| TCRB3  | fe008158 | u32       | u32         | DMA3 Count B          |
| DMARS0 | fe009000 | u16       | u16         | DMA resource select 0 |
| DMARS1 | fe009004 | u16       | u16         | DMA resource select 1 |
| DMARS2 | fe009008 | u16       | u16         | DMA resource select 2 |

<br>

---

# [MMU] - Memory Manager

| Name       | Address  | Data size | Access size | Description                         |
|------------|----------|-----------|-------------|-------------------------------------|
| MMUCR      | ff000010 | u32       | u32         | MMU Control                         |
| PTEH       | ff000000 | u32       | u32         | MMU Page table entry high           |
| PTEL       | ff000004 | u32       | u32         | MMU Page table entry low            |
| PTEA       | ff000034 | u32       | u32         | MMU Page table entry assistance     |
| TTB        | ff000008 | u32       | u32         | MMU Translation table base          |
| TEA        | ff00000c | u32       | u32         | MMU TLB Exception address           |
| PASCR      | ff000070 | u32       | u32         | Physical address control            |
| IRMCR      | ff000078 | u32       | u32         | Instruction refetch inhibit control |
| ITLBADDRA  | f2000000 | 01000000  | u32         | ITLB Address Array                  |
| ITLBDATAA1 | f3000000 | 00800000  | u32         | ITLB Data Array 1                   |
| ITLBDATAA2 | f3800000 | 00800000  | u32         | ITLB Data Array 2                   |
| UTLBADDRA  | f6000000 | 00100000  | u32         | UTLB Address Array                  |
| UTLBDATAA1 | f7000000 | 00100000  | u32         | UTLB Data Array 1                   |
| UTLBDATAA2 | f7800000 | 00100000  | u32         | UTLB Data Array 2                   |
| PMBADDRA   | f6100000 | 00100000  | u32         | PMB Address Array                   |
| PMBDATAA   | f7100000 | 00100000  | u32         | PMB Data Array                      |

<br>

---

# [Cache] - Cache control

| Name    | Address  | Data size | Access size | Description                     |
|---------|----------|-----------|-------------|---------------------------------|
| CCR     | ff00001c | u32       | u32         | Cache control                   |
| ICADDRA | f0000000 | 01000000  | u32         | Instruction Cache Address Array |
| ICDATAA | f1000000 | 01000000  | u32         | Instruction Cache Data Array    |
| OCADDRA | f4000000 | 01000000  | u32         | Operand Cache Address Array     |
| OCDATAA | f5000000 | 01000000  | u32         | Operand Cache Data Array        |

<br>

---

# [BSC] - Bus control

| Name    | Address  | Data size | Access size | Description           |
|---------|----------|-----------|-------------|-----------------------|
| RTCSR   | fec10048 | u32       | u32         | Refresh timer control |
| RTCNT   | fec1004c | u32       | u32         | Refresh counter       |
| RTCOR   | fec10050 | u32       | u32         | Refresh constant      |
| CMNCR   | fec10000 | u32       | u32         | Bus Common control    |
| CS0BCR  | fec10004 | u32       | u32         | Bus control for CS0   |
| CS2BCR  | fec10008 | u32       | u32         | Bus control for CS2   |
| CS4BCR  | fec10010 | u32       | u32         | Bus control for CS4   |
| CS3BCR  | fec1000c | u32       | u32         | Bus control for CS3   |
| CS5ABCR | fec10014 | u32       | u32         | Bus control for CS5A  |
| CS5BBCR | fec10018 | u32       | u32         | Bus control for CS5B  |
| CS6ABCR | fec1001c | u32       | u32         | Bus control for CS6A  |
| CS6BBCR | fec10020 | u32       | u32         | Bus control for CS6B  |
| CS0WCR  | fec10024 | u32       | u32         | Wait control for CS0  |
| CS2WCR  | fec10028 | u32       | u32         | Wait control for CS2  |
| CS3WCR  | fec1002c | u32       | u32         | Wait control for CS3  |
| CS4WCR  | fec10030 | u32       | u32         | Wait control for CS4  |
| CS5AWCR | fec10034 | u32       | u32         | Wait control for CS5A |
| CS5BWCR | fec10038 | u32       | u32         | Wait control for CS5B |
| CS6AWCR | fec1003c | u32       | u32         | Wait control for CS6A |
| CS6BWCR | fec10040 | u32       | u32         | Wait control for CS6B |
| SDCR    | fec10044 | u32       | u32         | SDRAM control         |
| SDMR2   | fec14000 | 00001000  | u8          | SDRAM mode for CS2    |
| SDMR3   | fec15000 | 00001000  | u8          | SDRAM mode for CS3    |

<br>

---

# [Clock] - Clock generation

| Name     | Address  |  Data size | Access size | Description                |
|-----------------------------------------------------------------------------|
| FRQCR    | a4150000 |  u32       | u32         | Frequency control          |
| FSICLKCR | a4150008 |  u32       | u32         | FSI Clock control          |
| SPUCLKCR | a415003c |  u32       | u32         | SPU Clock control          |
| DDCLKCR  | a4150010 |  u32       | u32         | DD Clock control           |
| USBCLKCR | a4150014 |  u32       | u32         | USB Clock control          |
| PLLCR    | a4150024 |  u32       | u32         | PLL1 control               |
| PLL2CR   | a4150028 |  u32       | u32         | PLL2 control               |
| FLLFRQ   | a4150050 |  u32       | u32         | FLL Multiplication control |
| LSTATUS  | a4150060 |  u32       | u32         | Frequency change status    |
| SSCGCR   | a4150044 |  u32       | u32         | Spread spectrum control    |

<br>

---

# [RTC] - Real-time clock

| Name       | Address  | Data size | Access size | Description            |
|------------|----------|-----------|-------------|------------------------|
| R64CNT     | a413fec0 | u8        | u8          | 64-Hz counter          |
| RSECCNT    | a413fec2 | u8        | u8          | Seconds counter        |
| RMINCNT    | a413fec4 | u8        | u8          | Minutes counter        |
| RHRCNT     | a413fec6 | u8        | u8          | Hours counter          |
| RWKCNT     | a413fec8 | u8        | u8          | Weekday counter        |
| RDAYCNT    | a413feca | u8        | u8          | Date counter           |
| RMONCNT    | a413fecc | u8        | u8          | Months counter         |
| RYRCNT     | a413fece | u16       | u16         | Years counter          |
| RSECAR     | a413fed0 | u8        | u8          | Seconds alarm          |
| RMINAR     | a413fed2 | u8        | u8          | Minutes alarm          |
| RHRAR      | a413fed4 | u8        | u8          | Hours alarm            |
| RWKAR      | a413fed6 | u8        | u8          | Weekday alarm          |
| RDAYAR     | a413fed8 | u8        | u8          | Date alarm             |
| RMONAR     | a413feda | u8        | u8          | Months alarm           |
| RYRAR      | a413fee0 | u16       | u16         | Years alarm            |
| RCR1       | a413fedc | u8        | u8          | RTC control 1          |
| RCR2       | a413fede | u8        | u8          | RTC control 2          |
| RCR3       | a413fee4 | u8        | u8          | RTC control 3          |
| RWTCNT     | a4520000 | u16       | u16         | Watchdog timer counter |
| RWTCSR     | a4520004 | u16       | u16         | Watchdog control       |

<br>

---

#  [WDT] - Watchdog timer

| Name   | Address  | Data size | Access size | Description            |
|--------|----------|-----------|-------------|------------------------|
| RWTCNT | a4520000 | u16       | u16         | Watchdog timer counter |
| RWTCSR | a4520004 | u16       | u16         | Watchdog control       |

<br>

---

# [Power] - Power-down modes

| Name    | Address  | Data size | Access size | Description     |
|---------|----------|-----------|-------------|-----------------|
| STBCR   | a4150020 | u32       | u32         | Standby control |
| MSTPCR0 | a4150030 | u32       | u32         | Module stop 0   |
| MSTPCR2 | a4150038 | u32       | u32         | Module stop 2   |
| BAR     | a4150040 | u32       | u32         | Boot address    |

<br>

---


# [TMU0] - Timer unit 0

| Name  | Address  | Data size | Access size | Description      |
|-------|----------|-----------|-------------|------------------|
| TSTR  | a4490004 | u8        | u8          | Timer start      |
| TCOR0 | a4490008 | u32       | u32         | Timer 0 constant |
| TCNT0 | a449000c | u32       | u32         | Timer 0 counter  |
| TCR0  | a4490010 | u16       | u16         | Timer 0 control  |

# [TMU1] - Timer unit 1

| Name  | Address  | Data size | Access size | Description      |
|-------|----------|-----------|-------------|------------------|
| TCOR1 | a4490014 | u32       | u32         | Timer 1 constant |
| TCNT1 | a4490018 | u32       | u32         | Timer 1 counter  |
| TCR1  | a449001c | u16       | u16         | Timer 1 control  |

# [TMU2] - Timer unit 2

| Name  | Address  | Data size | Access size | Description      |
|-------|----------|-----------|-------------|------------------|
| TCOR2 | a4490020 | u32       | u32         | Timer 2 constant |
| TCNT2 | a4490024 | u32       | u32         | Timer 2 counter  |
| TCR2  | a4490028 | u16       | u16         | Timer 2 control  |

<br>

---

# [CMT] - Compare match timer

| Name  | Address  | Data size | Access size | Description                  |
|-------|----------|-----------|-------------|------------------------------|
| CMSTR | a44a0000 | u16       | u16         | Compare match timer start    |
| CMCSR | a44a0060 | u16       | u16         | Compare match timer control  |
| CMCNT | a44a0064 | u32       | u32         | Compare match timer counter  |
| CMCOR | a44a0068 | u32       | u32         | Compare match timer constant |

<br>

---

# [SCIF] - Serial communication

| Name   | Address  | Data size | Access size | Description          |
|--------|----------|-----------|-------------|----------------------|
| SCSMR  | 04410000 | u16       | u16         | Serial Mode          |
| SCBRR  | 04410004 | u8        | u8          | Serial Bit rate      |
| SCSCR  | 04410008 | u16       | u16         | Serial Control       |
| SCFTDR | 0441000c | u8        | u8          | Serial Transmit data |
| SCFSR  | 04410010 | u16       | u16         | Serial Status        |
| SCFRDR | 04410014 | u8        | u8          | Serial Receive data  |
| SCFCR  | 04410018 | u16       | u16         | Serial FIFO control  |
| SCFDR  | 0441001c | u16       | u16         | Serial FIFO count    |
| SCLSR  | 04410024 | u16       | u16         | Serial Line status   |

<br>

---

# [IIC] - I2C communication

| Name | Address  | Data size | Access size | Description            |
|------|----------|-----------|-------------|------------------------|
| ICDR | 04470000 | u8        | u8          | I2C bus data           |
| ICCR | 04470004 | u8        | u8          | I2C bus control        |
| ICSR | 04470008 | u8        | u8          | I2C bus status         |
| ICIC | 0447000c | u8        | u8          | I2C interrupt control  |
| ICCL | 04470010 | u8        | u8          | I2C clock control low  |
| ICCH | 04470014 | u8        | u8          | I2C clock control high |

<br>

---

# [USB] - USB 2 control

| Name      | Address  | Data size | Access size | Description                       |
|-----------|----------|-----------|-------------|-----------------------------------|
| SYSCFG    | a4d80000 | u16       | u16         | System configuration control      |
| BUSWAIT   | a4d80002 | u16       | u16         | CPU bus wait setting              |
| SYSSTS    | a4d80004 | u16       | u16         | System configuration status       |
| DVSTCTR   | a4d80008 | u16       | u16         | Device status control             |
| TESTMODE  | a4d8000c | u16       | u16         | Test mode                         |
| CFIFO     | a4d80014 | u32       | u8          | CFIFO port                        |
| D0FIFO    | a4d80018 | u32       | u8          | D0FIFO port                       |
| D1FIFO    | a4d8001c | u32       | u8          | D1FIFO port                       |
| CFIFOSEL  | a4d80020 | u16       | u16         | CFIFO port select                 |
| CFIFOCTR  | a4d80022 | u16       | u16         | CFIFO port control                |
| D0FIFOSEL | a4d80028 | u16       | u16         | D0FIFO port select                |
| D0FIFOCTR | a4d8002a | u16       | u16         | D0FIFO port control               |
| D1FIFOSEL | a4d8002c | u16       | u16         | D1FIFO port select                |
| D1FIFOCTR | a4d8002e | u16       | u16         | D1FIFO port control               |
| INTENB0   | a4d80030 | u16       | u16         | Interrupt enable 0                |
| BRDYENB   | a4d80036 | u16       | u16         | BRDY interrupt enable             |
| NRDYENB   | a4d80038 | u16       | u16         | NRDY interrupt enable             |
| BEMPENB   | a4d8003a | u16       | u16         | BEMP interrupt enable             |
| SOFCFG    | a4d8003c | u16       | u16         | SOF pin configuration             |
| INTSTS0   | a4d80040 | u16       | u16         | Interrupt status 0                |
| BRDYSTS   | a4d80046 | u16       | u16         | BRDY interrupt status             |
| NRDYSTS   | a4d80048 | u16       | u16         | NRDY interrupt status             |
| BEMPSTS   | a4d8004a | u16       | u16         | BEMP interrupt status             |
| FRMNUM    | a4d8004c | u16       | u16         | Frame number                      |
| UFRMNUM   | a4d8004e | u16       | u16         | mFrame number                     |
| USBADDR   | a4d80050 | u16       | u16         | USB address                       |
| USBREQ    | a4d80054 | u16       | u16         | USB request type                  |
| USBVAL    | a4d80056 | u16       | u16         | USB request value                 |
| USBINDX   | a4d80058 | u16       | u16         | USB request index                 |
| USBLENG   | a4d8005a | u16       | u16         | USB request length                |
| DCPCFG    | a4d8005c | u16       | u16         | DCP configuration                 |
| DCPMAXP   | a4d8005e | u16       | u16         | DCP max packet size               |
| DCPCTR    | a4d80060 | u16       | u16         | DCP control                       |
| PIPESEL   | a4d80064 | u16       | u16         | Pipe window select                |
| PIPECFG   | a4d80068 | u16       | u16         | Pipe configuration                |
| PIPEBUF   | a4d8006a | u16       | u16         | Pipe buffer setting               |
| PIPEMAXP  | a4d8006c | u16       | u16         | Pipe max packet size              |
| PIPEPERI  | a4d8006e | u16       | u16         | Pipe cycle control                |
| PIPE1CTR  | a4d80070 | u16       | u16         | Pipe 1 control                    |
| PIPE2CTR  | a4d80072 | u16       | u16         | Pipe 2 control                    |
| PIPE3CTR  | a4d80074 | u16       | u16         | Pipe 3 control                    |
| PIPE4CTR  | a4d80076 | u16       | u16         | Pipe 4 control                    |
| PIPE5CTR  | a4d80078 | u16       | u16         | Pipe 5 control                    |
| PIPE6CTR  | a4d8007a | u16       | u16         | Pipe 6 control                    |
| PIPE7CTR  | a4d8007c | u16       | u16         | Pipe 7 control                    |
| PIPE8CTR  | a4d8007e | u16       | u16         | Pipe 8 control                    |
| PIPE9CTR  | a4d80080 | u16       | u16         | Pipe 9 control                    |
| PIPE1TRE  | a4d80090 | u16       | u16         | Pipe 1 transaction counter enable |
| PIPE1TRN  | a4d80092 | u16       | u16         | Pipe 1 transaction counter        |
| PIPE2TRE  | a4d80094 | u16       | u16         | Pipe 2 transaction counter enable |
| PIPE2TRN  | a4d80096 | u16       | u16         | Pipe 2 transaction counter        |
| PIPE3TRE  | a4d80098 | u16       | u16         | Pipe 3 transaction counter enable |
| PIPE3TRN  | a4d8009a | u16       | u16         | Pipe 3 transaction counter        |
| PIPE4TRE  | a4d8009c | u16       | u16         | Pipe 4 transaction counter enable |
| PIPE4TRN  | a4d8009e | u16       | u16         | Pipe 4 transaction counter        |
| PIPE5TRE  | a4d800a0 | u16       | u16         | Pipe 5 transaction counter enable |
| PIPE5TRN  | a4d800a2 | u16       | u16         | Pipe 5 transaction counter        |
| UPONCR    | a40501d4 | u16       | u16         | USB power control                 |

<br>

---

#  [FLCTL] - NAND Flash controller

| Name          | Address  | Data size | Access size | Description                            |
|---------------|----------|-----------|-------------|----------------------------------------|
| FLCMNCR       | 04cc0000 | u32       | u32         | Flash common control                   |
| FLCMDCR       | 04cc0004 | u32       | u32         | Flash command control                  |
| FLCMCDR       | 04cc0008 | u32       | u32         | Flash command code                     |
| FLADR         | 04cc000c | u32       | u32         | Flash address                          |
| FLADR2        | 04cc003c | u32       | u32         | Flash address 2                        |
| FLDTCNTR      | 04cc0014 | u32       | u32         | Flash data counter                     |
| FLDATAR       | 04cc0010 | u32       | u32         | Flash data                             |
| FLINTDMACR    | 04cc0018 | u32       | u32         | Flash Interrupt/DMA control            |
| FLBSYTMR      | 04cc001c | u32       | u32         | Flash Ready/busy timeout               |
| FLBSYCNT      | 04cc0020 | u32       | u32         | Flash Ready/busy timeout counter       |
| FLDTFIFO      | 04cc0024 | u32       | u32         | Flash data FIFO                        |
| FLDTFIFO2     | 04cc0050 | 00000010  | u32         | Flash data FIFO                        |
| FLECFIFO      | 04cc0028 | u32       | u32         | Flash control code FIFO                |
| FLECFIFO2     | 04cc0060 | 00000010  | u32         | Flash control code FIFO                |
| FLTRCR        | 04cc002c | u8        | u8          | Flash transfer control                 |
| FL4ECCRESULT1 | 04cc0080 | u32       | u32         | Flash ECC result 1                     |
| FL4ECCRESULT2 | 04cc0084 | u32       | u32         | Flash ECC result 2                     |
| FL4ECCRESULT3 | 04cc0088 | u32       | u32         | Flash ECC result 3                     |
| FL4ECCRESULT4 | 04cc008c | u32       | u32         | Flash ECC result 4                     |
| FL4ECCCR      | 04cc0090 | u32       | u32         | Flash ECC control                      |
| FL4ECCCNT     | 04cc0094 | u32       | u32         | Flash ECC error count                  |
| FLERRADR      | 04cc0098 | u32       | u32         | Flash error address                    |
| FLNANDON      | 04cc009c | u32       | u32         | NAND control                           |
| FLAPPBUF      | 04cc1000 | 00000100  | u32         | Flash Auto Page Program address buffer |

<br>

---

# [ECC] - ECC unit

| Name       | Address  | Data size | Access size | Description            |
|------------|----------|-----------|-------------|------------------------|
| ECCCR      | fd000000 | u32       | u32         | ECC control            |
| ECCSR      | fd000004 | u32       | u32         | ECC status             |
| ECCINTCR   | fd000008 | u32       | u32         | ECC interrupt control  |
| ECCRSTR    | fd00000c | u32       | u32         | ECC reset              |
| ECCERCNTR  | fd000010 | u32       | u32         | ECC error count        |
| ECCBWCNTR  | fd000080 | u32       | u32         | ECC buffer write count |
| ECCERPOS1  | fd000084 | u32       | u32         | ECC error position 1   |
| ECCERPOS2  | fd000088 | u32       | u32         | ECC error position 2   |
| ECCERPOS3  | fd00008c | u32       | u32         | ECC error position 3   |
| ECCERPOS4  | fd000090 | u32       | u32         | ECC error position 4   |
| ECCERPOS5  | fd000094 | u32       | u32         | ECC error position 5   |
| ECCERPOS6  | fd000098 | u32       | u32         | ECC error position 6   |
| ECCERPOS7  | fd00009c | u32       | u32         | ECC error position 7   |
| ECCERPOS8  | fd0000a0 | u32       | u32         | ECC error position 8   |
| ECCERPOS9  | fd0000a4 | u32       | u32         | ECC error position 9   |
| ECCERPOS10 | fd0000a8 | u32       | u32         | ECC error position 10  |
| ECCERPOS11 | fd0000ac | u32       | u32         | ECC error position 11  |
| ECCERPOS12 | fd0000b0 | u32       | u32         | ECC error position 12  |
| ECCERPOS13 | fd0000b4 | u32       | u32         | ECC error position 13  |
| ECCERPOS14 | fd0000b8 | u32       | u32         | ECC error position 14  |
| ECCERPOS15 | fd0000bc | u32       | u32         | ECC error position 15  |
| ECCBUF     | fd001000 | 00000480  | u8          | ECC buffer             |

<br>

---

# [ADC] - Analog/Digital converter

| Name   | Address  | Data size | Access size | Description        |
|--------|----------|-----------|-------------|--------------------|
| ADDRA  | 04610080 | u16       | u16         | A/D A data         |
| ADDRB  | 04610082 | u16       | u16         | A/D B data         |
| ADDRC  | 04610084 | u16       | u16         | A/D C data         |
| ADDRD  | 04610086 | u16       | u16         | A/D D data         |
| ADCSR  | 04610088 | u16       | u16         | A/D Control/status |
| ADCCSR | 0461008a | u16       | u16         | A/D Custom control |
| ADCUST | 0461008c | u16       | u16         | A/D Control        |
| ADPCTL | 0461008e | u16       | u16         | A/D Port control   |

<br>

---

# [Cmod] - C-specification module

| Name      | Address  | Data size | Access size | Description                 |
|-----------|----------|-----------|-------------|-----------------------------|
| DDCLKR0   | a44c0000 | u16       | u16         | External CLK1 setting       |
| DDCLKR1   | a44c0002 | u16       | u16         | External CLK2 setting       |
| DDCLKR2   | a44c0004 | u16       | u16         | External CLK3 setting       |
| DDCK_CNTR | a44c0020 | u8        | u8          | External clock control      |
| DDCS_CNTR | a44c0006 | u8        | u8          | External CS control         |
| HIZ_CNTR  | a44c0008 | u8        | u8          | Interrupt pin level control |
| FASCR     | a4cb0010 | u16       | u16         | BCD Calculation control     |
| FASSRA    | a4cb0014 | u32       | u32         | BCD Calculation source A    |
| FASSRB    | a4cb0018 | u32       | u32         | BCD Calculation source B    |
| FASDR     | a4cb001c | u32       | u32         | BCD Calculation result      |
| RTSTR0    | a44d0030 | u8        | u8          | RTC Clock timer 0 start     |
| RTCR0     | a44d003c | u8        | u8          | RTC Clock timer 0 control   |
| RTCOR0    | a44d0034 | u32       | u32         | RTC Clock timer 0 constant  |
| RTCNT0    | a44d0038 | u32       | u32         | RTC Clock timer 0 counter   |
| RTSTR1    | a44d0050 | u8        | u8          | RTC Clock timer 1 start     |
| RTCR1     | a44d005c | u8        | u8          | RTC Clock timer 1 control   |
| RTCOR1    | a44d0054 | u32       | u32         | RTC Clock timer 1 constant  |
| RTCNT1    | a44d0058 | u32       | u32         | RTC Clock timer 1 counter   |
| RTSTR2    | a44d0070 | u8        | u8          | RTC Clock timer 2 start     |
| RTCR2     | a44d007c | u8        | u8          | RTC Clock timer 2 control   |
| RTCOR2    | a44d0074 | u32       | u32         | RTC Clock timer 2 constant  |
| RTCNT2    | a44d0078 | u32       | u32         | RTC Clock timer 2 counter   |
| RTSTR3    | a44d0090 | u8        | u8          | RTC Clock timer 3 start     |
| RTCR3     | a44d009c | u8        | u8          | RTC Clock timer 3 control   |
| RTCOR3    | a44d0094 | u32       | u32         | RTC Clock timer 3 constant  |
| RTCNT3    | a44d0098 | u32       | u32         | RTC Clock timer 3 counter   |
| RTSTR4    | a44d00b0 | u8        | u8          | RTC Clock timer 4 start     |
| RTCR4     | a44d00bc | u8        | u8          | RTC Clock timer 4 control   |
| RTCOR4    | a44d00b4 | u32       | u32         | RTC Clock timer 4 constant  |
| RTCNT4    | a44d00b8 | u32       | u32         | RTC Clock timer 4 counter   |
| RTSTR5    | a44d00d0 | u8        | u8          | RTC Clock timer 5 start     |
| RTCR5     | a44d00dc | u8        | u8          | RTC Clock timer 5 control   |
| RTCOR5    | a44d00d4 | u32       | u32         | RTC Clock timer 5 constant  |
| RTCNT5    | a44d00d8 | u32       | u32         | RTC Clock timer 5 counter   |

<br>

---

# [Cmod2A] - C-specification module 2A

| Name      | Address  | Data size | Access size | Description                           |
|-----------|----------|-----------|-------------|---------------------------------------|
| CHRMCTRL  | a4cd0000 | u32       | u32         | Character extension operation control |
| CHRCOLOR  | a4cd0004 | u32       | u32         | Character color specification         |
| CHRRADDR  | a4cd0008 | u32       | u32         | Character data read start address     |
| CHRSIZE   | a4cd000c | u32       | u32         | Character data read length            |
| MSKRADDR  | a4cd0010 | u32       | u32         | Mask data read start address          |
| VRMWADDR  | a4cd0014 | u32       | u32         | VRAM write start address              |
| VRMWSBIT  | a4cd0018 | u32       | u32         | VRAM write start bit                  |
| VRMAREA   | a4cd001c | u32       | u32         | VRAM area                             |
| DESWADDR  | a4cd0020 | u32       | u32         | Destination write start address       |
| DESAREA   | a4cd0024 | u32       | u32         | Destination area                      |
| DMAMCTRL  | a4cd0028 | u32       | u32         | DMA data transfer operation control   |
| VRMRADDR  | a4cd002c | u32       | u32         | VRAM data read start address          |
| VRMRSIZE  | a4cd0030 | u32       | u32         | VRAM data read length                 |
| DDWPOINT1 | a4cd0034 | u32       | u32         | D/D-RAM write start pointer 1         |
| DDWPOINT2 | a4cd0038 | u32       | u32         | D/D-RAM write start pointer 2         |
| DDWPOINT3 | a4cd003c | u32       | u32         | D/D-RAM write start pointer 3         |
| DDWPOINT4 | a4cd0040 | u32       | u32         | D/D-RAM write start pointer 4         |
| DDWSIZE1  | a4cd0044 | u32       | u32         | D/D-RAM write length 1                |
| DDWSIZE2  | a4cd0048 | u32       | u32         | D/D-RAM write length 2                |
| DDWSIZE3  | a4cd004c | u32       | u32         | D/D-RAM write length 3                |
| DDWSIZE4  | a4cd0050 | u32       | u32         | D/D-RAM write length 4                |
| DDAREA1   | a4cd0054 | u32       | u32         | D/D-RAM area 1                        |
| DDAREA2   | a4cd0058 | u32       | u32         | D/D-RAM area 2                        |
| DDAREA3   | a4cd005c | u32       | u32         | D/D-RAM area 3                        |
| DDAREA4   | a4cd0060 | u32       | u32         | D/D-RAM area 4                        |
| LAYMCTRL  | a4cd0064 | u32       | u32         | Layer operation control               |

<br>

---

# [RAM] - On-chip RAM

| Name  | Address  | Data size | Access size | Description                   |
|-------|----------|-----------|-------------|-------------------------------|
| XRAM  | e5007000 | 00002000  | 00000000    | On-chip DSP XRAM              |
| YRAM  | e5017000 | 00002000  | 00000000    | On-chip DSP YRAM              |
| ILRAM | e5200000 | 00001000  | 00000000    | On-chip DSP ILRAM             |
| RSRAM | fd800000 | 00004000  | 00000000    | On-chip RS RAM                |
| RAMCR | ff000074 | u32       | u32         | On-chip memory control        |
| XSA   | ff000050 | u32       | u32         | X memory transfer source      |
| YSA   | ff000054 | u32       | u32         | Y memory transfer source      |
| XDA   | ff000058 | u32       | u32         | X memory transfer destination |
| YDA   | ff00005c | u32       | u32         | Y memory transfer destination |
| XPR   | ff000060 | u32       | u32         | X bus protection control      |
| YPR   | ff000064 | u32       | u32         | Y bus protection control      |
| YEA   | ff00006c | u32       | u32         | Y bus exception address       |
| XEA   | ff000068 | u32       | u32         | X bus exception address       |

<br>

---

# [UBC] - User break controller

| Name  | Address  | Data size | Access size | Description                  |
|-------|----------|-----------|-------------|------------------------------|
| CBR0  | ff200000 | u32       | u32         | Match condition setting 0    |
| CRR0  | ff200004 | u32       | u32         | Match operation setting 0    |
| CAR0  | ff200008 | u32       | u32         | Match address setting 0      |
| CAMR0 | ff20000c | u32       | u32         | Match address mask setting 0 |
| CBR1  | ff200020 | u32       | u32         | Match condition setting 1    |
| CRR1  | ff200024 | u32       | u32         | Match operation setting 1    |
| CAR1  | ff200028 | u32       | u32         | Match address setting 1      |
| CAMR1 | ff20002c | u32       | u32         | Match address mask setting 1 |
| CDR1  | ff200030 | u32       | u32         | Match data setting 1         |
| CDMR1 | ff200034 | u32       | u32         | Match data mask setting 1    |
| CETR1 | ff200038 | u32       | u32         | Execution count break 1      |
| CCMFR | ff200600 | u32       | u32         | Channel match flag           |
| CBCR  | ff200620 | u32       | u32         | Break control                |

<br>

---

# [HUDI] - User debugging interface

| Name    | Address  | Data size | Access size | Description        |
|---------|----------|-----------|-------------|--------------------|
| SDIR    | fc110000 | u16       | u16         | Debug instruction  |
| SDDRH   | fc110008 | u16       | u16         | Data register high |
| SDDRL   | fc11000a | u16       | u16         | Data register low  |
| SDINT   | fc110018 | u16       | u16         | Interrupt source   |

<br>

---

# [SDC] - SD Card controller

| Name            | Address  | Data size | Access size | Description           |
|-----------------|----------|-----------|-------------|-----------------------|
| SD_CMD          | a4cf0000 | u16       | u16         | ?                     |
| SD_ARG0         | a4cf0004 | u16       | u16         | ?                     |
| SD_ARG1         | a4cf0006 | u16       | u16         | ?                     |
| SD_STOP         | a4cf0008 | u16       | u16         | ?                     |
| SD_SECCNT       | a4cf000a | u16       | u16         | ?                     |
| SD_RSP0         | a4cf000c | u16       | u16         | ?                     |
| SD_RSP1         | a4cf000e | u16       | u16         | ?                     |
| SD_RSP2         | a4cf0010 | u16       | u16         | ?                     |
| SD_RSP3         | a4cf0012 | u16       | u16         | ?                     |
| SD_RSP4         | a4cf0014 | u16       | u16         | ?                     |
| SD_RSP5         | a4cf0016 | u16       | u16         | ?                     |
| SD_RSP6         | a4cf0018 | u16       | u16         | ?                     |
| SD_RSP7         | a4cf001a | u16       | u16         | ?                     |
| SD_INFO1        | a4cf001c | u16       | u16         | SD card information 1 |
| SD_INFO2        | a4cf001e | u16       | u16         | ?                     |
| SD_INFO1_MASK   | a4cf0020 | u16       | u16         | ?                     |
| SD_INFO2_MASK   | a4cf0022 | u16       | u16         | ?                     |
| SD_CLK_CNTL     | a4cf0024 | u16       | u16         | ?                     |
| SD_SIZE         | a4cf0026 | u16       | u16         | ?                     |
| SD_OPTION       | a4cf0028 | u16       | u16         | ?                     |
| SD_ERR_STS1     | a4cf002c | u16       | u16         | ?                     |
| SD_ERR_STS2     | a4cf002e | u16       | u16         | ?                     |
| SD_BUFO         | a4cf0030 | u16       | u16         | ?                     |
| SDIO_MODE       | a4cf0034 | u16       | u16         | ?                     |
| SDIO_INFO1      | a4cf0036 | u16       | u16         | ?                     |
| SDIO_INFO1_MASK | a4cf0038 | u16       | u16         | ?                     |
| CC_EXT_MODE     | a4cf00d8 | u16       | u16         | ?                     |
| SOFT_RST        | a4cf00e0 | u16       | u16         | ?                     |
| VERSION         | a4cf00e2 | u16       | u16         | ?                     |
| EXT_SWAP        | a4cf00f0 | u16       | u16         | ?                     |

<br>

---

# [MMC] - MMC controller

| Name          | Address  | Data size | Access size | Description                 |
|---------------|----------|-----------|-------------|-----------------------------|
| CE_CMD_SET    | a4ca0000 | u32       | u32         | Command setting             |
| CE_ARG        | a4ca0008 | u32       | u32         | Argument                    |
| CE_ARG_CMD12  | a4ca000c | u32       | u32         | Argument for CMD12          |
| CE_CMD_CTRL   | a4ca0010 | u32       | u32         | Command control             |
| CE_BLOCK_SET  | a4ca0014 | u32       | u32         | Transfer block setting      |
| CE_CLK_CTRL   | a4ca0018 | u32       | u32         | Clock control               |
| CE_BUF_ACC    | a4ca001c | u32       | u32         | Buffer access configuration |
| CE_RESP3      | a4ca0020 | u32       | u32         | Response 3                  |
| CE_RESP2      | a4ca0024 | u32       | u32         | Response 2                  |
| CE_RESP1      | a4ca0028 | u32       | u32         | Response 1                  |
| CE_RESP0      | a4ca002c | u32       | u32         | Response 0                  |
| CE_RESP_CMD12 | a4ca0030 | u32       | u32         | Response for CMD12          |
| CE_DATA       | a4ca0034 | u32       | u32         | Data                        |
| CE_BOOT       | a4ca003c | u32       | u32         | Boot operation setting      |
| CE_INT        | a4ca0040 | u32       | u32         | Interrupt flag              |
| CE_INT_EN     | a4ca0044 | u32       | u32         | Enterrupt enable            |
| CE_HOST_STS1  | a4ca0048 | u32       | u32         | Status 1                    |
| CE_HOST_STS2  | a4ca004c | u32       | u32         | Status 2                    |
| CE_VERSION    | a4ca007c | u32       | u32         | Version                     |

<br>

---

# [SHway] - Super Hyway Bus

| Name     | Address  | Data size | Access size | Description         |
|----------|----------|-----------|-------------|---------------------|
| PRLCKCR  | ff800018 | u32       | u32         | LCK control         |
| PRPRICR0 | ff800020 | u32       | u32         | PRI control 0       |
| PRPRICR1 | ff800028 | u32       | u32         | PRI control 1       |
| PRPRICR2 | ff800030 | u32       | u32         | PRI control 2       |
| PRPRICR3 | ff800038 | u32       | u32         | PRI control 3       |
| PRPRICR4 | ff800040 | u32       | u32         | PRI control 4       |
| PRPRICR5 | ff800048 | u32       | u32         | PRI control 5       |
| SHOCMCR  | a4530000 | u32       | u32         | SHOC master control |
| SHOCMSR  | a4530004 | u32       | u32         | SHOC master status  |

<br>

---

# [KEY] - Key interface unit

| Name           | Address  | Data size | Access size | Description                  |
|----------------|----------|-----------|-------------|------------------------------|
| KIUDATA0       | a44b0000 | u16       | u16         | Key input data 0             |
| KIUDATA1       | a44b0002 | u16       | u16         | Key input data 1             |
| KIUDATA2       | a44b0004 | u16       | u16         | Key input data 2             |
| KIUDATA3       | a44b0006 | u16       | u16         | Key input data 3             |
| KIUDATA4       | a44b0008 | u16       | u16         | Key input data 4             |
| KIUDATA5       | a44b000a | u16       | u16         | Key input data 5             |
| KIUCNTREG      | a44b000c | u16       | u16         | Scan control                 |
| KIAUTOFIXREG   | a44b000e | u16       | u16         | Automatic key bounce setting |
| KIUMODEREG     | a44b0010 | u16       | u16         | Scan mode setting            |
| KIUSTATEREG    | a44b0012 | u16       | u16         | Scan state                   |
| KIUINTREG      | a44b0014 | u16       | u16         | Interrupt setting            |
| KIUWSETREG     | a44b0016 | u16       | u16         | Scan wait time setting       |
| KIUINTERVALREG | a44b0018 | u16       | u16         | Scan interval time setting   |
| KOUTPINSET     | a44b001a | u16       | u16         | KOUT line function setting   |
| KINPINSET      | a44b001c | u16       | u16         | KIN line function setting    |

<br>

---

# [MSIOF0] - Sync serial interface 0

| Name    | Address  | Data size | Access size | Description              |
|---------|----------|-----------|-------------|--------------------------|
| SITMDR1 | a4c40000 | u32       | u32         | Transmit mode 1          |
| SITMDR2 | a4c40004 | u32       | u32         | Transmit mode 2          |
| SITMDR3 | a4c40008 | u32       | u32         | Transmit mode 3          |
| SITSCR  | a4c40020 | u16       | u16         | Transmit clock select    |
| SIRMDR1 | a4c40010 | u32       | u32         | Receive mode 1           |
| SIRMDR2 | a4c40014 | u32       | u32         | Receive mode 2           |
| SIRMDR3 | a4c40018 | u32       | u32         | Receive mode 3           |
| SIRSCR  | a4c40024 | u16       | u16         | Receive clock select     |
| SICTR   | a4c40028 | u32       | u32         | Control                  |
| SIFCTR  | a4c40030 | u32       | u32         | FIFO control             |
| SISTR   | a4c40040 | u32       | u32         | Status                   |
| SIIER   | a4c40044 | u32       | u32         | Interrupt enable         |
| SITDR1  | a4c40048 | u32       | u32         | Transmit control data 1  |
| SITDR2  | a4c4004c | u32       | u32         | Transmit control data 2  |
| SITFDR  | a4c40050 | u32       | u32         | Transmit FIFO data       |
| SIRDR1  | a4c40058 | u32       | u32         | Receive control data 1   |
| SIRDR2  | a4c4005c | u32       | u32         | Receive control data 2   |
| SIRFDR  | a4c40060 | u32       | u32         | Receive FIFO data        |

<br>

---

# [MSIOF1] - Sync serial interface 1

| Name    | Address  | Data size | Access size | Description              |
|---------|----------|-----------|-------------|--------------------------|
| SITMDR1 | a4c50000 | u32       | u32         | Transmit mode 1          |
| SITMDR2 | a4c50004 | u32       | u32         | Transmit mode 2          |
| SITMDR3 | a4c50008 | u32       | u32         | Transmit mode 3          |
| SITSCR  | a4c50020 | u16       | u16         | Transmit clock select    |
| SIRMDR1 | a4c50010 | u32       | u32         | Receive mode 1           |
| SIRMDR2 | a4c50014 | u32       | u32         | Receive mode 2           |
| SIRMDR3 | a4c50018 | u32       | u32         | Receive mode 3           |
| SIRSCR  | a4c50024 | u16       | u16         | Receive clock select     |
| SICTR   | a4c50028 | u32       | u32         | Control                  |
| SIFCTR  | a4c50030 | u32       | u32         | FIFO control             |
| SISTR   | a4c50040 | u32       | u32         | Status                   |
| SIIER   | a4c50044 | u32       | u32         | Interrupt enable         |
| SITDR1  | a4c50048 | u32       | u32         | Transmit control data 1  |
| SITDR2  | a4c5004c | u32       | u32         | Transmit control data 2  |
| SITFDR  | a4c50050 | u32       | u32         | Transmit FIFO data       |
| SIRDR1  | a4c50058 | u32       | u32         | Receive control data 1   |
| SIRDR2  | a4c5005c | u32       | u32         | Receive control data 2   |
| SIRFDR  | a4c50060 | u32       | u32         | Receive FIFO data        |

<br>

---

# [SPU2] - Sound processing unit 2

| Name    | Address  | Data size | Access size | Description                      |
|---------|----------|-----------|-------------|----------------------------------|
| PBANKC0 | fe2ffc00 | u32       | u32         | PRAM bank control 0              |
| PBANKC1 | fe2ffc04 | u32       | u32         | PRAM bank control 1              |
| XBANKC0 | fe2ffc10 | u32       | u32         | XRAM bank control 0              |
| XBANKC1 | fe2ffc14 | u32       | u32         | XRAM bank control 1              |
| SPUSRST | fe2ffc24 | u32       | u32         | SPU software reset               |
| SPUADR  | fe2ffc28 | u32       | u32         | SPU address                      |
| ENDIAN  | fe2ffc2c | u32       | u32         | SHway endian                     |
| GCOM0   | fe2ffc40 | u32       | u32         | Global common 0                  |
| GCOM1   | fe2ffc44 | u32       | u32         | Global common 1                  |
| GCOM2   | fe2ffc48 | u32       | u32         | Global common 2                  |
| GCOM3   | fe2ffc4c | u32       | u32         | Global common 3                  |
| GCOM4   | fe2ffc50 | u32       | u32         | Global common 4                  |
| GCOM5   | fe2ffc54 | u32       | u32         | Global common 5                  |
| GCOM6   | fe2ffc58 | u32       | u32         | Global common 6                  |
| GCOM7   | fe2ffc5c | u32       | u32         | Global common 7                  |
| DMABUF0 | fe2ffc80 | u32       | u32         | Inter-DSP communication buffer 0 |
| DMABUF1 | fe2ffc84 | u32       | u32         | Inter-DSP communication buffer 1 |
| DMABUF2 | fe2ffc88 | u32       | u32         | Inter-DSP communication buffer 2 |
| DMABUF3 | fe2ffc8c | u32       | u32         | Inter-DSP communication buffer 3 |

<br>

---

# [SPU2DSP0] - DSP 0 for sound processing unit 2

| Name       | Address  | Data size | Access size | Description                 |
|------------|----------|-----------|-------------|-----------------------------|
| DSPRST     | fe2ffd00 | u32       | u32         | DSP full reset              |
| DSPCORERST | fe2ffd04 | u32       | u32         | DSP core reset              |
| DSPHOLD    | fe2ffd08 | u32       | u32         | DSP hold                    |
| DSPRESTART | fe2ffd0c | u32       | u32         | DSP restart                 |
| IEMASKC    | fe2ffd18 | u32       | u32         | CPU interrupt source mask   |
| IMASKC     | fe2ffd1c | u32       | u32         | CPU interrupt signal mask   |
| IEVENTC    | fe2ffd20 | u32       | u32         | CPU interrupt source        |
| IEMASKD    | fe2ffd24 | u32       | u32         | DSP interrupt source mask   |
| IMASKD     | fe2ffd28 | u32       | u32         | DSP interrupt signal mask   |
| IESETD     | fe2ffd2c | u32       | u32         | DSP interrupt set           |
| IECLRD     | fe2ffd30 | u32       | u32         | DSP interrupt clear         |
| OR         | fe2ffd34 | u32       | u32         | DMAC operation              |
| COM0       | fe2ffd38 | u32       | u32         | CPU-DSP communication 0     |
| COM1       | fe2ffd3c | u32       | u32         | CPU-DSP communication 1     |
| COM2       | fe2ffd40 | u32       | u32         | CPU-DSP communication 2     |
| COM3       | fe2ffd44 | u32       | u32         | CPU-DSP communication 3     |
| COM4       | fe2ffd48 | u32       | u32         | CPU-DSP communication 4     |
| COM5       | fe2ffd4c | u32       | u32         | CPU-DSP communication 5     |
| COM6       | fe2ffd50 | u32       | u32         | CPU-DSP communication 6     |
| COM7       | fe2ffd54 | u32       | u32         | CPU-DSP communication 7     |
| BTADRU     | fe2ffd58 | u32       | u32         | Bus-through address high    |
| BTADRL     | fe2ffd5c | u32       | u32         | Bus-through address low     |
| WDATU      | fe2ffd60 | u32       | u32         | Bus-through write data high |
| WDATL      | fe2ffd64 | u32       | u32         | Bus-through write data low  |
| RDATU      | fe2ffd68 | u32       | u32         | Bus-through read data high  |
| RDATL      | fe2ffd6c | u32       | u32         | Bus-through read data low   |
| BTCTRL     | fe2ffd70 | u32       | u32         | Bus-through mode control    |
| SPUSTS     | fe2ffd74 | u32       | u32         | SPU status                  |
| SBAR0      | fe2ffe00 | u32       | u32         | Source base address 0       |
| SAR0       | fe2ffe04 | u32       | u32         | Source address 0            |
| DBAR0      | fe2ffe08 | u32       | u32         | Destination base address 0  |
| DAR0       | fe2ffe0c | u32       | u32         | Destination address 0       |
| TCR0       | fe2ffe10 | u32       | u32         | Transfer count 0            |
| SHPRI0     | fe2ffe14 | u32       | u32         | SHway priority 0            |
| CHCR0      | fe2ffe18 | u32       | u32         | Channel control 0           |
| SBAR1      | fe2ffe20 | u32       | u32         | Source base address 1       |
| SAR1       | fe2ffe24 | u32       | u32         | Source address 1            |
| DBAR1      | fe2ffe28 | u32       | u32         | Destination base address 1  |
| DAR1       | fe2ffe2c | u32       | u32         | Destination address 1       |
| TCR1       | fe2ffe30 | u32       | u32         | Transfer count 1            |
| SHPRI1     | fe2ffe34 | u32       | u32         | SHway priority 1            |
| CHCR1      | fe2ffe38 | u32       | u32         | Channel control 1           |
| SBAR2      | fe2ffe40 | u32       | u32         | Source base address 2       |
| SAR2       | fe2ffe44 | u32       | u32         | Source address 2            |
| DBAR2      | fe2ffe48 | u32       | u32         | Destination base address 2  |
| DAR2       | fe2ffe4c | u32       | u32         | Destination address 2       |
| TCR2       | fe2ffe50 | u32       | u32         | Transfer count 2            |
| SHPRI2     | fe2ffe54 | u32       | u32         | SHway priority 2            |
| CHCR2      | fe2ffe58 | u32       | u32         | Channel control 2           |
| LSA0       | fe2ffe80 | u32       | u32         | Loop start address 0        |
| LEA0       | fe2ffe84 | u32       | u32         | Loop end address 0          |
| LSA1       | fe2ffe90 | u32       | u32         | Loop start address 1        |
| LEA1       | fe2ffe94 | u32       | u32         | Loop end address 1          |
| LSA2       | fe2ffea0 | u32       | u32         | Loop start address 2        |
| LEA2       | fe2ffea4 | u32       | u32         | Loop end address 2          |

<br>

---

# [SPU2DSP1] - DSP 1 for sound processing unit 2

| Name       | Address  | Data size | Access size | Description                 |
|------------|----------|-----------|-------------|-----------------------------|
| DSPRST     | fe3ffd00 | u32       | u32         | DSP full reset              |
| DSPCORERST | fe3ffd04 | u32       | u32         | DSP core reset              |
| DSPHOLD    | fe3ffd08 | u32       | u32         | DSP hold                    |
| DSPRESTART | fe3ffd0c | u32       | u32         | DSP restart                 |
| IEMASKC    | fe3ffd18 | u32       | u32         | CPU interrupt source mask   |
| IMASKC     | fe3ffd1c | u32       | u32         | CPU interrupt signal mask   |
| IEVENTC    | fe3ffd20 | u32       | u32         | CPU interrupt source        |
| IEMASKD    | fe3ffd24 | u32       | u32         | DSP interrupt source mask   |
| IMASKD     | fe3ffd28 | u32       | u32         | DSP interrupt signal mask   |
| IESETD     | fe3ffd2c | u32       | u32         | DSP interrupt set           |
| IECLRD     | fe3ffd30 | u32       | u32         | DSP interrupt clear         |
| OR         | fe3ffd34 | u32       | u32         | DMAC operation              |
| COM0       | fe3ffd38 | u32       | u32         | CPU-DSP communication 0     |
| COM1       | fe3ffd3c | u32       | u32         | CPU-DSP communication 1     |
| COM2       | fe3ffd40 | u32       | u32         | CPU-DSP communication 2     |
| COM3       | fe3ffd44 | u32       | u32         | CPU-DSP communication 3     |
| COM4       | fe3ffd48 | u32       | u32         | CPU-DSP communication 4     |
| COM5       | fe3ffd4c | u32       | u32         | CPU-DSP communication 5     |
| COM6       | fe3ffd50 | u32       | u32         | CPU-DSP communication 6     |
| COM7       | fe3ffd54 | u32       | u32         | CPU-DSP communication 7     |
| BTADRU     | fe3ffd58 | u32       | u32         | Bus-through address high    |
| BTADRL     | fe3ffd5c | u32       | u32         | Bus-through address low     |
| WDATU      | fe3ffd60 | u32       | u32         | Bus-through write data high |
| WDATL      | fe3ffd64 | u32       | u32         | Bus-through write data low  |
| RDATU      | fe3ffd68 | u32       | u32         | Bus-through read data high  |
| RDATL      | fe3ffd6c | u32       | u32         | Bus-through read data low   |
| BTCTRL     | fe3ffd70 | u32       | u32         | Bus-through mode control    |
| SPUSTS     | fe3ffd74 | u32       | u32         | SPU status                  |
| SBAR0      | fe3ffe00 | u32       | u32         | Source base address 0       |
| SAR0       | fe3ffe04 | u32       | u32         | Source address 0            |
| DBAR0      | fe3ffe08 | u32       | u32         | Destination base address 0  |
| DAR0       | fe3ffe0c | u32       | u32         | Destination address 0       |
| TCR0       | fe3ffe10 | u32       | u32         | Transfer count 0            |
| SHPRI0     | fe3ffe14 | u32       | u32         | SHway priority 0            |
| CHCR0      | fe3ffe18 | u32       | u32         | Channel control 0           |
| SBAR1      | fe3ffe20 | u32       | u32         | Source base address 1       |
| SAR1       | fe3ffe24 | u32       | u32         | Source address 1            |
| DBAR1      | fe3ffe28 | u32       | u32         | Destination base address 1  |
| DAR1       | fe3ffe2c | u32       | u32         | Destination address 1       |
| TCR1       | fe3ffe30 | u32       | u32         | Transfer count 1            |
| SHPRI1     | fe3ffe34 | u32       | u32         | SHway priority 1            |
| CHCR1      | fe3ffe38 | u32       | u32         | Channel control 1           |
| SBAR2      | fe3ffe40 | u32       | u32         | Source base address 2       |
| SAR2       | fe3ffe44 | u32       | u32         | Source address 2            |
| DBAR2      | fe3ffe48 | u32       | u32         | Destination base address 2  |
| DAR2       | fe3ffe4c | u32       | u32         | Destination address 2       |
| TCR2       | fe3ffe50 | u32       | u32         | Transfer count 2            |
| SHPRI2     | fe3ffe54 | u32       | u32         | SHway priority 2            |
| CHCR2      | fe3ffe58 | u32       | u32         | Channel control 2           |
| LSA0       | fe3ffe80 | u32       | u32         | Loop start address 0        |
| LEA0       | fe3ffe84 | u32       | u32         | Loop end address 0          |
| LSA1       | fe3ffe90 | u32       | u32         | Loop start address 1        |
| LEA1       | fe3ffe94 | u32       | u32         | Loop end address 1          |
| LSA2       | fe3ffea0 | u32       | u32         | Loop start address 2        |
| LEA2       | fe3ffea4 | u32       | u32         | Loop end address 2          |

<br>

---

# [SPU2RAM] - Sound processing unit 2 RAM

| Name  | Address  | Data size | Access size | Description      |
|-------|----------|-----------|-------------|------------------|
| PRAM0 | fe200000 | 00028000  | u32         | DSP0 Program RAM |
| XRAM0 | fe240000 | 00038000  | u32         | DSP0 XRAM        |
| YRAM0 | fe280000 | 0000a000  | u32         | DSP0 YRAM        |
| PRAM1 | fe300000 | 00028000  | u32         | DSP1 Program RAM |
| XRAM1 | fe340000 | 00038000  | u32         | DSP1 XRAM        |
| YRAM1 | fe380000 | 0000a000  | u32         | DSP1 YRAM        |

<br>

---

# [FSI] - FIFO serial interface

| Name       | Address  | Data size | Access size | Description            |
|------------|----------|-----------|-------------|------------------------|
| A_DO_FMT   | fe3c0000 | u32       | u32         | A output serial format |
| A_DOFF_CTL | fe3c0004 | u32       | u32         | A output FIFO control  |
| A_DOFF_ST  | fe3c0008 | u32       | u32         | A output FIFO status   |
| A_DI_FMT   | fe3c000c | u32       | u32         | A input serial format  |
| A_DIFF_CTL | fe3c0010 | u32       | u32         | A input FIFO control   |
| A_DIFF_ST  | fe3c0014 | u32       | u32         | A input FIFO status    |
| A_CKG1     | fe3c0018 | u32       | u32         | A clock set 1          |
| A_CKG2     | fe3c001c | u32       | u32         | A clock set 2          |
| A_DIDT     | fe3c0020 | u32       | u32         | A read data            |
| A_DODT     | fe3c0024 | u32       | u32         | A write data           |
| A_MUTE_ST  | fe3c0028 | u32       | u32         | A mute state           |
| B_DO_FMT   | fe3c0040 | u32       | u32         | B output serial format |
| B_DOFF_CTL | fe3c0044 | u32       | u32         | B output FIFO control  |
| B_DOFF_ST  | fe3c0048 | u32       | u32         | B output FIFO status   |
| B_DI_FMT   | fe3c004c | u32       | u32         | B input serial format  |
| B_DIFF_CTL | fe3c0050 | u32       | u32         | B input FIFO control   |
| B_DIFF_ST  | fe3c0054 | u32       | u32         | B input FIFO status    |
| B_CKG1     | fe3c0058 | u32       | u32         | B clock set 1          |
| B_CKG2     | fe3c005c | u32       | u32         | B clock set 2          |
| B_DIDT     | fe3c0060 | u32       | u32         | B read data            |
| B_DODT     | fe3c0064 | u32       | u32         | B write data           |
| B_MUTE_ST  | fe3c0068 | u32       | u32         | B mute state           |
| INT_ST     | fe3c0200 | u32       | u32         | Interrupt state        |
| IEMSK      | fe3c0204 | u32       | u32         | Interrupt source mask  |
| IMSK       | fe3c0208 | u32       | u32         | Interrupt signal mask  |
| MUTE       | fe3c020c | u32       | u32         | Mute set               |
| CLK_RST    | fe3c0210 | u32       | u32         | Clock reset            |
| SOFT_RST   | fe3c0214 | u32       | u32         | Software reset         |
| FIFO_SZ    | fe3c0218 | u32       | u32         | FIFO size              |
