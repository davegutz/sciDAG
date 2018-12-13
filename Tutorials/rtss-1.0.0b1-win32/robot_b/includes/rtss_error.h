/*-----------------------------------------------------------------------------------
 *  Copyright 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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
 * @file  rtss_error.h
 *
 * @brief Interface to ERROR module
 *
 * A more detailed description goes here (TODO).
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         March 2009
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 * $LastChangedDate: 2009-08-11 14:11:00 +0200(mar, 11 ago 2009) $
 */



#ifndef RTSS_ERROR_HDR
#define RTSS_ERROR_HDR
/**
 * @defgroup error ERROR
 */
/** @{ */
/*--------------------------------
 * Bunch of external declarations.
 *------------------------------ */
extern void sciprint(char * , ...);
extern int Scierror(int , char * , ...);

/**
 * @brief Success termination code
 */
#define RTSS_SUCCESS 1

/**
 * @brief Failure termination code
 */
#define RTSS_FAILURE 0

/**
 * @brief Fatal error related to a NULL pointer dereference
 *
 * Print an error message on the Scilab console and return a RTSS failure
 */
#define rtss_err_null_ptr() \
{ \
    Scierror(999, "%s: Dereferencing NULL pointer\n", __FUNCTION__); \
    return(RTSS_FAILURE); \
}

/**
 * @brief Fatal error related to a generic failure
 *
 * Print an error message on the Scilab console and return a RTSS failure
 */
#define rtss_err_fail(errid, errmsg, ...) \
{ \
    Scierror(errid, "%s: " errmsg "\n", __FUNCTION__, ##__VA_ARGS__);\
    return(RTSS_FAILURE); \
}

/**
 * @brief Print some info about the caller of a failing function, and quit
 *
 * Print a message on the Scilab console summarizing some info about the caller
 * of a failing function, and return a RTSS failure
 */
#define rtss_err_call() \
{ \
    sciprint("Called by %s at line %d (%s)\n", __FUNCTION__, __LINE__, __FILE__); \
    return(RTSS_FAILURE); \
}
/** @} */
#endif /* RTSS_ERROR_HDR */
