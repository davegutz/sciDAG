int ext1c(int *n, double *a, double *b, double *c)
{int k;
  for (k = 0; k < *n; ++k) 
      c[k] = a[k] + b[k];
  return(0);}
