#ifndef __STRING_H__
#define __STRING_H__
void *memcpy(void *s1, const void *s2, size_t n);
char * strcpy (char *dstp, const char *srcp);
int strcmp(const char *s1, const char *s2);
int memcmp(const void * cs,const void * ct,int count);
#define FMT_RJUST 0
#define FMT_LJUST 1
#define FMT_RJUST0 2
#define FMT_CENTER 3
#endif
