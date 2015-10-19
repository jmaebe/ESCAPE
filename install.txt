Prerequisites
=============

Free Pascal Compiler 2.6.4 or newer: http://www.freepascal.org/download.var
Lazarus IDE 1.4.2 or newer: http://www.lazarus.freepascal.org


Supported platforms
===================

ESCAPE is known to work on Windows, (Mac) OS X (PowerPC and i386) and Linux
(i386 and x86-64). Other platforms supported by both the Free Pascal Compiler
and Lazarus should also work.


Compilation
===========

1. Install the EscapeComponents package: add
EscapeComponents/escapecomponents.lpk according to the instructions at
http://wiki.freepascal.org/Install_Packages#Adding_new_packages
2. Build Escape in Lazarus (Run -> Build)

On Linux, the Qt widgetset may work better than the gtk2 widgetset.  Note that
if you did not install Lazarus using the package manager of your distribution,
you will have to also download and install the libQt4Pas library from
http://users.pandora.be/Jan.Van.hijfte/qtforfpc/fpcqt4.html 
