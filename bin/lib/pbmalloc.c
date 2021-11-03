#include <types.h>
#include <asm/mipsregs.h>
#include <spinlock.h>
#include <malloc.h>
#include <pbmalloc.h>

struct kmembuckets bucket[MINBUCKET + 16];
static char *kmem;
static long kmem_offs;

struct freelist {
	caddr_t	next;
};

static DEFINE_SPINLOCK(kmemlock);


/*
 * Allocate a block of memory
 */
void *pbmalloc(unsigned long size, int align)
{
	register struct kmembuckets *kbp;
	register struct freelist *freep;
	long indx, npg, allocsize, allsize;
	long flags;
	caddr_t va, cp, savedlist;
	if ((size % align) != 0)
		size = (size + align - 1) & ~(align - 1);
	indx = BUCKETINDX(size);
	kbp = &bucket[indx];
	spin_lock_irqsave(&kmemlock, flags);
	if (kbp->kb_next == NULL) {
		if (size > MAXALLOCSAVE)
			allocsize = size;
		else
			allocsize = 1 << indx;
		allsize = ctob(btoc(allocsize));
		va = (caddr_t) malloc_align(allsize, align);
		if (va == NULL) {
			/*
			 * Kmem_malloc() can return NULL, even if it can
			 * wait, if there is no map space available, because
			 * it can't fix that problem.  Neither can we,
			 * right now.  (We should release pages which
			 * are completely free and which are in buckets
			 * with too many free elements.)
			 */
			spin_unlock_irqrestore(&kmemlock, flags);
			return ((void *) NULL);
		}
		if (allocsize > MAXALLOCSAVE) {
			goto out;
		}
		/*
		 * Just in case we blocked while allocating memory,
		 * and someone else also allocated memory for this
		 * bucket, don't assume the list is still empty.
		 */
		savedlist = kbp->kb_next;
		kbp->kb_next = cp = va;
		for (;;) {
			freep = (struct freelist *)cp;
			cp += allocsize;
			if (cp  > va + allsize - allocsize)
				break;
			freep->next = cp;
		}
		freep->next = savedlist;
	}
	va = kbp->kb_next;
	kbp->kb_next = ((struct freelist *)va)->next;
out:
	spin_unlock_irqrestore(&kmemlock, flags);
	return ((void *) va);
}

/*
 * Free a block of memory allocated by malloc.
 */
void pbfree(void *addr, int size)
{
	register struct kmembuckets *kbp;
	register struct freelist *freep;
	long flags;
	int indx = BUCKETINDX(size);
	kbp = &bucket[indx];

	spin_lock_irqsave(&kmemlock, flags);
	if (size > MAXALLOCSAVE) {
		free(addr);
		spin_unlock_irqrestore(&kmemlock, flags);
		return;
	}
	freep = (struct freelist *)addr;
	freep->next = kbp->kb_next;
        kbp->kb_next = freep;
	spin_unlock_irqrestore(&kmemlock, flags);
}

