/*  File      : /afs/psi.ch/user/f/flechsig/phase/src/phase/error.c */
/*  Date      : <26 Oct 04 13:49:18 flechsig>  */
/*  Time-stamp: <2013-05-13 12:24:54 flechsig>  */
/*  Author    : Uwe Flechsig, flechsig@psi.ch */

/*  $Source$  */
/*  $Date$ */
/*  $Revision$  */
/*  $Author$  */

#if HAVE_CONFIG_H
#include "config.h"
#endif

#include "error.h"

static void error (int exit_status, const char *mode, 
                   const char *message);

static void
error (int exit_status, const char *mode, const char *message)
{
  fprintf (stderr, "%s: %s: %s.\n", program_name, mode, message);

  if (exit_status >= 0)
    exit (exit_status);
}

void
sic_info (const char *message)
{
  error (-1, "info", message);
}

void
sic_warning (const char *message)
{
  error (-1, "warning", message);
}

void
sic_error (const char *message)
{
  error (-1, "ERROR", message);
}

void
sic_fatal (const char *message)
{
#ifndef QTGUI
  error (EXIT_FAILURE, "FATAL", message);
#endif
}

const char *program_name = NULL;

/* failed with the posix version of basename */
/* UF 25.12.07 apply basename to a copy      */
void set_program_name (const char *path)
{
  char *pathcopy;
#ifndef QTGUI  
  pathcopy= xstrdup(path);
  /*  if (!program_name) */
  program_name = (const char *)basename(pathcopy);
#endif
}


