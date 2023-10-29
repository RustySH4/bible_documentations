---
layout: page
title: "Reset and Power-Down Modes documentation"
permalink: /hardware/sh7305/power.html
author: Yatis
---

# Reset and Power-Down Modes (CPG)

This module is really close to the SH7724 but without the U-Stanby mode, the MSTPCR2
and most of bit information about MSPTCR0 and MSTPCR2 is unviable.

This LSI supports R-standby in which low power consumption is achieved by turning
off the internal power-supply to part of the chip. This LSI also supports sleep mode,
software standby mode, and module standby function, in which clock supply to the
LSI is controlled optimally.

<u>Features</u>
* Supports a variety of power-down modes, i.e. sleep, software standby, module standby, and R-standby modes.
* In R-standby modes, the RWDT, CMT, KEYSC, and RTC that operate on RCLK are operational.

<u>Division of Power-Supply Areas</u>
To realize power-down modes, this LSI is divided into the following four power-supply areas.
* Core area
> This area is operated by the VDD power supply and encompasses all areas other
> than the following three. Power consumption on standby is greatly reduced in
> R-standby modes by turning off the power to this area.

* Back-up area
> This area is operated by the VDD power supply. This area includes RS memory and
> registers back-up area for some modules.
> On waking up from R-standby mode, the register contents backed up in this area
> are automatically rewritten to the respective registers.

* Sub area
> This area is operated by the V DD power supply and encompasses the RWDT, CMT,
> KEYSC, and RTC.

* I/O area
> This area is operated by the V CC power supply and encompasses the I/O buffer.


__Chapter:__<br>
[1\] Power registers documentation<br>](#power-registers-documentation)
[2\] Module Operations](#module-operations)
* [2.1\] Sleep mode](#sleep-mode)
* [2.2\] Module standby mode](#module-standby-mode)
* [2.3\] R-Standby mode](#r-standby-mode)

---

## Power registers documentation

After many tests, there is all register with bits field.<br>
But be careful some module need external clock to be written to, some modules
have other module dependency (like the FSI which depend on the SPU), moreover
certain need preprocessing action before starting or stopping them.

[Registers list:]({{ site.baseurl }}/hardware/sh7305/registers_list.html#power---power-down-modes)
* [(0xa4150020) STBCR - Standby Control Register](#stbcr---standby-control-register-address-0xa4150020--bitmask-0x000000a0)
* [(0xa4150030) MSTPCR0 - Module Stop Register 0](#mstpcr0---module-stop-register-0-address-0xa4150030--bitmask-0xfe7ee0e6)
* [(0xa4150038) MSTPCR2 - Module Stop Register 2](#mstpcr2---module-stop-register-2-address-0xa4150038--bitmask-0x28126b74)
* [(0xa4150040) BAR - Boot Adress Register](#bar---boot-adress-register-address-0xa4150040--bitmask-0xffffffff)

---

### STBCR - Standby Control Register (address: 0xa4150020 && bitmask: 0x000000a0)

STBCR is a 32-bit readable/writable register that can select sleep mode,
standby mode, or R-standby mode.

STBCR can be accessed only in longwords.

Writing 1 to more than one bit for selecting a standby mode is prohibited; set
all bits to 0 or set only one bit to 1.

| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31 to 8  | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 7        | STBY     | 0             | R/W | Standby.                                                                         |
| 6        | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 5        | RSTBY    | 0             | R/W | R-Standby.                                                                       |
| 4 to 0   | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |

<u>Bit 7: STBY</u>
> Executing the SLEEP instruction after this bit is set to 1 makes a transition
> to software standby mode.

<u>Bit 6: RSTBY</u>
> Executing the SLEEP instruction after this bit is set to 1 makes a transition
> to R-standby mode.

<u>Note</u>
* Note that the RSTBY bit should be set to 1 before entering R-standby mode, and
when R-standby mode is canceled by an interrupt, the RSTBY bit should be returned
to 0 after waking up from R-standby mode.
* The boot address when R-standby mode is canceled by an interrupt is the value
set in BAR.
* Casio configuration = 0x00000000
* Same as the SH7305 but without the U-stabby mode.

---


### MSTPCR0 - Module Stop Register 0 (address: 0xa4150030 && bitmask: 0xfe7ee0e6)

MSTPCR0 is a 32-bit readable/writable register that can individually start or
stop the module assigned to each bit.

MSTPCR0 can be accessed only in longwords.

After canceling the module stop state for the instruction cache (IC),
operand cache (OC), TLB, either of the following preprocessing must be performed
before accessing these modules. Note that such module access includes instruction
fetch from a relevant module and instruction fetch using a relevant module.
* After reading the changed MSTPn bit once, execute the RTE instruction.
* After reading the changed MSTPn bit once, execute the ICBI instruction for any address.
(The address can be in a non-cacheable area)


| Bit      | Bit name | Initial Value | R/W |Description                                                                       |
|----------|:--------:|---------------|:---:|----------------------------------------------------------------------------------|
| 31       | MSTP031  | 0             | R/W | TLB                                                                              |
| 30       | MSTP030  | 0             | R/W | Instruction cache (IC)                                                           |
| 29       | MSTP029  | 0             | R/W | Operand cache (OC)                                                               |
| 28       | MSTP028  | 0             | R/W | RS memory                                                                        |
| 27       | MSTP027  | 0             | R/W | IL memory                                                                        |
| 26       | MSTP026  | 0             | R/W | Secondary Cache                                                                  |
| 25       | MSTP025  | 0             | R/W | Unknown (probably On-Chip Memory module)                                         |
| 24, 23   | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 22       | MSTP022  | 0             | R/W | Interrupt Controller (INTC)                                                      |
| 21       | MSTP021  | 0             | R/W | Direct Memory Access Controller (DMA)                                            |
| 20       | MSTP020  | 0             | R/W | SuperHyway Packet Router                                                         |
| 19       | MSTP019  | 0             | R/W | User Debugging Interface (HUDI)                                                  |
| 18       | MSTP018  | 0             | R/W | Unknown (no idea)                                                                |
| 17       | MSTP017  | 0             | R/W | User Break Controller (UBC)                                                      |
| 16       | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 15       | MSTP015  | 0             | R/W | Timer Unit (TMU0, TMU1, TMU2)                                                    |
| 14       | MSTP014  | 0             | R/W | Compare Match Timer (CMT)                                                        |
| 13       | MSTP013  | 0             | R/W | Wathdog Timer (RWDT)                                                             |
| 12       | -        | 1             | R   | Reserved.<br>These bits are always read as 1.The write value should always be 1. |
| 11 to 8  | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 7        | MSTP011  | 0             | R/W | Serial Communication Interface with FIFO (SCIF)                                  |
| 6        | MSTP010  | 0             | R/W | Key Scan Interface (KEYSC)                                                       |
| 5        | MSTP009  | 0             | R/W | Real Time Clock (RTC)                                                            |
| 4, 3     | -        | All 0         | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |
| 2        | MSTP006  | 0             | R/W | Clock-Synchronized Serial Interface with FIFO (MSIOF0)                           |
| 1        | MSTP005  | 0             | R/W | Clock-Synchronized Serial Interface with FIFO (MSIOF1)                           |
| 0        | -        | 0             | R   | Reserved.<br>These bits are always read as 0.The write value should always be 0. |

<u>Note</u>
* Casio's configuration: 0x002a3086


---


### MSTPCR2 - Module Stop Register 2 (address: 0xa4150038 && bitmask: 0x28126b74)

MSTPCR2 is a 32-bit readable/writable register that can individually start or stop the module
assigned to each bit.

MSTPCR2 can be accessed only in longwords.


| Bit      | Bit name | Initial Value | R/W |Description                                                                         |
|----------|:--------:|---------------|:---:|------------------------------------------------------------------------------------|
| 31, 30   | -        | All 1         | R   | Reserved.<br>These bits are always read as 1.The write value should always be 1.   |
| 29       | MSTP229  | 1             | R/W | MMC Controller (MMC)                                                               |
| 28       | -        | 1             | R   | Reserved.<br>These bits are always read as 1.The write value should always be 1.   |
| 27       | MSTP227  | 1             | R/W | A/D Converter (ADC)                                                                |
| 26 to 21 | -        | All 1         | R   | Reserved.<br>These bits are always read as 1.The write value should always be 1.   |
| 20       | MSTP222  | 1             | R/W | USB 2.0 Function Module (USB)                                                      |
| 19, 18   | -        | All 1         | R   | Reserved.<br>These bits are always read as 1.The write value should always be 1.   |
| 17       | MSTP219  | 1             | R/W | SD Card controller (SDC)                                                           |
| 16, 15   | -        | All 1         | R   | Reserved.<br>These bits are always read as 1.The write value should always be 1.   |
| 14       | MSTP216  | 1             | R/W | NAND Flash Controller (FLCTL)                                                      |
| 13       | MSTP215  | 1             | R/W | ECC unit (ECC)                                                                     |
| 12       | -        | 1             | R   | Reserved.<br>These bits are always read as 1.The write value should always be 1.   |
| 11       | MSTP213  | 1             | R/W | I2C Bus Interface (IIC)                                                            |
| 10       | -        | 1             | R   | Reserved.<br>These bits are always read as 1.The write value should always be 1.   |
| 9        | MSTP211  | 1             | R/W | DSP Modules (Sound Processing Unit (SPU) and FIFO-Buffered Serial Interface (FSI)) |
| 8        | MSTP210  | 1             | R/W | Unknown (no idea)                                                                  |
| 7        | -        | 1             | R   | Reserved.<br>These bits are always read as 1.The write value should always be 1.   |
| 6        | MSTP210  | 1             | R/W | LCD Driver                                                                         |
| 5        | MSTP210  | 1             | R/W | Unknown (no idea)                                                                  |
| 4        | MSTP210  | 1             | R/W | Custom specification module (Cmod)                                                 |
| 3        | -        | 1             | R   | Reserved.<br>These bits are always read as 1.The write value should always be 1.   |
| 2        | MSTP202  | 1             | R/W | Custom specification module 2a (Cmod2a)                                            |
| 1, 0     | -        | All 1         | R   | Reserved.<br>These bits are always read as 1.The write value should always be 1.   |

<u>Note</u>
* Casio's configuration: 0xf7ffff8f

---

### BAR - Boot Adress Register (address: 0xa4150040 && bitmask: 0xffffffff)

BAR is a 32-bit readable/writable register that specifies the start address after
waking up from R-standby mode. BAR can specify an address in RS memory or in area 0.

| Bit      | Bit name | Initial Value | R/W |Description                                                                         |
|----------|:--------:|---------------|:---:|------------------------------------------------------------------------------------|
| 31 to 0  | -        | All 0         | R/W | These bits set the boot address on waking up from R-standby mode                   |

<br>

---

## Module Operations

## Sleep mode

<u>1) Transition to the "sleep mode"<br></u>
Executing the SLEEP instruction when the STBY and RSTBY bits in STBCR are 0 causes a
transition from the program execution state to sleep mode. In sleep mode, the supply of the clock
to the CPU core is stopped. Although the CPU stops immediately after executing the SLEEP
instruction, the contents of the CPU core registers and memory remain unchanged. The on-chip
peripheral modules continue to operate in sleep mode and the clock continues to be output to the
CKO and MCLK pins.

The procedure for a transition to sleep mode is as follows:
1. Clear the STBY and RSTBY bits in STBCR to 0.
2. Execute the SLEEP instruction.

<u>2)Canceling the "sleep Mode"<br></u>
Sleep mode is canceled by an interrupt (NMI, IRQ, or on-chip peripheral module) or a reset.
Interrupts are accepted in sleep mode even when the BL bit in SR is 1. If necessary, save SPC and
SSR in the stack before executing the SLEEP instruction.

* Canceling with Interrupt<br>
> When an NMI, IRQ, or on-chip peripheral module interrupt occurs, sleep mode is canceled and
> interrupt exception handling is executed. A code indicating the interrupt source is set in INTEVT.
> For the types of on-chip peripheral module interrupts, see section 13, Interrupt Controller (INTC).

* Canceling with Reset<br>
> Sleep mode is canceled by a power-on reset or a system reset.

<br>

## Module standby mode

<u>1) Transition to Module Standby State<br></u>
Setting the MSTP bits in the module stop registers to 1 halts the supply of clocks to the
corresponding on-chip peripheral modules. This function can be used to reduce power
consumption in the normal operation of the CPU.

Modules in the module standby state keep the state immediately before the transition to the
module standby state. The registers keep the contents before halted, and the external pins keep the
functions before halted. On return from the module standby state, operation is restarted from the
condition immediately before the registers and external pins have halted.

* Note: Make sure to set the MSTP bit to 1 while the modules have completed the operation and
are in an the idle state, with no interrupt sources from the external pins or other modules.

<u>2) Canceling Module Standby State<br></u>
The module standby state can be canceled by clearing the respective MSTP bit to 0.

<br>

## R-Standby mode

<u>1) Transition to R-Standby Mode<br></u>
Executing the SLEEP instruction when the RSTBY bit is 1 and the STBY is 0
in STBCR causes a transition from the program execution state to R-standby mode. In R-standby
mode, power to the I/O area, backup area, and sub area of the power-supply separating region is
on, but power to the core area is off. This provides a greater reduction of the leak current than is
achieved in software standby mode. In addition, since the register contents and the destination
address on waking up from R-standby mode can be held in the backup area, high-speed wakeup by
an interrupt is possible.

In R-standby mode, modules that can operate on RCLK or RTC_CLK (RWDT, CMT, KEYSC,
RTC) continue to operate and the I/O area functions of NMI and IRQ interrupt detection are
operational.

In R-standby mode, input RCLK and RTC_CLK to operate the RWDT, CMT, KEYSC, and RTC.
In clock modes 0 to 2, input EXTAL as the source clock of RCLK, and also input RTC_CLK
when the RTC is used. In clock operating modes 3 to 7, input RTC_CLK as the source clock of
RCLK.

In R-standby mode, the contents of the registers and memory for each module in the core area are
initialized or held by being saved in the backup area, depending on the module.
Since the contents of the registers and memory for initialized modules are lost on entry to
R-standby mode, operation should be guaranteed by software.

The procedure for a transition to R-standby mode is as follows:
1. Set the RSTBY bit to 1 and clear the STBY to 0 in STBCR.
2. Set in BAR the first branch destination address used when making a transition
from R-standby mode to the program execution state.
3. Execute the SLEEP instruction.
4. R-standby mode is entered and the clocks within the LSI are halted. The outputs of the
STATUS0 and STATUS2 pins go high. When the core area is turned off, the output of the
PDSTATUS pin goes high.

<u>2) Canceling R-Standby Mode<br></u>
R-standby mode is canceled by an interrupt (NMI, IRQ, or CMT, KEYSC, RTC), a power-on
reset, or a system reset.

* Canceling with Interrupt<br>
> When an NMI, IRQ, or CMT, KEYSC, RTC interrupt is detected, the core area is turned on. The
> reset is asserted only in the core area*, and the clock will be supplied to the entire LSI after
> oscillation of all PLL and DLL circuits that should operate has settled. In this case, the PLL and
> DLL oscillation settling times are automatically ensured by the LSI. When R-standby mode is
> canceled, the STATUS0 and STATUS2 pins go low. The start address on waking up from R-
> standby mode is the address set in BAR. After this, the interrupt exception handling by the CPU is
> executed. Interrupts are accepted in R-standby mode even when the BL bit in SR is 1. If
> necessary, save SPC and SSR in the stack before executing the SLEEP instruction.
> The clock outputs of the CKO and LPCLK pins are halted until R-standby mode is canceled.
> Note: * The RESETOUT pin is not asserted.

* Canceling with Reset<br>
> R-standby mode is canceled by a power-on reset or a system reset, and the core area is turned on.
> The start address after returning from R-standby mode is the reset vector address (H'A000 0000).

<u>3) Registers and Memory Held in R-Standby Mode<br></u>
In R-standby mode, the register contents saved in the backup area and the RS memory remain
unchanged. When R-standby mode is canceled by an interrupt, operation is started with the same
register values before the transition to R-standby mode. This recovering process after canceling R-
standby mode is operated automatically prior to the execution of the instruction specified by BAR.
For details on the held registers, refer to the register descriptions in each section.

<u>4) R-Standby Mode Usage Example<br></u>
In R-standby mode, only partial data necessary for restarting operation is saved. Data not saved
must be guaranteed by software. Procedures for halting operating modules are also processed by
software.

Processing before Transition
1. Set the MD, BL, and RB bits in SR to 1.
2. Carry out the processing to halt on-chip peripheral modules. As the FIFO buffer contents are
not saved, confirm that the FIFO buffer is empty before executing the processing to halt
operation.
3. Save data, such as values set in registers, in external memory whose contents are held and the
on-chip RS memory.
4. When cache is enabled, purge (write back to main memory), reset, and disable cache. When
the TLB is used, reset and disable the TLB after carrying out the processing necessary for
restarting operation.
5. Set the RSTBY bit to 1 and clear the STBY bit to 0 in STBCR.
6. Set the address of the instruction to be executed first when transiting from R-standby mode to
the program execution state in BAR.
7. Execute the SLEEP instruction.
8. R-standby mode is entered.

Processing after Transition
1. The values set in the BSC, DBSC, INTC, CPG, PFC, and I/O ports and the RS memory
contents are saved when waking up from R-standby mode. All other contents need to be re-
specified by software to guarantee operation.
2. Start executing the instruction in the address set in BAR. At this time, the interrupt initiating
wakeup is pended since SR is reset and the BL bit in SR is set to 1.
3. Set SR and R15. The BL bit in SR should remain set to 1.
4. Use software to process the procedures for restarting on-chip peripheral modules. After
respecifying the control registers and others, set the module enable bits to 1.
5. Newly specify the VBR, TLB and cache.
6. Clear the BL bit in SR to 0. Set other bits accordingly.
7. The pended interrupt is accepted, a branch is made to the interrupt handler, and normal
interrupt handling is executed.
