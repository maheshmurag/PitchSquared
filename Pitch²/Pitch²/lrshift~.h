#include "m_pd.h"

/* ------------------------ lrshift~ ----------------------------- */

static t_class *lrshift_tilde_class;

typedef struct _lrshift_tilde
{
    t_object x_obj;
    int x_n;
    t_float x_f;
} t_lrshift_tilde;

static t_int *leftshift_perform(t_int *w);
static t_int *rightshift_perform(t_int *w);
static void lrshift_tilde_dsp(t_lrshift_tilde *x, t_signal **sp);
static void *lrshift_tilde_new(t_floatarg f);
void lrshift_tilde_setup(void);