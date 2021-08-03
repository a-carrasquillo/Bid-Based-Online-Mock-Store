<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.CPEN410FINALPROJECT.*"%>
<%// Import the java.sql package to use MySQL related methods%>
<%@ page import="java.sql.*"%>

<%
	// Perform the authentication process
	if ((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null)) {
		// delete session variables
		session.setAttribute("currentPage", null);
		session.setAttribute("userName", null);
		// return to the login page
		response.sendRedirect("login.jsp");
	} else {
		// Declare and define the current page, and get the username and the previous page from the session variables
		String currentPage="addNewDepartment.jsp";
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
				if (res.next()) {
				  // the user was authenticated					
					// Create the current page attribute
					session.setAttribute("currentPage", "addNewDepartment.jsp");
					
					// Create or update a session variable for the username
					if (session.getAttribute("userName")==null) {
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
					// Create an instance of the class where the addDepartment method is located
				    applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());
					// Retrieve the department name from the form and eliminate undesired spaces at the beginning and the end of the parameter
					String department = request.getParameter("departmentName").trim();
					// Verify that the department variable is not empty
					if(!department.isEmpty()) {
						// Try to add the department
						if(appDBMnger.addDepartment(department)) {
						   // added successfully
							// Delete the session variables
							session.setAttribute("errorDept", null);
							session.setAttribute("departmentName", null);
							// HTML code to generate a message indicating that the department was added successfully
%>
							<!DOCTYPE html>
								<html>
									<head>
										<title>Redirecting...</title>
										<meta http-equiv="Refresh" content="8;url=welcomeMenu.jsp">
										<link rel="icon" type="image/x-icon" href="images/favicon.ico">
										<meta charset="utf-8">
										<style type="text/css">
											h1 {position: relative; margin-top: 25%; text-align: center;}
											body {background-color: rgb(59, 191, 151);}
										</style>
									</head>
									<body>
										<h1>Department added successfully, redirecting to welcomeMenu...</h1>
									</body>
								</html>
<%
						} else { //error
							// Verify the length of the department variable to
							// determine if the error was because the department
							// name already exists in the DB or the name was too
							// long and the user bypass the client-side
							// validation of the department name length 
							if(department.length() <= 40) {
								// Create error session variable
								session.setAttribute("errorDept", "The department name already exists in the system. Use another one or if it is Inactive go to department list using the inactive filter and by editing the department you can select to make it active again!!!");
								// Create a session variable for the department name
								session.setAttribute("departmentName", department);
								// redirect to the addDepartment page
								response.sendRedirect("addDepartment.jsp");
							} else {
								// Create error session variable
								session.setAttribute("errorDept", "The department name is too long... It can not be more than 40 characters including spaces!!!");
								// Create a session variable for the department name
								session.setAttribute("departmentName", department);
								// redirect to the addDepartment page
								response.sendRedirect("addDepartment.jsp");
							}
						}
					} else {
						// Create error session variable
						session.setAttribute("errorDept", "The department name field is empty!!!");
						// redirect to the addDepartment page
						response.sendRedirect("addDepartment.jsp");
					}
					// Close the connection to the DB
					appDBMnger.close();
				} else {
				   // the user can not be authenticated
					// Clear session variables
					session.setAttribute("currentPage", null);
					session.setAttribute("userName", null);
					session.setAttribute("errorDept", null);
					session.setAttribute("departmentName", null);
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
				session.setAttribute("errorDept", null);
				session.setAttribute("departmentName", null);
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
			session.setAttribute("errorDept", null);
			session.setAttribute("departmentName", null);
			// return to the login page
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>