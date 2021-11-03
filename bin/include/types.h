#ifndef __TYPE__H__
#define __TYPE__H__
typedef unsigned long long u64;
typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned char u8;
typedef unsigned int uint;
typedef  char __s8;
typedef  short __s16;
typedef  int __s32;
typedef  long long __s64;
typedef  char s8;
typedef  short s16;
typedef  int s32;
typedef  long long s64;
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
typedef unsigned long		dma_addr_t;
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
#define BIT(nr)			(1UL << (nr))
#define BIT_ULL(nr)		(1ULL << (nr))
#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
#define BIT_ULL_MASK(nr)	(1ULL << ((nr) % BITS_PER_LONG_LONG))
#define BIT_ULL_WORD(nr)	((nr) / BITS_PER_LONG_LONG)
#define BITS_PER_BYTE		8
#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
#define DECLARE_BITMAP(name, bits) \
	unsigned long name[BITS_TO_LONGS(bits)]
typedef unsigned long fdt_addr_t;
typedef long ssize_t;
typedef long long off_t;
typedef long long loff_t;
#define SSIZE_MAX LONG_MAX
typedef u_int32_t pcireg_t;		/* configuration space register XXX */
typedef unsigned long device_t;
typedef unsigned int mode_t;
typedef unsigned int dev_t;
typedef long intptr_t;
typedef u_int32_t bus_addr_t;
typedef u_int32_t bus_size_t;
typedef u_int32_t bus_space_handle_t;
typedef unsigned long	vaddr_t;
typedef	char *caddr_t;
typedef unsigned long vm_offset_t;
typedef unsigned int paddr_t;
typedef unsigned int vm_size_t;
typedef unsigned long size_t;
typedef long long quad_t;
typedef	unsigned long long u_quad_t;	/* quads */
#endif
