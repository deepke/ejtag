#ifndef __BITOPS_H
#define __BITOPS_H
static inline int fls(int word)
{
	__asm__(".set mips32;clz %0, %1;.set mips0" : "=r" (word) : "r" (word));
	return 32-word;
}

static int inline ffs(int word)
{
	if(!word)
		return 0;
	return fls(word & -word);
}
#endif
