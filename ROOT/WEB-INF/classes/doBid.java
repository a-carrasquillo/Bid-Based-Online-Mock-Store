// Import required java libraries
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import ut.JAR.CPEN410FINALPROJECT.*;
import java.sql.*;

/**
 *  This Servlet perform a bid to a product in the system.
 *
 *	 It returns a message with "true" if the bid was performed
 *	 successfully, else the message will be "false"
 *	
 *  Required values:
 *		username of the person who makes the bid: userName
 *		product Id: productId
 *		bid amount made to the product: bid
 *  @author a-carrasquillo
 */
public class doBid extends HttpServlet {

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
		out.println("This Servlet does not support the GET method! \n" + request.getSession().toString());
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
      String userName = request.getParameter("userName");
		String productId = request.getParameter("productId");
		String bid = request.getParameter("bid");
		
	   // Set response content type
	   response.setContentType("text/html");

	   // Define a PrintWriter object so the message can be send to the client
	   PrintWriter out = response.getWriter();
	     
	   // Perform the actual bid process
		String msg = performBid(userName, productId, bid);
		  
		// Send the final response to the requester
		out.println(msg);
		System.out.println(msg);
	  }

	/**
		<b>performBid method: </b>
			This method perform the bid process
			@param userName: username of the user
			@param productId: id of the product to which the bid is performed
			@param bid: amount of the bid
			@return A message indicating if the bid was successful.
					Successful = true
					Fail = false
	*/
   public String performBid(String userName, String productId, String bid) {
   	// Declaring and initializing the message
		String msg = "false";
		
		try {
			// Connect the the database
			applicationDBManager appDBMg = new applicationDBManager();
			System.out.println("Connecting...");
			System.out.println(appDBMg.toString());
		
			// try to make the bid
			if(appDBMg.makeBid(userName, productId, bid)) {
				// bid was successful
				msg = "true";
			}
			// close the connection to the DB
			appDBMg.close();
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {		
			// Return the actual message
			return msg;
		}
   }

   public void destroy() {
      // do nothing.
   }
}