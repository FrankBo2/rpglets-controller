# Installation #

Please down load and install a servlet container 2.4+ and install it on your System-I.
I have successfully installed and ran it on the following servers Tomcat 6.0.16, Jetty 7.0 and IBM Websphere 6.1. )
Once The servlet container is started. Using a Deploy manager download and install rpglets.war into the container.

After this is done you should be able to get an error page response using the follwing request from your favourite browser. http://youriseries:port:/rpgcontext.py. This will tell you that you have successfully installed the web app correctly.

Now download and save the webobjs.savf onto a folder on your IfS folder( _your\_ifs\_folder_). Then on a 5250 session enter the following commands to extract the objects stored in the save files

  * CRTLIB LIB(RPGLETLIB)

  * CPYFRMSTMF FROMSTMF('/your\_ifs\_folder/webobjs.savf') TOMBR('/qsys.lib/RPGLETLIB.lib/WEBLETSAV.FILE')

> At this point you can take a peek at the save file to see what objects are contained inside using the **DSPSAVF RPGLETLIB/WEBLETSAV**

Restore all the saved objects in the save file into our created library

**RSTOBJ OBJ(**ALL) SAVLIB(APILIB) DEV(**SAVF) SAVF(RPGLETLIB/WEBLETSAV) RSTLIB(RPGLETLIB)**

You should have the following objects

```



WEBRPG_LET  *SRVPGM   RPGLE       QPGMR               368  YES
PROPERTIES  *SRVPGM   RPGLE       QPGMR               440  YES
ARRAYLIST   *SRVPGM   RPGLE       QPGMR              1020  YES
MESSAGE     *SRVPGM   RPGLE       QPGMR               184  YES
LLIST       *SRVPGM   RPGLE       QPGMR              1560  YES
REFLECTION  *SRVPGM   RPGLE       QPGMR               152  YES
JSON        *SRVPGM               QPGMR              2468  YES
LIBTREE     *SRVPGM               QPGMR              1060  YES
RPGSERVE    *BNDDIR               QPGMR                 8  YES
WEBTOOLS    *BNDDIR               QPGMR                 8  YES
JSON        *BNDDIR               QPGMR                 8  YES
```

Check that all the binding directory entries are pointing to the correct  library "RPGLETLIB"

You can now try the Hello World Example on the project home and compile it