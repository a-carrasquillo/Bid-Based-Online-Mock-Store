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
		String currentPage="addNewUser.jsp";
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
					session.setAttribute("currentPage", "addNewUser.jsp");
					
					// Create or update a session variable for the username
					if (session.getAttribute("userName")==null)	{
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
				    // Retrieve parameters from the form and remove the unnecessary spaces from the start and end
					String completeName = request.getParameter("completeName").trim();
					String email = request.getParameter("userEmail").trim();
					String newUserName = request.getParameter("newUserName").trim();
					String userPass = request.getParameter("userPass");
					String userPassConfirm = request.getParameter("userPassConfirm");
					String userTelephone = request.getParameter("telephone").trim();
					String postalAddress = request.getParameter("postalAddress").trim();
   
				   // Perform Server-side validation
				   // 1. Validate if there is any empty parameter
				   if(completeName.isEmpty()||email.isEmpty()||newUserName.isEmpty()||userPass.isEmpty()||   userPassConfirm.isEmpty()||userTelephone.isEmpty()||postalAddress.isEmpty()) {
				    	// Create a session variable to indicate that an error occur due to empty parameters
					    session.setAttribute("error", "empty");
					    // Create and fill the parameters of the user information, as session variables, before redirecting
					    session.setAttribute("completeName", completeName);
					    session.setAttribute("userEmail", email);
					    session.setAttribute("newUserName", newUserName);
					    session.setAttribute("telephone", userTelephone);
					    session.setAttribute("postalAddress", postalAddress);
					    // redirect to the addUser page
					    response.sendRedirect("addUser.jsp");
				   } else {
				      // There are no empty parameters
						// 2. Validate that the email at least have the @
					    boolean errorEmail = email.indexOf("@") !=-1 ? false: true;
					    if(errorEmail) {
					      // Since there is an error in the email field, create a session variable to indicate this problem
				    		session.setAttribute("errorEmail", "true");
				    	}
					    // 3. Validate that the passwords are the same
					    boolean errorPassword = !(userPass.equals(userPassConfirm));
					    if(errorPassword) {
						    // Create a session variable indicating that there is an error in the password
						    session.setAttribute("errorPassword", "true");
					    }
					    // Verify if there is an error with the email or the password
					    if(errorEmail||errorPassword) {
					      // since there is an error with the email or the password, perform the following:
						    // Create a session variable indicating that there is an error
						    session.setAttribute("error", "true");
						    // Create and fill the parameters of the user information before redirecting
						    session.setAttribute("completeName", completeName);
						    session.setAttribute("userEmail", email);
						    session.setAttribute("newUserName", newUserName);
						    session.setAttribute("telephone", userTelephone);
						    session.setAttribute("postalAddress", postalAddress);
						    // redirect to the addUser page
						    response.sendRedirect("addUser.jsp");
					    } else {
					      // There are no empty parameters neither problems with the password or email
					    	// Verify if the user has been added
					    	if(appDBAuth.addUser(completeName, email, newUserName, userPass, userTelephone, postalAddress))	{
					    	  // Added successfully
					            // delete all session variables
					            session.setAttribute("error", null);
					            session.setAttribute("errorPassword", null);
					            session.setAttribute("errorEmail", null);
					            session.setAttribute("errorUsername", null);
					            session.setAttribute("completeName", null);
					            session.setAttribute("userEmail", null);
					            session.setAttribute("newUserName", null);
					            session.setAttribute("telephone", null);
					            session.setAttribute("postalAddress", null);
					            // HTML code to generate a message indicating that the user was added successfully 
%>
					            <!DOCTYPE html>
					            <html>
					              <head>
					                <title>Redirecting...</title>
					                <meta http-equiv="Refresh" content="8;url=welcomeMenu.jsp">
					                <style type="text/css">
					                  h1 {
					                      position: relative;
					                      margin-top: 25%;
					                      text-align: center;
					                  }
					                  body {
					                      background-color: rgb(59, 191, 151);
					                  }
					                </style>
					              </head>
					              <body>
					                <h1>User created successfully, redirecting to welcomeMenu page...</h1>
					              </body>
					            </html>
<%
    						} else {
    						  // Error while adding the user
					            // Create a session variable to indicate that there has been an error
					            session.setAttribute("error", "true");
					            // create a session variable to indicate that the user already exists
					            session.setAttribute("errorUsername", "true");
					            // Reset the session variables of errors due to password or email
					            session.setAttribute("errorPassword", null);
					            session.setAttribute("errorEmail", null);
					            // Create and fill the parameters of the user information before redirecting
					            session.setAttribute("completeName", completeName);
					            session.setAttribute("userEmail", email);
					            session.setAttribute("newUserName", newUserName);
					            session.setAttribute("telephone", userTelephone);
					            session.setAttribute("postalAddress", postalAddress);
					            // redirect to the addUser page
					            response.sendRedirect("addUser.jsp");
					    	}
				    	}
				    }
				} else {
				  // the user can not be authenticated
					// Clear session variables
					session.setAttribute("currentPage", null);
					session.setAttribute("userName", null);
					session.setAttribute("error", null);
					session.setAttribute("errorPassword", null);
					session.setAttribute("errorEmail", null);
					session.setAttribute("errorUsername", null);
					session.setAttribute("completeName", null);
					session.setAttribute("userEmail", null);
					session.setAttribute("newUserName", null);
					session.setAttribute("telephone", null);
					session.setAttribute("postalAddress", null);
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
				session.setAttribute("error", null);
				session.setAttribute("errorPassword", null);
				session.setAttribute("errorEmail", null);
				session.setAttribute("errorUsername", null);
				session.setAttribute("completeName", null);
				session.setAttribute("userEmail", null);
				session.setAttribute("newUserName", null);
				session.setAttribute("telephone", null);
				session.setAttribute("postalAddress", null);
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
			session.setAttribute("error", null);
			session.setAttribute("errorPassword", null);
			session.setAttribute("errorEmail", null);
			session.setAttribute("errorUsername", null);
			session.setAttribute("completeName", null);
			session.setAttribute("userEmail", null);
			session.setAttribute("newUserName", null);
			session.setAttribute("telephone", null);
			session.setAttribute("postalAddress", null);
			// return to the login page
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>