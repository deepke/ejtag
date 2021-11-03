#include <time.h>
#define isleap(y) ((((y) % 4) == 0 && ((y) % 100) != 0) || ((y) % 400) == 0)

#define	SECS_PER_MIN	60
#define	MINS_PER_HOUR	60
#define	HOURS_PER_DAY	24
#define	DAYS_PER_WEEK	7
#define	DAYS_PER_NYEAR	365
#define	DAYS_PER_LYEAR	366
#define	SECS_PER_HOUR	(SECS_PER_MIN * MINS_PER_HOUR)
#define	SECS_PER_DAY	((long) SECS_PER_HOUR * HOURS_PER_DAY)
#define	MONS_PER_YEAR	12

#define YEAR_BASE	1900
#define EPOCH_YEAR      1970
#define EPOCH_WDAY      4

#ifdef CONFIG_DAYLIGHT_SAVEINGS
long 		tz_stdoffset = 0;
#endif
static const int	mon_lengths[2][MONS_PER_YEAR] = {
	{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
	{31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
};

static const int	year_lengths[2] = {
	DAYS_PER_NYEAR, DAYS_PER_LYEAR
};

time_t time(time_t *tloc)
{
	struct timespec ts;

	gettimeofday(&ts);
        if (tloc)
	 *tloc = ts.ts_sec; 
	return ts.ts_sec;
}

struct tm *localtime(const time_t *timep)
{
	static struct tm tm0;
	struct tm *tm = &tm0;
        int year, mon, day, hour, min, sec;
        int yr, yl, tyr, days;
        const int *ip;
	long ts_sec;
	if (timep)
		ts_sec = *timep;
	else
	   ts_sec = time(NULL);

        sec = ts_sec % 60;
        min = (ts_sec/60)%60;
        hour = (ts_sec/3600)%24;
        tyr = ts_sec/3600/24;

        for(yr = EPOCH_YEAR;
                        tyr >= (yl=year_lengths[isleap(yr)]); yr++) {

                tyr -= yl;
        }

        year = yr;
        days = tyr;

        ip = mon_lengths[isleap(yr)];
        for (mon = 0; days >= (long) ip[mon]; ++mon)
                days -=  ip[mon];
        day = days;

	tm->tm_year = year;
	tm->tm_mon = mon;
	tm->tm_mday = day+1;
	tm->tm_hour = hour;
	tm->tm_min = min;
	tm->tm_sec = sec;

        return tm;
}

time_t	mktime(struct tm *tm)
{
    int yr;
    int mn;
    time_t secs;
    struct	tm *ntm;

    if (tm->tm_sec > 61 || 
	tm->tm_min > 59 || 
	tm->tm_hour > 23 || 
	tm->tm_mday > 31 || 
	tm->tm_mon > 12 ||
	tm->tm_year < 70) {
	return (time_t)-1;
    }
    
    /*
     * Sum up seconds from beginning of year
     */
    secs = tm->tm_sec;
    secs += tm->tm_min * SECS_PER_MIN;
    secs += tm->tm_hour * SECS_PER_HOUR;
    secs += (tm->tm_mday-1) * SECS_PER_DAY;
    
    for (mn = 0; mn < tm->tm_mon; mn++)
      secs += mon_lengths[isleap(tm->tm_year+1900)][mn] * SECS_PER_DAY;
    
    for(yr=1970; yr < tm->tm_year + 1900; yr++)
      secs += year_lengths[isleap(yr)]*SECS_PER_DAY;
    
#ifdef CONFIG_DAYLIGHT_SAVEINGS
    if(tm->tm_isdst == 0) {
	secs -= tz_stdoffset;
#endif
	ntm = localtime(&secs);
#ifdef CONFIG_DAYLIGHT_SAVEINGS
    } else if(tm->tm_isdst > 0) {
	tm->tm_isdst = 1;
	secs -= tz_dstoffset;
	ntm = localtime(&secs);
    } else {
	/* try to determine if daylight saving was set at this time 
	 */
	secs -= tz_stdoffset;
	ntm = localtime(&secs);
	if(ntm->tm_mday != tm->tm_mday ||
	   ntm->tm_hour != tm->tm_hour ||
	   ntm->tm_min  != tm->tm_min ||
	   ntm->tm_sec  != tm->tm_sec) {
	    secs += tz_stdoffset;
	    secs -= tz_dstoffset;
	}
    }
#endif
    /* work secs back into a tm to get all the fields correct 
     */
    if(ntm->tm_year != tm->tm_year ||
       ntm->tm_mon  != tm->tm_mon ||
       ntm->tm_mday != tm->tm_mday ||
       ntm->tm_hour != tm->tm_hour ||
       ntm->tm_min  != tm->tm_min ||
       ntm->tm_sec  != tm->tm_sec 
#ifdef CONFIG_DAYLIGHT_SAVEINGS
|| (tm->tm_isdst >= 0 && ntm->tm_isdst != tm->tm_isdst)
#endif
)
       return -1;
    
    *tm = *ntm;
    return secs;
}

