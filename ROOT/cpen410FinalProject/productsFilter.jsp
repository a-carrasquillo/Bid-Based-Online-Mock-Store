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
		String currentPage="productsFilter.jsp";
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
					String userActualName = res.getString(3);
					
					// Create the current page attribute
					session.setAttribute("currentPage", "productsFilter.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
				    // Retrieve the product filter
					String search_filter = request.getParameter("search_filter").trim();
					// Verify the filter value
					if(search_filter.isEmpty()) {
						// delete filter session variable
						session.setAttribute("filter", null);
						// redirect to listProducts page
						response.sendRedirect("listProducts.jsp");
					} else if(search_filter.equals("active")) {
						// create filter session variable
						session.setAttribute("filter", "active");
						// redirect to listProducts page
						response.sendRedirect("listProducts.jsp");
					} else if(search_filter.equals("inactive")) {
						// create filter session variable
						session.setAttribute("filter", "inactive");
						// redirect to listProducts page
						response.sendRedirect("listProducts.jsp");
					} else {
						// error, clear session variables
						session.setAttribute("currentPage", null);
						session.setAttribute("userName", null);
						session.setAttribute("filter", null);
						System.out.println("Product search filter not recognized. Redirecting to login page...");
						// return to the login page
						response.sendRedirect("login.jsp");
					}
				} else {
					// the user can not be authenticated
					// Clear session variables
					session.setAttribute("currentPage", null);
					session.setAttribute("userName", null);
					session.setAttribute("filter", null);
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
				session.setAttribute("filter", null);
				// return to the login page
				response.sendRedirect("login.jsp");
			}
		} catch(Exception e) {
%>
			Nothing to show!
<%
			e.printStackTrace();
			// Clear session variables
			session.setAttribute("currentPage", null);
			session.setAttribute("userName", null);
			session.setAttribute("filter", null);
			// return to the login page
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>