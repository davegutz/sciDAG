/*-----------------------------------------------------------------------------------
 *  Copyright (C) 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
 *
 *  This file is part of RTSS, the Robotics Toolbox for Scilab/Scicos.
 *
 *  RTSS is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  RTSS is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with RTSS; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *--------------------------------------------------------------------------------- */



/**
 * @file  rtss_dummy.c
 *
 * @brief Dummy definitions of printing functions unavailable in standalone mode
 *
 * A more detailed description goes here (TODO).
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         April 2007
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 * $LastChangedDate: 2009-08-14 17:51:40 +0200(ven, 14 ago 2009) $
 */



#include "../includes/rtss_error.h"  /* Interface to ERROR module */

#ifdef __STDC__
/**
 * @brief Dummy definition of function Scierror
 *
 * @param[int] iv error number
 * @param[int] fmt error message
 * @return     RTSS_SUCCESS
 */
int
Scierror(int iv, char * fmt,...)
{
    return(RTSS_SUCCESS);
}
#else
/**
 * @brief Dummy definition of function Scierror
 *
 * @return     RTSS_SUCCESS
 */
int
Scierror()
{
    return(RTSS_SUCCESS);
}
#endif

/**
 * @brief Dummy definition of function mexPrintf
 *
 * @param[int] fmt message
 */
void
mexPrintf(char * fmt,...)
{
}
