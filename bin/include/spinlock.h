#ifndef __SPINLOCK_H__
#define __SPINLOCK_H__
typedef int spinlock_t;
#define DEFINE_SPINLOCK(x) spinlock_t x;	
#define spin_lock_irqsave(lock, flags) flags = (clear_c0_status(1) & 1)
#define spin_unlock(...)
#define spin_lock(...)
#define spin_lock_init(...)
#define spin_unlock_irqrestore(lock, flags) change_c0_status(1, flags)
#endif
