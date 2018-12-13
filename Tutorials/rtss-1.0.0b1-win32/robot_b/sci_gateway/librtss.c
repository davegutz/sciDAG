#include <mex.h> 
static int direct_gateway(char *fname,void F(void)) { F();return 0;};
extern Gatefunc sci_rt_frne;
static GenericTable Tab[]={
  {(Myinterfun)sci_gateway,sci_rt_frne,"rt_frne"},
};
 
int C2F(librtss)()
{
  Rhs = Max(0, Rhs);
  (*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F);
  return 0;
}
