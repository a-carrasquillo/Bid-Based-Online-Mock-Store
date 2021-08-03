<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.CPEN410FINALPROJECT.*"%>
<%// Import the java.sql package to use MySQL related methods %>
<%@ page import="java.sql.*"%>

<%
	// Perform the authentication process
	if((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null)) {
		// delete session variables
		session.setAttribute("currentPage", null);
		session.setAttribute("userName", null);
		// return to the login page
		response.sendRedirect("login.jsp");
	} else {
		// Declare and define the current page, and get the username
		// and the previous page from the session variables
		String currentPage = "makeBid.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		
		// Try to connect the database using the applicationDBAuthentication class
		try {
			// Create the appDBAuth object
			applicationDBAuthentication appDBAuth = new applicationDBAuthentication();
			System.out.println("Connecting...");
			System.out.println(appDBAuth.toString());
				
			// Verify if the user has access to this page
			if(appDBAuth.verifyUserPageAccess(userName, currentPage)) {
				// The user have access to the current page
				// Verify that the user is following the page flow
				ResultSet res =appDBAuth.verifyUserPageFlow(userName, currentPage, previousPage);
				if(res.next()) {
					// the user was authenticated
					// Create the current page attribute
					session.setAttribute("currentPage", "makeBid.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}

					// Retrieve the ID of the product from the request
					String ID = request.getParameter("ID").trim();
					// Verify if the ID is empty there has been
					// some manipulation in the code
					if(ID.isEmpty()) {
						System.out.println("There has been some manipulation in the HTML code, and the ID is empty. Redirecting to login.jsp ...");
						// Close any session associated with the user
						session.setAttribute("userName", null);
						session.setAttribute("currentPage", null);
						session.setAttribute("search", null);
						session.setAttribute("search_filter", null);
						// return to the login page
						response.sendRedirect("login.jsp");
					}

					// Retrieve the new bid of the product from the request
					String newBid = request.getParameter("newBid").trim();
					// Verify if the newBid is empty, if so the client
					// bypass the client-side validation
					if(newBid.isEmpty()) {
						// Error, set the session variables related
						// to the error and ID of the product
						session.setAttribute("errorBid", "The bid field is empty. Enter a valid Value.");
						session.setAttribute("ID", ID);
						// return to the detailsProduct page
						response.sendRedirect("detailsProduct.jsp");
					} else {
						// New bid field has a value
						// Perform the connection to the DB
						applicationDBManager appDBMan = new applicationDBManager();
						System.out.println("Connecting...");
						System.out.println(appDBMan.toString());
						// Try to perform the bid
						if(appDBMan.makeBid(userName, ID, newBid)) {
							// bid was successful
							// Clear error session variable
							session.setAttribute("errorBid", null);
							// Set a session variable for the product ID
							session.setAttribute("ID", ID);
							// return/redirect to the detailsProduct page
							response.sendRedirect("detailsProduct.jsp");
						} else {
							// bid was not successful
							// Set a session variable for the error message
							session.setAttribute("errorBid", "Bid Not Allow!!!");
							// Set a session variable for the product ID
							session.setAttribute("ID", ID);
							// return/redirect to the detailsProduct page
							response.sendRedirect("detailsProduct.jsp");
						}
						// Close the connection to the database
						appDBMan.close();
					}
				} else {
					// the user can not be authenticated
					// Close any session associated with the user
					session.setAttribute("userName", null);
					session.setAttribute("currentPage", null);
					session.setAttribute("search", null);
					session.setAttribute("search_filter", null);
					session.setAttribute("errorBid", null);
					// return to the login page
					response.sendRedirect("login.jsp");
				}
				// close the result set
				res.close();
				// Close the connection to the database
				appDBAuth.close();
			} else {
				// The user does not have access to the current page
				// Clear session variables
				session.setAttribute("currentPage", null);
				session.setAttribute("userName", null);
				session.setAttribute("search", null);
				session.setAttribute("search_filter", null);
				session.setAttribute("errorBid", null);
				// return to the login page
				response.sendRedirect("login.jsp");
			}
		} catch(Exception e) {
			e.printStackTrace();
			// Clear session variables
			session.setAttribute("currentPage", null);
			session.setAttribute("userName", null);
			session.setAttribute("search", null);
			session.setAttribute("search_filter", null);
			session.setAttribute("errorBid", null);
			// return to the login page
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>