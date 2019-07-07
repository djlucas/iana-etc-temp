#!/usr/bin/gawk --re-interval -f
# the above doesn't work (stupid kernel) but serves as documentation

# Copyright (c) 2003-2004, 2006 Seth W. Klein <sk@sethwklein.net>
# Licensed under the Open Software License version 3.0
# See the file COPYING in the distribution tarball or
# http://www.opensource.org/licenses/osl-3.0.txt

BEGIN { print "# IANA protocols for LFS\n" }
(/<record/) { v=n="" }
(/<value/) { v=$3 }
(/<name/ && $3!~/ /) { n=$3 }
(/<description/) {d=$3}
(/<\/record/ && n && v!="") { printf "%-15s %3i %-15s\t# %s\n", tolower(n),v,n,d }

