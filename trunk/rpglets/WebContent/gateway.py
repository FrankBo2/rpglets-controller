
from com.ibm.as400.access import AS400Text 
from com.ibm.as400.access import ProgramCall
from com.ibm.as400.access import QSYSObjectPathName
from com.ibm.as400.access import ProgramParameter

from java.util import Properties

import sys
import array

global_LOG = False
global_LOG_FILE = sys.stdout 

class Parameter(Properties):    
    DEFAULT_OUTPUT_SIZE = 100000
    DEFAULT_SIZE = -1
    DATA_SIZE = -2;
    OUTPUT_SIZE = -3
    UNKNOWN_SIZE = 0;
    
    def __init__(self, out=sys.stderr):
        Properties.__init__(self)
        self.out = out
            
    def getBytes(self, size):
        parmStr = self.toString()
        if size == Parameter.DATA_SIZE:
            dataSize = len(parmStr)
        elif size == Parameter.UNKNOWN_SIZE:
            dataSize = len(parmStr);
        elif size == Parameter.DEFAULT_SIZE:
            dataSize = 65000;
        elif size == Parameter.OUTPUT_SIZE:
            dataSize = Parameter.DEFAULT_OUTPUT_SIZE
        else: dataSize = size    
            
        nulled = array.zeros( 'b', 3)
        nulled[0] = 0
        nulled[1] = 0
        nulled[2] = 0
        convertor = AS400Text(dataSize + 3, 37);

        return convertor.toBytes( parmStr + nulled.tostring() );
        
    def toString(self):        
        buffer =""        
        for key in self.keys():
            buffer  += '%s=%s\r' % ( key, self.getProperty(key) )
        #print "buffer " , buffer
        #"remove the last carriage return"
        return buffer[:-1]
        
    def load(self, data):
        data = data.strip()
                
        items = data.split("\r\n")
        #print >>self.out, 'items to load from string', items
        for item in items:
            item = item.strip('"')
            kv = item.split("=")            
            if kv and len(kv)>1:
                self[kv[0]] = kv[1]  

class GateWay:
    """ this is a proxy class for the gateway on the Python side """
    def __init__(self, input, control):        
        self.control = control
        self.input = input
        self.error = 0
    
    def setSystem(self, system):
        self.system = system

    def runRequest(self):
            
        pgm = ProgramCall(self.system)        
        programName = QSYSObjectPathName("*LIBL", "WEBRPGSERV", "PGM");
        output = Parameter(sys.stdout)    
        self.error = 0
        self.control.setProperty("ctrl_length", "65000")
        self.control.setProperty("out_length", "100000")
        self.control.setProperty("in_length", "32000")
        print  'input created', self.input
        pgmInput = ProgramParameter(self.input.getBytes(Parameter.DATA_SIZE), ProgramParameter.PASS_BY_REFERENCE)        
        programOutput = ProgramParameter(output.getBytes(Parameter.OUTPUT_SIZE),ProgramParameter.PASS_BY_REFERENCE);
        pgmControl = ProgramParameter(self.control.getBytes(Parameter.DEFAULT_SIZE), ProgramParameter.PASS_BY_REFERENCE);
        parameterList = array.array(ProgramParameter, [pgmInput, programOutput, pgmControl])        
        
        pgm.setProgram(programName.getPath(), parameterList);
        print  '<br> Remote Job strting' , pgm.serverJob
        ok = pgm.run()                
        print  '>>> Affter Run' , dir(pgm.messageList)
        if (not ok):
            print >>sys.stderr, 'No Successful'   
            self.messageList = []
            self.error = 1
            self.output = ""
            for message in pgm.getMessageList():
                print 'job returned a message ', message.__class__, dir(message)                 
                print 'Error Messages', message
                self.messageList.append(message)
                                 
            controller = parameterList[2].getOutputData();            
            self.control.load(AS400Text(len(controller), 37).toObject(controller));                
        else:    
            #logging.warning("gateway completed correctly")
            self.error = 0
            controller = parameterList[2].getOutputData();            
            self.control.load(AS400Text(len(controller), 37).toObject(controller));
            self.messageList = pgm.getMessageList()
            if global_LOG: print >>global_LOG_FILE, "Returned from an AS400 Call"
            if self.control.contains('FAIL'):
                print self.control.toString()
                self.error = 1
                self.output = self.control.toString()                            
            else:            
                print self.messageList
                results = parameterList[1].getOutputData();            
                self.output = AS400Text(len(results), 37).toObject(results)
            
        print 'Program State exceptions ', len(pgm.messageList)  
        return self