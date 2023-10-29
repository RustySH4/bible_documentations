---
layout: page
title: "Software documentation"
permalink: /software/
author: Yatis
---

# Welcome to the software documentation part

I disassembled many syscalls, mainly for the sake of reverse-engineering drivers.
You can find here many documentation from [Simon Lothar][1], [Lephenixnoir][2] and
me about Casio's OS operation.

But be careful, information of this part of the bible is not absolutely sure because
some part  has been documented with an "old" OS version.

[1]: https://bible.planet-casio.com/simlo/
[2]: https://bible.planet-casio.com/lephenixnoir/

---

## Syscall
Monochrom:
* [syscall list]({{ site.baseurl }}/software/syscall/index.html)
* Bfile documentation (TODO)
* Timer documentation (TODO)

---

## File format
* [Add-in "g1a" format]({{ site.baseurl }}/software/format/g1a.html)
* [Add-in "g3a" format]({{ site.baseurl }}/software/format/g3a.html)

---

## File system
* Old File system (used by USB power Graphic 1/2) (TODO)
* [Fugue File system]({{ site.baseurl }}/software/fs/fugue.html)

---

## Hardware and software specifics note:

There is all file that I use frequently when I trace syscall and / or find information.<br>
WARNING: Those files are simply note and suposition, so be careful with them !

* [Graph35+ (OS 02.05.2201) - Random Notes (raw)]({{ site.baseurl }}/software/notes/g35E_OS02.05.2201_random_notes.txt)
* [Graph35+ (OS 02.05.2201) - Casio VBR handling (raw)]({{ site.baseurl }}/software/notes/g35E_OS02.05.2201_vbr_handler.txt)
* [Graph35+ (OS 02.05.2201) - Casio TLB miss (raw)]({{ site.baseurl }}/software/notes/g35E_OS02.05.2201_tlb_miss.txt)
* [Graph35+ (OS 02.05.2201) - KEYSC handler (raw)]({{ site.baseurl }}/software/notes/g35E_OS02.05.2201_keysc_interrupt_handler.txt)
* [Graph35+E II (OS 03.00.2200) - Hidden menus (raw)]({{ site.baseurl }}/software/notes/g35EII_OS03.00.2200_hidden_menus.txt)
* [Graph35+E II (OS 03.00.2200) - Fugue FAT File System (raw)]({{ site.baseurl }}/software/notes/g35EII_OS03.00.2200_Fugue_FS.txt)
* [Graph35+E II (OS 03.00.2200) - Ramdom notes (raw)]({{ site.baseurl }}/software/notes/g35EII_OS03.00.2200_random_notes.txt)

---

## OS disassembling note:

There is all file that I use frequently to trace syscall and / or find information.<br>
WARNING: Those files are huge because those are a full OS image who have been "objdumped".
* [[SH3\] Graph75+     (OS 01.00.0000) - OS disassembling notes (raw)]({{ site.baseurl }}/software/OS/OS75_01.00.0000_SH3.asm.txt)
* [[SH4\] Graph35+E    (OS 02.05.2201) - OS disassembling notes (raw)]({{ site.baseurl }}/software/OS/OS75_02.05.2201_SH4.asm.txt)
* [[SH4\] Graph90+E    (OS 03.20.2202) - OS disassembling notes (raw)]({{ site.baseurl }}/software/OS/OS90_03.20.2202_SH4.asm.txt)
* [[SH4\] Graph35+E II (OS 03.00.2200) - OS disassembling notes (raw)]({{ site.baseurl }}/software/OS/OS75_03.00.2200_SH4.asm.txt)

<br>
