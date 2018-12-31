#ifdef __cplusplus
extern "C" {
#endif
#include <mex.h> 
#include <sci_gateway.h>
#include <api_scilab.h>
#include <MALLOC.h>
static int direct_gateway(char *fname,void F(void)) { F();return 0;};
extern Gatefunc sci_csum;
extern Gatefunc sci_csub;
extern Gatefunc sci_multiplybypi;
extern Gatefunc sci_foo;
extern Gatefunc sci_cerror;
static GenericTable Tab[]={
  {(Myinterfun)sci_gateway_without_putlhsvar,sci_csum,"c_sum"},
  {(Myinterfun)sci_gateway_without_putlhsvar,sci_csub,"c_sub"},
  {(Myinterfun)sci_gateway_without_putlhsvar,sci_multiplybypi,"c_multiplybypi"},
  {(Myinterfun)sci_gateway_without_putlhsvar,sci_foo,"foo"},
  {(Myinterfun)sci_gateway_without_putlhsvar,sci_cerror,"c_error"},
};
 
int C2F(skeleton_c)()
{
  Rhs = Max(0, Rhs);
  if (*(Tab[Fin-1].f) != NULL) 
  {
     if(pvApiCtx == NULL)
     {
       pvApiCtx = (StrCtx*)MALLOC(sizeof(StrCtx));
     }
     pvApiCtx->pstName = (char*)Tab[Fin-1].name;
    (*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F);
  }
  return 0;
}
#ifdef __cplusplus
}
#endif
