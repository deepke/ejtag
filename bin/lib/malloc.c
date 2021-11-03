/* $Id: malloc.c,v 1.1.1.1 2006/09/14 01:59:08 root Exp $ */

/*
 * Copyright (c) 2000-2002 Opsycon AB  (www.opsycon.se)
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
 *	This product includes software developed by Opsycon AB.
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */
#include <asm/mipsregs.h>
#include <spinlock.h>
static DEFINE_SPINLOCK(memlock);	
typedef long long  ALIGN;
void free(void *ap);
void * memset(void * s,int c, size_t count);


union header {
    struct {
	union header   *ptr;
	unsigned        size;
    } s;
    ALIGN           x;
};

typedef union header HEADER;

static HEADER   base;
static HEADER  *allocp;		/* K&R called allocp, freep */

#ifndef NULL
#define NULL   0
#endif
#define NALLOC 128

/* The rest of this file is from pages 185-189 of K & R Edition 2 */

static HEADER *morecore (unsigned nbyte);

extern char _heap[];
extern char _start[];
char *membase=_heap;
char  *sbrk(int size)
{
char *p;
char *end;
long flags;
spin_lock_irqsave(&memlock, flags);
p = membase;
membase += size;
#ifdef MEMEND
end = MEMEND;
#elif defined(MEMSIZE) && defined(LOADADDR)
#if LOADADDR
end = LOADADDR + MEMSIZE;
#else
end = _start + MEMSIZE;
#endif
#endif

#if defined(MEMEND) || (defined(MEMSIZE) && defined(LOADADDR))
if(membase > end)
{
	printf("malloc exceed memory size membase=0x%lx\n", (long)membase);
	while(1);
}
#endif
spin_unlock_irqrestore(&memlock, flags);
return p;
}


void *
malloc(size_t nbytes)
{
	HEADER *p, *q;	/* K&R called q, prevp */
	unsigned nunits;
	long flags;

	nunits = (nbytes + sizeof (HEADER) - 1) / sizeof (HEADER) + 1;
	spin_lock_irqsave(&memlock, flags);
	if ((q = allocp) == NULL) {	/* no free list yet */
		base.s.ptr = allocp = q = &base;
		base.s.size = 0;
	}
	for (p = q->s.ptr;; q = p, p = p->s.ptr) {
		if (p->s.size >= nunits) {	/* big enough */
			if (p->s.size == nunits)	/* exactly */
				q->s.ptr = p->s.ptr;
			else {		/* allocate tail end */
				p->s.size -= nunits;
				p += p->s.size;
				p->s.size = nunits;
			}
			allocp = q;
			p->s.ptr = p;
			spin_unlock_irqrestore(&memlock, flags);
			return ((char *)(p + 1));
		}
		if (p == allocp)
		{
			spin_unlock_irqrestore(&memlock, flags);
			if ((p = morecore (nunits)) == NULL)
			return (NULL);
			spin_lock_irqsave(&memlock, flags);
		}
	}
}


static HEADER  *
morecore(unsigned nu)
{
	char *cp;
	HEADER *up;
	int rnu;

	rnu = NALLOC * ((nu + NALLOC - 1) / NALLOC);
	cp = sbrk(rnu * sizeof (HEADER));
	if ((int)cp == NULL)
		return (NULL);
	up = (HEADER *) cp;
	up->s.size = rnu;
        up->s.ptr = up;
	free ((char *)(up + 1));
	return (allocp);
}


void
free(void *ap)
{
	HEADER *p, *q;
	long flags;
	if (!ap)
		return ;

	p = (HEADER *) ap - 1;
	if (p->s.ptr != p)
	   p = p->s.ptr;
	spin_lock_irqsave(&memlock, flags);
	for (q = allocp; !(p > q && p < q->s.ptr); q = q->s.ptr)
		if (q >= q->s.ptr && (p > q || p < q->s.ptr))
			break;
	if (p + p->s.size == q->s.ptr) {
		p->s.size += q->s.ptr->s.size;
		p->s.ptr = q->s.ptr->s.ptr;
	} else
		p->s.ptr = q->s.ptr;
	if (q + q->s.size == p) {
		q->s.size += p->s.size;
		q->s.ptr = p->s.ptr;
	} else
		q->s.ptr = p;
	allocp = q;
	spin_unlock_irqrestore(&memlock, flags);
}

void * malloc_align(size_t nbytes, int align)
{
	void *p, *p1;
	HEADER *q, *q1;
	if (align<=sizeof(ALIGN)) return malloc(nbytes);

	p = malloc(nbytes + align);
	p1 = (long)(p + align - 1) & ~(align - 1);
	if (p1 != p)
	{
		q = ((HEADER *)p)-1;
		q1 = ((HEADER *)p1)-1;
		q1->s.size = q->s.size - (p1 - p);
		q1->s.ptr = q;
	}

	return p1;
}

void * zalloc_align(size_t nbytes, int align)
{
	char *p = malloc_align(nbytes, align);
	if (p)
		memset(p, 0, nbytes);
	return p;
}

int
allocsize(void *ap)
{
	HEADER *p;

	p = (HEADER *) ap - 1;
	return (p->s.size * sizeof (HEADER));
}

