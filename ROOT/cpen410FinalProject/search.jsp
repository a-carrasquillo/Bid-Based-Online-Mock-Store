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
		String currentPage="search.jsp";
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
					session.setAttribute("currentPage", "search.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}

					// Retrieve information from search bar
					String search = request.getParameter("search").trim();
					// Retrieve the departments from the filter
					String search_filter = request.getParameter("search_filter").trim();
					// Create session variables to store the search
					// and search filter values
					session.setAttribute("search", search);
					session.setAttribute("search_filter", search_filter);
					// Redirect to the welcomeMenu to perform the search there and show the results
					response.sendRedirect("welcomeMenu.jsp");
				} else {
					// the user can not be authenticated
					// Close any session associated with the user
					session.setAttribute("userName", null);
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
				// return to the login page
				response.sendRedirect("login.jsp");
			}
		} catch(Exception e) {
			e.printStackTrace();
			// Clear session variables
			session.setAttribute("currentPage", null);
			session.setAttribute("userName", null);
			// return to the login page
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>