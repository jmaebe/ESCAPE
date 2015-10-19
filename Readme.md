Introduction
============

ESCAPE is an interactive portable simulation environment of a 32 bit pipelined
and microprogrammed architecture based on Hennessy and Patterson's DLX.  The
main goal is to present students with an easy-to-understand custom-made
architecture that allows them to become familiar with the basic concepts of
computer architecture, without being overwhelmed by the complexity of realistic
microprocessor architectures.

ESCAPE was developed by Peter Verplaetse and Jan Van Campenhout at the
Electronics and Information Systems (ELIS) department at the University of
Ghent (http://www.elis.ugent.be). It was ported from Delphi to the Free Pascal
Compiler and Lazarus by Jonas Maebe from the same department.
 
ESCAPE was first presented at the Workshop on Computer Architecture Education
(WCAE) held in June 1998 in cojunction with ISCA-25 at Barcelona, Spain. A brief
paper on this topic also appeared in a special issue on Computer Architecture
Education of the IEEE Computer Society Technical Committee on Computer
Architecture (TCCA) Newsletter.


Prerequisites
=============

* Free Pascal Compiler 2.6.4 or newer: <http://www.freepascal.org/download.var>
* Lazarus IDE 1.4.2 or newer: <http://www.lazarus.freepascal.org>


Supported platforms
===================

ESCAPE is known to work on Windows, (Mac) OS X (PowerPC and i386) and Linux
(i386 and x86-64). Other platforms supported by both the Free Pascal Compiler
and Lazarus should also work.


Compilation
===========

1. Install the EscapeComponents package: add
EscapeComponents/escapecomponents.lpk according to the instructions at
<http://wiki.freepascal.org/Install_Packages#Adding_new_packages>
2. Build Escape in Lazarus (Run -> Build)

On Linux, the Qt widgetset may work better than the gtk2 widgetset.  Note that
if you did not install Lazarus using the package manager of your distribution,
you will have to also download and install the libQt4Pas library from
<http://users.pandora.be/Jan.Van.hijfte/qtforfpc/fpcqt4.html>


Additional information
======================

* Paper about ESCAPE can be downloaded from <http://users.elis.ugent.be/escape/download.html#papers>
* Sample exercises can be found at <http://users.elis.ugent.be/escape/exercises.html>
