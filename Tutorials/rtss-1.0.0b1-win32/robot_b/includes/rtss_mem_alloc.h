/*-----------------------------------------------------------------------------------
 *  Copyright (C) 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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
 * @file  rtss_mem_alloc.h
 *
 * @brief OS specific routines for memory management
 *
 * A more detailed description goes here (TODO).
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         August 2009
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 * $LastChangedDate: 2009-08-15 19:14:27 +0200(sab, 15 ago 2009) $
 */



#ifndef RTSS_MEM_ALLOC_HDR
#define RTSS_MEM_ALLOC_HDR
#if WIN32
    #include <os_specific/win_mem_alloc.h>  /* Scilab MALLOC, FREE for Win32 systems (Vista) */
#else
    #include <os_specific/sci_mem_alloc.h>  /* Scilab MALLOC, FREE */
#endif

/**
 * @brief Define NULL pointer value
 */
#ifndef NULL
    #define NULL ((void *)0)
#endif

/**
 * @brief OS specific malloc()
 * @param[in]  size number of bytes of memory to be allocated
 * @return pointer to the allocated memory
 */
#define rtss_malloc(size) MALLOC(size)

/**
 * @brief OS specific free()
 * @param[in]  ptr pointer to the memory allocation to be deallocated
 */
#define rtss_free(ptr) if(ptr != NULL) FREE((char *) ptr)
#endif /* RTSS_MEM_ALLOC */
