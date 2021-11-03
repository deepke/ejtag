#include <r4kcache.h>
#define SERIALBASE  0xbfe00000
#define printf newprintf

struct cpuinfo_mips current_cpu_data;

#if 0
int putchar(int c)
{
while(!(*(volatile char *)(SERIALBASE+5)&0x20));
*(volatile char *)SERIALBASE=c;
return 0;
}
#endif



int mymain()
{
 int i;
 long taddr = (int)0x81000000;
 int tsize = 0x100000;

memset(&current_cpu_data,0, sizeof(current_cpu_data));
probe_cache(&current_cpu_data, 2);

for(i=0;i<tsize;i+=64)
{
if((i&0xffff)==0)printf("w%08x\n",i);
 *(volatile int *)(taddr + i) = i;
}

//r4k_dma_cache_wback_inv(taddr, tsize);
blast_scache_range(taddr, taddr + tsize);

for(i=0;i<tsize;i+=64)
{
if((i&0xffff)==0)printf("r%08x\n",i);
 if(*(volatile int *)(taddr + i) != i) printf("verify error on 0x%08x\n");
}
printf("done\n");
return 0;
}
