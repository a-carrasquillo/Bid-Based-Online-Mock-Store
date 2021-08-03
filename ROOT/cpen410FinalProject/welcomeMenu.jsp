<%@ page import="java.lang.*"%>
<%//Import the package where the API is located%>
<%@ page import="ut.JAR.CPEN410FINALPROJECT.*"%>
<%//Import the java.sql package to use MySQL related methods %>
<%@ page import="java.sql.*"%>
<!doctype html> 
<html>
    <head>
    	<!--Define the encoding-->
        <meta charset="utf-8">
        <!--Define the authors of the page-->
        <meta name="author" content="a-carrasquillo, arivesan">
        <!--Import the style-sheet for page-->
        <link rel="stylesheet" type="text/css" href="css/welcomeMenu.css">
        <!--Import the icon shown in the tab-->
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <!-- Load search icon library -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<%
	// perform the authentication process
	if((session.getAttribute("userName")==null) || (session.getAttribute("currentPage")==null)) {
		// delete session variables
		session.setAttribute("currentPage", null);
		session.setAttribute("userName", null);
		// return to the login page
		response.sendRedirect("login.jsp");
	} else {
		// Declare and define the current page, and get the username
		// and the previous page from the session variables
		String currentPage="welcomeMenu.jsp";
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
				ResultSet res = appDBAuth.verifyUserPageFlow(userName, currentPage, previousPage);
				if(res.next()) {
					// the user was authenticated
					// Get the user complete name and role
					String userActualName=res.getString(3);
					String userRole = res.getString(1);
					
					// Create the current page attribute
					session.setAttribute("currentPage", "welcomeMenu.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}

					// Verify the role of the user to load the webpage display
					if(!appDBAuth.isAdministrator(userRole)) {
						// Is a client
%>
							<!--Define the title of the page-->
							<title>Heaven of Bids</title>
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
					        <button class ="logout" type="button" onclick="window.location.href='signout.jsp';">Sign out</button>
        					<!--Sell Product Ad-->
					        <div class="sell">
					            <h2 id="sellHeader">Want to become part of Heaven of Bids?</h2>
					            <a id="sell_Link" href="sellProduct.jsp" ><b>Click Here to Sell a Product</b></a>
					        </div>
					        <!--Search Bar Section-->
					        <div class="search_bar">
					            <form id="search" action="search.jsp" method="post">
<%
								// clear the error session variable
								session.setAttribute("errorBid", null);
								// Declare a message variable
								String search = "";
								// Verify if there is a search
								Boolean noActiveSearch = (session.getAttribute("search")==null);
								if(noActiveSearch)
									search = "Search a product...";
								else
									search = session.getAttribute("search").toString();
								
%>
					                <input type="text" placeholder="<%=search%>" name="search" class="search" required>
					                <select name="search_filter" class="search_filter">
					                    <option value="">All Departments</option>
<%
										// Create the applicationDBManager object
					                	applicationDBManager appDBMan = new applicationDBManager();
					                	System.out.println("Connecting...");
										System.out.println(appDBMan.toString());
										// Create the applicationDBManager object
										applicationDBManager appDBMan2 = new applicationDBManager();
					                	System.out.println("Connecting...");
										System.out.println(appDBMan2.toString());
										// Retrieve the active departments from the DB
					                	res = appDBMan.listActiveDepartments();
					                	// Verify if there is a search filter
					                	String search_filter = "";
										if(session.getAttribute("search_filter")!=null) {
											// Retrieve the search filter value from the session variable
											search_filter = session.getAttribute("search_filter").toString();
										}
										// iterate over the result set with the active departments
					                	while(res.next()) {
					                		// if search filter is null or empty there is no selected
					                		// department as filter
					                		if(session.getAttribute("search_filter")==null || (search_filter.trim().isEmpty())) {
%> 
					                	   		<option value="<%=res.getString(1)%>"><%=res.getString(1)%></option>
<%	
					                		} else {
					                			// verify if there is a department that match the filter
					                			if(res.getString(1).equals(search_filter)) {
					                				// match
%> 
					                	   			<option value="<%=res.getString(1)%>" selected><%=res.getString(1)%></option>
<%	
					                			} else {
					                				// no match
%> 
					                	   			<option value="<%=res.getString(1)%>"><%=res.getString(1)%></option>
<%
					                			}
					                		}
					                	}
%>
					                </select>
                					<button type="submit" class="search_button" accesskey="enter"><i class="fa fa-search"></i></button>
            					</form>
        					</div>

<%							// Search == Null?
							if(noActiveSearch) {
%>
								<div class="results_area" id="top">
					          		<h2 id="noResultInfo">Products will be shown here when you perform a search.</h2>
					        	</div>
<%
							} else {
								// search is not null
								// get the search from the session variable
								search = session.getAttribute("search").toString();
								// Verify the search_filter to determine which method need to be called
								if(search_filter.trim().isEmpty()) {
									// search in all departments
									res = appDBMan.searchProductAllDepartments(search);
								} else {
									// need to search in an specific department
									res = appDBMan.searchProductByDepartments(search, search_filter);
								}
								// verify if there are results for the search
								if(!res.next()) {
					                //System.out.println("No Product Found for your search. Try changing your search or department...");
%>
									<div class="results_area" id="top">
					          			<h2 id="noResultInfo">No Product Found for your search. Try changing your search or department...</h2>
					        		</div>
<%
					            } else {
					            	// there is at least one result
					            	// Declare and initialize a result set
					            	ResultSet res2 = null;
					            	// reset result set pointer
					                res.beforeFirst();
					                // counter for the number of results
					                int resCount = 0;
					                while(res.next())
					                    resCount++;
					                
					                // reset result set pointer
					                res.beforeFirst();
					                // check if there is only one result
					                if(resCount==1) {
					                	// move the result set pointer to the first and only result
					                	res.next();
%>
										<div class="results_area" id="top">
								            <form class="product" action="detailsProduct.jsp" method="post">
								                <input type="hidden" class="ID" name="ID" value="<%=res.getString(1)%>">
								                <button type="submit" class="product_name"><%=res.getString(2)%></button>
								                <input type="text" class="bid" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
												// Declare and initialize a variable to hold the departments
												// that a product belongs to 
												String departments = "";
												// Retrieve the departments that a product belongs to 
												res2 = appDBMan2.departmentsBelongs(res.getString(1));
												// Declare and initialize a counter for the departments
												int depCounter = 0;
												// Count the number of departments
												while(res2.next())
													depCounter++;
												
												// reset result set pointer
					                			res2.beforeFirst();
					                			// Iterate over the result set
					                			while(res2.next()) {
													// Determine if there is more than 1 department
													if(depCounter>1) {
														// Concatenate the names of the departments separated
														// by commas
														departments += res2.getString(1) + ", ";
														// Decrease the number of departments
														depCounter--;
													} else {
														// Concatenate the last department
														departments += res2.getString(1);
													}
												}												
%>
								                <input type="text" class="departments" name="departments" readonly value="Departments: <%=departments%>">
								                <!--Product Image Section-->
								                <img src="usersData/<%=res.getString(4)%>">	
								            </form>
								        </div>
<%
					                } else {
					                	// there is more than one result for the search
					                	// Declare and initialize a counter
					                	int i = 1;
					                	// Iterate over the result set
					                	while(res.next()) {
						                    if(i==1) {
						                    	// first iteration
%>
										<div class="results_area" id="top">
								           <form class="product" action="detailsProduct.jsp" method="post">
								                <input type="hidden" class="ID" name="ID" value="<%=res.getString(1)%>">
								                <button type="submit" class="product_name"><%=res.getString(2)%></button>
								                <input type="text" class="bid" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
												// Declare and initialize a variable to hold the departments
												// that a product belongs to
												String departments = "";
												// Retrieve the departments that a product belongs to 
												res2 = appDBMan2.departmentsBelongs(res.getString(1));
												// Declare and initialize a counter for the departments
												int depCounter = 0;
												// Count the number of departments
												while(res2.next())
													depCounter++;
												
												// reset result set pointer
					                			res2.beforeFirst();
					                			// Iterate over the result set
					                			while(res2.next()) {
													// Determine if there is more than 1 department
													if(depCounter>1) {
														// Concatenate the names of the departments separated by commas
														departments += res2.getString(1) + ", ";
														// Decrease the number of departments
														depCounter--;
													} else {
														// Concatenate the last department
														departments += res2.getString(1);
													}
												}												
%>
								                <input type="text" class="departments" name="departments" readonly value="Departments: <%=departments%>">
								                <!--Product Image Section-->
								                <img src="usersData/<%=res.getString(4)%>">	
								            </form>
								        </div>
<%
												// increase the counter
												i++;
											} else if(i!=resCount) {
												// iteration between number 2 and rescount-1
%>
										<div class="results_area">
								           <form class="product" action="detailsProduct.jsp" method="post">
								                <input type="hidden" class="ID" name="ID" value="<%=res.getString(1)%>">
								                <button type="submit" class="product_name"><%=res.getString(2)%></button>
								                <input type="text" class="bid" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
												// Declare and initialize a variable to hold the departments
												// that a product belongs to
												String departments = "";
												// Retrieve the departments that a product belongs to 
												res2 = appDBMan2.departmentsBelongs(res.getString(1));
												// Declare and initialize a counter for the departments
												int depCounter = 0;
												// Count the number of departments
												while(res2.next())
													depCounter++;
												
												// reset result set pointer
					                			res2.beforeFirst();
					                			// Iterate over the result set
					                			while(res2.next()) {
													// Determine if there is more than 1 department
													if(depCounter>1) {
														// Concatenate the names of the departments separated by commas
														departments += res2.getString(1) + ", ";
														// Decrease the number of departments
														depCounter--;
													} else {
														// Concatenate the last department
														departments += res2.getString(1);
													}
												}												
%>
								                <input type="text" class="departments" name="departments" readonly value="Departments: <%=departments%>">
								                <!--Product Image Section-->
								                <img src="usersData/<%=res.getString(4)%>">	
								            </form>
								        </div>
<%
												// increase the counter
												i++;
											} else {
												// last iteration
%>
										<div class="results_area" id="bottom">
								           <form class="product" action="detailsProduct.jsp" method="post">
								                <input type="hidden" class="ID" name="ID" value="<%=res.getString(1)%>">
								                <button type="submit" class="product_name"><%=res.getString(2)%></button>
								                <input type="text" class="bid" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
												// Declare and initialize a variable to hold the departments
												// that a product belongs to
												String departments = "";
												// Retrieve the departments that a product belongs to
												res2 = appDBMan2.departmentsBelongs(res.getString(1));
												// Declare and initialize a counter for the departments
												int depCounter = 0;
												// Count the number of department
												while(res2.next()) {
													depCounter++;
												}
												// reset result set pointer
					                			res2.beforeFirst();
					                			// Iterate over the result set
					                			while(res2.next()) {
													// Determine if there is more than 1 department
													if(depCounter>1) {
														// Concatenate the names of the departments
														// separated by commas
														departments += res2.getString(1) + ", ";
														// Decrease the number of departments
														depCounter--;
													} else {
														// Concatenate the last department
														departments += res2.getString(1);
													}
												}												
%>
								                <input type="text" class="departments" name="departments" readonly value="Departments: <%=departments%>">
								                <!--Product Image Section-->
								                <img src="usersData/<%=res.getString(4)%>">	
								            </form>
								        </div>
<%
											}
											
						                }

					                }
					                // close the result set
					                res2.close();
					            }
							}
							// close the connection to the DB
							appDBMan2.close();
							appDBMan.close();
					} else {
						// Is an Admin
%>
							<!--Define the title of the page-->
							<title>Heaven of Bids Administration</title>
					    </head>
						<body>
					        <div class="header" id="admin">
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
					        <button class="logout" id="admin" type="button" onclick="window.location.href='signout.jsp';">Sign out</button>
					        <div class = "left_side_square">
					            <!--Central message of the left side square-->
					            <h1>Administrator Operations</h1> 
					            <!--Options that the Administrator can choose from--> 
<%	
									// Bring the menu from the database based on the username
					            	res = appDBAuth.menuElements(userName);
									
									String previousTitle = "";
									// Verify that the result set is not empty
									if(!res.isAfterLast()) {
										// Iterate through the result set
										while(res.next()) {
											// Verify that the title is different from the previous one
											if(!previousTitle.equals(res.getString(2))) {
%>
												<h2 class="optionClassTag"><%=res.getString(2)%>:</h2>
<%
											}
%>
											<button class="option" type="button" onclick="window.location.href='<%=res.getString(1)%>';"><%=res.getString(3)%></button>
															
<%
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
<%
						}
					} else {
						// the user can not be authenticated
						// Close any session associated with the user
						session.setAttribute("currentPage", null);
						session.setAttribute("userName", null);
						session.setAttribute("search", null);
						session.setAttribute("search_filter", null);
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
					session.setAttribute("search", null);
					session.setAttribute("search_filter", null);
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
			session.setAttribute("search", null);
			session.setAttribute("search_filter", null);
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>
    </body>
</html>