//
// PARPORT.H
//
// Handles all access to the parallel port
//
// Copyright (c) 2002, Jason Riffel - TotalEmbedded LLC.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions 
// are met:
//
// Redistributions of source code must retain the above copyright 
// notice, this list of conditions and the following disclaimer. 
//
// Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in 
// the documentation and/or other materials provided with the
// distribution. 
//
// Neither the name of TotalEmbedded nor the names of its 
// contributors may be used to endorse or promote products derived 
// from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
// LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
// POSSIBILITY OF SUCH DAMAGE.
//

#ifndef dPARPORT_H
#define dPARPORT_H

//
// DEFINES
//
// Define the pins each signal is assigned to on the data port
#define dPARPORT_TAP_RESET_BIT  (pp_pins&0xf)
#define dPARPORT_TAP_DI_BIT  ((pp_pins>>4)&0xf)
#define dPARPORT_TAP_DO_BIT  ((pp_pins>>8)&0xf)
#define dPARPORT_TAP_MS_BIT  ((pp_pins>>12)&0xf)
#define dPARPORT_TAP_CLK_BIT  ((pp_pins>>16)&0xf)
#define dPARPORT_TARGET_RESET_BIT  ((pp_pins>>20)&0xf)

// Define the bit in the status register that is our TAP_DI
#define dPARPORT_TAP_DO        (1<<dPARPORT_TAP_DO_BIT)

// Macro to calculate the bit settings when writing to the data port
#define mPARPORT_TRS_BIT(x) (x << dPARPORT_TAP_RESET_BIT   )
#define mPARPORT_TMS_BIT(x) (x << dPARPORT_TAP_MS_BIT      )
#define mPARPORT_TDI_BIT(x) (x << dPARPORT_TAP_DI_BIT      )
#define mPARPORT_TCK_BIT(x) (x << dPARPORT_TAP_CLK_BIT     )
#define mPARPORT_RST_BIT(x) (x << dPARPORT_TARGET_RESET_BIT)

//
// PROTOTYPES
//
void                 fPARPORT_Init (void);
void          fPARPORT_Write(unsigned char uc_byte);
unsigned char fPARPORT_Read (void);

#endif // #ifndef dPARPORT_H
