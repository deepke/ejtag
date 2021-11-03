#ifndef __EEP_8000_H
#define __EEP_8000_H

/*******************************************************************************
 * Copyright 2013-2015 Avago Technologies
 * Copyright (c) 2009 to 2012 PLX Technology Inc.  All rights reserved.
 *
 * This software is available to you under a choice of one of two
 * licenses.  You may choose to be licensed under the terms of the GNU
 * General Public License (GPL) Version 2, available from the file
 * COPYING in the main directorY of this source tree, or the
 * BSD license below:
 *
 *     Redistribution and use in source and binary forms, with or
 *     without modification, are permitted provided that the following
 *     conditions are met:
 *
 *      - Redistributions of source code must retain the above
 *        copyright notice, this list of conditions and the following
 *        disclaimer.
 *
 *      - Redistributions in binary form must reproduce the above
 *        copyright notice, this list of conditions and the following
 *        disclaimer in the documentation and/or other materials
 *        provided with the distribution.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 ******************************************************************************/

/******************************************************************************
 *
 * File Name:
 *
 *      Eep_8000.h
 *
 * Description:
 *
 *      The include file for 8000-series EEPROM support functions
 *
 * Revision History:
 *
 *      08-01-11 : PLX SDK v6.50
 *
 ******************************************************************************/


//#include "DrvDefs.h"

typedef int    PLX_STATUS;
#define PLX_STATUS_START 0

typedef enum _PLX_STATUS_CODE
{
    PLX_STATUS_OK               = PLX_STATUS_START,
    PLX_STATUS_FAILED,
    PLX_STATUS_NULL_PARAM,
    PLX_STATUS_UNSUPPORTED,
    PLX_STATUS_NO_DRIVER,
    PLX_STATUS_INVALID_OBJECT,
    PLX_STATUS_VER_MISMATCH,
    PLX_STATUS_INVALID_OFFSET,
    PLX_STATUS_INVALID_DATA,
    PLX_STATUS_INVALID_SIZE,
    PLX_STATUS_INVALID_ADDR,
    PLX_STATUS_INVALID_ACCESS,
    PLX_STATUS_INSUFFICIENT_RES,
    PLX_STATUS_TIMEOUT,
    PLX_STATUS_CANCELED,
    PLX_STATUS_COMPLETE,
    PLX_STATUS_PAUSED,
    PLX_STATUS_IN_PROGRESS,
    PLX_STATUS_PAGE_GET_ERROR,
    PLX_STATUS_PAGE_LOCK_ERROR,
    PLX_STATUS_LOW_POWER,
    PLX_STATUS_IN_USE,
    PLX_STATUS_DISABLED,
    PLX_STATUS_PENDING,
    PLX_STATUS_NOT_FOUND,
    PLX_STATUS_INVALID_STATE,
    PLX_STATUS_BUFF_TOO_SMALL,
    PLX_STATUS_RSVD_LAST_ERROR    // Do not add API errors below this line
} PLX_STATUS_CODE;


// EEPROM status
typedef enum _PLX_EEPROM_STATUS
{
    PLX_EEPROM_STATUS_NONE         = 0,     // Not present
    PLX_EEPROM_STATUS_VALID        = 1,     // Present with valid data
    PLX_EEPROM_STATUS_INVALID_DATA = 2,     // Present w/invalid data or CRC error
    PLX_EEPROM_STATUS_BLANK        = PLX_EEPROM_STATUS_INVALID_DATA,
    PLX_EEPROM_STATUS_CRC_ERROR    = PLX_EEPROM_STATUS_INVALID_DATA
} PLX_EEPROM_STATUS;


// EEPROM CRC status
typedef enum _PLX_CRC_STATUS
{
    PLX_CRC_INVALID             = 0,
    PLX_CRC_VALID               = 1,
    PLX_CRC_UNSUPPORTED         = 2,
    PLX_CRC_UNKNOWN             = 3
} PLX_CRC_STATUS;


// PLX chip families
typedef enum _PLX_CHIP_FAMILY
{
    PLX_FAMILY_NONE = 0,
    PLX_FAMILY_UNKNOWN,
    PLX_FAMILY_BRIDGE_P2L,              // 9000 series & 8311
    PLX_FAMILY_BRIDGE_PCI_P2P,          // 6000 series
    PLX_FAMILY_BRIDGE_PCIE_P2P,         // 8111,8112,8114
    PLX_FAMILY_ALTAIR,                  // 8525,8533,8547,8548
    PLX_FAMILY_ALTAIR_XL,               // 8505,8509
    PLX_FAMILY_VEGA,                    // 8516,8524,8532
    PLX_FAMILY_VEGA_LITE,               // 8508,8512,8517,8518
    PLX_FAMILY_DENEB,                   // 8612,8616,8624,8632,8647,8648
    PLX_FAMILY_SIRIUS,                  // 8604,8606,8608,8609,8613,8614,8615
                                        //   8617,8618,8619
    PLX_FAMILY_CYGNUS,                  // 8625,8636,8649,8664,8680,8696
    PLX_FAMILY_SCOUT,                   // 8700
    PLX_FAMILY_DRACO_1,                 // 8712,8716,8724,8732,8747,8748,8749
    PLX_FAMILY_DRACO_2,                 // 8713,8717,8725,8733 + [Draco 1 rev BA]
    PLX_FAMILY_MIRA,                    // 2380,3380,3382,8603,8605
    PLX_FAMILY_CAPELLA_1,               // 8714,8718,8734,8750,8764,8780,8796
    PLX_FAMILY_CAPELLA_2,               // 9712,9716,9733,9749,9750,9765,9781,9797
    PLX_FAMILY_ATLAS,                   // C010,C011,C012
    PLX_FAMILY_LAST_ENTRY               // -- Must be final entry --
} PLX_CHIP_FAMILY;

// Mode PLX API uses to access device
typedef enum _PLX_API_MODE
{
    PLX_API_MODE_PCI,                   // Device accessed via PLX driver over PCI/PCIe
    PLX_API_MODE_I2C_AARDVARK,          // Device accessed via Aardvark I2C USB
    PLX_API_MODE_MDIO_SPLICE,           // Device accessed via Splice MDIO USB
    PLX_API_MODE_SDB,                   // Device accessed via Serial Debug Port
    PLX_API_MODE_TCP                    // Device accessed via TCP/IP
} PLX_API_MODE;


// Port types
typedef enum _PLX_PORT_TYPE
{
    PLX_PORT_UNKNOWN            = 0xFF,
    PLX_PORT_ENDPOINT           = 0,
    PLX_PORT_LEGACY_ENDPOINT    = 1,
    PLX_PORT_ROOT_PORT          = 4,
    PLX_PORT_UPSTREAM           = 5,
    PLX_PORT_DOWNSTREAM         = 6,
    PLX_PORT_PCIE_TO_PCI_BRIDGE = 7,
    PLX_PORT_PCI_TO_PCIE_BRIDGE = 8,
    PLX_PORT_ROOT_ENDPOINT      = 9,
    PLX_PORT_ROOT_EVENT_COLL    = 10
} PLX_PORT_TYPE;

// PLX port flags for mask
typedef enum _PLX_FLAG_PORT
{
    PLX_FLAG_PORT_NT_LINK_1     = 63,   // Bit for NT Link port 0
    PLX_FLAG_PORT_NT_LINK_0     = 62,   // Bit for NT Link port 1
    PLX_FLAG_PORT_NT_VIRTUAL_1  = 61,   // Bit for NT Virtual port 0
    PLX_FLAG_PORT_NT_VIRTUAL_0  = 60,   // Bit for NT Virtual port 1
    PLX_FLAG_PORT_NT_DS_P2P     = 59,   // Bit for NT DS P2P port (Virtual)
    PLX_FLAG_PORT_DMA_RAM       = 58,   // Bit for DMA RAM
    PLX_FLAG_PORT_DMA_3         = 57,   // Bit for DMA channel 3
    PLX_FLAG_PORT_DMA_2         = 56,   // Bit for DMA channel 2
    PLX_FLAG_PORT_DMA_1         = 55,   // Bit for DMA channel 1
    PLX_FLAG_PORT_DMA_0         = 54,   // Bit for DMA ch 0 or Func 1 (all 4 ch)
    PLX_FLAG_PORT_PCIE_TO_USB   = 53,   // Bit for PCIe-to-USB P2P or Root Port
    PLX_FLAG_PORT_USB           = 52,   // Bit for USB Host/Bridge
    PLX_FLAG_PORT_ALUT_3        = 51,   // Bit for ALUT RAM arrays 0
    PLX_FLAG_PORT_ALUT_2        = 50,   // Bit for ALUT RAM arrays 1
    PLX_FLAG_PORT_ALUT_1        = 49,   // Bit for ALUT RAM arrays 2
    PLX_FLAG_PORT_ALUT_0        = 48,   // Bit for ALUT RAM arrays 3
    PLX_FLAG_PORT_STN_REGS_S5   = 47,   // Bit for VS or Fabric mode station 0 specific regs
    PLX_FLAG_PORT_STN_REGS_S4   = 46,   // Bit for VS or Fabric mode station 1 specific regs
    PLX_FLAG_PORT_STN_REGS_S3   = 45,   // Bit for VS or Fabric mode station 2 specific regs
    PLX_FLAG_PORT_STN_REGS_S2   = 44,   // Bit for VS or Fabric mode station 3 specific regs
    PLX_FLAG_PORT_STN_REGS_S1   = 43,   // Bit for VS or Fabric mode station 4 specific regs
    PLX_FLAG_PORT_STN_REGS_S0   = 42,   // Bit for VS or Fabric mode station 5 specific regs
    PLX_FLAG_PORT_MAX           = 41,   // Bit for highest possible standard port

	// Flags below are special ports for GEP (24) & its parent P2P (25)
    PLX_FLAG_PORT_GEP           = 24,
    PLX_FLAG_PORT_GEP_P2P       = 25
} PLX_FLAG_PORT;

typedef unsigned char U8;
typedef unsigned short U16;
typedef unsigned int U32;
typedef int BOOLEAN;
typedef void VOID;


// PCI Device Key Identifier
typedef struct _PLX_DEVICE_KEY
{
    U32 IsValidTag;                  // Magic number to determine validity
    U8  domain;                      // Physical device location
    U8  bus;
    U8  slot;
    U8  function;
    U16 VendorId;                    // Device Identifier
    U16 DeviceId;
    U16 SubVendorId;
    U16 SubDeviceId;
    U8  Revision;
    U16 PlxChip;                     // PLX chip type
    U8  PlxRevision;                 // PLX chip revision
    U8  PlxFamily;                   // PLX chip family
    U8  ApiIndex;                    // Used internally by the API
    U16 DeviceNumber;                // Used internally by device drivers
    U8  ApiMode;                     // Mode API uses to access device
    U8  PlxPort;                     // PLX port number of device
    union
    {
        U8  PlxPortType;             // PLX-specific port type (NT/DMA/Host/etc)
        U8  NTPortType;              // (Deprecated) If NT, stores NT port type
    };
    U8  NTPortNum;                   // If NT port exists, store NT port number
    U8  DeviceMode;                  // Device mode used internally by API
    U32 ApiInternal[2];              // Reserved for internal PLX API use
} PLX_DEVICE_KEY;

typedef struct plx800 {
	unsigned long long base;

	PLX_DEVICE_KEY         Key;                           // Device location & identification
} DEVICE_EXTENSION;
DEVICE_EXTENSION Plx = { 
.base = 0x9000000041100000ULL,
.Key = {
.PlxChip = 0x8619,
.PlxFamily = PLX_FAMILY_SIRIUS,
.ApiMode = PLX_API_MODE_PCI,
},
};

#define FALSE 0
#define TRUE 1

#define PLX_8000_REG_READ(pdx, offset) (*(volatile unsigned int *)(pdx->base+offset))
#define PLX_8000_REG_WRITE(pdx, offset, val) (*(volatile unsigned int *)(pdx->base+offset) = (val))
#define DebugPrintf(x)  printf x
#define Plx_sleep udelay



#ifdef __cplusplus
extern "C" {
#endif




/**********************************************
*               Definitions
**********************************************/
#define CONST_CRC_XOR_VALUE             0xDB710641          // Constant used in CRC calculations

// PLX 8000-series EEPROM definitions
#define PLX8000_EE_CMD_READ             3
#define PLX8000_EE_CMD_READ_STATUS      5
#define PLX8000_EE_CMD_WRITE_ENABLE     6
#define PLX8000_EE_CMD_WRITE_DISABLE    4
#define PLX8000_EE_CMD_WRITE            2
#define PLX8000_EE_CMD_WRITE_STATUS     1




/**********************************************
*               Functions
**********************************************/
PLX_STATUS
Plx8000_EepromPresent(
    DEVICE_EXTENSION *pdx,
    U8               *pStatus
    );

PLX_STATUS
Plx8000_EepromGetAddressWidth(
    DEVICE_EXTENSION *pdx,
    U8               *pWidth
    );

PLX_STATUS
Plx8000_EepromSetAddressWidth(
    DEVICE_EXTENSION *pdx,
    U8                width
    );

PLX_STATUS
Plx8000_EepromCrcGet(
    DEVICE_EXTENSION *pdx,
    U32              *pCrc,
    U8               *pCrcStatus
    );

PLX_STATUS
Plx8000_EepromCrcUpdate(
    DEVICE_EXTENSION *pdx,
    U32              *pCrc,
    BOOLEAN           bUpdateEeprom
    );

PLX_STATUS
Plx8000_EepromReadByOffset(
    DEVICE_EXTENSION *pdx,
    U32               offset,
    U32              *pValue
    );

PLX_STATUS
Plx8000_EepromWriteByOffset(
    DEVICE_EXTENSION *pdx,
    U32               offset,
    U32               value
    );

PLX_STATUS
Plx8000_EepromReadByOffset_16(
    DEVICE_EXTENSION *pdx,
    U32               offset,
    U16              *pValue
    );

PLX_STATUS
Plx8000_EepromWriteByOffset_16(
    DEVICE_EXTENSION *pdx,
    U32               offset,
    U16               value
    );

BOOLEAN
Plx8000_EepromWaitIdle(
    DEVICE_EXTENSION *pdx
    );

BOOLEAN
Plx8000_EepromSendCommand(
    DEVICE_EXTENSION *pdx,
    U32               command
    );

VOID
Plx8000_EepromComputeNextCrc(
    U32 *pCrc,
    U32  NextEepromValue
    );

U16
Plx8000_EepromGetCtrlOffset(
    DEVICE_EXTENSION *pdx
    );



#ifdef __cplusplus
}
#endif

#endif
