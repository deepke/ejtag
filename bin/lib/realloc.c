int allocsize(void *ap);
void *memcpy(void *s1, const void *s2, size_t n);
void * malloc(size_t nbytes);
void *
realloc(void *ptr, size_t size)
{
	void *p;
	size_t sz;

	p = malloc (size);
	if (!p)
		return (p);
	sz = allocsize (ptr);
	memcpy (p, ptr, (sz > size) ? size : sz);
	free (ptr);
	return (p);
}
