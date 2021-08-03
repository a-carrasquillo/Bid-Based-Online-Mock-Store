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
		String currentPage="addDepartment.jsp";
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
					session.setAttribute("currentPage", "addDepartment.jsp");
					
					// Create or update a session variable for the username
					if (session.getAttribute("userName")==null)
						// create the session variable
						session.setAttribute("userName", userName);
					 else
						// Update the session variable
						session.setAttribute("userName", userName);
					
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
		        <link rel="stylesheet" type="text/css" href="css/addDepartment.css">
		        <!--Import the icon shown in the tab-->
		        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
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
        		<div class = "left_side_square">
	            <!--Central message of the left side square-->
	            <h1>Administrator Operations</h1> 
	            <!--Options that the Administrator can choose from-->
<%
					// Bring the menu from the database based on the username
				   	res = appDBAuth.menuElements(userName);
					
					String previousTitle = "";
					//Verify that the result set is not empty
					if(!res.isAfterLast()) {
						// Iterate through the result set 
						while(res.next()) {
							//Verify that the title is different from the previous one
							if(!previousTitle.equals(res.getString(2))) {
%>
								<h2 class="optionClassTag"><%=res.getString(2)%>:</h2>
<%
							}
							// Verify if the current page is the same as the one recover from the DB
							if(currentPage.equals(res.getString(1))) {
								// Since is the same page, remove the link and set an active id
%>
								<button class="option" type="button" id="active"><%=res.getString(3)%></button>							
<%
							} else {
								// Since it's not the same page, get the link to the page and do not use an active id
%>
								<button class="option" type="button" onclick="window.location.href='<%=res.getString(1)%>';"><%=res.getString(3)%></button>							
<%								
							}
							// update the previous title variable for the next iteration
							previousTitle = res.getString(2);
						}
					} else {
						System.out.println("The user does not have a menu option...");
						// Clear session variables
						session.setAttribute("currentPage", null);
						session.setAttribute("userName", null);
						// return to the login page
						response.sendRedirect("login.jsp");
					}
%>
		        </div>
		        <img class = "background" src="images/Bids.png">
		        <!--Section where the information of the new department is filled-->
		        <div class = "right_side_square">
		            <form id="addDepartment" action="addNewDepartment.jsp" method="post">
		                <!--Central message of the right side square-->
		                <h1>Adding a Department</h1> 
<%
						// Define the variables related with an error in the new department processing 
						String errorDept = "", departmentName = "";
						// Verify if there is an error
						if(session.getAttribute("errorDept")!=null) {
							// Get the error and department name from the session variables
							errorDept = session.getAttribute("errorDept").toString();
							departmentName = session.getAttribute("departmentName").toString();
						}
%>
						<!--Error Message-->
		                <p id="errorDept"><%=errorDept%></p>
		                <!--Name Section-->
		                <div class="row">
		                    <span><b>Department Name: </b></span>
		                    <input type="text" id="departmentName" name="departmentName" placeholder="Enter the new department name" maxlength="40" value="<%=departmentName%>" required>
		                </div>
		                <!--Buttons Section-->
		                <div class="buttons">
		                    <button id ="cancel" type="button" onclick="window.location.href='cancelNewDepartment.jsp';">Cancel</button>
		                    <button id ="submit" type="submit">Add</button>
		                </div>
		            </form>
		        </div>
		    </body>
		</html>
<%
				} else {
				   // the user can not be authenticated
					// Close any session associated with the user
					session.setAttribute("userName", null);
					session.setAttribute("currentPage", null);
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