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
		String currentPage = "modifyUser.jsp";
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
					String userActualName = res.getString(3);
					
					// Create the current page attribute
					session.setAttribute("currentPage", "modifyUser.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
%>
					<!doctype html> 
					<html>
					    <head>
					    	<!--Define the encoding-->
					        <meta charset="utf-8">  
					        <!--Define the authors of the page-->
					        <meta name="author" content="a-carrasquillo, arivesan">
					        <!--Define the title of the page-->
					        <title>Heaven of Bids Administration</title>
					        <!--Import the style-sheet for page-->
					        <link rel="stylesheet" type="text/css" href="css/modifyUser.css">
					        <!--Import the icon shown in the tab-->
					        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
					         <!--Script to validate the email and the password with confirm password-->
					        <script>
					            function checkform() {
					                "use strict";
					                // Retrieving the value in the email box
					                var emailVal = document.signup.userEmail.value;
					                // Check if the email does not have the @
					                if(!emailVal.includes("@")) {
					                    // Show the error
					                    document.getElementById("errorEmail").value = "Emails must contain @";
					                    // Make the cursor go to the email box
					                    document.signup.userEmail.focus();
					                } else {
					                    //There is no error in the email, hence, we empty the error message
					                    document.getElementById("errorEmail").value = "";
					                }
					                // Retrieving the password and the confirmation of the password
					                var pass = document.signup.userPass.value;
					                var passConf = document.signup.userPassConfirm.value;
					                // Verify if the password is not the same as the confirmation password
					                if(pass!==passConf) {
					                    // Show the error message
					                    document.getElementById("errorPassword").value = "Passwords don't match!";
					                    // if there is no problem with the email, move the cursor to the confirm password box
					                    if(emailVal.includes("@")){
					                        document.signup.userPassConfirm.focus();
					                    }
					                } else {
					                    // if the passwords are the same, empty the error message
					                    document.getElementById("errorPassword").value = "";
					                }
					                // if there is any kind of problem return false, else, true. 
					                if(!emailVal.includes("@") || pass!=passConf){
					                   return false;
					                } else {
					                    return true;   
					                }
					            }
					        </script>
					    </head>
					    <body>
					        <div class="header">
					            <!--Small Bid Icon-->
					            <img class = "header_icon" src="images/BID.jpg"> 
					            <!--Left side clouds-->
					            <img class = "nube" id="nube1" src="images/nube.png">
					            <img class = "nube" id="nube2" src="images/nube.png">
					            <!--Central message-->
					            <h1>Welcome <%=userActualName%> to the Heaven of Bids</h1>
					            <!--Right side clouds-->
					            <img class = "nube" id="nube5" src="images/nube.png">
					            <img class = "nube" id="nube6" src="images/nube.png">
					            <img class = "nube" id="nube7" src="images/nube.png">
					            <img class = "nube" id="nube8" src="images/nube.png">
					        </div>
					        
					        <!--Logout/sign-out button-->
					        <button id ="logout" type="button" onclick="window.location.href='signout.jsp';">Sign out</button>
					        <!--Left side background image-->
					        <div class="left_side">
					            <img class = "background" id="left_side" src="images/Bids_part1.png">
					        </div>
					        <!--Section where the user information is presented-->
					        <div class = "center_square">
<%
							// Search the username of the user being edited,
							// either from a session variable or as parameter in a request
							String usernameID = "";
							if(session.getAttribute("errorUserMod")!=null)
								usernameID = session.getAttribute("usernameID").toString();
							else
								usernameID = request.getParameter("userName").trim();

							// Create an applicationDBManager object to connect to the DB
							applicationDBManager appDBMan = new applicationDBManager();
							System.out.println("Connecting...");
							System.out.println(appDBMan.toString());
							// Perform the a search to retrieve the info of the user
							res = appDBMan.searchUser(usernameID);
							// retrieve the information and store it in string variables
							String currentName="", currentTelephone="", currentPostalAddress="", currentActive="", currentEmail="";
							// If the result set have a result, retrieve the information 
							if(res.next()) {
								// user found
								currentName = res.getString(2);
								currentTelephone = res.getString(3);
								currentPostalAddress = res.getString(4);
								currentActive = res.getString(5);
								currentEmail = res.getString(6);
							} else {
								//error, username not found in the system due to
								// manipulation of the HTML code
								System.out.println("Error!!! Username not found due to manipulation of the HTML code... Redirecting to login page...");
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
							// Declare and initialize string variables to hold the user
							// information, at first the information will be the original one,
							// but if an error occurs the stored information will be the modified one
							String error="", name="", telephone="", postalAddress="", active="", email="", errorPassword="", errorEmail="";
							// Verify if there is an error
							if(session.getAttribute("errorUserMod")!=null) {
								// Retrieve the error and user information from the session variables
								error = session.getAttribute("errorUserMod").toString();
								// Identify the type of error
								if(error.equals("empty")) {
									// required field is empty
									error = "There is a required field that is empty. Password does not apply if is not being changed...";
								} else if(error.equals("updateFail")) {
									error = "The update FAIL, try again in a few minutes. If problem persists contact the developers";
								} else {
									//If there is an error in the password, show the message
									if(session.getAttribute("errorPassword")!=null) 
			                        	errorPassword = "The passwords do not match!!!";
			                        
			                        //If there is an error in the email format, show the message
			                        if(session.getAttribute("errorEmail")!=null)
			                            errorEmail = "The email must have the @";
			                        
								}
								// user information
								name = session.getAttribute("name").toString();
								telephone = session.getAttribute("telephone").toString();
								postalAddress = session.getAttribute("postalAddress").toString();
								active = session.getAttribute("active").toString();
								email = session.getAttribute("email").toString();
							} else {
								// no error, first time loading the page
								name = currentName;
								telephone = currentTelephone;
								postalAddress = currentPostalAddress;
								active = currentActive;
								email = currentEmail;
							}
%>
					            <!--Section where the user information is presented-->
					            <form action="modifyUserInfo.jsp" method="post" autocomplete="off">
					                <h1>Editing User Information</h1>
					                <p id="error"><%=error%></p>
					                <!--Username Section-->
					                <div class="row" id="top">
					                    <span><b>Username: </b></span>
					                    <input type="text" id="userName" name="username" required readonly value="<%=usernameID%>">
					                </div>
					                <!--Name Section-->
					                <div class="row">
					                    <span><b>Name: </b></span>
					                    <input type="text" id="completeName" name="completeName" placeholder="<%=currentName%>" value="<%=name%>" maxlength="30" required>
					                </div>
					                <!--Email Section-->
					                <div class="row">
					                    <span><b>Email: </b></span>
					                    <input type="email" id="userEmail" name="userEmail" placeholder="<%=currentEmail%>" value="<%=email%>" maxlength="45" required>
					                </div>
					                <!--Error message-->
                     				<input type="text" id="errorEmail" name="errorEmail" readonly value="<%=errorEmail%>">					                
					                <!--Password Section-->
					                <!--Clarifying Message-->
					                <p id="passMessage"><b>Note: Only fill the passwords fields if you want to change the user current password, else, let it blank.</b></p>
					                <div class="row">
					                    <span><b>Password: </b></span>
					                    <input type="password" id="userPass" name="userPass" placeholder="Enter your password" >
					                </div>
					                <!--Confirm Password Section-->
					                <div class="row">
					                    <span><b>Confirm Password: </b></span>
					                    <input type="password" id="userPassConfirm" name="userPassConfirm" placeholder="Reenter your password" >
					                </div>
					                <!--Error message-->
                      				<input type="text" id="errorPassword" name="errorPassword" readonly value="<%=errorPassword%>">
					                <!--Telephone Section-->
					                <div class="row">
					                    <span><b>Telephone: </b></span>
					                    <input type="text" id="telephone" name="telephone" placeholder="<%=currentTelephone%>" value="<%=telephone%>"  maxlength="15" required>
					                </div>
					                <!--Postal Address Section-->
					                <div class="row">
					                    <span><b>Postal Address: </b></span>
					                </div>
					                <textarea id="postalAddress" name="postalAddress" placeholder="<%=currentPostalAddress%>" maxlength="50" required><%=postalAddress%></textarea>
<%
									// verify if the current state of the user is inactive
									if(currentActive.equals("0")) {
										// verify the state of the user after being modified
										if(active.equals("0")) {
											// inactive user
%>	
											<!--Checkbox for activating a User-->
							                <div class="row">
							                    <input type="checkbox" id="activeDepartment" name="activate" value="activate"><span><label for="activeDepartment"> Activate User</label></span> 
							                </div>
<%
										} else if(active.equals("1")) {	
											// active user, so the checkbox has the checked property
%>	
											<!--Checkbox for activating a User-->
							                <div class="row">
							                    <input type="checkbox" id="activeDepartment" name="activate" value="activate" checked><span><label for="activeDepartment"> Activate User</label></span> 
							                </div>
<%
										} else {
											System.out.println("Error!!! User Active value not recognized ... Redirecting to login page...");
											// Clear Session Variables
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
											// Redirect to the login page
											response.sendRedirect("login.jsp");
										}
									} else if(currentActive.equals("1")) {
										System.out.println("The user is active, hence the checkbox is not shown...");
									} else {
										System.out.println("Error!!! User currentActive value not recognized ... Redirecting to login page...");
										// Clear Session Variables
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
										// Redirect to the login page
										response.sendRedirect("login.jsp");
									}
%>       
					                <!--Buttons-->
					                <div class="buttons">
					                    <button id ="cancel" type="button" onclick="window.location.href='cancelModUser.jsp';">Cancel Changes</button>
					                    <button id ="submit" type="submit">Save Changes</button>
					                </div>
					            </form>
					        </div>
					        <!--Right side background image-->
					        <div class="right_side">
					            <img class = "background" id="right_side" src="images/Bids_part2.png">
					        </div>
					    </body>
					</html>
<%
					// close the connection to the DB
				    appDBMan.close();
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
				//return to the login page
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