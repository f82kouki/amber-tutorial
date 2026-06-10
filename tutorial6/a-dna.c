#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include "nabcode.h"
extern char NAB_rsbuf[];
static int mytaskid, numtasks;

static MOLECULE_T *m;


int main( argc, argv )
	int	argc;
	char	*argv[];
{
	nabout = stdout; /*default*/

	mytaskid=0; numtasks=1;
static STRING_T *__st0001__ = NULL;
static STRING_T *__st0002__ = NULL;
static STRING_T *__st0003__ = NULL;
m = fd_helix( STEMP( __st0001__, "adna" ), STEMP( __st0002__, "aaaaaaaaaa" ), STEMP( __st0003__, "dna" ) );
putpdb( "a-dna.nab.pdb", m, "-wwpdb" );


	exit( 0 );
}
