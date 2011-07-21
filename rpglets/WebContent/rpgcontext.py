import array
import binascii
import sys
import multifile 
import os
import java 
import javax
import tempfile
import traceback
#import gateway
import logging

from gateway import *

from java.io import File
from java.io import PrintStream
from java.util import Properties

from javax.servlet.http import HttpServlet
from com.ibm.as400.access import CommandCall
from com.ibm.as400.access import ProgramCall
from com.ibm.as400.access import QSYSObjectPathName
from com.ibm.as400.access import AS400Text
from com.ibm.as400.access import ProgramParameter

global_LOG = 0
global_LOG_FILE = sys.stderr 


"""
Experimental Error Handler - Will Change - Suggestions Welcomed
"""
def handleError(claz, exc, trcback, response):
    outstream = response.getOutputStream()
    tbformat = traceback.format_tb(trcback)
    if global_LOG: print >>global_LOG_FILE, 'determining error', trcback.__class__, dir(trcback)
    if global_LOG: print >>global_LOG_FILE, 'determining exception', exc.__class__, dir(exc)
    if global_LOG: print >>global_LOG_FILE, '====> Displaying ERROR CONTEXT <==='
    print >>outstream, "<h1>General Error Encounted</h1>"
    print >>outstream, "<h2>Exception : <b>%s</b><h2>" % ( claz )             
    print >>outstream, "<h3>Traceback</h3>"
    for line in tbformat:
        print >>outstream, "<br><code>", line, '</code>'
                        
    print >>outstream, "<h3>%s</h3>" % ('=' * 100)     
            
    if hasattr(exc, 'printStackTrace'):
        print >>outstream, exc.message, 'produced the following stacktrace<br><code>'
        stackList =  exc.getStackTrace()
        for stack in stackList:
            print >>outstream,'\t\t', stack, '<br/>'
        #exc.printStackTrace(PrintStream(outstream))
        print >>outstream, '</code>'
    else:
        if global_LOG: print >>global_LOG_FILE, '====> dictionary items <===', exc.__dict__
        exc_args = exc.__dict__.get('args', '')
        print >>outstream, "<h4>arguments :<i>", exc_args,"</i></h6>"             

#def logTrace(msg):
#    logging.warn("testing warning" + msg)
#    logging.error("testing error" + msg)
#    logging.exception("testing exception" + msg)
#    logging.info("mesaage" + msg )
    
    
class Dummy:
    def __init__(self):
        pass
    
servlet = Dummy
try :
    servlet = javax.servlet.http.HttpServlet    
except:
    print "Using Simple java Class"
    servlet = java.lang.Object

class rpgcontext(javax.servlet.http.HttpServlet ):
    def init(self, config):
        self.config = config
        #self.controll = Parameter()
    def doPost(self, request, response):    
        if global_LOG:
            global global_LOG_FILE 
            global_LOG_FILE = response.getOutputStream()    
        self.processRequest(request, response)
        
    def doGet(self, request, response):
        if global_LOG:
            global global_LOG_FILE
            global_LOG_FILE = response.getOutputStream() 

        self.processRequest(request, response)

    def getInputData(self, request):
        rmtuser = request.getRemoteUser() or ' ' 
        if global_LOG: print >> global_LOG_FILE, dir(request)
        if global_LOG: print >> global_LOG_FILE, 'remote user ', rmtuser
        if global_LOG: print >> global_LOG_FILE, '       host ', request.getRemoteHost()
        if global_LOG: print >> global_LOG_FILE, '       port ', request.getRemotePort()
        if global_LOG: print >> global_LOG_FILE, '    address ', request.getRemoteAddr()
       
        self.controll.setProperty('session.remote.user',  rmtuser )
        self.controll.setProperty('session.remote.host',  request.getRemoteHost() )
        self.controll.setProperty('session.remote.address',  request.getRemoteAddr() )
        self.controll.setProperty('session.remote.port',  `request.getRemotePort()` )   
             
        input = Parameter()
        for p in request.parameterNames:
            if p in ( 'control.gateway', 'control.web.framework', 'control.view.content.type'):
                self.controll.setProperty(p.replace('control.',''), request.getParameter(p))
            else:
                input.setProperty(p, request.getParameter(p))
        return input

    def invokeRPGContainer(self, request):
        session = request.getSession()
        self.connection = session.getAttribute('db.connector')
        if global_LOG: print >>global_LOG_FILE, 'have connection', self.connection
        input = self.getInputData(request)        
        cmd = CommandCall(self.connection)        
        cmd.run('ADDLIBLE APILIB')
        if global_LOG: print >>global_LOG_FILE, 'did command ', self.connection
        self.controll.setProperty('SERVER_JOB', cmd.getServerJob().toString() );
        #response.setHeader('server-job', cmd.getServerJob().toString())        
        if global_LOG: print >>global_LOG_FILE, 'have server job', cmd.getServerJob().toString()
        handler = GateWay(input, self.controll)
        if global_LOG: print >>global_LOG_FILE, 'have gteway', handler
        handler.setSystem(self.connection)
        if global_LOG: print >>global_LOG_FILE, 'have connection attached to gateway',  handler
        handler = handler.runRequest()
        if global_LOG: print >>global_LOG_FILE,  'gateway executed ', handler
        return handler
    
    #def getJobContext(self, request, response):

        
    def processRequest(self, request, response):
        try:
            if global_LOG: response.setContentType("text/plain")
            self.controll = Parameter()
            requestHandler = self.invokeRPGContainer(request)
            #print >>outstream, "gateway " + gateway.error
            if requestHandler.error:
                outstream = response.getOutputStream()
                response.setContentType("text/html")
                print >>outstream, self.controll['SERVER_JOB']
                for message in requestHandler.messageList:
                    print >>outstream, "<br>" ,message
                print >>outstream, "<h1>Internal RPG SERVE ERROR Encounted</h1>"
                state = self.controll.getProperty("STATE", " "*200)
                print >>outstream, "<h1>", state[90: 170].strip(), "</h1>"
                print >>outstream, requestHandler.output
            else:
                response.setContentType(self.controll['contentType'])
                outstream = response.getOutputStream()
                if global_LOG: print >>global_LOG_FILE, '====> Displaying content<===' 
                print >>outstream, requestHandler.output        
        except:
            claz, exc, trcback = sys.exc_info()
            handleError(claz, exc, trcback, response)
            
