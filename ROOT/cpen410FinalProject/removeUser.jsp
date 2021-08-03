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
		String currentPage="removeUser.jsp";
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
					session.setAttribute("currentPage", "removeUser.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
				    
				    // Retrieve the user name from the form
					String user = request.getParameter("userName").trim();
					// Create an instance of the class where the
					// required API method is located
					applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());
					// Verify the integrity of the HTML code
					if(!user.isEmpty()) {
						// HTML code to generate a message indicating
						// that the user was remove successfully or
						// there was an error
%>
						<!DOCTYPE html>
								<html>
									<head>
										<title>Redirecting...</title>
										<meta http-equiv="Refresh" content="8;url=listUsers.jsp">
										<link rel="icon" type="image/x-icon" href="images/favicon.ico">
										<meta charset="utf-8">
										<style type="text/css">
											h1 {position: relative; margin-top: 25%; text-align: center;}
											h1#error {color: red;}
											body {background-color: rgb(59, 191, 151);}
										</style>
									</head>
									<body>
<%
						// try to make inactive
						if(appDBMnger.makeUserInactive(user)) {
%>							
							<h1>User made inactive successfully, redirecting to List of Users...</h1>
<%
						} else {
%>							
							<h1 id="error">User can not be made inactive at the moment. If the problem persists contact the developers. Redirecting to List of Users...</h1>
<%
						}
%>
							</body>
						</html>
<%
					} else {
						// error in the HTML code
						// Clear session variables
						session.setAttribute("currentPage", null);
						session.setAttribute("userName", null);
						// Error Message
						System.out.println("The HTML code from listUsers has been modified, redirecting to login...");
						// return to the login page
						response.sendRedirect("login.jsp");
					}
					// close the connection to the DB
					appDBMnger.close();
				} else {
					// the user can not be authenticated
					// Clear session variables
					session.setAttribute("currentPage", null);
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
%>
			Nothing to show!
<%
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