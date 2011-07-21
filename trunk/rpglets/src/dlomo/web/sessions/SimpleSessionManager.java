package dlomo.web.sessions;

import java.util.logging.Logger;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import com.ibm.as400.access.AS400;

public class SimpleSessionManager implements HttpSessionListener {
	
	private boolean connectionFound;
	private AS400 as400;
	private String msg;
	
	private static Logger logger = Logger.getLogger(SimpleSessionManager.class.getCanonicalName()); 
	
	public void sessionCreated(HttpSessionEvent event) {
		try {
		//as400 = new AS400("localhost", "*CURRENT", "*CURRENT");
		as400 = new AS400("isd", "auxprd", "auxprd");	
		as400.connectService(AS400.COMMAND);
		connectionFound = true;
		msg = "connection ok";
		logger.warning(msg);
		} catch (Exception e) {
			connectionFound = false;
			msg = e.getMessage();
			e.printStackTrace();
			logger.severe(msg);
		} 
		event.getSession().setAttribute("db.connection.message",  msg );
		event.getSession().setAttribute("db.connection.error",  connectionFound );
		event.getSession().setAttribute("db.connector", as400);
		
	}

	public void sessionDestroyed(HttpSessionEvent event) {
		as400.disconnectAllServices();		
	}
	
}
