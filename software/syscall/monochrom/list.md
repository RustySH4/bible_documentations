---
layout: page
title: "Fx9860g - Syscall list"
permalink: /software/syscall/
author: Yatis
---

# Fx9860g - Syscall list

Thank's to [Simon Lothar][1] for the first syscall list and documentation that you did !
The OSes of the fx-9860G-types contain an address table, which should provide for
a calculator-independent software-development.
Most of these addresses are entry-points to some function.

[1]: https://bible.planet-casio.com/simlo/

---

## How to use a syscall:

Normally, the SH3 processor provide the **"TRAPA"** instruction which allow
tipping between userland and kernel. But Casio don't use this method, this is
why we are alway in "priviligied mode" and we can do whatever we want :D

The Casio's calling convention to access the system calls, is to jump to 0x80010070
with the syscall number in r0.

There is a small implementation in asm of "how using a syscall" with Casio's
implementation.

```
	mov.l	.syscall_trampoline, r1	! get syscall trampoline address
	mov.l	.syscall_ID, r0		! set the syscall that we want (here 0x135)
	jmp	@r1			! jump into syscall trampoline code
	nop				! (delayed branch) do nothing.

	.align 4
	.syscall_trampoline:	.long 0x80010070
	.syscall_ID:		.long 0x00000135
```

The 0x80010070 address represents the syscall trampoline code which will just get
syscall function address using his ID sent in r0 like an index.

```
	mov.l	.syscall_addresses_tab, r2		! get syscall table
	shll2	r0					! syscallID * 4
	mov.l	@(r0,r2), r0				! systab[syscallID]
	jmp	@r0					! jump to the syscall
	nop						! (delayed branch) do nothing.

	.align 4
	.syscall_addresses_tab: .long 0x80223414	! real address for the Graph35+E II OS:03.20.2200
```

---


## Syscall documentations

| Syscall ID | Function name                                | Notes |
|------------|----------------------------------------------|-------|
| 0x000      | system_init                                  |
| 0x001      | TLB exception handler (protection)           |
| 0x002      | CPU address error handler (instruction/data) |
| 0x003      | TLB_miss_handler                             |
| 0x004      | TLB_init                                     |
| 0x005      | App_RegisterAddins                           | Scans available G1As and updates the addin array
| 0x009      | FindFreeAddinSlot                            |
| 0x00a      | GetAddindHeaderAddr                          |
| 0x00e      | App_GetAddindEstripInformation               | Returns the start of the addin array
| 0x013      | GlibAddinAplExecutionCheck                   |
| 0x014      | GlibGetAddinLibInf                           |
| 0x015      | GlibGetOSVersionInfo                         |
| 0x018      | MMU_FlushCache                               | Uses the 0xA0000000-based uncached address
| 0x01b      | DD_Clear                                     |
| 0x01c      | Bdisp_WriteGraph_VRAM                        | SDK
| 0x01d      | Bdisp_WriteGraph_DD                          | SDK
| 0x01e      | Bdisp_WriteGraph_DDVRAM                      | SDK
| 0x022      | Bdisp_ReadArea_VRAM                          | SDK
| 0x024      | Bdisp_GetDisp_DD                             | SDK
| 0x025      | DD_Read                                      | Reads the data line of the DD (often the next page in the DD RAM, depending on conf)
| 0x026      | DD_ReadFromPage                              | Select page and return the data. SDK - renamed from DD_GET
| 0x027      | DD_WriteToPage                               | Select page and write supplied data
| 0x028      | Bdisp_PutDisp_DD                             | SDK
| 0x02A      | =0x02F                                       |
| 0x02F      | Bdisp_DrawShapeToVRAM                        | Draws a dot, a line, a dashed line, a box or a circle to VRAM
| 0x030      | Bdisp_DrawLineVRAM                           | SDK
| 0x031      | Bdisp_ClearLineVRAM                          | SDK
| 0x032      | Bdisp_DrawShapeToDD                          | draws a dot, a line, a dashed line, a box or a circle to DD
| 0x033      | Bdisp_DrawShapeToVRAM_DD                     | draws a dot, a line, a dashed line, a box or a circle to VRAM and DD
| 0x034      | =0x032                                       |
| 0x035      | =0x033                                       |
| 0x037      | Wait_ms                                      | gWait duration ms (uses TMU_2; max. duration=2000)
| 0x039      | RTC_Reset                                    | resets RTC
| 0x03A      | RTC_GetTime                                  | Reads hours, minutes, seconds and milliseconds from RTC
| 0x03B      | RTC_GetTicks                                 | reads RTC-tick-count
| 0x03C      | RTC_Elapsed_ms                               | Checks, if a duration in ms has elapsed
| 0x05C      | Num_UIntToBCD                                | Unsigned long up to 0x1869F (99999) to BCD. Func name only a suggestion
| 0x05D      | Num_BCDToUInt                                | BCD up to 99999 to unsigned long.
| 0x118      | Timer_Install                                | supports SDK SetTimer
| 0x119      | Timer_Deinstall                              | supports SDK KillTimer
| 0x11A      | Timer_Start                                  | supports SDK SetTimer
| 0x11B      | Timer_Stop                                   | supports SDK KillTimer
| 0x11F      | Bdisp_PutDispArea_DD                         | SDK
| 0x12D      | DD_Poweroff                                  | Turns off the DD.
| 0x130      | Wait_ms                                      | wait duration ms (uses WDT)
| 0x132      | DD_SetContrast                               |
| 0x133      | DD_SetFRS                                    | gSet the DD FRS.
| 0x134      | DD_SetBias                                   | Set the DD bias.
| 0x135      | Bdisp_GetVRAM_Address                        | Returns the address of the VRAM.
| 0x136      | GetCharacterGlyph                            | see datatables
| 0x137      | GetCharacterMiniGlyph                        | see datatables
| 0x138      | Cursor_SetPosition                           | Sets the cursor to provided column and row.
| 0x139      | Cursor_SetFlashStyle                         | Sets the look/style of the flashing cursor.
| 0x13A      | Cursor_SetFlashMode                          | Configures the visibility of a flashing cursor
| 0x13B      | Cursor_GetSettings                           | Used to retrieve the current Cursor settings.
| 0x13C      | Print_OS                                     | Prints a string at the current cursor position
| 0x142      | Bdisp_AllClr_DD                              | SDK
| 0x143      | Bdisp_AllClr_VRAM                            | SDK
| 0x144      | Bdisp_AllClr_DDVRAM                          | SDK
| 0x145      | Bdisp_GetDisp_VRAM                           | SDK
| 0x146      | Bdisp_SetPoint_VRAM                          | SDK
| 0x147      | Bdisp_SetPoint_DD                            | SDK
| 0x148      | Bdisp_SetPoint_DDVRAM                        | SDK
| 0x149      | Bdisp_GetPoint_VRAM                          | SDK
| 0x14A      | Bdisp_AreaClr_DD                             | SDK
| 0x14B      | Bdisp_AreaClr_VRAM                           | SDK
| 0x14C      | Bdisp_AreaClr_DDVRAM                         | SDK
| 0x14D      | Bdisp_AreaReverseVRAM                        | SDK
| 0x150      | PrintXY                                      |
| 0x153      | Disp_Save                                    | Wrapper for Disp_Manage with act set to 1 (VRAM->RAM loc.)
| 0x154      | Disp_Restore                                 | Wrapper for Disp_Manage with act set to 0 (RAM loc.->VRAM)
| 0x155      | Disp_GetPtr                                  | Wrapper for Disp_Manage with act set to 2 (Return ptr to RAM loc)
| 0x156      | PopUpWin                                     |
| 0x158      | Disp_Manage                                  | Function used to copy data to/from VRAM and other display buffers.
| 0x159      | System_UpdateOS                              | OS update
| 0x15D      | PrintCR                                      | A combination of locate and Print functionality.
| 0x15F      | atoi                                         | Returns a string's Long representation.
| 0x160      | LongToAsc                                    | Returns an ASCII representation, with given ASCII string.
| 0x161      | LongToAscHex                                 | The same functionality like 0x467
| 0x162      | pc_toupper                                   |
| 0x163      | pc_tolower                                   |
| 0x172      | strcmp                                       | case-insensitive
| 0x173      | strcmp                                       | branches to syscall 0x172
| 0x175      | -                                            | No SysCall but the start of a datatable
| 0x176      | DiagnosticMode                               |
| 0x18A      | InvertMem                                    | ginverts a memory range
| 0x19F      | StorageMemory_Optimization                   |
| 0x1A9      | GUI_ProgressBar                              | Displays a progressbar dialog ('One moment please'), and can be used to draw the bar.
| 0x1ad      | Bfile_SMEM_????                              |
| 0x1ae      | Bfile_SMEM_Clear_????                        |
| 0x1B7-BD   | Get8x8BitmapPointer                          | Return a bitmap out of the 8x8-font-datatables
| 0x1c8      | memcpy                                       | Used by Bfile_SMEM_*, Add 0xA0000000 at the source address (Non-cacheable area).
| 0x1cd      | Bfile_SMEM_ReserveSlot                       |
| 0x1d1      | Bfile_SMEM_Search_File                       |
| 0x1e8      | Bfile_SMEM_Load_File                         |
| 0x1e9      | Bfile_SMEM_Check_Cache                       |
| 0x205      | Bfile_SMEM_Read_File                         |
| 0x20E      | StorageMemory_GetFilePos                     | retrieves the current position of an opened storage memory file
| 0x22a      | Bfile_SMEM_Device_Check                      |
| 0x22e      | Bfile_Path_Check                             |
| 0x236      | RebootOS                                     | 'Reboots' the hardware/OS
| 0x23D      | RTC_TriggerAlarm                             | Triggers the RTC alarm
| 0x23E      | RTC_SetDateTime                              | Set the RTC date and time
| 0x241      | Keyboard_ClrBuffer                           | clears the keyboardbuffer
| 0x242      | Bkey_Set_RepeatTime                          | SDK
| 0x243      | Bkey_Get_RepeatTime                          | SDK
| 0x244      | Bkey_Set_RepeatTime_Default                  | SDK
| 0x245      | Keyboard_EnableAutoRepeat                    |
| 0x246      | Keyboard_DisableAutoRepeat                   |
| 0x247      | Keyboard_GetKeyWait                          | SDK, broken?
| 0x248      | Keyboard_PutKeycode                          | Injects a keycode into the key-buffer
| 0x249      | Keyboard_GetKeyDownTime                      |
| 0x24A      | Keyboard_IsAnyKeyDown                        | greturns the matrix code of the actual pressed key
| 0x24B      | Keyboard_IsSpecialKeyDown                    | checks if the matrix code of a special key is pressed (variant of IsKeyDown)
| 0x24C      | Keyboard_IsSpecialKeyDown                    | SDK, 0x024B with doubled poll-count, accounts for chattering
| 0x24D      | Keyboard_KeyDown                             | directly queries port A
| 0x24E      | Keyboard_SecondaryInterruptHandler           |
| 0x24F      | Keyboard_PutKeymatrixCode                    | Injects a keymatrixcode into the key-buffer
| 0x251      | Keyboard_TimerHandler                        |
| 0x25E      | Keyboard_PrimaryInterruptHandler             |
| 0x268      | GetFKeyIconPointer                           |
| 0x284      | BCD_GetNotANumberValue                       | also see NumberFormat
| 0x285      | Serial_Open_57600                            | opens the serial channel with 57600 baud (not longer supported since fx-9860GII)
| 0x286      | BCD_AnsToSerial                              | Transfers the current answer as string to serial interface with 57600 baud (not longer supported since fx-9860GII)
| 0x28D      | Comm_Open                                    | opens a communication's channel
| 0x28E      | Comm_Close                                   | closes the open communication's channel
| 0x28F      | Comm_WaitForAnyBuffer                        |
| 0x290      | Comm_ReadOneByte                             | gfetches the next available byte from the open communication's receive buffer
| 0x291      | Comm_TransmitOneByte                         | drops a byte into the open communication's transmit buffer
| 0x292      | Comm_WaitForAndReadNBytes                    | waits for and fetches N available bytes from the open communication's receive buffer
| 0x293      | Comm_TransmitNBytes                          | drops N bytes into the open communication's transmit buffer
| 0x294      | Comm_ClearReceiveBuffer                      | clears the open communication's receive interrupt buffers
| 0x295      | Comm_ClearTransmitBuffer                     | clears the open communication's transmit interrupt buffers
| 0x296      | Comm_IsValidPacketAvailable                  | spies for a byte in the receivebuffer, which is a valid packet type
| 0x298      | Comm_IsOpen                                  | queries the open-status of the communication's channel
| 0x299      | Comm_GetCurrentSelector                      | returns the current selected communication's channel (USB or serial)
| 0x2A1      | HexToByte                                    |
| 0x2A2      | HexToWord                                    |
| 0x2A3      | ByteToHex                                    | Returns hex representation (ascii) of given byte into a char[2].
| 0x2A4      | WordToHex                                    | Returns hex rep. (ascii) of given word into a char[4].
| 0x2A5      | Comm_Padding_5C                              |
| 0x2A6      | Comm_ReversePadding_5C                       |
| 0x2A7      | AscHexToNibble                               |
| 0x2A8      | NibbleToAscHex                               | gReturns hex rep. (ascii) of given nibble into a char. Only used by ByteToAscHex
| 0x2A9      | strlen                                       | string
| 0x2AA      | memcpy                                       | string, slow version - should probably use 0xACF
| 0x2AB      | Serial_Open2                                 | opens the serial channel, unsigned short parameter
| 0x2ac      | USB_Open()                                   | wait USB cable by scanning manually the VBUS (USB hardware module not power-up)
| 0x2AF      | Comm_Spy0thByte                              |
| 0x2DB      | Comm_ProcessInPacket                         | gRetrieve the next packet
| 0x2E1      | Comm_PrepareAckPacket                        |
| 0x2E2      | Comm_PrepareErrorPacket                      |
| 0x2E3      | Comm_PrepareTerminatePacket                  |
| 0x2E4      | Comm_PrepareRoleswapPacket                   |
| 0x2E5      | Comm_PrepareCheckPacket                      |
| 0x2E6      | Comm_PrepareCommandPacket                    |
| 0x2E7      | Comm_PrepareDataPacket                       |
| 0x2ee      | System_GetOSVersion                          | Do not use this syscall, use the OS version stored at 0x80010020
| 0x35E      | memset_range                                 |
| 0x35F      | memset                                       |
| 0x363      | MCS_CreateDirectory                          |
| 0x364      | MCS_WriteItem                                |
| 0x366      | MCS_DeleteDirectory                          |
| 0x367      | MCS_DeleteItem                               |
| 0x368      | MCS_GetState                                 |
| 0x369      | MCS_GetSystemDirectoryInfo                   |
| 0x370      | MCS_RenameItem                               |
| 0x371      | MCS_OverwriteData                            |
| 0x372      | MCS_GetItemData                              |
| 0x373      | MCS_RenameDirectory                          |
| 0x374      | BMCSRenameVariable                           | SDK
| 0x375      | MCS_SearchDirectory                         
| 0x376      | MCS_SearchDirectoryItem                      |
| 0x37C      | MCS_GetFirstDataPointerByDirno               |
| 0x37D      | MCS_GetDirectoryEntryByNumber                |
| 0x37E      | MCS_SearchItem                               |
| 0x37F      | MCS_str8cpy                                  |
| 0x380      | MCS_GetDirectoryEntryAddress                 |
| 0x381      | MCS_GetCurrentBottomAddress                  |
| 0x383      | MCS_GetCapa                                  |
| 0x392      | MCS_GetMainMemoryStart                       |
| 0x3C6      | AddinMcsData                                 | Test MODE: AddinMcsData menu entr
| 0x3DC      | Setup_GetInfo                                |
| 0x3EA      | -                                            | No SysCall but the start of a datatab
| 0x3ED      | Interrupt_SetOrClrStatusFlags
| 0x3F4      | PowerOff                                     | r4=0: Poweroff. r4=1: Display logo and poweroff.
| 0x3F5      | ClearMainMemory                              | Clears main memory, and reboots, showing 'Main memories cleared'.
| 0x3F6      | SH7337_TMU_Stop                              |
| 0x3F7      | SH7337_TMU_int_handler                       |
| 0x3FA      | Hmem_SetMMU                                  | gSDK
| 0x3fc      | TLB_map                                      |
| 0x3fe      | GetStackPtr                                  |
| 0x3ff      | MMU_FlushCache                               | uses the 0x80000000-based cached address
| 0x404      | GetPhysicalROMstart                          |
| 0x405      | GetPhysicalRAMstart                          |
| 0x409      | Serial_ResetAndDisable                       |
| 0x40A      | Serial_GetInterruptHandler                   |
| 0x40B      | Serial_SetInterruptHandler                   |
| 0x40C      | Serial_ReadOneByte                           | gfetches the next available byte from the serial receive interrupt buffer
| 0x40D      | Serial_ReadNBytes                            | fetches a specified count of bytes from the serial receive interrupt buffer
| 0x40E      | Serial_BufferedTransmitOneByte               | drops a byte into the serial transmit interrupt buffer
| 0x40F      | Serial_BufferedTransmitNBytes                | drops N bytes into the serial transmit interrupt buffer
| 0x410      | Serial_DirectTransmitOneByte                 | drops a byte into the serial transmit FIFO
| 0x411      | Serial_GetReceivedBytesAvailable             | returns the count of bytes available in the receive buffer
| 0x412      | Serial_GetFreeTransmitSpace                  | returns free transmit space
| 0x413      | Serial_ClearReceiveBuffer                    | clears the serial receive interrupt buffer
| 0x414      | Serial_ClearTransmitBuffer                   | clears the serial transmit interrupt buffer
| 0x418      | Serial_Open                                  | opens the serial channel
| 0x419      | Serial_Close                                 | closes the serial channel
| 0x41B      | Serial_CallReceiveIntErrorResetHandler       |
| 0x41C      | Serial_CallReceiveIntHandler                 |
| 0x41D      | Serial_CallTransmitIntErrorResetHandler      |
| 0x41E      | Serial_CallTransmitIntHandler                |
| 0x420      | OS_inner_Sleep                               |
| 0x422      | Serial_SpyNthByte                            | gSpies the Nth byte from the serial receive interrupt buffer, if available
| 0x423      | Serial_GetStatus                             | OS; get serial status from SCSSR (function changes the original bit order)
| 0x425      | Serial_IsOpen                                | queries the open-status of the serial channel
| 0x429      | Bfile_identify_device_OS                     | Tries to detect the device referenced by a FONTCHARACTER-filename (fls0 = SMEM or crd0 = SD card).
| 0x42c      | Bfile_OpenFile_OS                            | OS (SDK)
| 0x42D      | Bfile_CloseFile_OS                           | OS (SDK)
| 0x42E      | Bfile_GetMediaFree_OS                        | OS (SDK); incompatible since series GII-2
| 0x42F      | Bfile_GetFileSize_OS                         | OS (SDK)
| 0x431      | Bfile_SeekFile_OS                            | OS (SDK)
| 0x432      | Bfile_ReadFile_OS                            | OS (SDK)
| 0x434      | Bfile_CreateEntry_OS                         | OS (SDK)
| 0x435      | Bfile_WriteFile_OS                           | OS (SDK)
| 0x438      | Bfile_RenameEntry                            | OS (SDK)
| 0x439      | Bfile_DeleteEntry                            | OS (SDK)
| 0x43B      | Bfile_FindFirst                              | SDK
| 0x43C      | Bfile_FindNext                               | SDK
| 0x43D      | Bfile_FindClose                              | SDK
| 0x44E      | memcpy                                       |
| 0x44F      | memcmp                                       | gBfile_GetFilenameLength
| 0x450      | Bfile_GetFilenameLength                      |
| 0x451      | Bfile_Name_cmp                               | gCompares two FONTCHARACTER( short )-arrays
| 0x452      | Bfile_Name_Cpy                               | Copies two FONTCHARACTER (short-arrays)
| 0x453      | Bfile_Name_ncpy                              | Copies n characters of two FONTCHARACTER( short )-arrays
| 0x456      |  Bfile_NameToStr_ncpy                        | Copies a FONTCHARACTER (short array) to a char array
| 0x457      | Bfile_StrToName_ncpy                         | Copies a char array to a FONTCHARACTER( short )-array
| 0x45a      | Bfile_GetNextWord                            |
| 0x45b      | Bfile_GetLastWord                            |
| 0x461      | Kidou_Project                                | Test MODE: Kidou Project entry. (Unused for OS75 02.05.2201)
| 0x462      | GetAppName                                   | SDK, Returns the name of the running application.
| 0x463      | SetAppName                                   | Sets the name of the running application.
| 0x464      | CmpAppName                                   | Compare given name with registered name for the application.
| 0x465      | GetIntPtrContent                             | convert non-4-aligned 4-byte sequences to int
| 0x467      | LongToAscHex                                 | Returns an ASCII hexadecimal representation, with given number of digits.
| 0x468      | Bfile_Check_SD_card_option                   | Returns 1, if SD; returns 0, if non-SD (uses bit 0 of port E)
| 0x469      | Battery_DisplayLowStatus                     |
| 0x46B      | App_BuiltInCount                             | returns the number of built in applicatio
| 0x476      | Battery_IsLow                                |
| 0x477      | EnableGetkeyToMainFunctionReturn             |
| 0x478      | DisableGetkeyToMainFunctionReturn            |
| 0x47F      | SetAutoPowerOffTime                          | in minutes
| 0x480      | GetAutoPowerOffTime                          | in minutes
| 0x486      | GetdatatablePtr                              | returns pointers to OS message- and bitmap-datatables
| 0x48D      | SetAutoPowerOffFlag                          | 1=AutoPowerOff
| 0x48E      | GetAutoPowerOffFlag                          | 1=AutoPowerOff
| 0x492      | Battery_IsLow                                |
| 0x494      | CallbackAtQuitMainFunction                   | SDK (internal CallbackAtQuitMainFunction)
| 0x495      | Battery_DisplayLowStatus                     |
| 0x499      | Heap_SetTopChunk                             |
| 0x49A      | App_Start                                    |
| 0x49C      | Battery_GetStatus                            |
| 0x49E      | -                                            | Calls 0x236, RebootOS
| 0x4A0      | AUX_DisplayErrorMessage                      | like 0x954. Reboots if parameter is 23.
| 0x4AD      | USB_InterruptHandler                         |
| 0x4AE      | USB_TimerHandler                             |
| 0x4B0      | AUX_DisplayFKeyIcons                         |
| 0x4CB      | Keyboard_RemapFKeyCode                       | gchanges the GetKey-returncode of a set of FKeys
| 0x4D1      | AUX_DisplayFKeyIcon                          |
| 0x4DC      | Setup_GetEntry                               | gReturns the Setup value at a given index.
| 0x4DD      | Setup_SetEntry                               | Sets the Setup value at a given index.
| 0x4DE      | Setup_GetEntryPtr                            | Returns a pointer to Setup data with specific index.
| 0x4DF      | Alpha_GetData                                | Returns the data of a given AlphaMem variable.
| 0x4E0      | Alpha_SetData                                | Copies the given data to an AlphaMem variable.
| 0x4E1      | Alpha_ClearAll                               | Clears all AlphaMem variables, except Ans.
| 0x4e2      | Keyboard_wait_user_break                     | wait user break by pressing AC/ON
| 0x4E6      | HourGlass                                    |
| 0x4E9      | LocalizeStringID                             | Returns pointer to localized string of given I
| 0x4F5      | BCD_ToStrAsNumber1                           |
| 0x4F6      | BCD_ToStrAsNumber2                           |
| 0x500      | BCDToInternal                                |
| 0x518      | Setup_GetEntry_3E                            | gas short variable
| 0x519      | Setup_GetEntry_40                            | as short variable
| 0x51A      | Setup_SetEntry_3E                            | as short variable
| 0x51B      | Setup_SetEntry_40                            | as short variable
| 0x531      | MB_IsLead                                    | does byte signal an extended character set?
| 0x533      | MB_ElementCount                              | number of elements in multibyte string (number of symbols that will be "printed")
| 0x534      | MB_ByteCount                                 | number of bytes in multibyte string (number of bytes that must be copied)
| 0x536      | MB_strcat                                    | concatenate two multibyte strings
| 0x537      | MB_strncat                                   | same, but with size limitation
| 0x538      | MB_strcpy                                    | copy a multibyte string
| 0x53C      | MB_GetSecondElemPtr                          | get pointer to second element in string
| 0x53D      | MB_GetElement                                | returns value (a short), containing first element in string
| 0x53E      | MB_CopyToHeap                                | allocates memory and copies provided string to the heap. NOT used by OS
| 0x53F      | another                                      | itoa
| 0x542      | to_uppercase                                 | Convert 'a'-'z' byte at provided pointer destination, to uppercase.
| 0x543      | to_lowercase                                 | Convert 'A'-'Z' byte at provided pointer destination, to lowercase
| 0x544-54   | Math_GetConstant                             | several functions to fetch BCD coded constants
| 0x5A6      | BCD_SetAsInt                                 |
| 0x5AF-B8   | Math_GetConstant                             |
| 0x645      | CalculateExpression                          |
| 0x64A      | CalculateExpression0                         |
| 0x652      | NextOpcode                                   | PRGM related
| 0x6A6      | IsEndOfLine                                  | PRGM related
| 0x6C4      | Keyboard_PRGM_GetKey                         | PRGM-GetKey (non-blocking and calc-type independent)
| 0x6D4      | Alpha_GetData2                               | Returns the data of a given AlphaMem variable and does a range check.
| 0x713      | Print_ClearLine_OS                           | Clears a line
| 0x763      | Bdisp_DrawRectangle                          | draws a rectangle
| 0x7FC      | Expressions_OpcodeToStr                      |
| 0x804      | CLIP_Store                                   | gstores a buffer to the clipboard
| 0x807      | locate                                       | SDK, OS
| 0x808      | Print                                        | SDK
| 0x809      | PrintRev                                     | SDK
| 0x80A      | PrintC                                       | SDK
| 0x80B      | PrintRevC                                    | SDK
| 0x80C      | PrintLine                                    | SDK
| 0x80D      | PrintRLine                                   | SDK
| 0x811      | Cursor_SetFlashOn                            | Enables cursor-flashing and sets the look/style of the cursor.
| 0x812      | Cursor_SetFlashOff                           | Turns off the cursor flashing.
| 0x813      | SaveDisp                                     | SDK
| 0x814      | RestoreDisp                                  | SDK
| 0x829      | MCS_CreateDirectory                          |
| 0x82A      | MCS_PutInternalItem                          |
| 0x82B      | MCSPutVar2                                   | SDK
| 0x830      | MCSOvwDat2                                   | SDK
| 0x832      | MCS_OverwriteOpenItem                        |
| 0x833      | MCS_ClearInternalDirectory                   |
| 0x834      | MCS_ClearDirectory                           |
| 0x835      | MCS_DeleteInternalItem                       |
| 0x836      | MCSDelVar2                                   | SDK
| 0x83A      | MCS_GotoInternalItem                         |
| 0x83B      | MCS_OpenMainMemoryItem                       |
| 0x83C      | MCS_GotoHandleNeighbour                      |
| 0x83D      | MCS_CheckOpenedItem                          |
| 0x83E      | MCS_GetOpenItem                              |
| 0x83F      | MCS_OpenInternalDirectoryItem                |
| 0x840      | MCSGetDlen2                                  | SDK
| 0x841      | MCSGetData1                                  | SDK
| 0x843      | MCS_MapMCS_Result                            |
| 0x844      | MCSGetCapa                                   | SDK
| 0x84B      | MCS_OpenInternalDirectoryItem2               |
| 0x84D      | MCS_OpenAlphaMemItem                         |
| 0x852      | MCS_DirtypeToItemtype                        |
| 0x853      | MCS_ItemtypeToDirtype                        |
| 0x863      | MCS_DirtypeToName                            |
| 0x866      | MCS_MapError                                 |
| 0x869      | Alpha_ClearAllAndAns                         | Clears all AlphaMem variables.
| 0x86F      | MCS_DeleteDirectoryItems                     |
| 0x8DB      | EditExpression                               |
| 0x8DC      | EditValue                                    |
| 0x8E6      | EditMBStringCtrl                             | gvoid EditMBStringCtrl( unsigned char*, int xposmax, void*, void*, void*, int, int );
| 0x8EA      | DisplayMBString                              | void DisplayMBString( unsigned char*, int, int xpos, intx, int y );
| 0x8EC      | EditMBStringChar                             | void EditMBStringChar( unsigned char*, int xposmax, int xpos, int char );
| 0x8F7      | DisplayMBString2                             | void DisplayMBString2( int, unsigned char*, int, int xpos, int zero, int x, int y, int, int, int );
| 0x8FE      | PopupWin                                     | SDK, void PopupWin( int nlines )
| 0x901      | AUX_DisplayMessageBox                        |
| 0x905      | AUX_DisplayErrorMessage                      | Displays an error message box depending on the int parameter passed.
| 0x90B      | SetShiftAlphaState                           | See Setup
| 0x90C      | GetInsOverwriteState                         | See Setup
| 0x90D      | SetInsOverwriteState                         | See Setup
| 0x90E      | ClrShiftAlphaState                           | See Setup
| 0x90F      | GetKey                                       | SDK
| 0x910      | PutKey                                       | Puts a GetKey-keycode into keybuffer
| 0x91B      | GetShiftAlphaState                           | See Setup
| 0x924      | TestMode                                     | Enters the "TEST MODE" program, also avail via keypresses.
| 0x954      | AUX_DisplayErrorMessage                      | Displays an error message box depending on the int parameter passed.
| 0x985      | App_CONICS                                   | Entrypoint of the CONICS-app
| 0x998      | App_DYNA                                     | Entrypoint of the DYNA-app
| 0x9AD      | PrintXY                                      | SDK
| 0x9DF      | App_EACT                                     | Entrypoint of the EACT-app
| 0x9E1      | App_Equation                                 | Executes "Equation" (EQUA) built-in program.
| 0x9E2      | App_EQUA                                     | Entrypoint of the EQUA-app, Calls 0x9E1, App_Equation
| 0x9F5      | App_Program                                  | Executes "Program List" (PRGM) built-in program.
| 0xA00      | App_FINANCE                                  | Entrypoint of the FINANCE-app
| 0xA1F      | Keyboard_RemapFKeyCode                       | changes the GetKey-returncode of a set of FKeys; uses 0x4CB
| 0xA35      | AUX_DisplayMessage                           | Displays a four line message box depending on the int parameters passed.
| 0xA48      | App_GRAPH_TABLE                              | Entrypoint of the GRAPH- and TABLE-apps
| 0xA4A      | App_LINK                                     | Entrypoint of the LINK-app
| 0xA6A      | App_Optimization                             | Execute MEMORY's "F5:Optimization" dialog.
| 0xA6B      | App_Memory                                   | Execute the "Memory Manager" (MEMORY) built-in program.
| 0xA75      | App_RECUR                                    | Entrypoint of the RECUR-app
| 0xA97      | App_RUN_MAT_EXE                              | Entrypoint, when RUN MAT-app starts analyzing an expression
| 0xAAE      | App_RUN_MAT                                  | Entrypoint of the RUN MAT-app
| 0xAC6      | App_STAT                                     | Entrypoint of the STAT-app
| 0xAC8      | App_SYSTEM                                   | Entrypoint of the SYSTEM-app
| 0xac9      | longjmp                                      |
| 0xaca      | setjmp                                       |
| 0xACC      | free                                         | SDK, stdlib
| 0xACD      | malloc                                       | SDK, stdlib
| 0xACE      | memcmp                                       | string
| 0xACF      | memcpy                                       | smart memcpy; uses mov.b, mov.w or mov.l depending on parameter alignment
| 0xAD0      | memset                                       |
| 0xAD4      | strcat                                       |
| 0xAD5      | strcmp                                       | smart strcmp; uses mov.b or mov.l depending on parameter alignment
| 0xAD6      | strlen                                       | gstring
| 0xAD7      | strncat                                      | string
| 0xAD8      | strncmp                                      | string
| 0xAD9      | strncpy                                      | string
| 0xADA      | strrchr                                      | string
| 0xAE8      | Catalog-dialog                               | returns opcode
| 0xC4F      | PrintMiniSd                                  | SDK
| 0xCA7      | OpcodeType                                   |
| 0xCB0      | Send(/Send38k                                | gPRGM related
| 0xCB1      | Receive(/Receive38k                          | PRGM related
| 0xCB2      | Open/CloseComPort38k                         | PRGM related
| 0xCB7      | Variable_Manager_Menu                        | Test Mode: Variable Manager entry.
| 0xCC4      | Number                                       | Input Dialog
| 0xCC5      | String                                       | Input Dialog
| 0xCCB      | GetRAMSize                                   | returns 0x40000 or 0x80000
| 0xCD0      | InputDateDialog                              |
| 0xD65      | InputMonthDialog                             |
| 0xD66      | InputDayDialog                               |
| 0xD67      | InputYearDialog                              |
| 0xDAB      | StoreExpressionToGraphFuncMemory             |
| 0xE64      | Font/Lang_Check_Menu                         | Test MODE: Font/Lang Check menu entry.
| 0xE6B      | calloc                                       | SDK, stdlib
| 0xE6C      | memmove                                      |
| 0xE6D      | realloc                                      | gSDK, stdlib
| 0xE6E      | strchr                                       |
| 0xE6F      | strstr                                       |
| 0xfe8      | __fast_strcpy                                | DONT'T CALL BECAUSE IT USE `fast` ATTRIBUTE (argument passed using r0, r1, r2)
