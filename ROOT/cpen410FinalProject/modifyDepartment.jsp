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
		String currentPage = "modifyDepartment.jsp";
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
					session.setAttribute("currentPage", "modifyDepartment.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
					// Define and initialize a variable to hold
					// the department name
				    String department = "";
				    // determine if we come from listDepartments
				    // or changeDepartmentInfo
				    if(request.getParameter("departmentName")!=null) {
				    	// come from listDepartments
				    	// Retrieve the department name from the form
						department = request.getParameter("departmentName").trim();
				    } else {
				    	// come from changeDepartmentInfo
				    	// retrieve the department name from the session variable
				    	department = session.getAttribute("departmentName").toString().trim();
				    	// Delete the session variable since the
				    	// information was already retrieve
				    	session.setAttribute("departmentName", null);
				    }
					
					// Create an instance of the class where the required
					// API methods are located
					applicationDBManager appDBMnger = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMnger.toString());

					// Verify the integrity of the HTML code
					if(!department.isEmpty()) {
%>
						<!doctype html> 
						<html>
						    <head>
						    	<!--Define the encoding-->
						        <meta charset="utf-8">
						        <!--Define the authors of the page-->
						        <meta name="author" content="a-carrasquillo, arivesan">
						        <!--Import the style-sheet for page-->
						        <link rel="stylesheet" type="text/css" href="css/modifyDepartment.css">
						        <!--Import the icon shown in the tab-->
						        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
						        <!--Define the title of the page-->
						        <title>Heaven of Bids Administration</title>
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
						        <!--Left side Image-->
						        <div class="left_side">
						            <img class = "background" id="left_side" src="images/Bids_part1.png">
						        </div>
						        <!--Department Information Section-->
						        <div class = "center_square">
						            <form id="modifyDepartment" action="changeDepartmentInfo.jsp" method="post">
						                <!--Central message of the Center square-->
						                <h1>Modifying a Department</h1>
<%
										// Verify if there is an error message
										String errorDept = "";
										// determine if there is an error, if so,
										// retrieve the error message
										if(session.getAttribute("errorDept")!=null)
											errorDept = session.getAttribute("errorDept").toString().trim();
										
%>
						                <!--Error Message Section-->
						                <p id="errorDept"><%=errorDept%></p>
						                <!--Name Section-->
						                <div class="row">
						                    <span><b>Department Name: </b></span>
						                    <input type="hidden" name="oldDepartmentName" value="<%=department%>">
						                    <input type="text" id="departmentName" name="departmentName" placeholder="<%=department%>" maxlength="20" value="<%=department%>" required>
						                </div>
<%
										// Verify if the department is inactive 
										if(appDBMnger.isDepartmentInactive(department)) {
											// is inactive
%>
											<!--Checkbox for activating a department-->
							                <input type="checkbox" id="activateDepartment" name="activate" value="activate"><span id="activateDepTag"><label for="activateDepartment"> Activate Department</label></span> 
<%
										} else if(appDBMnger.isDepartmentActive(department)) {
											// is active
											// Message for debugging purposes
											System.out.println("The department is active, hence the checkbox is not shown.");
										} else {
											// Error, the department does not exists, hence the
											// HTML code has been manipulated
											// Clear session variables
											session.setAttribute("currentPage", null);
											session.setAttribute("userName", null);
											// Error Message
											System.out.println("The HTML code from listDepartments has been modified, redirecting to login...");
											// return to the login page
											response.sendRedirect("login.jsp");
										}
%> 
						                <!--Buttons-->
						                <div class="buttons">
						                    <button id ="cancel" type="button" onclick="window.location.href='cancelModDep.jsp';">Cancel</button>
						                    <button id ="submit" type="submit">Save Changes</button>
						                </div>
						            </form>
						        </div>
						        <!--Right Side Image-->
						        <div class="right_side">
						            <img class = "background" id="right_side" src="images/Bids_part2.png">
						        </div>
						    </body>
						</html>
<%
					} else {
						// error in the HTML code
						// Clear session variables
						session.setAttribute("currentPage", null);
						session.setAttribute("userName", null);
						// Error Message
						System.out.println("The HTML code from listDepartments has been modified, redirecting to login...");
						// return to the login page
						response.sendRedirect("login.jsp");
					}
					// Close the connection to the DB
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