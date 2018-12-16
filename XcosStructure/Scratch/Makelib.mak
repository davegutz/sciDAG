# ------------------------------------------------------
# generated by builder.sce : Please do not edit this file
# see TEMPLATE makefile for Visual Studio
# see SCI/modules/dynamic_link/src/scripts/TEMPLATE_MAKEFILE.VC
# ------------------------------------------------------
SCIDIR = C:/PROGRA~1/SCILAB~1.2
# ------------------------------------------------------
# default include options 
INCLUDES = -I"$(SCIDIR)/libs/MALLOC/includes" \
-I"$(SCIDIR)/libs/f2c" \
-I"$(SCIDIR)/libs/hashtable" \
-I"$(SCIDIR)/libs/intl" \
-I"$(SCIDIR)/modules/core/includes" \
-I"$(SCIDIR)/modules/api_scilab/includes" \
-I"$(SCIDIR)/modules/call_scilab/includes" \
-I"$(SCIDIR)/modules/output_stream/includes" \
-I"$(SCIDIR)/modules/jvm/includes" \
-I"$(SCIDIR)/modules/localization/includes" \
-I"$(SCIDIR)/modules/dynamic_link/includes" \
-I"$(SCIDIR)/modules/mexlib/includes" \
-I"$(SCIDIR)/modules/time/includes" \
-I"$(SCIDIR)/modules/windows_tools/includes"
# ------------------------------------------------------
# SCILAB_LIBS is used by the binary version of Scilab for linking external codes
SCILAB_LIBS = "$(SCIDIR)/bin/blasplus.lib" \
"$(SCIDIR)/bin/libf2c.lib" \
"$(SCIDIR)/bin/core.lib" \
"$(SCIDIR)/bin/core_f.lib" \
"$(SCIDIR)/bin/lapack.lib" \
"$(SCIDIR)/bin/libintl.lib" \
"$(SCIDIR)/bin/intersci.lib" \
"$(SCIDIR)/bin/output_stream.lib" \
"$(SCIDIR)/bin/dynamic_link.lib" \
"$(SCIDIR)/bin/integer.lib" \
"$(SCIDIR)/bin/optimization_f.lib" \
"$(SCIDIR)/bin/libjvm.lib" \
"$(SCIDIR)/bin/scilocalization.lib" \
"$(SCIDIR)/bin/linpack_f.lib" \
"$(SCIDIR)/bin/call_scilab.lib" \
"$(SCIDIR)/bin/time.lib" \
"$(SCIDIR)/bin/api_scilab.lib" \
"$(SCIDIR)/bin/libintl.lib" \
"$(SCIDIR)/bin/scilab_windows.lib"
# ------------------------------------------------------
# name of the dll to be built
LIBRARY = libScratch
# ------------------------------------------------------
# list of files
FILES_SRC = lim_int_comp.c
# ------------------------------------------------------
# list of objects file
OBJS = lim_int_comp.obj
OBJS_WITH_PATH = Release/lim_int_comp.obj
# ------------------------------------------------------
# added libraries
FORTRAN_RUNTIME_LIBRARIES = 
OTHERLIBS = C:\PROGRA~1\SCILAB~1.2\bin\scicos.lib
# ------------------------------------------------------
!include $(SCIDIR)\modules\dynamic_link\src\scripts\Makefile.incl.mak
# ------------------------------------------------------
#CC = 
# ------------------------------------------------------
CFLAGS = $(CC_OPTIONS) -D__SCILAB_TOOLBOX__ -DFORDLL -IC:\PROGRA~1\SCILAB~1.2\modules\scicos_blocks\includes  
# ------------------------------------------------------
FFLAGS = $(FC_OPTIONS) -DFORDLL  
# ------------------------------------------------------
EXTRA_LDFLAGS = 
# ------------------------------------------------------
!include $(SCIDIR)\modules\dynamic_link\src\scripts\Makedll.incl
# ------------------------------------------------------
