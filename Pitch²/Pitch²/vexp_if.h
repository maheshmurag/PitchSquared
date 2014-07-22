/*
 * jMax
 * Copyright (C) 1994, 1995, 1998, 1999 by IRCAM-Centre Georges Pompidou, Paris, France.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * See file LICENSE for further informations on licensing terms.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 * Based on Max/ISPW by Miller Puckette.
 *
 * Authors: Maurizio De Cecco, Francois Dechelle, Enzo Maggi, Norbert Schnell.
 *
 */

/* "expr" was written by Shahrokh Yadegari c. 1989. -msp */
/* "expr~" and "fexpr~" conversion by Shahrokh Yadegari c. 1999,2000 */

/*
 * Feb 2002 - added access to variables
 *            multiple expression support
 *            new short hand forms for fexpr~
 *              now $y or $y1 = $y1[-1] and $y2 = $y2[-1]
 * --sdy
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "vexp.h"

static char *exp_version = "0.4";

extern struct ex_ex *ex_eval(struct expr *expr, struct ex_ex *eptr,
                             struct ex_ex *optr, int n);

static t_class *expr_class;
static t_class *expr_tilde_class;
static t_class *fexpr_tilde_class;



/*------------------------- expr class -------------------------------------*/

extern int expr_donew(struct expr *expr, int ac, t_atom *av);

/*#define EXPR_DEBUG*/

static void expr_bang(t_expr *x);
t_int *expr_perform(t_int *w);


static void expr_list(t_expr *x, t_symbol *s, int argc, const fts_atom_t *argv);

static void expr_flt(t_expr *x, t_float f, int in);
static t_class *exprproxy_class;
typedef struct _exprproxy {
    t_pd p_pd;
    int p_index;
    t_expr *p_owner;
    struct _exprproxy *p_next;
} t_exprproxy;
t_exprproxy *exprproxy_new(t_expr *owner, int indx);
void exprproxy_float(t_exprproxy *p, t_floatarg f);

t_exprproxy *exprproxy_new(t_expr *owner, int indx);

void exprproxy_float(t_exprproxy *p, t_floatarg f);
/* method definitions */
static void expr_ff(t_expr *x);
static void expr_bang(t_expr *x);
static t_expr *
expr_new(t_symbol *s, int ac, t_atom *av);

t_int * expr_perform(t_int *w);
static void expr_dsp(t_expr *x, t_signal **sp);
/*
 * expr_verbose -- toggle the verbose switch
 */
static void expr_verbose(t_expr *x);

/*
 * expr_start -- turn on expr processing for now only used for fexpr~
 */
static void
expr_start(t_expr *x);

/*
 * expr_stop -- turn on expr processing for now only used for fexpr~
 */
static void expr_stop(t_expr *x);
static void fexpr_set_usage(void);
/*
 * fexpr_tilde_set -- set previous values of the buffers
 *              set val val ... - sets the first elements of output buffers
 *              set x val ...   - sets the elements of the first input buffer
 *              set x# val ...  - sets the elements of the #th input buffers
 *              set y val ...   - sets the elements of the first output buffer
 *              set y# val ...  - sets the elements of the #th output buffers
 */
static void fexpr_tilde_set(t_expr *x, t_symbol *s, int argc, t_atom *argv);
/*
 * fexpr_tilde_clear - clear the past buffers
 */
static void fexpr_tilde_clear(t_expr *x, t_symbol *s, int argc, t_atom *argv);
void expr_setup(void);
void expr_tilde_setup(void);
void fexpr_tilde_setup(void);



/* -- the following functions use Pd internals and so are in the "if" file. */


int ex_getsym(char *p, fts_symbol_t *s);
const char * ex_symname(fts_symbol_t s);
/*
 * max_ex_tab -- evaluate this table access
 *               eptr is the name of the table and arg is the index we
 *               have to put the result in optr
 *               return 1 on error and 0 otherwise
 *
 * Arguments:
 *  the expr object
 *  table
 *  the argument
 *  the result pointer
 */
int max_ex_tab(struct expr *expr, fts_symbol_t s, struct ex_ex *arg,
               struct ex_ex *optr);
int max_ex_var(struct expr *expr, fts_symbol_t var, struct ex_ex *optr);

#define ISTABLE(sym, garray, size, vec)                               \
if (!sym || !(garray = (t_garray *)pd_findbyclass(sym, garray_class)) || \
!garray_getfloatwords(garray, &size, &vec))  {          \
optr->ex_type = ET_FLT;                                         \
optr->ex_int = 0;                                               \
error("no such table '%s'", sym?(sym->s_name):"(null)");                       \
return;                                                         \
}

/*
 * ex_size -- find the size of a table
 */
void ex_size(t_expr *e, long int argc, struct ex_ex *argv, struct ex_ex *optr);

/*
 * ex_sum -- calculate the sum of all elements of a table
 */

void ex_sum(t_expr *e, long int argc, struct ex_ex *argv, struct ex_ex *optr);

void ex_Sum(t_expr *e, long int argc, struct ex_ex *argv, struct ex_ex *optr);


/*
 * ex_avg -- calculate the avarage of a table
 */

void ex_avg(t_expr *e, long int argc, struct ex_ex *argv, struct ex_ex *optr);
void ex_Avg(t_expr *e, long int argc, struct ex_ex *argv, struct ex_ex *optr);
/*
 * ex_store -- store a value in a table
 *             if the index is greater the size of the table,
 *             we will make a modulo the size of the table
 */

void ex_store(t_expr *e, long int argc, struct ex_ex *argv, struct ex_ex *optr);


