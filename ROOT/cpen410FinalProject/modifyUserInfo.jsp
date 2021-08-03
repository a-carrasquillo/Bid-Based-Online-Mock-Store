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
		String currentPage="modifyUserInfo.jsp";
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
					session.setAttribute("currentPage", "modifyUserInfo.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
				    // Retrieve parameters from the form and remove
				    // the unnecessary spaces from the start and end
				    String currentUsername = request.getParameter("username").trim();
					String completeName = request.getParameter("completeName").trim();
					String email = request.getParameter("userEmail").trim();
					String userPass = request.getParameter("userPass");
					String userPassConfirm = request.getParameter("userPassConfirm");
					String userTelephone = request.getParameter("telephone").trim();
					String postalAddress = request.getParameter("postalAddress").trim();
					// Determine if the checkbox is available
					Boolean activateAvailable = request.getParameter("activate")!=null;

					// Perform Server-side validation
					// 1. Validate if the username is not available, if so,
					// is because of undesired modification of the HTML code
					// in listUsers.jsp
					if(!currentUsername.isEmpty()) {
						// The username is available
						// 2.Validate that minimum required fields are filled
						if((!completeName.isEmpty()) && (!email.isEmpty()) && (!userTelephone.isEmpty()) && (!postalAddress.isEmpty())) {
							// All minimum required fields are filled 
							// 3. Validate that the email at least have the @
							boolean errorEmail = email.indexOf("@") !=-1 ? false : true;
						    if(errorEmail) {
						    	// Since there is an error in the email field,
						    	// create a session variable to indicate this problem
					    		System.out.println("The email does not contain the @ ...");
					    		session.setAttribute("errorEmail", "true");
					    	}
					    	// 4. Validate that the passwords are the same
					    	boolean errorPassword = !(userPass.equals(userPassConfirm));
					    	if(errorPassword) {
							    // Create a session variable indicating that there
							    // is an error in the password
							    session.setAttribute("errorPassword", "true");
						    }
						    // Verify if there is an error with the email or the password
						    if(errorEmail||errorPassword) {
						    	// if there is an error with the email or the password,
						    	// perform the following:
							    // Create a session variable indicating that there is an error
							    session.setAttribute("error", "true");
							    // Create and fill the parameters of the user information before redirecting
							    session.setAttribute("usernameID", currentUsername);
								session.setAttribute("name", completeName);
								session.setAttribute("telephone", userTelephone);
								session.setAttribute("postalAddress", postalAddress);
								session.setAttribute("email", email);
								if(activateAvailable) {
									if(request.getParameter("activate").equals("activate"))
										session.setAttribute("active", "1");
									else
										session.setAttribute("active", "0");
								}
							    // redirect to the signup page
							    response.sendRedirect("modifyUser.jsp");
						    } else {
						    	// There are no empty required parameters neither
						    	// problems with the password and the password confirmation or email
						    	// Perform the DB Connection to use the required API
								applicationDBManager appDBMan = new applicationDBManager();
								System.out.println("Connecting...");
								System.out.println(appDBMan.toString());
								boolean active = false;
								// Determine which of the four methods of user update is required
								if(userPass.isEmpty() && !activateAvailable) {
									// Try to perform the update
									if(appDBMan.updateUserInfo(currentUsername, completeName, userTelephone, postalAddress, email)) {
										// update successful
										// delete all session variables related with errors
										// and temporary information
										session.setAttribute("errorUserMod", null);
										session.setAttribute("usernameID", null);
										session.setAttribute("name", null);
										session.setAttribute("telephone", null);
										session.setAttribute("postalAddress", null);
										session.setAttribute("email", null);
										session.setAttribute("active", null);
										session.setAttribute("errorEmail", null);
										session.setAttribute("errorPassword", null);
										// HTML code to generate a message indicating that the user
										// was modified successfully 
%>
							            <!DOCTYPE html>
							            <html>
							              <head>
							                <title>Redirecting...</title>
							                <meta http-equiv="Refresh" content="8;url=listUsers.jsp">
							                <style type="text/css">
							                  h1 {position: relative;margin-top: 25%;text-align: center;}
							                  body {background-color: rgb(59, 191, 151);}
							                </style>
							              </head>
							              <body>
							                <h1>User updated successfully, redirecting to List of Users page...</h1>
							              </body>
							            </html>
<%
									} else {
										// ERROR in the update
										// Set the session variables related with the error
										// and user information
										session.setAttribute("errorUserMod", "updateFail");
										session.setAttribute("errorEmail", null);
										session.setAttribute("errorPassword", null);
										session.setAttribute("usernameID", currentUsername);
										session.setAttribute("name", completeName);
										session.setAttribute("telephone", userTelephone);
										session.setAttribute("postalAddress", postalAddress);
										session.setAttribute("email", email);
										// Redirect to modifyUser.jsp
										response.sendRedirect("modifyUser.jsp");
									}
								} else if(userPass.isEmpty() && activateAvailable) {
									// Determine if the checkbox is selected
									active = request.getParameter("activate").equals("activate");
									// Try to perform the update
									if(appDBMan.updateUserInfo(currentUsername, completeName, userTelephone, postalAddress, active, email)) {
										// update successful
										//delete all session variables related with errors
										// and temporary information
										session.setAttribute("errorUserMod", null);
										session.setAttribute("usernameID", null);
										session.setAttribute("name", null);
										session.setAttribute("telephone", null);
										session.setAttribute("postalAddress", null);
										session.setAttribute("email", null);
										session.setAttribute("active", null);
										session.setAttribute("errorEmail", null);
										session.setAttribute("errorPassword", null);
										// HTML code to generate a message indicating that
										// the user was modified successfully
%>
							            <!DOCTYPE html>
							            <html>
							              <head>
							                <title>Redirecting...</title>
							                <meta http-equiv="Refresh" content="8;url=listUsers.jsp">
							                <style type="text/css">
							                  h1 {position: relative;margin-top: 25%;text-align: center;}
							                  body {background-color: rgb(59, 191, 151);}
							                </style>
							              </head>
							              <body>
							                <h1>User updated successfully, redirecting to List of Users page...</h1>
							              </body>
							            </html>
<%
									} else {
										// ERROR in the update
										// set the session variables related with the error
										// and the user information
										session.setAttribute("errorUserMod", "updateFail");
										session.setAttribute("errorEmail", null);
										session.setAttribute("errorPassword", null);
										session.setAttribute("usernameID", currentUsername);
										session.setAttribute("name", completeName);
										session.setAttribute("telephone", userTelephone);
										session.setAttribute("postalAddress", postalAddress);
										session.setAttribute("email", email);
										if(active)
											session.setAttribute("active", "1");
										else
											session.setAttribute("active", "0");
										// Redirect to modifyUser.jsp
										response.sendRedirect("modifyUser.jsp");
									}
								} else if(!userPass.isEmpty() && !activateAvailable) {
									// Try to perform the update
									if(appDBMan.updateUserInfo(currentUsername, userPass, completeName, userTelephone, postalAddress, email)) {
										// update successful
										// delete all session variables related with errors
										// and temporary information
										session.setAttribute("errorUserMod", null);
										session.setAttribute("usernameID", null);
										session.setAttribute("name", null);
										session.setAttribute("telephone", null);
										session.setAttribute("postalAddress", null);
										session.setAttribute("email", null);
										session.setAttribute("active", null);
										session.setAttribute("errorEmail", null);
										session.setAttribute("errorPassword", null);
										// HTML code to generate a message indicating that
										// the user was modified successfully
%>
							            <!DOCTYPE html>
							            <html>
							              <head>
							                <title>Redirecting...</title>
							                <meta http-equiv="Refresh" content="8;url=listUsers.jsp">
							                <style type="text/css">
							                  h1 {position: relative;margin-top: 25%;text-align: center;}
							                  body {background-color: rgb(59, 191, 151);}
							                </style>
							              </head>
							              <body>
							                <h1>User updated successfully, redirecting to List of Users page...</h1>
							              </body>
							            </html>
<%
									} else {
										// ERROR in the update
										// set the session variables related with the error
										// and the user information
										session.setAttribute("errorUserMod", "updateFail");
										session.setAttribute("errorEmail", null);
										session.setAttribute("errorPassword", null);
										session.setAttribute("usernameID", currentUsername);
										session.setAttribute("name", completeName);
										session.setAttribute("telephone", userTelephone);
										session.setAttribute("postalAddress", postalAddress);
										session.setAttribute("email", email);
										// Redirect to modifyUser.jsp
										response.sendRedirect("modifyUser.jsp");
									}
								} else {
									// Determine if the checkbox is selected
									active = request.getParameter("activate").equals("activate");
									// Try to perform the update
									if(appDBMan.updateUserInfo(currentUsername, userPass, completeName, userTelephone, postalAddress, active, email)) {
										// update successful
										//delete all session variables related with errors
										// and temporary information
										session.setAttribute("errorUserMod", null);
										session.setAttribute("usernameID", null);
										session.setAttribute("name", null);
										session.setAttribute("telephone", null);
										session.setAttribute("postalAddress", null);
										session.setAttribute("email", null);
										session.setAttribute("active", null);
										session.setAttribute("errorEmail", null);
										session.setAttribute("errorPassword", null);
										// HTML code to generate a message indicating that
										// the user was modified successfully
%>
							            <!DOCTYPE html>
							            <html>
							              <head>
							                <title>Redirecting...</title>
							                <meta http-equiv="Refresh" content="8;url=listUsers.jsp">
							                <style type="text/css">
							                  h1 {position: relative;margin-top: 25%;text-align: center;}
							                  body {background-color: rgb(59, 191, 151);}
							                </style>
							              </head>
							              <body>
							                <h1>User updated successfully, redirecting to List of Users page...</h1>
							              </body>
							            </html>
<%
									} else {
										// ERROR in the update
										// set the session variables related with the error
										// and the user information
										session.setAttribute("errorUserMod", "updateFail");
										session.setAttribute("errorEmail", null);
										session.setAttribute("errorPassword", null);
										session.setAttribute("usernameID", currentUsername);
										session.setAttribute("name", completeName);
										session.setAttribute("telephone", userTelephone);
										session.setAttribute("postalAddress", postalAddress);
										session.setAttribute("email", email);
										if(active)
											session.setAttribute("active", "1");
										else
											session.setAttribute("active", "0");
										// Redirect to modifyUser.jsp
										response.sendRedirect("modifyUser.jsp");
									}
								}
								// Close the DB connection
								appDBMan.close();
						    }
						} else {
							// One ore more of the required fields are empty. 
							// Create a session variable to indicate the error due
							// to empty parameters
							session.setAttribute("errorUserMod", "empty");
							// Create session variables to hold the filled information,
							// DO NOT INCLUDE THE PASSWORD, the password need to be reentered
							session.setAttribute("usernameID", currentUsername);
							session.setAttribute("name", completeName);
							session.setAttribute("telephone", userTelephone);
							session.setAttribute("postalAddress", postalAddress);
							session.setAttribute("email", email);
							if(activateAvailable) {
								if(request.getParameter("activate").equals("activate"))
									session.setAttribute("active", "1");
								else
									session.setAttribute("active", "0");
							}
							// Redirect to modifyUser.jsp
							response.sendRedirect("modifyUser.jsp");
						}
					} else {
						// error, manipulation of the HTML code
						System.out.println("The HTML code from listUsers.jsp has been modified because the username is empty... Redirecting to login page...");
						// Clear session variables
						session.setAttribute("currentPage", null);
						session.setAttribute("userName", null);
						session.setAttribute("errorUserMod", null);
						session.setAttribute("errorPassword", null);
						session.setAttribute("errorEmail", null);
						session.setAttribute("name", null);
						session.setAttribute("telephone", null);
						session.setAttribute("postalAddress", null);
						session.setAttribute("active", null);
						session.setAttribute("email", null);
						session.setAttribute("usernameID", null);
						// return to the login page
						response.sendRedirect("login.jsp");
					}
				} else {
					// the user can not be authenticated
					// Clear session variables
					session.setAttribute("currentPage", null);
					session.setAttribute("userName", null);
					session.setAttribute("errorUserMod", null);
					session.setAttribute("errorPassword", null);
					session.setAttribute("errorEmail", null);
					session.setAttribute("name", null);
					session.setAttribute("telephone", null);
					session.setAttribute("postalAddress", null);
					session.setAttribute("active", null);
					session.setAttribute("email", null);
					session.setAttribute("usernameID", null);
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
				session.setAttribute("errorUserMod", null);
				session.setAttribute("errorPassword", null);
				session.setAttribute("errorEmail", null);
				session.setAttribute("name", null);
				session.setAttribute("telephone", null);
				session.setAttribute("postalAddress", null);
				session.setAttribute("active", null);
				session.setAttribute("email", null);
				session.setAttribute("usernameID", null);
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
			session.setAttribute("errorUserMod", null);
			session.setAttribute("errorPassword", null);
			session.setAttribute("errorEmail", null);
			session.setAttribute("name", null);
			session.setAttribute("telephone", null);
			session.setAttribute("postalAddress", null);
			session.setAttribute("active", null);
			session.setAttribute("email", null);
			session.setAttribute("usernameID", null);
			// return to the login page
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>