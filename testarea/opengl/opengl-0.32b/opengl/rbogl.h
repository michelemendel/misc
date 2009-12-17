/*
 * $Date: 2000/01/06 16:37:43 $
 * $Author: kusano $
 */
#ifndef _RBOGL_H_
#define _RBOGL_H_

#include "ruby.h"

typedef struct RArray RArray;
extern VALUE cProc;
int ary2cint(VALUE, int[], int);
int ary2cdbl(VALUE, double[], int);
int ary2cflt(VALUE, float[], int);
void mary2ary(VALUE, VALUE);
void ary2cmat4x4(VALUE, double[]);
VALUE allocate_buffer_with_string(int);
#ifndef NUM2DBL
double num2double(VALUE);
#define _NO_NUM2DBL_
#define NUM2DBL(_val) num2double(_val) 
#endif

#endif
