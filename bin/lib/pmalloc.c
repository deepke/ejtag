
void *pmalloc (size_t );
void pfree (void * );
void free (void * );
void * memset(void * s,int c, size_t count);


void *
pmalloc(size_t nbytes)
{
	void *p;
	p = malloc(nbytes);
	if(p) {
		memset(p, 0, nbytes);
	}
	return(p);
}

void
pfree(void *ap)
{
	free(ap);
}
