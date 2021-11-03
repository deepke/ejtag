#ifndef __MALLOC_H__
#define __MALLOC_H__
void * malloc(size_t nbytes);
void free(void *ap);
void * malloc_align(size_t nbytes, int align);
#endif
