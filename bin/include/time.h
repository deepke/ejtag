#ifndef __TIME__H_
#define __TIME__H_ 1
typedef long  time_t;
struct timespec {
        long       ts_sec;
        long       ts_nsec;
};


struct tm {
	/*
	 * the number of seconds after the minute, normally in the range
	 * 0 to 59, but can be up to 60 to allow for leap seconds
	 */
	int tm_sec;
	/* the number of minutes after the hour, in the range 0 to 59*/
	int tm_min;
	/* the number of hours past midnight, in the range 0 to 23 */
	int tm_hour;
	/* the day of the month, in the range 1 to 31 */
	int tm_mday;
	/* the number of months since January, in the range 0 to 11 */
	int tm_mon;
	/* the number of years since 1900 */
	long tm_year;
	/* the number of days since Sunday, in the range 0 to 6 */
	int tm_wday;
	/* the number of days since January 1, in the range 0 to 365 */
	int tm_yday;
};


int gettimeofday(struct timespec *tv);
time_t time(time_t *tloc);
struct tm *localtime(const time_t *timep);
extern unsigned long long jiffies ;
unsigned int get_timer(unsigned int base);
#ifndef HZ
#define HZ 10
#endif

#define time_after(a,b)		((long)((b) - (a)) < 0)
#define time_after_eq(a,b)		((long)(a) - (long)(b) >= 0)
#define time_before(a,b)	time_after(b,a)
#define time_before_eq(a,b)	time_after_eq(b,a)
#endif
