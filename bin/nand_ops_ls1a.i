# 1 "/loongson/ejtag-debug/bin/nand_ops_ls1a.c"
# 1 "/loongson/ejtag-debug/bin//"
# 1 "<built-in>"
#define __STDC__ 1
#define __STDC_HOSTED__ 1
#define __GNUC__ 4
#define __GNUC_MINOR__ 4
#define __GNUC_PATCHLEVEL__ 0
#define __SIZE_TYPE__ unsigned int
#define __PTRDIFF_TYPE__ int
#define __WCHAR_TYPE__ int
#define __WINT_TYPE__ unsigned int
#define __INTMAX_TYPE__ long long int
#define __UINTMAX_TYPE__ long long unsigned int
#define __CHAR16_TYPE__ short unsigned int
#define __CHAR32_TYPE__ unsigned int
#define __GXX_ABI_VERSION 1002
#define __SCHAR_MAX__ 127
#define __SHRT_MAX__ 32767
#define __INT_MAX__ 2147483647
#define __LONG_MAX__ 2147483647L
#define __LONG_LONG_MAX__ 9223372036854775807LL
#define __WCHAR_MAX__ 2147483647
#define __CHAR_BIT__ 8
#define __INTMAX_MAX__ 9223372036854775807LL
#define __FLT_EVAL_METHOD__ 0
#define __DEC_EVAL_METHOD__ 2
#define __FLT_RADIX__ 2
#define __FLT_MANT_DIG__ 24
#define __FLT_DIG__ 6
#define __FLT_MIN_EXP__ (-125)
#define __FLT_MIN_10_EXP__ (-37)
#define __FLT_MAX_EXP__ 128
#define __FLT_MAX_10_EXP__ 38
#define __FLT_MAX__ 3.40282347e+38F
#define __FLT_MIN__ 1.17549435e-38F
#define __FLT_EPSILON__ 1.19209290e-7F
#define __FLT_DENORM_MIN__ 1.40129846e-45F
#define __FLT_HAS_DENORM__ 1
#define __FLT_HAS_INFINITY__ 1
#define __FLT_HAS_QUIET_NAN__ 1
#define __DBL_MANT_DIG__ 53
#define __DBL_DIG__ 15
#define __DBL_MIN_EXP__ (-1021)
#define __DBL_MIN_10_EXP__ (-307)
#define __DBL_MAX_EXP__ 1024
#define __DBL_MAX_10_EXP__ 308
#define __DBL_MAX__ 1.7976931348623157e+308
#define __DBL_MIN__ 2.2250738585072014e-308
#define __DBL_EPSILON__ 2.2204460492503131e-16
#define __DBL_DENORM_MIN__ 4.9406564584124654e-324
#define __DBL_HAS_DENORM__ 1
#define __DBL_HAS_INFINITY__ 1
#define __DBL_HAS_QUIET_NAN__ 1
#define __LDBL_MANT_DIG__ 53
#define __LDBL_DIG__ 15
#define __LDBL_MIN_EXP__ (-1021)
#define __LDBL_MIN_10_EXP__ (-307)
#define __LDBL_MAX_EXP__ 1024
#define __LDBL_MAX_10_EXP__ 308
#define __DECIMAL_DIG__ 17
#define __LDBL_MAX__ 1.7976931348623157e+308L
#define __LDBL_MIN__ 2.2250738585072014e-308L
#define __LDBL_EPSILON__ 2.2204460492503131e-16L
#define __LDBL_DENORM_MIN__ 4.9406564584124654e-324L
#define __LDBL_HAS_DENORM__ 1
#define __LDBL_HAS_INFINITY__ 1
#define __LDBL_HAS_QUIET_NAN__ 1
#define __DEC32_MANT_DIG__ 7
#define __DEC32_MIN_EXP__ (-94)
#define __DEC32_MAX_EXP__ 97
#define __DEC32_MIN__ 1E-95DF
#define __DEC32_MAX__ 9.999999E96DF
#define __DEC32_EPSILON__ 1E-6DF
#define __DEC32_SUBNORMAL_MIN__ 0.000001E-95DF
#define __DEC64_MANT_DIG__ 16
#define __DEC64_MIN_EXP__ (-382)
#define __DEC64_MAX_EXP__ 385
#define __DEC64_MIN__ 1E-383DD
#define __DEC64_MAX__ 9.999999999999999E384DD
#define __DEC64_EPSILON__ 1E-15DD
#define __DEC64_SUBNORMAL_MIN__ 0.000000000000001E-383DD
#define __DEC128_MANT_DIG__ 34
#define __DEC128_MIN_EXP__ (-6142)
#define __DEC128_MAX_EXP__ 6145
#define __DEC128_MIN__ 1E-6143DL
#define __DEC128_MAX__ 9.999999999999999999999999999999999E6144DL
#define __DEC128_EPSILON__ 1E-33DL
#define __DEC128_SUBNORMAL_MIN__ 0.000000000000000000000000000000001E-6143DL
#define __SFRACT_FBIT__ 7
#define __SFRACT_IBIT__ 0
#define __SFRACT_MIN__ (-0.5HR-0.5HR)
#define __SFRACT_MAX__ 0X7FP-7HR
#define __SFRACT_EPSILON__ 0x1P-7HR
#define __USFRACT_FBIT__ 8
#define __USFRACT_IBIT__ 0
#define __USFRACT_MIN__ 0.0UHR
#define __USFRACT_MAX__ 0XFFP-8UHR
#define __USFRACT_EPSILON__ 0x1P-8UHR
#define __FRACT_FBIT__ 15
#define __FRACT_IBIT__ 0
#define __FRACT_MIN__ (-0.5R-0.5R)
#define __FRACT_MAX__ 0X7FFFP-15R
#define __FRACT_EPSILON__ 0x1P-15R
#define __UFRACT_FBIT__ 16
#define __UFRACT_IBIT__ 0
#define __UFRACT_MIN__ 0.0UR
#define __UFRACT_MAX__ 0XFFFFP-16UR
#define __UFRACT_EPSILON__ 0x1P-16UR
#define __LFRACT_FBIT__ 31
#define __LFRACT_IBIT__ 0
#define __LFRACT_MIN__ (-0.5LR-0.5LR)
#define __LFRACT_MAX__ 0X7FFFFFFFP-31LR
#define __LFRACT_EPSILON__ 0x1P-31LR
#define __ULFRACT_FBIT__ 32
#define __ULFRACT_IBIT__ 0
#define __ULFRACT_MIN__ 0.0ULR
#define __ULFRACT_MAX__ 0XFFFFFFFFP-32ULR
#define __ULFRACT_EPSILON__ 0x1P-32ULR
#define __LLFRACT_FBIT__ 63
#define __LLFRACT_IBIT__ 0
#define __LLFRACT_MIN__ (-0.5LLR-0.5LLR)
#define __LLFRACT_MAX__ 0X7FFFFFFFFFFFFFFFP-63LLR
#define __LLFRACT_EPSILON__ 0x1P-63LLR
#define __ULLFRACT_FBIT__ 64
#define __ULLFRACT_IBIT__ 0
#define __ULLFRACT_MIN__ 0.0ULLR
#define __ULLFRACT_MAX__ 0XFFFFFFFFFFFFFFFFP-64ULLR
#define __ULLFRACT_EPSILON__ 0x1P-64ULLR
#define __SACCUM_FBIT__ 7
#define __SACCUM_IBIT__ 8
#define __SACCUM_MIN__ (-0X1P7HK-0X1P7HK)
#define __SACCUM_MAX__ 0X7FFFP-7HK
#define __SACCUM_EPSILON__ 0x1P-7HK
#define __USACCUM_FBIT__ 8
#define __USACCUM_IBIT__ 8
#define __USACCUM_MIN__ 0.0UHK
#define __USACCUM_MAX__ 0XFFFFP-8UHK
#define __USACCUM_EPSILON__ 0x1P-8UHK
#define __ACCUM_FBIT__ 15
#define __ACCUM_IBIT__ 16
#define __ACCUM_MIN__ (-0X1P15K-0X1P15K)
#define __ACCUM_MAX__ 0X7FFFFFFFP-15K
#define __ACCUM_EPSILON__ 0x1P-15K
#define __UACCUM_FBIT__ 16
#define __UACCUM_IBIT__ 16
#define __UACCUM_MIN__ 0.0UK
#define __UACCUM_MAX__ 0XFFFFFFFFP-16UK
#define __UACCUM_EPSILON__ 0x1P-16UK
#define __LACCUM_FBIT__ 31
#define __LACCUM_IBIT__ 32
#define __LACCUM_MIN__ (-0X1P31LK-0X1P31LK)
#define __LACCUM_MAX__ 0X7FFFFFFFFFFFFFFFP-31LK
#define __LACCUM_EPSILON__ 0x1P-31LK
#define __ULACCUM_FBIT__ 32
#define __ULACCUM_IBIT__ 32
#define __ULACCUM_MIN__ 0.0ULK
#define __ULACCUM_MAX__ 0XFFFFFFFFFFFFFFFFP-32ULK
#define __ULACCUM_EPSILON__ 0x1P-32ULK
#define __LLACCUM_FBIT__ 31
#define __LLACCUM_IBIT__ 32
#define __LLACCUM_MIN__ (-0X1P31LLK-0X1P31LLK)
#define __LLACCUM_MAX__ 0X7FFFFFFFFFFFFFFFP-31LLK
#define __LLACCUM_EPSILON__ 0x1P-31LLK
#define __ULLACCUM_FBIT__ 32
#define __ULLACCUM_IBIT__ 32
#define __ULLACCUM_MIN__ 0.0ULLK
#define __ULLACCUM_MAX__ 0XFFFFFFFFFFFFFFFFP-32ULLK
#define __ULLACCUM_EPSILON__ 0x1P-32ULLK
#define __QQ_FBIT__ 7
#define __QQ_IBIT__ 0
#define __HQ_FBIT__ 15
#define __HQ_IBIT__ 0
#define __SQ_FBIT__ 31
#define __SQ_IBIT__ 0
#define __DQ_FBIT__ 63
#define __DQ_IBIT__ 0
#define __TQ_FBIT__ 127
#define __TQ_IBIT__ 0
#define __UQQ_FBIT__ 8
#define __UQQ_IBIT__ 0
#define __UHQ_FBIT__ 16
#define __UHQ_IBIT__ 0
#define __USQ_FBIT__ 32
#define __USQ_IBIT__ 0
#define __UDQ_FBIT__ 64
#define __UDQ_IBIT__ 0
#define __UTQ_FBIT__ 128
#define __UTQ_IBIT__ 0
#define __HA_FBIT__ 7
#define __HA_IBIT__ 8
#define __SA_FBIT__ 15
#define __SA_IBIT__ 16
#define __DA_FBIT__ 31
#define __DA_IBIT__ 32
#define __TA_FBIT__ 63
#define __TA_IBIT__ 64
#define __UHA_FBIT__ 8
#define __UHA_IBIT__ 8
#define __USA_FBIT__ 16
#define __USA_IBIT__ 16
#define __UDA_FBIT__ 32
#define __UDA_IBIT__ 32
#define __UTA_FBIT__ 64
#define __UTA_IBIT__ 64
#define __REGISTER_PREFIX__ 
#define __USER_LABEL_PREFIX__ 
#define __VERSION__ "4.4.0"
#define __GNUC_GNU_INLINE__ 1
#define __OPTIMIZE__ 1
#define __FINITE_MATH_ONLY__ 0
#define __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 1
#define __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 1
#define __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 1
#define __GCC_HAVE_DWARF2_CFI_ASM 1
#define __SIZEOF_INT__ 4
#define __SIZEOF_LONG__ 4
#define __SIZEOF_LONG_LONG__ 8
#define __SIZEOF_SHORT__ 2
#define __SIZEOF_FLOAT__ 4
#define __SIZEOF_DOUBLE__ 8
#define __SIZEOF_LONG_DOUBLE__ 8
#define __SIZEOF_SIZE_T__ 4
#define __SIZEOF_WCHAR_T__ 4
#define __SIZEOF_WINT_T__ 4
#define __SIZEOF_PTRDIFF_T__ 4
#define __SIZEOF_POINTER__ 4
#define __mips__ 1
#define _mips 1
#define mips 1
#define __R3000 1
#define __R3000__ 1
#define R3000 1
#define _R3000 1
#define __mips_fpr 32
#define _MIPS_ARCH_MIPS64R2 1
#define _MIPS_ARCH "mips64r2"
#define _MIPS_TUNE_MIPS64R2 1
#define _MIPS_TUNE "mips64r2"
#define __mips 64
#define __mips_isa_rev 2
#define _MIPS_ISA _MIPS_ISA_MIPS64
#define _ABIO32 1
#define _MIPS_SIM _ABIO32
#define _MIPS_SZINT 32
#define _MIPS_SZLONG 32
#define _MIPS_SZPTR 32
#define _MIPS_FPSET 16
#define __mips_hard_float 1
#define __MIPSEL 1
#define __MIPSEL__ 1
#define MIPSEL 1
#define _MIPSEL 1
#define __LANGUAGE_C 1
#define __LANGUAGE_C__ 1
#define LANGUAGE_C 1
#define _LANGUAGE_C 1
#define __GCC_HAVE_BUILTIN_MIPS_CACHE 1
#define __gnu_linux__ 1
#define __linux 1
#define __linux__ 1
#define linux 1
#define __unix 1
#define __unix__ 1
#define unix 1
#define __ELF__ 1
#define __BIGGEST_ALIGNMENT__ 8
# 1 "<command-line>"
#define GUEST 1
#define CPU_COUNT_PER_US 10
# 1 "include/common.h" 1

#define __COMMON_H__ 
# 1 "include/regdef.h" 1
/*	$OpenBSD: regdef.h,v 1.3 1999/01/27 04:46:06 imp Exp $	*/

/*
 * Copyright (c) 1992, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * Ralph Campbell. This file is derived from the MIPS RISC
 * Architecture book by Gerry Kane.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)regdef.h	8.1 (Berkeley) 6/10/93
 */

#define _MIPS_REGDEF_H_ 
# 116 "include/regdef.h"
#define FIFO 0x1F0
#define STACK 0x1E8
#define PARAM 0x1E0
#define PARAMI 0x1E0
#define PARAMO 0x1E0
#define SERIAL 0x1D8
#define FIFO1 0x1D0
#define RTC 0x1C8
#define HEX_ADDR 0x1C0
#define RET_ADDR 0x1B8
#define SPI_IOBASE 0x100
#define LS1DFLASH_IOBASE 0x108

#define DMEM 0x0
# 4 "include/common.h" 2
#define SERIAL_REG (0xffffffffff200000+SERIAL)
#define RTC_REG (0xffffffffff200000+RTC)
#define ARGC_REG (0xffffffffff200000+RET_ADDR)
#define HEX_REG (0xffffffffff200000+HEX_ADDR)

#define ___constant_swab16(x) ((unsigned short)( (((unsigned short)(x) & (unsigned short)0x00ffU) << 8) | (((unsigned short)(x) & (unsigned short)0xff00U) >> 8)))



#define ___constant_swab32(x) ((unsigned int)( (((unsigned int)(x) & (unsigned int)0x000000ffUL) << 24) | (((unsigned int)(x) & (unsigned int)0x0000ff00UL) << 8) | (((unsigned int)(x) & (unsigned int)0x00ff0000UL) >> 8) | (((unsigned int)(x) & (unsigned int)0xff000000UL) >> 24)))





#define ___constant_swab64(x) ((unsigned long long)( (((unsigned long long)(x) & (unsigned long long)0x00000000000000ffULL) << 56) | (((unsigned long long)(x) & (unsigned long long)0x000000000000ff00ULL) << 40) | (((unsigned long long)(x) & (unsigned long long)0x0000000000ff0000ULL) << 24) | (((unsigned long long)(x) & (unsigned long long)0x00000000ff000000ULL) << 8) | (((unsigned long long)(x) & (unsigned long long)0x000000ff00000000ULL) >> 8) | (((unsigned long long)(x) & (unsigned long long)0x0000ff0000000000ULL) >> 24) | (((unsigned long long)(x) & (unsigned long long)0x00ff000000000000ULL) >> 40) | (((unsigned long long)(x) & (unsigned long long)0xff00000000000000ULL) >> 56)))
# 30 "include/common.h"
# 1 "include/stdarg.h" 1

#define __STDARG_H__ 
typedef void * va_list;



#define va_start __builtin_va_start

#define va_arg __builtin_va_arg
#define va_end __builtin_va_end
# 31 "include/common.h" 2
# 1 "include/types.h" 1

#define __TYPE__H__ 
typedef unsigned long long u64;
typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned char u8;
typedef unsigned int uint;
typedef char __s8;
typedef short __s16;
typedef int __s32;
typedef long long __s64;
typedef char s8;
typedef short s16;
typedef int s32;
typedef long long s64;
typedef unsigned char __u8;
typedef unsigned short __u16;
typedef unsigned int __u32;
typedef unsigned long long __u64;
typedef char int8_t;
typedef short int16_t;
typedef int int32_t;
typedef long long int64_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;
typedef unsigned char u_int8_t;
typedef unsigned short u_int16_t;
typedef unsigned int u_int32_t;
typedef unsigned long long u_int64_t;
typedef unsigned char u_char;
typedef unsigned int u_int;
typedef unsigned long u_long;
typedef unsigned char __le8;
typedef unsigned short __le16;
typedef unsigned int __le32;
typedef unsigned long long __le64;
typedef unsigned int __be32;
typedef int bool;
enum {
false = 0,
true = 1,
};
typedef unsigned long dma_addr_t;
typedef int gfp_t;
typedef unsigned long uintptr_t;
typedef unsigned long phys_addr_t;
typedef unsigned char uchar;
typedef unsigned short ushort;
typedef unsigned long ulong;

#define __iomem 
#define __packed __attribute__((packed))


#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
#define BITS_PER_LONG _MIPS_SZLONG
#define BIT(nr) (1UL << (nr))
#define BIT_ULL(nr) (1ULL << (nr))
#define BIT_MASK(nr) (1UL << ((nr) % BITS_PER_LONG))
#define BIT_WORD(nr) ((nr) / BITS_PER_LONG)
#define BIT_ULL_MASK(nr) (1ULL << ((nr) % BITS_PER_LONG_LONG))
#define BIT_ULL_WORD(nr) ((nr) / BITS_PER_LONG_LONG)
#define BITS_PER_BYTE 8
#define BITS_TO_LONGS(nr) DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
#define DECLARE_BITMAP(name,bits) unsigned long name[BITS_TO_LONGS(bits)]

typedef unsigned long fdt_addr_t;
typedef long ssize_t;
typedef long long off_t;
typedef long long loff_t;
#define SSIZE_MAX LONG_MAX
typedef u_int32_t pcireg_t; /* configuration space register XXX */
typedef unsigned long device_t;
typedef unsigned int mode_t;
typedef unsigned int dev_t;
typedef long intptr_t;
typedef u_int32_t bus_addr_t;
typedef u_int32_t bus_size_t;
typedef u_int32_t bus_space_handle_t;
typedef unsigned long vaddr_t;
typedef char *caddr_t;
typedef unsigned long vm_offset_t;
typedef unsigned int paddr_t;
typedef unsigned int vm_size_t;
typedef unsigned long size_t;
typedef long long quad_t;
typedef unsigned long long u_quad_t; /* quads */
# 32 "include/common.h" 2
#define __P(x) x
#define SSIZE_MAX LONG_MAX

int printf (const char *fmt, ...);
int newprintf (const char *fmt, ...);
int printbase(long v,int w,int base,int sign);
int snprintbase(char *d, int n, long v,int w,int base,int sign);
int sprintbase(char *d, long v,int w,int base,int sign);
int tvsnprintf(char *buf, int n, const char *fmt, void **arg);
int tsnprintf(char *buf, int n, const char *fmt,...);
int tsprintf(char *buf, const char *fmt,...);
#define isdigit(c) (c>='0' && c<='9')

#define NULL ((void *)0)

#define __read_32bit_c0_register(source,sel) ({ int __res; if (sel == 0) __asm__ __volatile__( "mfc0\t%0, " #source "\n\t" : "=r" (__res)); else __asm__ __volatile__( ".set\tmips32\n\t" "mfc0\t%0, " #source ", " #sel "\n\t" ".set\tmips0\n\t" : "=r" (__res)); __res; })
# 63 "include/common.h"
#define __read_64bit_c0_split(source,sel) ({ unsigned long long val; unsigned long flags; local_irq_save(flags); if (sel == 0) __asm__ __volatile__( ".set\tmips64\n\t" "dmfc0\t%M0, " #source "\n\t" "dsll\t%L0, %M0, 32\n\t" "dsrl\t%M0, %M0, 32\n\t" "dsrl\t%L0, %L0, 32\n\t" ".set\tmips0" : "=r" (val)); else __asm__ __volatile__( ".set\tmips64\n\t" "dmfc0\t%M0, " #source ", " #sel "\n\t" "dsll\t%L0, %M0, 32\n\t" "dsrl\t%M0, %M0, 32\n\t" "dsrl\t%L0, %L0, 32\n\t" ".set\tmips0" : "=r" (val)); local_irq_restore(flags); val; })
# 92 "include/common.h"
#define __read_64bit_c0_register(source,sel) ({ unsigned long long __res; if (sizeof(unsigned long) == 4) __res = __read_64bit_c0_split(source, sel); else if (sel == 0) __asm__ __volatile__( ".set\tmips3\n\t" "dmfc0\t%0, " #source "\n\t" ".set\tmips0" : "=r" (__res)); else __asm__ __volatile__( ".set\tmips64\n\t" "dmfc0\t%0, " #source ", " #sel "\n\t" ".set\tmips0" : "=r" (__res)); __res; })
# 113 "include/common.h"
#define __write_32bit_c0_register(register,sel,value) do { if (sel == 0) __asm__ __volatile__( "mtc0\t%z0, " #register "\n\t" : : "Jr" ((unsigned int)(value))); else __asm__ __volatile__( ".set\tmips32\n\t" "mtc0\t%z0, " #register ", " #sel "\n\t" ".set\tmips0" : : "Jr" ((unsigned int)(value))); } while (0)
# 128 "include/common.h"
#define __write_64bit_c0_split(source,sel,val) do { unsigned long flags; local_irq_save(flags); if (sel == 0) __asm__ __volatile__( ".set\tmips64\n\t" "dsll\t%L0, %L0, 32\n\t" "dsrl\t%L0, %L0, 32\n\t" "dsll\t%M0, %M0, 32\n\t" "or\t%L0, %L0, %M0\n\t" "dmtc0\t%L0, " #source "\n\t" ".set\tmips0" : : "r" (val)); else __asm__ __volatile__( ".set\tmips64\n\t" "dsll\t%L0, %L0, 32\n\t" "dsrl\t%L0, %L0, 32\n\t" "dsll\t%M0, %M0, 32\n\t" "or\t%L0, %L0, %M0\n\t" "dmtc0\t%L0, " #source ", " #sel "\n\t" ".set\tmips0" : : "r" (val)); local_irq_restore(flags); } while (0)
# 156 "include/common.h"
#define __write_64bit_c0_register(register,sel,value) do { if (sizeof(unsigned long) == 4) __write_64bit_c0_split(register, sel, value); else if (sel == 0) __asm__ __volatile__( ".set\tmips3\n\t" "dmtc0\t%z0, " #register "\n\t" ".set\tmips0" : : "Jr" (value)); else __asm__ __volatile__( ".set\tmips64\n\t" "dmtc0\t%z0, " #register ", " #sel "\n\t" ".set\tmips0" : : "Jr" (value)); } while (0)
# 175 "include/common.h"
#define __read_ulong_c0_register(reg,sel) ((sizeof(unsigned long) == 4) ? (unsigned long) __read_32bit_c0_register(reg, sel) : (unsigned long) __read_64bit_c0_register(reg, sel))




#define __write_ulong_c0_register(reg,sel,val) do { if (sizeof(unsigned long) == 4) __write_32bit_c0_register(reg, sel, val); else __write_64bit_c0_register(reg, sel, val); } while (0)
# 190 "include/common.h"
#define read_c0_index() __read_32bit_c0_register($0, 0)
#define write_c0_index(val) __write_32bit_c0_register($0, 0, val)

#define read_c0_entrylo0() __read_ulong_c0_register($2, 0)
#define write_c0_entrylo0(val) __write_ulong_c0_register($2, 0, val)

#define read_c0_entrylo1() __read_ulong_c0_register($3, 0)
#define write_c0_entrylo1(val) __write_ulong_c0_register($3, 0, val)

#define read_c0_conf() __read_32bit_c0_register($3, 0)
#define write_c0_conf(val) __write_32bit_c0_register($3, 0, val)

#define read_c0_context() __read_ulong_c0_register($4, 0)
#define write_c0_context(val) __write_ulong_c0_register($4, 0, val)

#define read_c0_pagemask() __read_32bit_c0_register($5, 0)
#define write_c0_pagemask(val) __write_32bit_c0_register($5, 0, val)

#define read_c0_wired() __read_32bit_c0_register($6, 0)
#define write_c0_wired(val) __write_32bit_c0_register($6, 0, val)

#define read_c0_info() __read_32bit_c0_register($7, 0)

#define read_c0_cache() __read_32bit_c0_register($7, 0)
#define write_c0_cache(val) __write_32bit_c0_register($7, 0, val)

#define read_c0_badvaddr() __read_ulong_c0_register($8, 0)
#define write_c0_badvaddr(val) __write_ulong_c0_register($8, 0, val)

#define read_c0_count() __read_32bit_c0_register($9, 0)
#define write_c0_count(val) __write_32bit_c0_register($9, 0, val)

#define read_c0_count2() __read_32bit_c0_register($9, 6)
#define write_c0_count2(val) __write_32bit_c0_register($9, 6, val)

#define read_c0_count3() __read_32bit_c0_register($9, 7)
#define write_c0_count3(val) __write_32bit_c0_register($9, 7, val)

#define read_c0_entryhi() __read_ulong_c0_register($10, 0)
#define write_c0_entryhi(val) __write_ulong_c0_register($10, 0, val)

#define read_c0_compare() __read_32bit_c0_register($11, 0)
#define write_c0_compare(val) __write_32bit_c0_register($11, 0, val)

#define read_c0_compare2() __read_32bit_c0_register($11, 6)
#define write_c0_compare2(val) __write_32bit_c0_register($11, 6, val)

#define read_c0_compare3() __read_32bit_c0_register($11, 7)
#define write_c0_compare3(val) __write_32bit_c0_register($11, 7, val)

#define read_c0_status() __read_32bit_c0_register($12, 0)

#define write_c0_status(val) __write_32bit_c0_register($12, 0, val)


#define read_c0_cause() __read_32bit_c0_register($13, 0)
#define write_c0_cause(val) __write_32bit_c0_register($13, 0, val)

#define read_c0_epc() __read_ulong_c0_register($14, 0)
#define write_c0_epc(val) __write_ulong_c0_register($14, 0, val)

#define read_c0_prid() __read_32bit_c0_register($15, 0)

#define read_c0_config() __read_32bit_c0_register($16, 0)
#define read_c0_config1() __read_32bit_c0_register($16, 1)
#define read_c0_config2() __read_32bit_c0_register($16, 2)
#define read_c0_config3() __read_32bit_c0_register($16, 3)
#define read_c0_config4() __read_32bit_c0_register($16, 4)
#define read_c0_config5() __read_32bit_c0_register($16, 5)
#define read_c0_config6() __read_32bit_c0_register($16, 6)
#define read_c0_config7() __read_32bit_c0_register($16, 7)
#define write_c0_config(val) __write_32bit_c0_register($16, 0, val)
#define write_c0_config1(val) __write_32bit_c0_register($16, 1, val)
#define write_c0_config2(val) __write_32bit_c0_register($16, 2, val)
#define write_c0_config3(val) __write_32bit_c0_register($16, 3, val)
#define write_c0_config4(val) __write_32bit_c0_register($16, 4, val)
#define write_c0_config5(val) __write_32bit_c0_register($16, 5, val)
#define write_c0_config6(val) __write_32bit_c0_register($16, 6, val)
#define write_c0_config7(val) __write_32bit_c0_register($16, 7, val)

/*
 * The WatchLo register.  There may be upto 8 of them.
 */
#define read_c0_watchlo0() __read_ulong_c0_register($18, 0)
#define read_c0_watchlo1() __read_ulong_c0_register($18, 1)
#define read_c0_watchlo2() __read_ulong_c0_register($18, 2)
#define read_c0_watchlo3() __read_ulong_c0_register($18, 3)
#define read_c0_watchlo4() __read_ulong_c0_register($18, 4)
#define read_c0_watchlo5() __read_ulong_c0_register($18, 5)
#define read_c0_watchlo6() __read_ulong_c0_register($18, 6)
#define read_c0_watchlo7() __read_ulong_c0_register($18, 7)
#define write_c0_watchlo0(val) __write_ulong_c0_register($18, 0, val)
#define write_c0_watchlo1(val) __write_ulong_c0_register($18, 1, val)
#define write_c0_watchlo2(val) __write_ulong_c0_register($18, 2, val)
#define write_c0_watchlo3(val) __write_ulong_c0_register($18, 3, val)
#define write_c0_watchlo4(val) __write_ulong_c0_register($18, 4, val)
#define write_c0_watchlo5(val) __write_ulong_c0_register($18, 5, val)
#define write_c0_watchlo6(val) __write_ulong_c0_register($18, 6, val)
#define write_c0_watchlo7(val) __write_ulong_c0_register($18, 7, val)

/*
 * The WatchHi register.  There may be upto 8 of them.
 */
#define read_c0_watchhi0() __read_32bit_c0_register($19, 0)
#define read_c0_watchhi1() __read_32bit_c0_register($19, 1)
#define read_c0_watchhi2() __read_32bit_c0_register($19, 2)
#define read_c0_watchhi3() __read_32bit_c0_register($19, 3)
#define read_c0_watchhi4() __read_32bit_c0_register($19, 4)
#define read_c0_watchhi5() __read_32bit_c0_register($19, 5)
#define read_c0_watchhi6() __read_32bit_c0_register($19, 6)
#define read_c0_watchhi7() __read_32bit_c0_register($19, 7)

#define write_c0_watchhi0(val) __write_32bit_c0_register($19, 0, val)
#define write_c0_watchhi1(val) __write_32bit_c0_register($19, 1, val)
#define write_c0_watchhi2(val) __write_32bit_c0_register($19, 2, val)
#define write_c0_watchhi3(val) __write_32bit_c0_register($19, 3, val)
#define write_c0_watchhi4(val) __write_32bit_c0_register($19, 4, val)
#define write_c0_watchhi5(val) __write_32bit_c0_register($19, 5, val)
#define write_c0_watchhi6(val) __write_32bit_c0_register($19, 6, val)
#define write_c0_watchhi7(val) __write_32bit_c0_register($19, 7, val)


static inline void tlb_write_indexed(void)
{
 __asm__ __volatile__(
  ".set noreorder\n\t"
  "tlbwi\n\t"
  ".set reorder");
}
void * malloc(size_t nbytes);
void * malloc_align(size_t nbytes, int align);
void * zalloc_align(size_t nbytes, int align);
void free(void *ap);
void * memset(void * s,int c, size_t count);
#define __always_inline inline __attribute__((always_inline))
#define noinline __attribute__((noinline))
#define __deprecated __attribute__((deprecated))
#define __packed __attribute__((packed))
#define __weak __attribute__((weak))
#define __alias(symbol) __attribute__((alias(#symbol)))
#define __attribute_const__ __attribute__((__const__))
#define __maybe_unused __attribute__((unused))
#define __always_unused __attribute__((unused))
#define __aligned(x) __attribute__((aligned(x)))
#define ROUND(a,b) (((a) + (b) - 1) & ~((b) - 1))
# 1 "<command-line>" 2
# 1 "/loongson/ejtag-debug/bin/nand_ops_ls1a.c"

#define MYDBG 
//printf("%s:%x\n",__func__,__LINE__)

#define _WL(x,y) (*((volatile unsigned int*)(x)) = (y))
#define _RL(x,y) ((y) = *((volatile unsigned int*)(x)))

#define NAND_WL(x,y) _WL((x) + NAND_BASE,(y))
#define NAND_RL(x,y) _RL((x) + NAND_BASE,(y))
#define DMA_WL(x,y) _WL((x) + DMA_DESP,(y))
#define DMA_RL(x,y) _RL((x) + DMA_DESP,(y))



#define RAM_ADDR 0xa4100000
#define DMA_DESP 0xa4001000
#define NAND_TMP 0xa4800000

#define BLOCK_TO_PAGE(x) ((x)<<6)
#define PAGE_TO_BLOCK(x) ((x)>>6)

#define PAGE_TO_FLASH(x) ((x)<<11)
#define PAGE_TO_FLASH_H(x) ((x)>>21)

#define PAGE_TO_FLASH_S(x) ((x)<<12)
#define PAGE_TO_FLASH_H_S(x) ((x)>>20)

#define FLASH_TO_PAGE(x) ((x)>>11)
#define VT_TO_PHY(x) ((x) & 0x0fffffff)

#define PAGES_A_BLOCK 0x40






/*ls1a*/
#define _NAND_BASE 0x1fe78000
#define ORDER_REG_ADDR 0xbfd01160



#define NAND_BASE (_NAND_BASE|0xa0000000)
#define NAND_DEV (_NAND_BASE+0x40)
#define CMD 0x0
#define ADDRL 0x4
#define ADDRH 0x8
#define TIMING 0xc
#define IDL 0x10
#define IDH 0x14
#define PARAM 0x18
#define OPNUM 0x1c
#define CS_RDY_MAP 0x20
#define DMA_ACCESS_ADDR 0x40

#define ADDR_C ADDRL
#define ADDR_R ADDRH

#define DMA_ORDER 0x0
#define DMA_SADDR 0x4
#define DMA_DEV 0x8
#define DMA_LEN 0xc
#define DMA_SET_LEN 0x10
#define DMA_TIMES 0x14
#define DMA_CMD 0x18


#define STOP_DMA (_WL(ORDER_REG_ADDR,0x10))
#define START_DMA(x) do{ _WL(ORDER_REG_ADDR,(VT_TO_PHY(x)|0x8));}while(0)
#define ASK_DMA(x) (_WL(ORDER_REG_ADDR,(VT_TO_PHY(x)|0x4)))

#define en_count(tmp) do{asm volatile("mfc0 %0,$23;li $2,0x2000000;or $2,%0;mtc0 $2,$23;":"=r"(tmp)::"$2"); }while(0)
#define dis_count(tmp) do{asm volatile("mtc0 %0,$23;"::"r"(tmp)); }while(0)

//#define SET_GPIO0_OUT(x)    do{x=(x==0?0:1);x=(*((volatile unsigned int*)0xbfd010f0) & ~0x1)|x; _WL(0xbfd010f0,(x));}while(0)
//#define SET_GPIO1_IN(x)    ((*((volatile unsigned int*)0xbfd010e0) & 0x2)>>1)


int is_bad_block(u32 block);
int erase_block(u32 block);
int read_pages(u32 ram,u32 page,u32 pages,u8 flag);//flag:0==main 1==spare 2==main+spare
int write_pages(u32 ram,u32 page,u32 pages,u8 flag);//flag:0==main 1==spare 2==main+spare
int read_nand(u32 ram,u32 flash, u32 len,u8 flag);
int write_nand(u32 ram,u32 flash,u32 len,u8 flag);
int erase_nand(u32 flashaddr,u32 len);

int chipsize=0x08000000;

void nand_udelay(unsigned int us)
{
    int tmp=0;
    do{asm volatile("mfc0 %0,$23;li $2,0x2000000;or $2,%0;mtc0 $2,$23;":"=r"(tmp)::"$2"); }while(0);
    udelay(us);
    do{asm volatile("mtc0 %0,$23;"::"r"(tmp)); }while(0);
}

static void nand_send_cmd(u32 cmd,u32 page)//Send addr and cmd
{
    if((cmd & (0x1<<9)) && !(cmd &(0x1<<8))){
        (*((volatile unsigned int*)((0x4) + (0x1fe78000|0xa0000000))) = ((0x800)));
    }else{
        (*((volatile unsigned int*)((0x4) + (0x1fe78000|0xa0000000))) = ((0)));
    }
    //NAND_WL(ADDR_R,PAGE_TO_FLASH(page));
    (*((volatile unsigned int*)((0x8) + (0x1fe78000|0xa0000000))) = ((page)));
//   printf("page ==%x,cmd=0x%03x\n",page,cmd);

    //NAND_WL(CMD,cmd & (~0xff));
    (*((volatile unsigned int*)((0x0) + (0x1fe78000|0xa0000000))) = ((cmd & (~0xfe))));
    (*((volatile unsigned int*)((0x0) + (0x1fe78000|0xa0000000))) = ((cmd)));
}
# 144 "/loongson/ejtag-debug/bin/nand_ops_ls1a.c"
static u8 rdy_status(void)
{
    return ((*((u32*) ((0x1fe78000|0xa0000000)+0x0)) & (0x1<<16)) == 0 ? 0:1);
}
static u8 nand_op_ok(u32 len,u32 ram)
{
    u32 ask=0,dmalen=0,dmastatus=0;
  //  nand_udelay(1000);
    while(1){
    ((*((volatile unsigned int*)(0xbfd01160)) = ((((0xa4001000) & 0x0fffffff)|0x4))));
    ((ask) = *((volatile unsigned int*)(0xa4001000 +0x4)));
    ((dmalen) = *((volatile unsigned int*)(0xa4001000 +0xc)));
    ((dmastatus) = *((volatile unsigned int*)(0xa4001000 +0x18)));
//    printf("ask==0x%08x,damlen==0x%08x,dmastatus==0x%08x\n",ask,dmalen,dmastatus);
//    printf("ask should==0x%08x,len==0x%08x\n", (VT_TO_PHY(ram)+((len+3)/4)*4),len);
    if(ask == (((ram) & 0x0fffffff)+((len+3)/4)*4)){break;}else{return 0;}
//    return 0;
    nand_udelay(60);
    }
    while(!rdy_status())
        nand_udelay(20);
    return 0;
}
static void dma_config(u32 len,u32 ddr,u32 cmd)
{
//    MYDBG;
    (*((volatile unsigned int*)((0x0) + 0xa4001000)) = ((0)));
//    MYDBG;
    (*((volatile unsigned int*)((0x4) + 0xa4001000)) = ((((ddr) & 0x0fffffff))));
//    MYDBG;
    (*((volatile unsigned int*)((0x8) + 0xa4001000)) = (((0x1fe78000 +0x40))));
//    MYDBG;
    (*((volatile unsigned int*)((0xc) + 0xa4001000)) = (((len+3)/4)));
//    MYDBG;
    (*((volatile unsigned int*)((0x10) + 0xa4001000)) = ((0)));
//    MYDBG;
    (*((volatile unsigned int*)((0x14) + 0xa4001000)) = ((1)));
//    MYDBG;
    (*((volatile unsigned int*)((0x18) + 0xa4001000)) = ((cmd)));
//    MYDBG;
}
int is_bad_block(u32 block)
{
    u32 page=0;
    page = ((block)<<6);
    read_pages(0xa4100000,page,1,1);
    if(*((u16*) 0xa4100000)!= 0xffff){return 1;}
    return 0;
}
int erase_block(u32 block)
{
    u32 flash_l=0,flash_h=0;
    (*((volatile unsigned int*)((0xc) + (0x1fe78000|0xa0000000))) = ((0x412)));
    (*((volatile unsigned int*)((0x1c) + (0x1fe78000|0xa0000000))) = ((0x1)));
    //printf("block==0x%08x\n",block);
    nand_send_cmd(0x9,((block)<<6));
    //MYDBG
    nand_udelay(30);
    while(!rdy_status())
        nand_udelay(30);
}
int read_pages(u32 ram,u32 page,u32 pages,u8 flag)//flag:0==main 1==spare 2==main+spare
{
    u32 len=0,dma_cmd=0,nand_cmd=0;
    u32 ret = 0,tmp;
    switch(flag){
        case 0:
            len = pages * 0x800;
            nand_cmd = 0x103;
            break;
        case 1:
            len = pages * 0x40;
            nand_cmd = 0x203;
            break;
        case 2:
            len = pages * 0x840;
            nand_cmd = 0x303;
            break;
        default:
            len = 0;
            nand_cmd = 0;
            break;
    }
//    MYDBG;
    dma_config(len,ram,dma_cmd);
//    MYDBG;
    ((*((volatile unsigned int*)(0xbfd01160)) = (0x10)));
//    MYDBG;
    nand_udelay(5);
//    MYDBG;
    do{ (*((volatile unsigned int*)(0xbfd01160)) = ((((0xa4001000) & 0x0fffffff)|0x8)));}while(0);
    nand_udelay(10);
    (*((volatile unsigned int*)((0xc) + (0x1fe78000|0xa0000000))) = ((0x412)));
    (*((volatile unsigned int*)((0x1c) + (0x1fe78000|0xa0000000))) = ((len)));
    nand_send_cmd(nand_cmd,page);
    nand_udelay(20000);
    ;
    ret = nand_op_ok(len,ram);
    ;
   if(ret){
        printf("nandread 0x%08x page 0x%08x pages have some error\n",page,pages);
   }
   return ret;
}
# 290 "/loongson/ejtag-debug/bin/nand_ops_ls1a.c"
int write_pages(u32 ram,u32 page,u32 pages,u8 flag)
{
    u32 len=0,dma_cmd=0x1000,nand_cmd=0;
    u32 ret=0,step=1;
    int val=pages;

    switch(flag){
        case 0:
            len = step*0x800;
            nand_cmd = 0x105;
            break;
        case 1:
            len = step*0x40;
            nand_cmd = 0x205;
            break;
        case 2:
            len = step*0x840;
            nand_cmd = 0x305;
            break;
        default:
            len = 0;
            nand_cmd = 0;
            break;
    }

    for(;val>0;val-=step){
        //printf("len==0x%08x,pages==0x%08x\n",len,val);
        dma_config(len,ram,dma_cmd);
        ((*((volatile unsigned int*)(0xbfd01160)) = (0x10)));
        nand_udelay(10);
        do{ (*((volatile unsigned int*)(0xbfd01160)) = ((((0xa4001000) & 0x0fffffff)|0x8)));}while(0);
        (*((volatile unsigned int*)((0xc) + (0x1fe78000|0xa0000000))) = ((0x412)));
        (*((volatile unsigned int*)((0x1c) + (0x1fe78000|0xa0000000))) = ((len)));
        nand_send_cmd(nand_cmd,page);
        nand_udelay(20000);
        ret = nand_op_ok(len,ram);
        ram+=len;
        page+=step;
        ;
        if(ret){
            printf("nandwrite 0x%08x page 0x%08x pages have some error\n",page,pages);
        }
    }
    return ret;
}
int error_check(u32 ram,u32 flash,u32 len)
{
    if(((flash)>>11) >= 0xffffffff){
        printf("the FLASH addr is big,this program don't work on this FLASH addr...\n");
        return -1;
    }
    if(flash & 0x7ff){
        printf("the FLASH addr don't align/* Need 0x800B alignment*/\n");
        return -1;
    }
    if(ram & 0x1f){
        printf("the RAM addr 0x%08x don't align/* Need 32B alignment*/\n",ram);
        return -1;
    }
    if(len < 0 || len > chipsize)
    {
        printf("the LEN 0x%08x(%d) is a unvalid number\n",len,len);
        return -1;
    }
    return 0;
}

int read_nand_nocheck(u32 ram,u32 flash,u32 len,u8 flag)
{
    u32 page=0;
    u32 ret = 0;
    u32 pages = 0, chunkpage=0;
    page = ((flash)>>11);//start page 
    switch(flag){
        case 0:
            chunkpage = 0x800;
            break;
        case 1:
            chunkpage = 0x40;
            break;
        case 2:
            chunkpage = 0x840;
            break;
        default:
            chunkpage = 0;
            break;
    }
    printf("\nreading ");
    pages = (len + chunkpage - 1)/chunkpage;
        ret = read_pages(ram,page,pages,flag);
        printf(". done\n");
return ret;
}

int write_nand_nocheck(u32 ram,u32 flash,u32 len,u8 flag)
{
    u32 page=0;
    u32 ret = 0;
    u32 pages = 0, chunkpage=0;
    ret = error_check(ram,flash,len);
    if(ret)
        return ret;
    page = ((flash)>>11);//start page 
    switch(flag){
        case 0:
            chunkpage = 0x800;
            break;
        case 1:
            chunkpage = 0x40;
            break;
        case 2:
            chunkpage = 0x840;
            break;
        default:
            chunkpage = 0;
            break;
    }
    printf("\nwriting. ");
    pages = (len + chunkpage - 1)/chunkpage;
        ret = write_pages(ram ,page, pages, flag);
        printf(". done\n");
    return ret;
}

int read_nand(u32 ram,u32 flash,u32 len,u8 flag)
{
    u32 page=0;
    u32 ret = 0;
    u32 b_pages = 0,a_pages=0;
    u32 pages = 0,block=0,chunkblock=0,chunkpage=0;
    ret = error_check(ram,flash,len);
    if(ret)
        return ret;
    page = ((flash)>>11);//start page 
//        printf("%x:page==0x%08x\n",__LINE__,page);
    while(is_bad_block(((page)>>6)))
    {
//        MYDBG;
        page+=0x40;
        page = (((((page)>>6))<<6));
        printf("the FLASH addr 0x%08x is a bad block,auto change FLASH addr 0x%08x\n",flash,((page)<<11));
    }
    switch(flag){
        case 0:
            chunkblock = 0x20000;
            chunkpage = 0x800;
            break;
        case 1:
            chunkblock = 0x1000;
            chunkpage = 0x40;
            break;
        case 2:
            chunkblock = 0x21000;
            chunkpage = 0x840;
            break;
        default:
            chunkblock = 0;
            chunkpage = 0;
            break;
    }
    printf("\nreading ");
    pages = (len + chunkpage - 1)/chunkpage;
    //printf("%x:pages==0x%08x\n",__LINE__,pages);
    b_pages = page % 0x40;
    b_pages = (0x40 - b_pages);
    if(pages > b_pages && b_pages > 0){
        ret = read_pages(ram,page,b_pages,flag);
        pages -= b_pages;
        page += b_pages;
        ram += (chunkpage * b_pages);
    }else if(pages <= b_pages && b_pages > 0){
    //printf("%x:pages==================0x%08x\n",__LINE__,pages);
        ret = read_pages(ram,page,pages,flag);
        pages = 0;
    }
    if(ret){return ret;}
    if(pages){
        block = pages / 0x40;
        a_pages = pages % 0x40;
    }
    for(;block > 0;block--){
        while(is_bad_block(((page)>>6))){
            printf("the FLASH addr 0x%08x is bad block,try next block...\n",((page)<<11));
            page += 0x40;
        }
        ret = read_pages(ram,page,0x40,flag);
        printf(". ");
        if(ret) {return ret;}
        pages -= 0x40;
        page += 0x40 ;
        ram += chunkblock;
    }
    if(a_pages){
        while(is_bad_block(((page)>>6))){
            printf("the FLASH addr 0x%08x is bad block,try next block...\n",((page)<<11));
            page += 0x40;
        }
        ret = read_pages(ram,page,a_pages,flag);
        if(ret){return ret;}
    }
        printf(". done\n");
    return ret;
}
int write_nand(u32 ram,u32 flash,u32 len,u8 flag)
{
    u32 page=0,start_page=0;
    u32 ret = 0;
    u32 b_pages = 0,a_pages=0;
    u32 pages = 0,block=0,chunkblock=0,chunkpage=0;
    ret = error_check(ram,flash,len);
    if(ret)
        return ret;
    page = ((flash)>>11);//start page 
    while(is_bad_block(((page)>>6)))
    {
        page+=0x40;

        page = (((((page)>>6))<<6));
        printf("the FLASH addr 0x%08x is a bad block,auto change FLASH addr 0x%08x\n",flash,((page)<<11));
    }
    switch(flag){
        case 0:
            chunkblock = 0x20000;
            chunkpage = 0x800;
            break;
        case 1:
            chunkblock = 0x1000;
            chunkpage = 0x40;
            break;
        case 2:
            chunkblock = 0x21000;
            chunkpage = 0x840;
            break;
        default:
            chunkblock = 0;
            chunkpage = 0;
            break;
    }
    printf("\nwriting. ");
    pages = (len + chunkpage - 1)/chunkpage;
//    printf("%x:pages==0x%08x\n",__LINE__,pages);
    start_page = page % 0x40;
    if(start_page){
        b_pages = (0x40 - start_page);
    }
    if(b_pages > 0){
        ret = read_pages(0xa4800000,page - start_page,start_page,2);
        if(ret){return ret;}
        erase_block(((page)>>6));
        ret = write_pages(0xa4800000,page - start_page,start_page,2);
        printf(". ");
        if(ret){return ret;}
    }
    if(pages > b_pages && b_pages > 0){
        ret = write_pages(ram,page,b_pages,flag);
        pages -= b_pages;
        page += b_pages;
        ram += (chunkpage * b_pages);
    }else if(pages <= b_pages && b_pages > 0){
        ret = write_pages(ram,page,pages,flag);
        pages = 0;
    }
    if(ret){return ret;}
    if(pages){
        block = pages / 0x40;
        a_pages = pages % 0x40;
    }
    //printf("block==0x%08x,a_pages==0x%08x\n",block,a_pages);
        //MYDBG;
    for(;block > 0;block--){
        //MYDBG;
        erase_block(((page)>>6));
        while(is_bad_block(((page)>>6))){
            printf("the FLASH addr 0x%08x is bad block,try next block...\n",((page)<<11));
            page += 0x40;
            erase_block(((page)>>6));
        }
        //MYDBG;
        ret = write_pages(ram,page,0x40,flag);
        //MYDBG;
        printf(". ");
        if(ret) {return ret;}
        pages -= 0x40;
        page += 0x40 ;
        ram += chunkblock;
    }
        //MYDBG;
    if(a_pages){
        erase_block(((page)>>6));
        while(is_bad_block(((page)>>6))){
            printf("the FLASH addr 0x%08x is bad block,try next block...\n",((page)<<11));
            page += 0x40;
            erase_block(((page)>>6));
        }
        ret = write_pages(ram,page,a_pages,flag);
        if(ret){return ret;}
    }
        printf(". done\n");
    return ret;
}

int erase_nand(u32 flashaddr,u32 len)
{
    int i=0;
    u32 start, blocks;
    start = flashaddr>>17;
    blocks = (len + (1<<17)-1)>>17;
    printf("\nerasing ");
    for(;i<blocks;i++){
        erase_block(i+start);
        printf(". ");
    }
        printf(" done\n");
    //MYDBG
    return 0;
}

int identify_nand()
{
    unsigned int id_val_l=0,id_val_h=0;

#define _NAND_IDL ( *((volatile unsigned int*)(NAND_BASE+IDL)))
#define _NAND_IDH (*((volatile unsigned int*)(NAND_BASE+IDH)))
    (*((volatile unsigned int*)((0x0) + (0x1fe78000|0xa0000000))) = ((0x21)));

    do id_val_h = (*((volatile unsigned int*)((0x1fe78000|0xa0000000)+0x14)));
    while(!((id_val_l |= ( *((volatile unsigned int*)((0x1fe78000|0xa0000000)+0x10)))) & 0xff));
    printf("id is %02x_%08x\n", id_val_h&0xff, id_val_l);

    return 0;
}

int mymain(char *cmd,...)
{
 void **arg;
 void *ap;
 int i;
 __builtin_va_start(ap,cmd);
 arg=ap;
 printf("cmd=%s\n",cmd);
 for(i=0;cmd[i];i++)
 {
  switch(cmd[i]){
   case 'i':
    identify_nand();
    break;
   case 'e':
    erase_nand(*arg++,*arg++);
    printf("erase nand ops OK...\n");
    break;
   case 'R':
    read_nand_nocheck(*arg++,*arg++,*arg++,*arg++);
    printf("read nand ops OK...\n");
    break;
   case 'r':
    read_nand(*arg++,*arg++,*arg++,*arg++);
    printf("read nand ops OK...\n");
    break;
   case 'W':
    write_nand_nocheck(*arg++,*arg++,*arg++,*arg++);
    printf("write nand ops OK...\n");
    break;
   case 'w':
    write_nand(*arg++,*arg++,*arg++,*arg++);
    printf("write nand ops OK...\n");
    break;
   case 'I':
    (*((volatile unsigned int*)((0x20) + (0x1fe78000|0xa0000000))) = ((0x88442200)));
    (*((volatile unsigned int*)((0x18) + (0x1fe78000|0xa0000000))) = ((0x400)));
    /*mux ctrl0*/
    *(volatile int *)0xbfd00420 = (*(volatile int *)0xbfd00420 & 0x01ffcfff) | 0xea000000;
    *(volatile int *)0xbfd010c4 &= ~(3<<2);
    *(volatile int *)0xbfd010c8 &= ~((0xff<<(68-64))|(3<<(84-64)));;
    break;
   default:
    printf("\ninput invalid OPS(erase_nand;read_nand;write_nand)...\n\n");
    printf("\n\t\t*****Nand Flash OPS*****\n\n");
    {
     printf("Uargs:callbin ./bin/nand_ops.bin e <flashaddr> <len>\n");
     printf("Uargs:callbin ./bin/nand_ops.bin <OPS> <ramaddr> <flashaddr> <len> <flag>\n");
     printf("Uargs:flag: 0=main; 1=spare; 2=spare+main\n\n");
     printf("Uargs:OPS:  w=write nand; r=read nand; e=erase nand; I init nand; i readid;R read nand nocheck;W write nand nocheck\n\n");
    }
    break;
  }
 }

 return 0;
}
