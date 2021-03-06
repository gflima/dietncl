# Makefile.am -- Template for generating Makefile via Automake.
# Copyright (C) 2013-2017 PUC-Rio/Laboratorio TeleMidia
#
# This file is part of DietNCL.
#
# DietNCL is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# DietNCL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with DietNCL.  If not, see <http://www.gnu.org/licenses/>.

include $(top_srcdir)/build-aux/Makefile.am.common

SUBDIRS= dietncl tests
ACLOCAL_AMFLAGS= -I build-aux ${ACLOCAL_FLAGS}

# Setup code coverage.
include $(top_srcdir)/build-aux/Makefile.am.coverage
COVERAGE_EXCLUDE+= tests/\* dietncl/macros.h dietncl/luax-macros.h

# Setup version.
BUILT_SOURCES= .version
.version:
	$(AM_V_GEN)echo $(VERSION) > $@-t && mv $@-t $@

# Prepare distribution.
include $(top_srcdir)/build-aux/Makefile.am.gitlog
dist-hook:
	@echo $(VERSION) > $(distdir)/.tarball-version

EXTRA_DIST=\
  .version\
  README.md\
  build-aux/git-log-fix\
  build-aux/git-version-gen\
  build-aux/gitlog-to-changelog\
  build-aux/manywarnings.m4\
  build-aux/perl.m4\
  build-aux/syntax-check-copyright\
  build-aux/syntax-check\
  build-aux/useless-if-before-free\
  build-aux/util.m4\
  build-aux/warnings.m4\
  maint.mk\
  $(NULL)

DISTCLEANFILES+=\
  config.cache\
  $(NULL)

MAINTAINERCLEANFILES+=\
  .version\
  ChangeLog\
  INSTALL\
  aclocal.m4\
  build-aux/ar-lib\
  build-aux/compile\
  build-aux/config.guess\
  build-aux/config.sub\
  build-aux/depcomp\
  build-aux/install-sh\
  build-aux/libtool.m4\
  build-aux/ltmain.sh\
  build-aux/ltoptions.m4\
  build-aux/ltsugar.m4\
  build-aux/ltversion.m4\
  build-aux/lt~obsolete.m4\
  build-aux/missing\
  build-aux/mkinstalldirs\
  build-aux/test-driver\
  configure\
  dietncl/config.h.in\
  dietncl/config.h.in~\
  $(NULL)
