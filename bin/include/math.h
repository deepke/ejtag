/* $Id: math.h,v 1.1.1.1 2006/09/14 01:59:06 root Exp $ */
#ifndef _MATH_
#define _MATH_

#ifdef FLOAT
float sin(float x);
float cos(float x);
float tan(float x);
float atan(float x);
float exp(float x);
float log(float x);
float pow(float x);
float sqrt(float x);
#else


double acos(double x);
double acosh(double x);
double asin(double x);
double atan(double x);
double atan2(double y, double x);
double atanh(double x);
double ceil(double x);
double cos(double x);
double cosh(double x);
double exp(double x);
double fabs(double x);
double floor(double x);
double fmod(double x, double y);
double frexp(double x, int *i);
double ldexp(double x, int i);
double log(double x);
double log10(double x);
double modf(double x, double *i);
double pow(double x,double y);
double sin(double x);
double sinh(double x);
double sqrt(double x);
double tan(double x);
double tanh(double x);

#endif


float acosf(float x);
float asinf(float x);
float atan2f(float y, float x);
float atanf(float x);
float ceilf(float x);
float cosf(float x);
float coshf(float x);
float expf(float x);
float fabsf(float x);
float floorf(float x);
float fmodf(float x, float y);
float frexpf(float x, int *i);
float ldexpf(float x, int i);
float log10f(float x);
float logf(float x);
float modff(float x, float *i);
float powf(float x);
float sinf(float x);
float sinhf(float x);
float sqrtf(float x);
float tanf(float x);
float tanhf(float x);

static inline void tgt_fpuenable()
{
//#if __mips < 3 || __mips == 32
#if (_MIPS_SZPTR == 32)
asm(\
"mfc0 $2,$12;\n" \
"li   $3,0x34000000 #ST0_CU1;\n" \
"or   $2,$3;\n"
"li   $3,0x04000000 #ST0_CU1;\n"
"xor   $2,$3;\n"
"mtc0 $2,$12;\n"
"li $2,0x00000000 #FPU_DEFAULT;\n"
"ctc1 $2,$31;\n"
"li $2,-1;\n"
"mtc1	$2, $f0\n;"
"mov.d	$f2, $f0\n;"
"mov.d	$f4, $f0\n;"
"mov.d	$f6, $f0\n;"
"mov.d	$f8, $f0\n;"
"mov.d	$f10, $f0\n;"
"mov.d	$f12, $f0\n;"
"mov.d	$f14, $f0\n;"
"mov.d	$f16, $f0\n;"
"mov.d	$f18, $f0\n;"
"mov.d	$f20, $f0\n;"
"mov.d	$f22, $f0\n;"
"mov.d	$f24, $f0\n;"
"mov.d	$f26, $f0\n;"
"mov.d	$f28, $f0\n;"
"mov.d	$f30, $f0\n;"
:::"$2","$3"
	);
#else
asm(\
"mfc0 $2,$12;\n"
"li   $3,0x34000000 #ST0_CU1;\n"
"or   $2,$3;\n"
"mtc0 $2,$12;\n"
"li $2,0x00000000 #FPU_DEFAULT;\n"
"ctc1 $2,$31;\n"
"li $2,-1;\n"
"dmtc1	$2, $f0\n;"
"mov.d	$f1, $f0\n;"
"mov.d	$f3, $f0\n;"
"mov.d	$f5, $f0\n;"
"mov.d	$f7, $f0\n;"
"mov.d	$f9, $f0\n;"
"mov.d	$f11, $f0\n;"
"mov.d	$f13, $f0\n;"
"mov.d	$f15, $f0\n;"
"mov.d	$f17, $f0\n;"
"mov.d	$f19, $f0\n;"
"mov.d	$f21, $f0\n;"
"mov.d	$f23, $f0\n;"
"mov.d	$f25, $f0\n;"
"mov.d	$f27, $f0\n;"
"mov.d	$f29, $f0\n;"
"mov.d	$f31, $f0\n;"
"mov.d	$f2, $f0\n;"
"mov.d	$f4, $f0\n;"
"mov.d	$f6, $f0\n;"
"mov.d	$f8, $f0\n;"
"mov.d	$f10, $f0\n;"
"mov.d	$f12, $f0\n;"
"mov.d	$f14, $f0\n;"
"mov.d	$f16, $f0\n;"
"mov.d	$f18, $f0\n;"
"mov.d	$f20, $f0\n;"
"mov.d	$f22, $f0\n;"
"mov.d	$f24, $f0\n;"
"mov.d	$f26, $f0\n;"
"mov.d	$f28, $f0\n;"
"mov.d	$f30, $f0\n;"
:::"$2","$3"
	);
#endif
}
#endif /* _MATH_ */

