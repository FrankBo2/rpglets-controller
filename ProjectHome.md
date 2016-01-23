Enables RPGLE/COBOL developers on the IBM i/ISeries/AS400 to write servlet/php like  programs using an Ibm I programming language of their choice.

Dependant on the following
  * [RPG Next Gen Properties](http://rpgnextgen.com/index.php?content=properties)
  * Web Servlet Container 2.3 I used [Apache Tomcat Server 6](http://tomcat.apache.org/download-60.cgi) or [Jetty 8.1.3 Server](http://dist.codehaus.org/jetty/jetty-hightide-8.1.3/jetty-hightide-8.1.3.v20120416.zip)
  * An IBM Toolbox for Java. You can use the [JTOpen on Sourceforge](http://sourceforge.net/projects/jt400/) compatible with the version of your System I, operating system
  * Python for java version 2.5+ [jython installer](http://sourceforge.net/projects/jython/files/jython/2.5.2/jython_installer-2.5.2.jar/download)



A Complete Hello World Program looks like this
```
     HBndDir('RPGSERVE')

     Dmain             PR                  EXTPGM('RPGLET1')
     D                                 *
     D                                 *
     D                                 *

     Dmain             PI
     D  pInput                         *
     D  pOutput                        *
     D  pConfig                        *

     D/COPY WEBRPG_H

      /free
        RPGLET_setContentType('text/html');
        RPGLET_printString('<h2>Hello Direct from RPG</h2>');

        *INLR = *On;
        return;

      /End-free     
```

You compile it. And You can access it by entering on the browser http://your_iseries:portNumber/rpglets/rpgcontext.py?request=RPGLET1

And you will get the following output

Please drop me an email if you have suggestions and any query