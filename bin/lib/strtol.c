/* $Id: misc.c,v 1.1.1.1 2006/09/14 01:59:06 root Exp $ */

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
#include <errno.h>

#if (_MIPS_SZPTR == 32)
#define ULONG_MAX 	4294967295UL
#define LONG_MAX 	2147483647L
#define LONG_MIN 	(-LONG_MAX-1)
#else
#define ULONG_MAX 	-1ULL
#define LONG_MAX 	-1/2ULL
#define LONG_MIN 	(-LONG_MAX-1)
#endif
#define isspace(c) (c==0x20)
#define isdigit(c)	  (((c) >= '0') && ((c) <= '9'))
#define isalpha(c)	( (((c) >= 'A') && ((c) <= 'Z')) || \
			  (((c) >= 'a') && ((c) <= 'z')) )
#define isupper(c)	(c>='A' && c<='Z')

long
strtol(const char *nptr,char **endptr,int base)
{
    int c;
    long result = 0L;
    long limit;
    int negative = 0;
    int overflow = 0;
    int digit;

    while ((c = *nptr) && isspace(c)) /* skip leading white space */
      nptr++;
    if ((c = *nptr) == '+' || c == '-') { /* handle signs */
	negative = (c == '-');
	nptr++;
    }
    if (base == 0) {		/* determine base if unknown */
	base = 10;
	if (*nptr == '0') {
	    base = 8;
	    nptr++;
	    if ((c = *nptr) == 'x' || c == 'X') {
		base = 16;
		nptr++;
	    }
	}
    }
    else
      if (base == 16 && *nptr == '0') {	/* discard 0x/0X prefix if hex */
	  nptr++;
	  if ((c = *nptr == 'x') || c == 'X')
	    nptr++;
      }

    limit = LONG_MAX / base;	/* ensure no overflow */

    nptr--;			/* convert the number */
    while ((c = *++nptr) != 0) {
	if (isdigit(c))
	  digit = c - '0';
	else if(isalpha(c))
	  digit = c - (isupper(c) ? 'A' : 'a') + 10;
	else
	  break;
	if (digit < 0 || digit >= base)
	  break;
	if (result > limit)
	  overflow = 1;
	if (!overflow) {
	    result = base * result;
	    if (digit > LONG_MAX - result)
	      overflow = 1;
	    else	
	      result += digit;
	}
    }
    if (negative && !overflow)
      result = 0L - result;
    if (overflow) {
	extern int errno;
	errno = ERANGE;
	if (negative)
	  result = LONG_MIN;
	else
	  result = LONG_MAX;
    }

    if (endptr != NULL)		/* set up return values */
      *endptr = (char *)nptr;
    return result;
}

