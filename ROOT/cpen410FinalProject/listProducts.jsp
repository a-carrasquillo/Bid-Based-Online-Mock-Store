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
		// Declare and define the current page, and get the
		// username and the previous page from the session variables
		String currentPage = "listProducts.jsp";
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
					session.setAttribute("currentPage", "listProducts.jsp");
					
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
					        <!--Import the style-sheet for page-->
					        <link rel="stylesheet" type="text/css" href="css/listProducts.css">
					        <!--Import the icon shown in the tab-->
					        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
					        <!--Define the title of the page-->
					        <title>Heaven of Bids Administration</title>
					        <!-- Load icon library -->
					        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
									// Bring the menu from the database
									// based on the username
								   	res = appDBAuth.menuElements(userName);
									
									String previousTitle = "";
									// Verify that the result set is not empty
									if(!res.isAfterLast()) {
										// Iterate through the result set
										while(res.next()) {
											// Verify that the title is different
											// from the previous one
											if(!previousTitle.equals(res.getString(2))) {
%>
												<h2 class="optionClassTag"><%=res.getString(2)%>:</h2>
<%
											}
											// Verify if the current page is the
											// same as the one recover from the DB
											if(currentPage.equals(res.getString(1))) {
												// Since is the same page, remove
												// the link and set an active id
%>
												<button class="option" type="button" id="active"><%=res.getString(3)%></button>							
<%
											} else {
												// Since it's not the same page,
												// get the link to the page and
												// do not use an active id
%>
												<button class="option" type="button" onclick="window.location.href='<%=res.getString(1)%>';"><%=res.getString(3)%></button>							
<%								
											}
											// update the previous title
											// variable for the next iteration
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
							<img class="background" src="images/Bids.png">
<%
							// Create an instance of the class where the
							// required API methods are located
						    applicationDBManager appDBMnger = new applicationDBManager();
							System.out.println("Connecting...");
							System.out.println(appDBMnger.toString());
							// Create an instance of the class where the
							// required API methods are located
							applicationDBManager appDBMan2 = new applicationDBManager();
					        System.out.println("Connecting...");
							System.out.println(appDBMan2.toString());
							// Define and initialize boolean variables that will
							// help determine which method of the API needs
							// to be called
							Boolean allProducts=false, activeProducts=false, inactiveProducts=false;
							// If the filter is null, means that the
							// administrator wants to see all the products
							allProducts = session.getAttribute("filter")==null;
							if(allProducts) {
								// all products list
								res = appDBMnger.infoForListProducts();
							} else {
								// Verify if the filter indicates active
								// or inactive products
								activeProducts = session.getAttribute("filter").toString().trim().equals("active");
								inactiveProducts = session.getAttribute("filter").toString().trim().equals("inactive"); 
								if(activeProducts) {
									// active products list
									res = appDBMnger.infoActiveProducts();
								} else if(inactiveProducts) {
									// inactive products list
									res = appDBMnger.infoInactiveProducts();
								} else {
								  // error in the session variable, value
								  // not recognized
									// Clear session variables
									session.setAttribute("currentPage", null);
									session.setAttribute("userName", null);
									System.out.println("Error in the session variable \"filter\", value not recognized. Redirecting to login page...");
									// return to the login page
									response.sendRedirect("login.jsp");
								}
							}
%>
							<!--User List Filter Section-->
					        <div class="filter">
					            <form action="productsFilter.jsp" method="post">
					                <select name="search_filter" class="search_filter">
<%
									// Determine what filter was used
									if(allProducts) {
%>
										<option value="" selected>All Products</option>
					                    <option value="active">Active Products</option>
					                    <option value="inactive">Inactive Products</option>
<%
									} else if(activeProducts) {
%>
										<option value="">All Products</option>
					                    <option value="active" selected>Active Products</option>
					                    <option value="inactive">Inactive Products</option>
<%
									} else {
%>
										<option value="">All Products</option>
					                    <option value="active">Active Products</option>
					                    <option value="inactive" selected>Inactive Products</option>
<%
									}
%>					                    
					                </select>
					                <button type="submit" class="filter_button" title="Filter"><i class="fa fa-filter" aria-hidden="true"></i></button>
					            </form>
				            </div>
<%
							// Verify if there are results for the product filter
							if(!res.next()) {
								// the result set is empty
%>
								<!--Error Message-->
								<div class="results_area" id="top">
						            <h2 id="noResultInfo">No Products found with the specified filter. Try another one.</h2>
						        </div>
<%
							} else {
								// there is at least one result
								// Define and initialize a result set
					            ResultSet res2 = null;
					            // reset result set pointer
								res.beforeFirst();
								// counter for the number of results
					            int resCount = 0;
					            // Count the number of results
					            while(res.next())
					                resCount++;
					            
					            // reset result set pointer
					            res.beforeFirst();

					            // Determine which filter was used to
					            // know which HTML code is needed
								if(allProducts) {
									// Verify the amount of results
									if(resCount==1) {
										// only one result
										// Move the result set pointer to
										// the first and only result
										res.next();
%>
										<div class="results_area" id="top">
								            <form class="product" action="detailsProduct.jsp" method="post">
								                <input type="hidden" class="ID" name="ID" value="<%=res.getString(1)%>">
								                <input type="hidden" name="active" value="<%=res.getString(3)%>">
								                <button type="submit" class="product_name"><%=res.getString(2)%></button>
<%
												if(res.getString(3).equals("1")) {
													// active product
%>
													<input type="text" class="state" name="state" readonly value="State: Active">
<%
												} else {
													// inactive product
%>
													<input type="text" class="state" name="state" readonly value="State: Inactive">
<%
												}
%>								                
								                <input type="text" class="bid" name="bid" readonly value="Highest Bid: $<%=res.getString(4)%>">
<%
												// Declare and initialize a variable to hold the
												// departments that a product belongs to 
												String departments = "";
												// Retrieve the departments that
												// a product belongs to 
												res2 = appDBMan2.departmentsBelongs(res.getString(1));
												// Declare and initialize a
												// counter for the departments
												int depCounter = 0;
												// Count the number of departments
												while(res2.next())
													depCounter++;
												
												// reset result set pointer
					                			res2.beforeFirst();
					                			// Determine if there is more
					                			// than 1 department
					                			if(depCounter>1)
													departments = "Departments: ";
												else
													departments = "Department: ";
												
												// Iterate over the result set
					                			while(res2.next()) {
													// Determine if there is
													// more than 1 department
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
								                <input type="text" class="departments" name="departments" readonly value="<%=departments%>">
								                <!--Product Image Section-->
								                <img src="usersData/<%=res.getString(5)%>">
								            </form>
								        </div>
<%
									} else {
										// two or more results
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
										                <input type="hidden" name="active" value="<%=res.getString(3)%>">
										                <button type="submit" class="product_name"><%=res.getString(2)%></button>
<%
														if(res.getString(3).equals("1")) {
															// active product
%>
															<input type="text" class="state" name="state" readonly value="State: Active">
<%
														} else {
															// inactive product
%>
															<input type="text" class="state" name="state" readonly value="State: Inactive">
<%
														}
%>								                
										                <input type="text" class="bid" name="bid" readonly value="Highest Bid: $<%=res.getString(4)%>">
<%														
														/* Declare and initialize a variable to hold the
														   departments that a product belongs to */
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
							                			// Determine if there is more than 1 department
							                			if(depCounter>1)
															departments = "Departments: ";
														else
															departments = "Department: ";
														
														// Iterate over the result set
							                			while(res2.next()) {
															// Determine if there is more than 1 department
															if(depCounter>1) {
																// Concatenate the names of the
																// departments separated by commas
																departments += res2.getString(1) + ", ";
																// Decrease the number of departments
																depCounter--;
															} else {
																// Concatenate the last department
																departments += res2.getString(1);
															}
														}							
%>								                
										                <input type="text" class="departments" name="departments" readonly value="<%=departments%>">
										                <!--Product Image Section-->
										                <img src="usersData/<%=res.getString(5)%>">
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
										                <input type="hidden" name="active" value="<%=res.getString(3)%>">
										                <button type="submit" class="product_name"><%=res.getString(2)%></button>
<%
														if(res.getString(3).equals("1")) {
															// active product
%>
															<input type="text" class="state" name="state" readonly value="State: Active">
<%
														} else {
															// inactive product
%>
															<input type="text" class="state" name="state" readonly value="State: Inactive">
<%
														}
%>								                
										                <input type="text" class="bid" name="bid" readonly value="Highest Bid: $<%=res.getString(4)%>">
<%
														// Declare and initialize a variable to hold
														// the departments that a product belongs to 
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
							                			// Determine if there is more than 1 department
							                			if(depCounter>1)
															departments = "Departments: ";
														else
															departments = "Department: ";
														
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
										                <input type="text" class="departments" name="departments" readonly value="<%=departments%>">
										                <!--Product Image Section-->
										                <img src="usersData/<%=res.getString(5)%>">
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
										                <input type="hidden" name="active" value="<%=res.getString(3)%>">
										                <button type="submit" class="product_name"><%=res.getString(2)%></button>
<%
														if(res.getString(3).equals("1")) {
															// active product
%>
															<input type="text" class="state" name="state" readonly value="State: Active">
<%
														} else {
															// inactive product
%>
															<input type="text" class="state" name="state" readonly value="State: Inactive">
<%
														}
%>								                
										                <input type="text" class="bid" name="bid" readonly value="Highest Bid: $<%=res.getString(4)%>">
<%
														// Declare and initialize a variable to hold
														// the departments that a product belongs to
														String departments = "";
														// Retrieve the departments that a product belongs to 
														res2 = appDBMan2.departmentsBelongs(res.getString(1));
														// Declare and initialize a counter for the departments
														int depCounter = 0;
														// Count the number of department
														while(res2.next())
															depCounter++;
														
														// reset result set pointer
							                			res2.beforeFirst();
							                			// Determine if there is more than 1 department
							                			if(depCounter>1)
															departments = "Departments: ";
														else
															departments = "Department: ";
														
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
										                <input type="text" class="departments" name="departments" readonly value="<%=departments%>">
										                <!--Product Image Section-->
										                <img src="usersData/<%=res.getString(5)%>">
										            </form>
										        </div>
<%
											}
										}
									}		
								} else if(activeProducts) {
									// Verify the amount of results
									if(resCount==1) {
										// only one result
										// Move the result set pointer to the first and only result
										res.next();
%>
										<div class="results_area" id="top">
								            <form class="product" action="detailsProduct.jsp" method="post">
								                <input type="hidden" class="ID" name="ID" value="<%=res.getString(1)%>">
								                <input type="hidden" name="active" value="1">
								                <button type="submit" class="product_name"><%=res.getString(2)%></button>
								                <input type="text" class="bid" id="moreSpace" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
												// Declare and initialize a variable to hold
												// the departments that a product belongs to 
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
					                			// Determine if there is more than 1 department
					                			if(depCounter>1)
													departments = "Departments: ";
												else
													departments = "Department: ";

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
								                <input type="text" class="departments" id="moreSpace" name="departments" readonly value="<%=departments%>">
								                <!--Product Image Section-->
								                <img src="usersData/<%=res.getString(4)%>">
								            </form>
								        </div>											
<%
									} else {
									  // two or more results
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
										                <input type="hidden" name="active" value="1">
										                <button type="submit" class="product_name"><%=res.getString(2)%></button>
										                <input type="text" class="bid" id="moreSpace" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
														// Declare and initialize a variable to hold
														// the departments that a product belongs to
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
							                			// Determine if there is more than 1 department
							                			if(depCounter>1)
															departments = "Departments: ";
														else
															departments = "Department: ";
														
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
										                <input type="text" class="departments" id="moreSpace" name="departments" readonly value="<%=departments%>">
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
										                <input type="hidden" name="active" value="1">
										                <button type="submit" class="product_name"><%=res.getString(2)%></button>
										                <input type="text" class="bid" id="moreSpace" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
														// Declare and initialize a variable to hold
														// the departments that a product belongs to 
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
							                			// Determine if there is more than 1 department
							                			if(depCounter>1)
															departments = "Departments: ";
														else
															departments = "Department: ";
														
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
										                <input type="text" class="departments" id="moreSpace" name="departments" readonly value="<%=departments%>">
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
										                <input type="hidden" name="active" value="1">
										                <button type="submit" class="product_name"><%=res.getString(2)%></button>
										                <input type="text" class="bid" id="moreSpace" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
														// Declare and initialize a variable to hold
														// the departments that a product belongs to
														String departments = "";
														// Retrieve the departments that a product belongs to
														res2 = appDBMan2.departmentsBelongs(res.getString(1));
														// Declare and initialize a counter for the departments
														int depCounter = 0;
														// Count the number of department
														while(res2.next())
															depCounter++;
														
														// reset result set pointer
							                			res2.beforeFirst();
							                			// Determine if there is more than 1 department
							                			if(depCounter>1)
															departments = "Departments: ";
														else
															departments = "Department: ";

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
										                <input type="text" class="departments" id="moreSpace" name="departments" readonly value="<%=departments%>">
										                <!--Product Image Section-->
										                <img src="usersData/<%=res.getString(4)%>">
										            </form>
										        </div>
<%
											}
										}
									}
								} else {
									// inactive products
									// Verify the amount of results
									if(resCount==1) {
										// only one result
										// Move the result set pointer to the first and only result
										res.next();
%>
										<div class="results_area" id="top">
								            <form class="product" action="detailsProduct.jsp" method="post">
								                <input type="hidden" class="ID" name="ID" value="<%=res.getString(1)%>">
								                <input type="hidden" name="active" value="0">
								                <button type="submit" class="product_name"><%=res.getString(2)%></button>
								                <input type="text" class="bid" id="moreSpace" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
												// Declare and initialize a variable to hold
												// the departments that a product belongs to
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
					                			// Determine if there is more than 1 department
					                			if(depCounter>1)
													departments = "Departments: ";
												else
													departments = "Department: ";
												
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
								                <input type="text" class="departments" id="moreSpace" name="departments" readonly value="<%=departments%>">
								                <!--Product Image Section-->
								                <img src="usersData/<%=res.getString(4)%>">
								            </form>
								        </div>											
<%
									} else {
										// two or more results
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
										                <input type="hidden" name="active" value="0">
										                <button type="submit" class="product_name"><%=res.getString(2)%></button>
										                <input type="text" class="bid" id="moreSpace" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
														// Declare and initialize a variable to hold
														// the departments that a product belongs to
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
							                			// Determine if there is more than 1 department
							                			if(depCounter>1)
															departments = "Departments: ";
														else
															departments = "Department: ";
														
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
										                <input type="text" class="departments" id="moreSpace" name="departments" readonly value="<%=departments%>">
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
										                <input type="hidden" name="active" value="0">
										                <button type="submit" class="product_name"><%=res.getString(2)%></button>
										                <input type="text" class="bid" id="moreSpace" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
														// Declare and initialize a variable to hold
														// the departments that a product belongs to 
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
							                			// Determine if there is more than 1 department
							                			if(depCounter>1)
															departments = "Departments: ";
														else
															departments = "Department: ";
														
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
																//Concatenate the last department
																departments += res2.getString(1);
															}
														}	
%>								                
										                <input type="text" class="departments" id="moreSpace" name="departments" readonly value="<%=departments%>">
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
										                <input type="hidden" name="active" value="0">
										                <button type="submit" class="product_name"><%=res.getString(2)%></button>
										                <input type="text" class="bid" id="moreSpace" name="bid" readonly value="Highest Bid: $<%=res.getString(3)%>">
<%
														// Declare and initialize a variable to hold
														// the departments that a product belongs to
														String departments = "";
														// Retrieve the departments that a product belongs to 
														res2 = appDBMan2.departmentsBelongs(res.getString(1));
														// Declare and initialize a counter for the departments
														int depCounter = 0;
														// Count the number of department
														while(res2.next())
															depCounter++;
														
														// reset result set pointer
							                			res2.beforeFirst();
							                			// Determine if there is more than 1 department
							                			if(depCounter>1)
															departments = "Departments: ";
														else
															departments = "Department: ";
														
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
										                <input type="text" class="departments" id="moreSpace" name="departments" readonly value="<%=departments%>">
										                <!--Product Image Section-->
										                <img src="usersData/<%=res.getString(4)%>">
										            </form>
										        </div>
<%
											}
										}
									}
								}
								// close the resul set
								res2.close();
							}
%>
						</body>
					</html>
				            
<%
					// Close connections to the DB
					appDBMan2.close();
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