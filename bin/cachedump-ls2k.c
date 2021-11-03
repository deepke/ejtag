void *maddr;
int mlen;

int dumpdcache()
{
	unsigned int taglo, taghi;
	int way;
	unsigned int tl, w, cs, scway;
	unsigned long addr;
	int ways = 4;
	long len=32*1024/ways;
	int i;


	for(i=0,addr=(int)0x9fc00000;len>0;len-=64,addr+=64,i+=64)
	{
		for(way=0;way<ways;way++)
		{
				asm volatile(".set mips64;cache %3,(%2);mfc0 %0,$28;mfc0 %1,$29;.set mips0;":"=r"(taglo),"=r"(taghi):"r"(addr|way),"i"(5));
				tl= taglo & 0xfffff000;
				w = (taglo >> 8)&1;
				cs = (taglo >> 6)&3;
				scway = taglo&0xf;
			if(maddr)
				mlen += sprintf(maddr+mlen,"cs=%d phy=0x%08x%08x way=%d w=%d scway=%d taglo=0x%08x taghi=0x%08x\n",cs, taghi&0xffff, tl|i, way, w, scway, taglo, taghi);
			else
				printf("cs=%d phy=0x%08x%08x way=%d w=%d scway=%d taglo=0x%08x taghi=0x%08x\n",cs, taghi&0xffff, tl|i, way, w, scway, taglo, taghi);
		}
	}

return 0;
}



int dumpscache()
{
	unsigned int taglo, taghi;
	int way;
	unsigned int tl, pkg, kp, w, ds, ss;
	unsigned long addr;
	int ways = 8;
	long len=1024*1024/ways;
	int i;


	for(i=0,addr=(int)0x9fc00000;len>0;len-=64,addr+=64,i+=64)
	{
		for(way=0;way<ways;way++)
		{
				asm volatile(".set mips64;cache %3,(%2);mfc0 %0,$28;mfc0 %1,$29;.set mips0;":"=r"(taglo),"=r"(taghi):"r"(addr|way),"i"(7));
				tl= taglo &0xffff0000;
				pkg = (taglo>>10)&3;
				kp = (taglo>>9)&1;
				w = (taglo>>8)&1;
				ds = (taglo>>7)&1;
				ss = (taglo>>6)&1;
			if(maddr)
				mlen += sprintf(maddr+mlen,"ss=%d phy=0x%08x%08x way=%d pkg=%d kp=%d w=%d ds=%d taglo=0x%08x taghi=0x%08x\n",ss, taghi&0xffff, tl|i, way, pkg, kp, w, ds, taglo, taghi);
			else
				printf("ss=%d phy=0x%08x%08x way=%d pkg=%d kp=%d w=%d ds=%d taglo=0x%08x taghi=0x%08x\n",ss, taghi&0xffff, tl|i, way, pkg, kp, w, ds, taglo, taghi);
		}
	}
	return 0;

}


int mymain(long addr)
{
	int argc = *(int *)ARGC_REG;
if(argc > 0) maddr = addr;
dumpdcache();
dumpscache();
//*(int *)ARGC_REG = mlen;
return mlen;
}
