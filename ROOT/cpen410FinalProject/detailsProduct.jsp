<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.CPEN410FINALPROJECT.*"%>
<%// Import the java.sql package to use MySQL related methods %>
<%@ page import="java.sql.*"%>

<!doctype html> 
<html>
    <head>
    	<!--Define the encoding-->
        <meta charset="utf-8">
        <!--Define the authors of the page-->
        <meta name="author" content="a-carrasquillo, arivesan">
        <!--Define the title of the page-->
        <title>Heaven of Bids</title>
        <!--Import the style-sheet for page-->
        <link rel="stylesheet" type="text/css" href="css/detailsProduct.css">
        <!--Import the icon shown in the tab-->
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <!-- Load icon library -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <!--Script that allows us to show a message when the make inactive button is pressed and the product is already inactive-->
        <script type="text/javascript">
		    function showMessage() {
		        alert("The Product is already inactive!!!");
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
		String currentPage = "detailsProduct.jsp";
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
					// Get the user complete name and role
					String userActualName=res.getString(3);
					String userRole = res.getString(1);

					// Create the current page attribute
					session.setAttribute("currentPage", "detailsProduct.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
%>
					<!--Central message-->
		            <h1>Welcome <%=userActualName%> to the Heaven of Bids</h1>
		            <!--Right side clouds-->
		            <img class = "nube" id="nube5" src="images/nube.png">
		            <img class = "nube" id="nube6" src="images/nube.png">
		            <img class = "nube" id="nube7" src="images/nube.png">
		            <img class = "nube" id="nube8" src="images/nube.png">
		        </div>
<%
					// Verify the role of the user to load the webpage display
					if(!appDBAuth.isAdministrator(userRole)) {
						// Is a client
%>
						<!--Go Back Section-->
        				<button id ="goBack" type="button" onclick="window.location.href='welcomeMenu.jsp';">Go Back to Keep Searching</button>
<%
					} else {
						//Is an Admin
%>
						<!--Go Back Section-->
        				<button id ="goBack" type="button" onclick="window.location.href='listProducts.jsp';">Go Back to List of Product</button>
<%
					}
%>
					<!--Logout/sign-out button-->
        			<button class ="logout" type="button" onclick="window.location.href='signout.jsp';">Sign out</button>
<%
					// Retrieve the ID of the product from the
					// request or the session variable
					String ID = "";
					if(request.getParameter("ID")!=null) {
						ID = request.getParameter("ID").trim();
					} else {
						ID = session.getAttribute("ID").toString().trim();
						session.setAttribute("ID", null);
					}

					// Create the appDBMan object
					applicationDBManager appDBMan = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(appDBMan.toString());
					// Perform Product Search by ID
					res = appDBMan.searchArticleById(ID);
					// retrieve the information and store it in string variables
					String productName="", productDescription="", productBid="", productPictureURL="", productDueDate="", departments="", active="";
					// verify if the product was found
					if(res.next()) {
					  // product found
						// Retrieve the information from the result set
						productName = res.getString(1);
						productDescription = res.getString(2);
						productBid = res.getString(3);
						productPictureURL = res.getString(4);
						productDueDate = res.getString(5);
						active = res.getString(6);
						// Split the date into year, month, and day
       					String[] splitArray = productDueDate.split("-");
       					String year, month, day;
       					year = splitArray[0];
       					month = splitArray[1];
       					day = splitArray[2];
       					// reorganize the date
       					productDueDate = month + "/" + day + "/" + year;

						// Determine the departments that the product belongs to					
						res = appDBMan.departmentsBelongs(ID);
						// Declare and initialize a counter for the departments
						int depCounter = 0;
						// Iterate over the result set to determine the amount of departments
						while(res.next())
							depCounter++;
						
						// reset result set pointer
						res.beforeFirst();
						// Determine if there is more than one department
						if(depCounter>1)
							departments = "Departments: ";
						else
							departments = "Department: ";

						// Iterate over the result set
						while(res.next()) {
							// Verify if the department is not the last one
							if(depCounter>1) {
								// Concatenate the names of the departments
								// separated by commas
								departments += res.getString(1) + ", ";
								// Decrease the number of departments
								depCounter--;
							} else {
								// Concatenate the last department
								departments += res.getString(1);
							}
						}

						// Verify the role of the user to load the webpage display
						if(!appDBAuth.isAdministrator(userRole)) {
						  // Is a client
%>
							<!--Search Bar section-->
							<div class="search_bar">
						        <form id="search" action="search.jsp" method="post">
<%
								// Declare the search variable
								String search = "";
								// Verify if there is a search and set
								// the correct message
								Boolean noActiveSearch = (session.getAttribute("search")==null);
								if(noActiveSearch)
									search = "Search a product...";
								else
									search = session.getAttribute("search").toString();
%>
									<!--Field where the search is entered-->
						            <input type="text" placeholder="<%=search%>" name="search" class="search" required>
						            <!--Department Filter-->
						            <select name="search_filter" class="search_filter">
						                <option value="">All Departments</option>
<%								
										// Retrieve the active departments from the DB
						                res = appDBMan.listActiveDepartments();
						                // Verify if there is a search filter
						                String search_filter = "";

										if(session.getAttribute("search_filter")!=null)
											search_filter = session.getAttribute("search_filter").toString();
										
										// Iterate over the result set containing
										// the active departments
						                while(res.next()) {
						                	// Verify if the department filter is empty
						                	if(session.getAttribute("search_filter")==null || (search_filter.trim().isEmpty())) {
%> 
					                   			<option value="<%=res.getString(1)%>"><%=res.getString(1)%></option>
<%	
						                	} else {
						                		// Since the department filter is not empty,
						                		// we verify which department match the
						                		// filter value to add a "selected" property
						                		// to the HTML code
						                		if(res.getString(1).equals(search_filter)) {
%> 
					                   				<option value="<%=res.getString(1)%>" selected><%=res.getString(1)%></option>
<%	
						                		} else {
%> 
					                   				<option value="<%=res.getString(1)%>"><%=res.getString(1)%></option>
<%
					                			}
					                		}
					                	}
%>
						            </select>
	                				<button type="submit" class="search_button"><i class="fa fa-search"></i></button>
	            				</form>
	        				</div>

	        			<!--Central Box where the information of the product is shown-->
	        			<div class="central_box">
	            			<form class="product" action="makeBid.jsp" method="post">
	                	       <input type="hidden" class="ID" name="ID" value="<%=ID%>">
					           <input type="text" class="productName" name="productName" readonly value="<%=productName%>">
					           <input type="text" class="bidInf" name="bid" readonly value="Highest Bid: $<%=productBid%>" >
					           <input type="text" class="due_date" name="due_date" readonly value="Due Date: <%=productDueDate%>">
					           <input type="text" class="departmentsInf" name="departments" readonly value="<%=departments%>">
					           <input type="text" class="description_tag" name="description_tag" readonly value="Description:">
	                		   <p class="description"><%=productDescription%></p>
	                		   <!--Section where the bid is entered-->
	                		   <input type="text" class="bid_tag" name="bid_tag" readonly value="Enter your bid:">
	                		   <div class="currency">
	                    		    <span class="currencySign">$</span>
	                    			<input type="number" name="newBid" id="currency_field" pattern="(\d{1-13}.\d{0-2})?$" value="" placeholder="1000.00" min="<%=Double.parseDouble(productBid)+0.01%>" maxlength="16" step=".01" required>
	                		   </div>
	                		   <button type="submit" class="makeBid">Make Bid</button>
<%
								// Declare and initialize the variable that will hold the error message
								String errorBid = "";
								// Verify if there is an error
								if(session.getAttribute("errorBid") != null)
									errorBid = session.getAttribute("errorBid").toString().trim();
%>
	                		   <span id="errorBid"><%=errorBid%></span>
	                		   <!--Product Image Section-->
	                		   <img src="usersData/<%=productPictureURL%>">
	            			</form>
	        			</div>
<%
						} else {
							// Is an Admin
%>
							<!--Central Box-->
					        <div class="central_box">
					            <form class="product" action="modifyProduct.jsp" method="post">
					                <input type="hidden" class="ID" name="ID" value="<%=ID%>">
					                <input type="text" class="productName" name="productName" readonly value="<%=productName%>">
<%
									// Determine the state of the product
									if(active.equals("1")) {
%>
										<input type="text" class="state" name="state" readonly value="State: Active">
<%
									} else if(active.equals("0")) {
%>
										<input type="text" class="state" name="state" readonly value="State: Inactive">
<%
									} else {
										System.out.println("Error, value of state is not recognized...");
									}
%>
					                <input type="text" class="bidInf" name="bid" readonly value="Highest Bid: $<%=productBid%>" >
					                <input type="text" class="due_date" name="due_date" readonly value="Due Date: <%=productDueDate%>">
					                <input type="text" class="departmentsInf" name="departments" readonly value="<%=departments%>">
					                <input type="text" class="description_tag" name="description_tag" readonly value="Description:">
					                <p class="description"><%=productDescription%></p>
					                
					                <button type="submit" class="editButton" title="Edit Product"><i class="fa fa-pencil"></i></button>
					                <!--Product Image Section-->
					                <img src="usersData/<%=productPictureURL%>">
					            </form>
					            <h3 id="opTag">Operations</h3>
					            <div id="square"><!--Square--></div>
<%								
								// Verify if the product is active or inactive
								// to allow the make inactive button
								if(active.equals("1")) {
									// active
%>
									<form action="removeProduct.jsp" method="post">
						                <input type="hidden" name="ID" value="<%=ID%>">
						                <button type="submit" class="inactiveButton" title="Make Product Inactive"><i class="fa fa-ban" aria-hidden="true"></i></button>
					            	</form>
<%
								} else if(active.equals("0")) {
									// inactive
%>
									<button type="button" class="inactiveButton" title="Product Already Inactive" onclick="return showMessage();"><i class="fa fa-ban" aria-hidden="true"></i></button>
<%
								} else {
									// value not recognized, error
									System.out.println("Error, value of state is not recognized...");
								}
%>  
					        </div>
<%
						}
						// Close the connection to the database
						appDBMan.close();
					} else {
						// product not found, error
						// Close any session associated with the user
						session.setAttribute("userName", null);
						session.setAttribute("currentPage", null);
						session.setAttribute("search", null);
						session.setAttribute("search_filter", null);
						session.setAttribute("errorBid", null);
						// return to the login page
						response.sendRedirect("login.jsp");
					}	
				} else {
					// the user can not be authenticated
					// Close any session associated with the user
					session.setAttribute("userName", null);
					session.setAttribute("currentPage", null);
					session.setAttribute("search", null);
					session.setAttribute("search_filter", null);
					session.setAttribute("errorBid", null);
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
				session.setAttribute("errorBid", null);
				// return to the login page
				response.sendRedirect("login.jsp");
			}
		} catch(Exception e) {
%>
			Nothing to show!
<%
			e.printStackTrace();
			// Clear session variables
			session.setAttribute("userName", null);
			session.setAttribute("currentPage", null);
			session.setAttribute("search", null);
			session.setAttribute("search_filter", null);
			session.setAttribute("errorBid", null);
			// return to the login page
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>
    </body>
</html>