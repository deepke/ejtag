int printf (const char *fmt, ...);
int dump_mem(unsigned char *buf, int len)
{
	int i;
	for(i=0;i<len;i++)
	{
		if((i&0xf)==0) printf("\n%08x/%08x: ", buf +i, i);
		printf("%02x ",buf[i]);
	}
	printf("\n");
	return 0;
}


