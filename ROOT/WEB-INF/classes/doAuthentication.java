// Import required java libraries
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import ut.JAR.CPEN410FINALPROJECT.*;
import java.sql.*;

/**
 *  This Servlet perform an authentication process.
 *	
 *  If the user is authenticated, it sends the user complete name.
 * 
 *  If the authentication fails, it sends "not" as the message
 *  or if it was an admin trying to gain access, it sends
 *  "admin" as message so in the client-side (Android Application)
 *	 we notify to the user that the administrators should only use
 *	 the web application.
 *
 *  Required values:
 *		userName: user
 *		passWord: pass
 *  @author a-carrasquillo
 */
public class doAuthentication extends HttpServlet {

   public void init() throws ServletException {
      // Do required initialization
   }

	/**
		<b>doGet method:</b>
			It is executed when the GET method is used for the HTTP request
			@param request: request sended by the client
			@param response: response send by the server to the client
	*/
   public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
	    // Set response content type
	    response.setContentType("text/html");

	    // Define a PrintWriter object so the message can be send to the client
	    PrintWriter out = response.getWriter();
	      
		// Send the response
		out.println("This Servlet does not support authentication via GET method! \n" + request.getSession().toString());
	  }

	/**
		<b>doPost method:</b> 
			This method is executed when the POST method is used for the HTTP request
			@param request: request sended by the client
			@param response: response send by the server to the client
	*/
	public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
		// Retrieve the HTTP request parameters
		String userName = request.getParameter("user");
		String passwd = request.getParameter("pass");
		 
	   // Set response content type
	   response.setContentType("text/html");

	   // Define a PrintWriter object so the message can be send to the client
	   PrintWriter out = response.getWriter();
	    
	   // Perform the actual authentication process
		String msg = doAuthentication(userName, passwd);
		  
		// Send the final response to the requester
		out.println(msg);
		System.out.println(msg);
	  }

	/**
		<b>doAuthentication method:</b> 
			This method perform an authentication process
			@param userName: username of the user
			@param userPass: password of the user
			@return An message indicating if the authentication was successful
				Successful = user's complete name
				Administrator = admin
				Fail = not
	*/
   public String doAuthentication(String userName, String userPass) {
   	// Declare and initialize the message
		String msg = "not";
		
		try {
			// Create the appDBAuth object
			applicationDBAuthentication appDBAuth = new applicationDBAuthentication();
			System.out.println("Connecting...");
			System.out.println(appDBAuth.toString());
			
			// Authenticate the user
			ResultSet res = appDBAuth.authenticate(userName, userPass);
		
			// Check for authentication result
			if(res.next()) {
				// Create the appDBAuth2 object
				applicationDBAuthentication appDBAuth2 = new applicationDBAuthentication();
				System.out.println("Connecting...");
				System.out.println(appDBAuth2.toString());
				// Verify if the user is administrator or client
				if(!appDBAuth2.isAdministrator(res.getString(2))) {
					// is a client, retrieve the client complete name
					msg = res.getString(3);
				} else {
					// admin
					msg = "admin";
				}
				// close the connection to the DB
				appDBAuth2.close();
			}
			// Close the result set
			res.close();
			// close the connection to the DB
			appDBAuth.close();
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally{	 	
			// Return the actual message
			return msg;
		}
   }

   public void destroy() {
      // do nothing.
   }
}