#ifndef __PMALLOC_H__
#define	__PMALLOC_H__

#ifndef PAGE_SHIFT
#define	PAGE_SHIFT		12		/* LOG2(NBPG) */
#endif
#define	NBPG		(1<<PAGE_SHIFT)		/* bytes/page */
#define	PGOFSET		(NBPG-1)	/* byte offset into page */


/* pages to bytes */
#define	ctob(x)	((x) << PAGE_SHIFT)
#define btoc(x) (((x) + PGOFSET) >> PAGE_SHIFT)


#define MINBUCKET	4		/* 4 => min allocation of 16 bytes */
/* always permanently allocate */
#define	MAXALLOCSAVE	(MINALLOCSIZE * 32768)


/*
 * Set of buckets for each size of memory block that is retained
 */
struct kmembuckets {
	caddr_t kb_next;	/* list of free blocks */
};

#define	MINALLOCSIZE	(1 << MINBUCKET)
#define	BUCKETINDX(size) \
	((size) <= (MINALLOCSIZE * 128) \
		? (size) <= (MINALLOCSIZE * 8) \
			? (size) <= (MINALLOCSIZE * 2) \
				? (size) <= (MINALLOCSIZE * 1) \
					? (MINBUCKET + 0) \
					: (MINBUCKET + 1) \
				: (size) <= (MINALLOCSIZE * 4) \
					? (MINBUCKET + 2) \
					: (MINBUCKET + 3) \
			: (size) <= (MINALLOCSIZE* 32) \
				? (size) <= (MINALLOCSIZE * 16) \
					? (MINBUCKET + 4) \
					: (MINBUCKET + 5) \
				: (size) <= (MINALLOCSIZE * 64) \
					? (MINBUCKET + 6) \
					: (MINBUCKET + 7) \
		: (size) <= (MINALLOCSIZE * 2048) \
			? (size) <= (MINALLOCSIZE * 512) \
				? (size) <= (MINALLOCSIZE * 256) \
					? (MINBUCKET + 8) \
					: (MINBUCKET + 9) \
				: (size) <= (MINALLOCSIZE * 1024) \
					? (MINBUCKET + 10) \
					: (MINBUCKET + 11) \
			: (size) <= (MINALLOCSIZE * 8192) \
				? (size) <= (MINALLOCSIZE * 4096) \
					? (MINBUCKET + 12) \
					: (MINBUCKET + 13) \
				: (size) <= (MINALLOCSIZE * 16384) \
					? (MINBUCKET + 14) \
					: (MINBUCKET + 15))

extern struct kmembuckets bucket[];

extern void *pmalloc (unsigned long size);
extern void pfree(void *addr, int size);

#endif /* !__PMALLOC_H__ */
