<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.CPEN410FINALPROJECT.*"%>
<%// Import the java.sql package to use MySQL related methods %>
<%@ page import="java.sql.*"%>

<%
	// Check the authentication process
	if((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null))	{
		// delete session variables
		session.setAttribute("currentPage", null);
		session.setAttribute("userName", null);
		// return to the login page
		response.sendRedirect("login.jsp");
	} else {
		// Declare and define the current page, and get the username and the
		// previous page from the session variables
		String currentPage="changeDepartmentInfo.jsp";
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
					// Get the user complete name
					String userActualName=res.getString(3);
					
					// Create the current page attribute
					session.setAttribute("currentPage", "changeDepartmentInfo.jsp");
					
					// Create or update a session variable for the username
					if (session.getAttribute("userName")==null)	{
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
				    
				    // Retrieve the new department name from the form
					String department = request.getParameter("departmentName").trim();
					// Retrieve the old name of the department
					String oldDepartment = request.getParameter("oldDepartmentName").trim();
					// Check if the checkbox is available
					boolean activateAllowed = request.getParameter("activate") != null;
					// Default value to determine if the checkbox was not present
					// in the HTML code
					String activate = "notAllowed";
					// Create an instance of the class where the required API
					// methods are located
					applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());
					// verify if the oldDepartment is empty meaning that there is
					// an error or manipulation in the HTML code of
					// modifyDepartment.jsp
					if(!oldDepartment.isEmpty()) {
					  // oldDepartment name is OK
						// Verify if the department field is empty, meaning that
						// the user bypass the client-side validation
						if(!department.isEmpty()) {
							// Get the value if the checkbox if exists and
							// Determine which method of the API need to be called
							if(activateAllowed)	{
								activate = request.getParameter("activate").toString().trim();
								// Verify if the checkbox value is activate
								if(activate.equals("activate")) { 
								  // change name and status
									// Try to update
									if(appDBMnger.changeDepartmentNameAndStatus(oldDepartment, department, "1")) {
									  // update was perform successfully
										// HTML code to generate a message
										// indicating that the department was
										// modified successfully
%>
										<!DOCTYPE html>
										<html>
											<head>
												<title>Redirecting...</title>
												<meta http-equiv="Refresh" content="8;url=listDepartments.jsp">
												<link rel="icon" type="image/x-icon" href="images/favicon.ico">
												<meta charset="utf-8">
												<style type="text/css">
													h1 {position: relative; margin-top: 25%; text-align: center;}
													body {background-color: rgb(59, 191, 151);}
												</style>
											</head>
											<body>
												<h1>Department update we a success, redirecting to List of Departments...</h1>
											</body>
										</html>
<%
									} else {
									  // update was not perform, high chance due to primary key conflict
										// create the session variables
										session.setAttribute("errorDept", "The Department Name \"" +department + "\" Already Exists... Go to List Of Departments using Inactive Filter and Search for it and by Editing you can make it available again. If the problem persists contact the developers.");
										session.setAttribute("departmentName", oldDepartment);
										// return to the modifyDepartment page
										response.sendRedirect("modifyDepartment.jsp");
									}
								} else {
								  // only change name
									// Try to update
									if(appDBMnger.changeDepartmentName(oldDepartment, department)) {
									  // update was perform successfully
										// HTML code to generate a message
										// indicating that the department was
										// modified successfully
%>
										<!DOCTYPE html>
										<html>
											<head>
												<title>Redirecting...</title>
												<meta http-equiv="Refresh" content="8;url=listDepartments.jsp">
												<link rel="icon" type="image/x-icon" href="images/favicon.ico">
												<meta charset="utf-8">
												<style type="text/css">
													h1 {position: relative; margin-top: 25%; text-align: center;}
													body {background-color: rgb(59, 191, 151);}
												</style>
											</head>
											<body>
												<h1>Department update we a success, redirecting to List of Departments...</h1>
											</body>
										</html>
<%
									} else {
									  // update was not perform, high chance due to primary key conflict
										// create the session variables
										session.setAttribute("errorDept", "The Department Name \"" +department + "\" Already Exists... Go to List Of Departments using Inactive Filter and Search for it and by Editing you can make it available again. If the problem persists contact the developers.");
										session.setAttribute("departmentName", oldDepartment);
										// return to the modifyDepartment page
										response.sendRedirect("modifyDepartment.jsp");
									}
								}
							} else {
							  // Checkbox is not present, just update the dept. name
								// Try to update
								if(appDBMnger.changeDepartmentName(oldDepartment, department)) {
								  // update was perform successfully
									// HTML code to generate a message indicating that the department was modified successfully
%>
									<!DOCTYPE html>
									<html>
										<head>
											<title>Redirecting...</title>
											<meta http-equiv="Refresh" content="8;url=listDepartments.jsp">
											<link rel="icon" type="image/x-icon" href="images/favicon.ico">
											<meta charset="utf-8">
											<style type="text/css">
												h1 {position: relative; margin-top: 25%; text-align: center;}
												body {background-color: rgb(59, 191, 151);}
											</style>
										</head>
										<body>
											<h1>Department update we a success, redirecting to List of Departments...</h1>
										</body>
									</html>
<%
								} else {
								  // update was not perform, high chance due to primary key conflict
									// create the session variables
									session.setAttribute("errorDept", "The Department Name \"" +department + "\" Already Exists... Go to List Of Departments using Inactive Filter and Search for it and by Editing you can make it available again. If the problem persists contact the developers.");
									session.setAttribute("departmentName", oldDepartment);
									// return to the modifyDepartment page
									response.sendRedirect("modifyDepartment.jsp");
								}
							}
						} else {
						  // error the field is empty
							// create the session variables
							session.setAttribute("errorDept", "The field is empty. Please enter the new name of the department.");
							session.setAttribute("departmentName", oldDepartment);
							// return to the modifyDepartment page
							response.sendRedirect("modifyDepartment.jsp");
						}
							
					} else {
						// oldDepartment name is empty meaning an error
						System.out.println("The oldDepartment hidden field is empty. Hence there is an error or not desire manipulation of the HTML code from modifyDepartment.jsp");
						// Clear session variables
						session.setAttribute("currentPage", null);
						session.setAttribute("userName", null);
						// return to the login page
						response.sendRedirect("login.jsp");
					}
					// close connection to the DB
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