# 1 "/loongson/ejtag-debug/bin/libm/k_sin.c"
# 1 "/loongson/ejtag-debug/bin/libm//"
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
#define _IEEE_LIBM 1
#define _ISOC99_SOURCE 1
#define _SVID_SOURCE 1
# 1 "/loongson/ejtag-debug/bin/include/common.h" 1

#define __COMMON_H__ 
# 1 "/loongson/ejtag-debug/bin/include/regdef.h" 1
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
# 116 "/loongson/ejtag-debug/bin/include/regdef.h"
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
# 4 "/loongson/ejtag-debug/bin/include/common.h" 2
#define SERIAL_REG (0xffffffffff200000+SERIAL)
#define RTC_REG (0xffffffffff200000+RTC)
#define ARGC_REG (0xffffffffff200000+RET_ADDR)
#define HEX_REG (0xffffffffff200000+HEX_ADDR)

#define ___constant_swab16(x) ((unsigned short)( (((unsigned short)(x) & (unsigned short)0x00ffU) << 8) | (((unsigned short)(x) & (unsigned short)0xff00U) >> 8)))



#define ___constant_swab32(x) ((unsigned int)( (((unsigned int)(x) & (unsigned int)0x000000ffUL) << 24) | (((unsigned int)(x) & (unsigned int)0x0000ff00UL) << 8) | (((unsigned int)(x) & (unsigned int)0x00ff0000UL) >> 8) | (((unsigned int)(x) & (unsigned int)0xff000000UL) >> 24)))





#define ___constant_swab64(x) ((unsigned long long)( (((unsigned long long)(x) & (unsigned long long)0x00000000000000ffULL) << 56) | (((unsigned long long)(x) & (unsigned long long)0x000000000000ff00ULL) << 40) | (((unsigned long long)(x) & (unsigned long long)0x0000000000ff0000ULL) << 24) | (((unsigned long long)(x) & (unsigned long long)0x00000000ff000000ULL) << 8) | (((unsigned long long)(x) & (unsigned long long)0x000000ff00000000ULL) >> 8) | (((unsigned long long)(x) & (unsigned long long)0x0000ff0000000000ULL) >> 24) | (((unsigned long long)(x) & (unsigned long long)0x00ff000000000000ULL) >> 40) | (((unsigned long long)(x) & (unsigned long long)0xff00000000000000ULL) >> 56)))
# 30 "/loongson/ejtag-debug/bin/include/common.h"
# 1 "/loongson/ejtag-debug/bin/include/stdarg.h" 1

#define __STDARG_H__ 
typedef void * va_list;



#define va_start __builtin_va_start

#define va_arg __builtin_va_arg
#define va_end __builtin_va_end
# 31 "/loongson/ejtag-debug/bin/include/common.h" 2
# 1 "/loongson/ejtag-debug/bin/include/types.h" 1

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
# 32 "/loongson/ejtag-debug/bin/include/common.h" 2
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
# 63 "/loongson/ejtag-debug/bin/include/common.h"
#define __read_64bit_c0_split(source,sel) ({ unsigned long long val; unsigned long flags; local_irq_save(flags); if (sel == 0) __asm__ __volatile__( ".set\tmips64\n\t" "dmfc0\t%M0, " #source "\n\t" "dsll\t%L0, %M0, 32\n\t" "dsrl\t%M0, %M0, 32\n\t" "dsrl\t%L0, %L0, 32\n\t" ".set\tmips0" : "=r" (val)); else __asm__ __volatile__( ".set\tmips64\n\t" "dmfc0\t%M0, " #source ", " #sel "\n\t" "dsll\t%L0, %M0, 32\n\t" "dsrl\t%M0, %M0, 32\n\t" "dsrl\t%L0, %L0, 32\n\t" ".set\tmips0" : "=r" (val)); local_irq_restore(flags); val; })
# 92 "/loongson/ejtag-debug/bin/include/common.h"
#define __read_64bit_c0_register(source,sel) ({ unsigned long long __res; if (sizeof(unsigned long) == 4) __res = __read_64bit_c0_split(source, sel); else if (sel == 0) __asm__ __volatile__( ".set\tmips3\n\t" "dmfc0\t%0, " #source "\n\t" ".set\tmips0" : "=r" (__res)); else __asm__ __volatile__( ".set\tmips64\n\t" "dmfc0\t%0, " #source ", " #sel "\n\t" ".set\tmips0" : "=r" (__res)); __res; })
# 113 "/loongson/ejtag-debug/bin/include/common.h"
#define __write_32bit_c0_register(register,sel,value) do { if (sel == 0) __asm__ __volatile__( "mtc0\t%z0, " #register "\n\t" : : "Jr" ((unsigned int)(value))); else __asm__ __volatile__( ".set\tmips32\n\t" "mtc0\t%z0, " #register ", " #sel "\n\t" ".set\tmips0" : : "Jr" ((unsigned int)(value))); } while (0)
# 128 "/loongson/ejtag-debug/bin/include/common.h"
#define __write_64bit_c0_split(source,sel,val) do { unsigned long flags; local_irq_save(flags); if (sel == 0) __asm__ __volatile__( ".set\tmips64\n\t" "dsll\t%L0, %L0, 32\n\t" "dsrl\t%L0, %L0, 32\n\t" "dsll\t%M0, %M0, 32\n\t" "or\t%L0, %L0, %M0\n\t" "dmtc0\t%L0, " #source "\n\t" ".set\tmips0" : : "r" (val)); else __asm__ __volatile__( ".set\tmips64\n\t" "dsll\t%L0, %L0, 32\n\t" "dsrl\t%L0, %L0, 32\n\t" "dsll\t%M0, %M0, 32\n\t" "or\t%L0, %L0, %M0\n\t" "dmtc0\t%L0, " #source ", " #sel "\n\t" ".set\tmips0" : : "r" (val)); local_irq_restore(flags); } while (0)
# 156 "/loongson/ejtag-debug/bin/include/common.h"
#define __write_64bit_c0_register(register,sel,value) do { if (sizeof(unsigned long) == 4) __write_64bit_c0_split(register, sel, value); else if (sel == 0) __asm__ __volatile__( ".set\tmips3\n\t" "dmtc0\t%z0, " #register "\n\t" ".set\tmips0" : : "Jr" (value)); else __asm__ __volatile__( ".set\tmips64\n\t" "dmtc0\t%z0, " #register ", " #sel "\n\t" ".set\tmips0" : : "Jr" (value)); } while (0)
# 175 "/loongson/ejtag-debug/bin/include/common.h"
#define __read_ulong_c0_register(reg,sel) ((sizeof(unsigned long) == 4) ? (unsigned long) __read_32bit_c0_register(reg, sel) : (unsigned long) __read_64bit_c0_register(reg, sel))




#define __write_ulong_c0_register(reg,sel,val) do { if (sizeof(unsigned long) == 4) __write_32bit_c0_register(reg, sel, val); else __write_64bit_c0_register(reg, sel, val); } while (0)
# 190 "/loongson/ejtag-debug/bin/include/common.h"
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
# 1 "/loongson/ejtag-debug/bin/libm/k_sin.c"
/* @(#)k_sin.c 5.1 93/09/24 */
/*
 * ====================================================
 * Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
 *
 * Developed at SunPro, a Sun Microsystems, Inc. business.
 * Permission to use, copy, modify, and distribute this
 * software is freely granted, provided that this notice 
 * is preserved.
 * ====================================================
 */





/* __kernel_sin( x, y, iy)
 * kernel sin function on [-pi/4, pi/4], pi/4 ~ 0.7854
 * Input x is assumed to be bounded by ~pi/4 in magnitude.
 * Input y is the tail of x.
 * Input iy indicates whether y is 0. (if iy=0, y assume to be 0). 
 *
 * Algorithm
 *	1. Since sin(-x) = -sin(x), we need only to consider positive x. 
 *	2. if x < 2^-27 (hx<0x3e400000 0), return x with inexact if x!=0.
 *	3. sin(x) is approximated by a polynomial of degree 13 on
 *	   [0,pi/4]
 *		  	         3            13
 *	   	sin(x) ~ x + S1*x + ... + S6*x
 *	   where
 *	
 * 	|sin(x)         2     4     6     8     10     12  |     -58
 * 	|----- - (1+S1*x +S2*x +S3*x +S4*x +S5*x  +S6*x   )| <= 2
 * 	|  x 					           | 
 * 
 *	4. sin(x+y) = sin(x) + sin'(x')*y
 *		    ~ sin(x) + (1-x*x/2)*y
 *	   For better accuracy, let 
 *		     3      2      2      2      2
 *		r = x *(S2+x *(S3+x *(S4+x *(S5+x *S6))))
 *	   then                   3    2
 *		sin(x) = x + (S1*x + (x *(r-y/2)+y))
 */

# 1 "/loongson/ejtag-debug/bin/include/math.h" 1
/* $Id: math.h,v 1.1.1.1 2006/09/14 01:59:06 root Exp $ */

#define _MATH_ 
# 17 "/loongson/ejtag-debug/bin/include/math.h"
double acos(double x);
double acosh(double x);
double asin(double x);
double atan(double x);
double atan2(double y, double x);
double atanh(double x);
double ceil(double x);
double cos(double x);
double cosh(double x);
double exp(double x);
double fabs(double x);
double floor(double x);
double fmod(double x, double y);
double frexp(double x, int *i);
double ldexp(double x, int i);
double log(double x);
double log10(double x);
double modf(double x, double *i);
double pow(double x,double y);
double sin(double x);
double sinh(double x);
double sqrt(double x);
double tan(double x);
double tanh(double x);




float acosf(float x);
float asinf(float x);
float atan2f(float y, float x);
float atanf(float x);
float ceilf(float x);
float cosf(float x);
float coshf(float x);
float expf(float x);
float fabsf(float x);
float floorf(float x);
float fmodf(float x, float y);
float frexpf(float x, int *i);
float ldexpf(float x, int i);
float log10f(float x);
float logf(float x);
float modff(float x, float *i);
float powf(float x);
float sinf(float x);
float sinhf(float x);
float sqrtf(float x);
float tanf(float x);
float tanhf(float x);

static inline void tgt_fpuenable()
{
//#if __mips < 3 || __mips == 32

asm("mfc0 $2,$12;\n" "li   $3,0x34000000 #ST0_CU1;\n" "or   $2,$3;\n"



"li   $3,0x04000000 #ST0_CU1;\n"
"xor   $2,$3;\n"
"mtc0 $2,$12;\n"
"li $2,0x00000000 #FPU_DEFAULT;\n"
"ctc1 $2,$31;\n"
"li $2,-1;\n"
"mtc1	$2, $f0\n;"
"mov.d	$f2, $f0\n;"
"mov.d	$f4, $f0\n;"
"mov.d	$f6, $f0\n;"
"mov.d	$f8, $f0\n;"
"mov.d	$f10, $f0\n;"
"mov.d	$f12, $f0\n;"
"mov.d	$f14, $f0\n;"
"mov.d	$f16, $f0\n;"
"mov.d	$f18, $f0\n;"
"mov.d	$f20, $f0\n;"
"mov.d	$f22, $f0\n;"
"mov.d	$f24, $f0\n;"
"mov.d	$f26, $f0\n;"
"mov.d	$f28, $f0\n;"
"mov.d	$f30, $f0\n;"
:::"$2","$3"
 );
# 144 "/loongson/ejtag-debug/bin/include/math.h"
}
# 46 "/loongson/ejtag-debug/bin/libm/k_sin.c" 2
# 1 "/loongson/ejtag-debug/bin/libm/math_private.h" 1
/*
 * ====================================================
 * Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
 *
 * Developed at SunPro, a Sun Microsystems, Inc. business.
 * Permission to use, copy, modify, and distribute this
 * software is freely granted, provided that this notice 
 * is preserved.
 * ====================================================
 */

/*
 * from: @(#)fdlibm.h 5.1 93/09/24
 * $Id: math_private.h,v 1.1 2001/11/24 03:07:40 ds Exp $
 */


#define _MATH_PRIVATE_H_ 

typedef enum
{
  _IEEE_ = -1, /* According to IEEE 754/IEEE 854.  */
  _SVID_, /* According to System V, release 4.  */
  _XOPEN_, /* Nowadays also Unix98.  */
  _POSIX_,
  _ISOC_ /* Actually this is ISO C99.  */
} _LIB_VERSION_TYPE;

/* This variable can be changed at run-time to any of the values above to
   affect floating point error handling behavior (it may also be necessary
   to change the hardware FPU exception settings).  */
extern _LIB_VERSION_TYPE _LIB_VERSION;






#define LITTLE_ENDIAN 1234
#define BIG_ENDIAN 4321
#define PDP_ENDIAN 3412
#define BYTE_ORDER LITTLE_ENDIAN
#define __BYTE_ORDER BYTE_ORDER
#define __BIG_ENDIAN BIG_ENDIAN
#define __LITTLE_ENDIAN LITTLE_ENDIAN

/* The original fdlibm code used statements like:
	n0 = ((*(int*)&one)>>29)^1;		* index of high word *
	ix0 = *(n0+(int*)&x);			* high word of x *
	ix1 = *((1-n0)+(int*)&x);		* low word of x *
   to dig two 32 bit words out of the 64 bit IEEE floating point
   value.  That is non-ANSI, and, moreover, the gcc instruction
   scheduler gets it wrong.  We instead use the following macros.
   Unlike the original code, we determine the endianness at compile
   time, not at run time; I don't see much benefit to selecting
   endianness at run time.  */

/* A union which permits us to convert between a double and two 32 bit
   ints.  */

/*
 * Math on arm is little endian except for the FP word order which is
 * big endian.
 */
# 82 "/loongson/ejtag-debug/bin/libm/math_private.h"
typedef union
{
  double value;
  struct
  {
    u_int32_t lsw;
    u_int32_t msw;
  } parts;
} ieee_double_shape_type;



/* Get two 32 bit ints from a double.  */

#define EXTRACT_WORDS(ix0,ix1,d) do { ieee_double_shape_type ew_u; ew_u.value = (d); (ix0) = ew_u.parts.msw; (ix1) = ew_u.parts.lsw; } while (0)







/* Get the more significant 32 bit int from a double.  */

#define GET_HIGH_WORD(i,d) do { ieee_double_shape_type gh_u; gh_u.value = (d); (i) = gh_u.parts.msw; } while (0)






/* Get the less significant 32 bit int from a double.  */

#define GET_LOW_WORD(i,d) do { ieee_double_shape_type gl_u; gl_u.value = (d); (i) = gl_u.parts.lsw; } while (0)






/* Set a double from two 32 bit ints.  */

#define INSERT_WORDS(d,ix0,ix1) do { ieee_double_shape_type iw_u; iw_u.parts.msw = (ix0); iw_u.parts.lsw = (ix1); (d) = iw_u.value; } while (0)







/* Set the more significant 32 bits of a double from an int.  */

#define SET_HIGH_WORD(d,v) do { ieee_double_shape_type sh_u; sh_u.value = (d); sh_u.parts.msw = (v); (d) = sh_u.value; } while (0)







/* Set the less significant 32 bits of a double from an int.  */

#define SET_LOW_WORD(d,v) do { ieee_double_shape_type sl_u; sl_u.value = (d); sl_u.parts.lsw = (v); (d) = sl_u.value; } while (0)







/* A union which permits us to convert between a float and a 32 bit
   int.  */

typedef union
{
  float value;
  u_int32_t word;
} ieee_float_shape_type;

/* Get a 32 bit int from a float.  */

#define GET_FLOAT_WORD(i,d) do { ieee_float_shape_type gf_u; gf_u.value = (d); (i) = gf_u.word; } while (0)






/* Set a float from a 32 bit int.  */

#define SET_FLOAT_WORD(d,i) do { ieee_float_shape_type sf_u; sf_u.word = (i); (d) = sf_u.value; } while (0)






/* ieee style elementary functions */
extern double __ieee754_sqrt (double);
extern double __ieee754_acos (double);
extern double __ieee754_acosh (double);
extern double __ieee754_log (double);
extern double __ieee754_atanh (double);
extern double __ieee754_asin (double);
extern double __ieee754_atan2 (double,double);
extern double __ieee754_exp (double);
extern double __ieee754_cosh (double);
extern double __ieee754_fmod (double,double);
extern double __ieee754_pow (double,double);
extern double __ieee754_lgamma_r (double,int *);
extern double __ieee754_gamma_r (double,int *);
extern double __ieee754_lgamma (double);
extern double __ieee754_gamma (double);
extern double __ieee754_log10 (double);
extern double __ieee754_sinh (double);
extern double __ieee754_hypot (double,double);
extern double __ieee754_j0 (double);
extern double __ieee754_j1 (double);
extern double __ieee754_y0 (double);
extern double __ieee754_y1 (double);
extern double __ieee754_jn (int,double);
extern double __ieee754_yn (int,double);
extern double __ieee754_remainder (double,double);
extern int __ieee754_rem_pio2 (double,double*);



extern double __ieee754_scalb (double,double);


/* fdlibm kernel function */
extern double __kernel_standard (double,double,int);
extern double __kernel_sin (double,double,int);
extern double __kernel_cos (double,double);
extern double __kernel_tan (double,double,int);
extern int __kernel_rem_pio2 (double*,double*,int,int,int,const int*);


/* ieee style elementary float functions */
extern float __ieee754_sqrtf (float);
extern float __ieee754_acosf (float);
extern float __ieee754_acoshf (float);
extern float __ieee754_logf (float);
extern float __ieee754_atanhf (float);
extern float __ieee754_asinf (float);
extern float __ieee754_atan2f (float,float);
extern float __ieee754_expf (float);
extern float __ieee754_coshf (float);
extern float __ieee754_fmodf (float,float);
extern float __ieee754_powf (float,float);
extern float __ieee754_lgammaf_r (float,int *);
extern float __ieee754_gammaf_r (float,int *);
extern float __ieee754_lgammaf (float);
extern float __ieee754_gammaf (float);
extern float __ieee754_log10f (float);
extern float __ieee754_sinhf (float);
extern float __ieee754_hypotf (float,float);
extern float __ieee754_j0f (float);
extern float __ieee754_j1f (float);
extern float __ieee754_y0f (float);
extern float __ieee754_y1f (float);
extern float __ieee754_jnf (int,float);
extern float __ieee754_ynf (int,float);
extern float __ieee754_remainderf (float,float);
extern int __ieee754_rem_pio2f (float,float*);
extern float __ieee754_scalbf (float,float);

/* float versions of fdlibm kernel functions */
extern float __kernel_sinf (float,float,int);
extern float __kernel_cosf (float,float);
extern float __kernel_tanf (float,float,int);
extern int __kernel_rem_pio2f (float*,float*,int,int,int,const int*);
# 47 "/loongson/ejtag-debug/bin/libm/k_sin.c" 2


static const double



half = 5.00000000000000000000e-01, /* 0x3FE00000, 0x00000000 */
S1 = -1.66666666666666324348e-01, /* 0xBFC55555, 0x55555549 */
S2 = 8.33333333332248946124e-03, /* 0x3F811111, 0x1110F8A6 */
S3 = -1.98412698298579493134e-04, /* 0xBF2A01A0, 0x19C161D5 */
S4 = 2.75573137070700676789e-06, /* 0x3EC71DE3, 0x57B1FE7D */
S5 = -2.50507602534068634195e-08, /* 0xBE5AE5E6, 0x8A2B9CEB */
S6 = 1.58969099521155010221e-10; /* 0x3DE5D93A, 0x5ACFD57C */


 double __kernel_sin(double x, double y, int iy)




{
 double z,r,v;
 int32_t ix;
 do { ieee_double_shape_type gh_u; gh_u.value = (x); (ix) = gh_u.parts.msw; } while (0);
 ix &= 0x7fffffff; /* high word of x */
 if(ix<0x3e400000) /* |x| < 2**-27 */
    {if((int)x==0) return x;} /* generate inexact */
 z = x*x;
 v = z*x;
 r = S2+z*(S3+z*(S4+z*(S5+z*S6)));
 if(iy==0) return x+v*(S1+z*r);
 else return x-((z*(half*y-v*r)-y)-v*S1);
}
