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
        <!--Import the style sheet for page-->
        <link rel="stylesheet" type="text/css" href="css/sellProduct.css">
        <!--Import the icon shown in the tab-->
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <!--Script that help us limit the number of selected departments to three-->
        <script type="text/javascript">
        	function validateSelection() {  
				// Get all the check boxes
			    var checkboxes = document.getElementsByName("department");
			    // Variable to hold the number of selected check boxes
			    var numberOfCheckedItems = 0;  
			    for(var i = 0; i < checkboxes.length; i++) {
			    	// Verify if the checkbox is selected and
			    	// increase the counter if so
			        if(checkboxes[i].checked)  
			            numberOfCheckedItems++;  
			    }
			    // verify of there are more than 3 selected check boxes
			    if(numberOfCheckedItems > 3) {
			    	// Show a pop-out message in the screen  
			        alert("You can't select more than three departments!");  
			        return false;  
			    }  
			}  
        </script>

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
		String currentPage="sellProduct.jsp";
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
					session.setAttribute("currentPage", "sellProduct.jsp");
					
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
				<title>Heaven of Bids Selling Page</title>
			</head>
			    <body>
			        <div class="header">
			            <!--Small Bid Icon-->
			            <img class = "header_icon" src="images/BID.jpg"> 
			            <!--Left side clouds-->
			            <img class = "nube" id="nube1" src="images/nube.png">
						<!--Central message-->
	            		<h1>Thanks for being part of Heaven of Bids <%=userActualName%> </h1>
	            		<!--Right side clouds-->
			            <img class = "nube" id="nube6" src="images/nube.png">
			            <img class = "nube" id="nube7" src="images/nube.png">
			            <img class = "nube" id="nube8" src="images/nube.png">
			        </div>
			        <!--Left side background image-->
			        <div class="left_side">
			            <img class = "background" id="left_side" src="images/Bids_part1.png">
			        </div>
			        <!--Logout/sign-out button-->
			        <button class ="logout" type="button" onclick="window.location.href='signout.jsp';">Sign out</button>
			        <!--Section where the product information is filled-->
			        <div class="center">
			            <h1 id="fillInfoTag">Fill the information to sell a product</h1>
			            <form action="addProduct.jsp" method="post" autocomplete="off" enctype="multipart/form-data">
<%
							// Variables to hold the product information after an error
							String error = "", productName="", bidInit="", dueDate="", description="", departments="";
							//Verify if there is an error
							if(session.getAttribute("errorProduct")!=null) {
								// retrieve the error message and the product information
								error = session.getAttribute("errorProduct").toString();
								productName = session.getAttribute("productName").toString();
								bidInit = session.getAttribute("bidInit").toString();
								dueDate = session.getAttribute("dueDate").toString();
								description = session.getAttribute("description").toString();
								departments = session.getAttribute("departments").toString();
							}
%>
							<!--Error Section-->
			                <input type="text" id="errorEmpty" name="errorEmpty" readonly value="<%=error%>">
			                <!--Product Name Section-->
			                <div class="row"><span><b>Product Name: </b></span>
			                <input type="text" class="productName" name="productName" placeholder="Enter the product name" maxlength="40" required value="<%=productName%>"></div>
			                <!--Initial Bid Section-->
			                <div class="row"><span ><b>Initial Bid: </b></span>
			                    <div class="currency">
			                        <span class="currencySign">$</span>
			                        <input type="number" name="bidInit" class="currency_field" pattern="(\d{1-13}.\d{0-2})?$" placeholder="1000.00" maxlength="16" min="0.00" step=".01" required value="<%=bidInit%>">
			                    </div>
			                </div>
			                <!--Picture Section-->
			                <div class="row"><span><b>Picture: </b></span>
			                <input type="file" accept="image/*" class="productImage" name="productImage" size="50" required></div>
			                <!--Due Date Section-->
			                <div class="row"><span><b>Due Date: </b></span>
			                <input type="date" class="dueDate" name="dueDate" required value="<%=dueDate%>"></div>
			                <!--Description Section-->
			                <div class="row"><span id="descTag"><b>Description: </b></span>
			                <textarea class="description" name="description" placeholder="Enter the product description" required rows="4"><%=description%></textarea> 
			                </div> 
			                <!--Departments Section-->
			                <div class="row"><span ><b>Department/s that belongs: </b></span>
			                    <div class="checkboxes">
			                        <table>
<%
									// Create an applicationDBManager object to connect to the DB
									applicationDBManager appDBMan = new applicationDBManager();
									System.out.println("Connecting...");
									System.out.println(appDBMan.toString());
									// retrieve the list of active departments from the DB
						            res = appDBMan.listActiveDepartments();
						            // Declare and initialize a counter
						            int counter = 0;
						            // Variable to work with the selected departments of a product
						            String checked = "";
						            // Message for debugging purposes
				                    //System.out.println("Checked departments: " + departments);
				                    // Iterate over the result set
						            while(res.next()) {
						            	// Clean any unwanted spaces
								        departments = departments.trim();
								        // Split the list of departments
			       						String[] splitArray = departments.split(" ");
			       						// Determine the size of the split array
						                int size = splitArray.length;
						                        
						                // Split array for department names with space
						                String[] deptNameSpace;
						                String deptName = "";
						                int sizeDeptNameSpace = 0;
			       						// Perform a loop to search in the splitArray
			       						// and compare results with the selected departments
			       						// of a product and the list of active departments
			       						for(int i=0; i<size; i++) {
			       							// Retrieve the department name from the result set
			       							deptName = res.getString(1);
			       							// Divide the name into words
			       							deptNameSpace = deptName.split(" ");
			       							sizeDeptNameSpace = deptNameSpace.length;
			       							// Verify if the department name is composed
			       							// by more than one word, if so, add underscores
			       							// to the name
			       							if(sizeDeptNameSpace>1) {
			       								deptName = "";
			       								for(int j=0; j<sizeDeptNameSpace; j++) {
			       									// verify that the selected word is not the last one
			       									if(j<sizeDeptNameSpace-1)
			       										deptName += deptNameSpace[j] + "_";
			       									else
			       										deptName += deptNameSpace[j];
			       								}
			       							}
			       							// Compare the actual product departments with the one
			       							// collected from the active ones in the DB
			       							if(splitArray[i].equals(deptName)) {
			       								// is the same, so add the checked property 
									        	checked = "checked";
									        	//System.out.println("Verifying department " + splitArray[i] + " == " + res.getString(1));
									        	break;
									        } else {
									        	// is not the same
									        	checked = " ";
									        	//System.out.println("Verifying department " + splitArray[i] + " != " + res.getString(1));
									        }
			       						}
								        // Verify the counter to know in which column
								        // of the table the checkbox is added    	
								        if(counter==0) {
								        	// first column
%>
											<tr>
			                            		<td><input type="checkbox" name="department" id="<%=res.getString(1)%>"  value="<%=deptName%>" <%=checked%> onclick="return validateSelection();"><label for="<%=res.getString(1)%>"> <%=res.getString(1)%></label></td>
<%
											// Increase the counter
											counter++;
								        } else if(counter==1) {
								        	// second/middle column
%>
								            	<td><input type="checkbox" name="department" id="<%=res.getString(1)%>"  value="<%=deptName%>" <%=checked%> onclick="return validateSelection();"><label for="<%=res.getString(1)%>"> <%=res.getString(1)%></label></td>
<%
											// Increase the counter
											counter++;
								        } else {
								        	// third/last column
%>
												<td><input type="checkbox" name="department" id="<%=res.getString(1)%>"  value="<%=deptName%>" <%=checked%> onclick="return validateSelection();"><label for="<%=res.getString(1)%>"> <%=res.getString(1)%></label></td>
			                            	</tr>
<%
											// Reset the counter
											counter=0;
								        }
								    }
								    // Close the connection to the DB
						            appDBMan.close();
%>
									</table>                
			                    </div>
			                </div> 
			                <!--Buttons-->
			                <div class="buttons">
			                    <button id ="cancel" type="button" onclick="window.location.href='cancelProductSell.jsp';">Cancel</button>
			                    <button id ="submit" type="submit">Submit</button>
			                </div>
			            </form>
			        </div>
			        <!--Right side background image-->
			        <div class="right_side">
			            <img class = "background" id="right_side" src="images/Bids_part2.png">
			        </div>
<%
					} else {
						// Is an Admin
%>
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
        					<button class ="logout" id="admin" type="button" onclick="window.location.href='signout.jsp';">Sign out</button>
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
											// Verify if the current page is the same as the one
											// recover from the DB
											if(currentPage.equals(res.getString(1))) {
												// Since is the same page, remove the link
												// and set an active id
%>
												<button class="option" type="button" id="active"><%=res.getString(3)%></button>							
<%
											} else {
												// Since it's not the same page, get the link
												// to the page and do not use an active id
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
							<img class = "background" id="admin" src="images/Bids.png">
							<div class = "right_side_square">
								<h1 id="fillInfoTag">Fill the information to sell a product</h1>
					            <form action="addProduct.jsp" method="post" autocomplete="off" enctype="multipart/form-data">
<%
									// Variables to hold the product information after an error
									String error = "", productName="", bidInit="", dueDate="", description="", departments="";
									// Verify if there is an error
									if(session.getAttribute("errorProduct")!=null) {
										// retrieve the error message and the product information
										error = session.getAttribute("errorProduct").toString();
										productName = session.getAttribute("productName").toString();
										bidInit = session.getAttribute("bidInit").toString();
										dueDate = session.getAttribute("dueDate").toString();
										description = session.getAttribute("description").toString();
										departments = session.getAttribute("departments").toString();
									}
%>
									<!--Error message Section-->
					                <input type="text" id="errorEmpty" name="errorEmpty" readonly value="<%=error%>">
					                <!--Product Name Section-->
					                <div class="row"><span><b>Product Name: </b></span>
					                <input type="text" class="productName" id="admin" name="productName" placeholder="Enter the product name" maxlength="40" required value="<%=productName%>"></div>
					                <!--Initial Bid Section-->
					                <div class="row" id="initialBid"><span ><b>Initial Bid: </b></span>
					                    <div class="currency" id="admin">
					                        <span class="currencySign" id="admin">$</span>
					                        <input type="number" name="bidInit" class="currency_field" id="admin" pattern="(\d{1-13}.\d{0-2})?$" placeholder="1000.00" maxlength="16" min="0.00" step=".01" required value="<%=bidInit%>">
					                    </div>
					                </div>
					                <!--Picture Section-->
					                <div class="row"><span><b>Picture: </b></span>
					                <input type="file" accept="image/*" class="productImage" id="admin" name="productImage" size="50" required></div>
					                <!--Due Date Section-->
					                <div class="row"><span><b>Due Date: </b></span>
					                <input type="date" class="dueDate" id="admin" name="dueDate" required value="<%=dueDate%>"></div>
					                <!--Description Section-->
					                <div class="row"><span id="descTag"><b>Description: </b></span>
					                	<textarea class="description" id="admin" name="description" placeholder="Enter the product description" required rows="4"><%=description%></textarea> 
					                </div> 
					                <!--Departments Section-->
					                <div class="row"><span ><b>Department/s that belongs: </b></span>
					                    <div class="checkboxes" id="admin">
					                        <table>
<%
											// Create an applicationDBManager object to connect to the DB
											applicationDBManager appDBMan = new applicationDBManager();
											System.out.println("Connecting...");
											System.out.println(appDBMan.toString());
											// retrieve the list of active departments from the DB
								            res = appDBMan.listActiveDepartments();
								            // Declare and initialize a counter
								            int counter = 0;
								            // Variable to work with the selected departments of a product
								            String checked = "";
								            // Message for debugging purposes
						                    //System.out.println("Checked departments: " + departments);
						                    // Iterate over the result set
								            while(res.next()) {
								            	// Clean any unwanted spaces
								            	departments = departments.trim();
								            	// Split the list of departments
			       								String[] splitArray = departments.split(" ");
			       								// Determine the size of the split array
						                        int size = splitArray.length;
						                        
						                        // Split array for department names with space
						                        String[] deptNameSpace;
						                        String deptName = "";
						                        int sizeDeptNameSpace = 0;
			       								// Perform a loop to search in the splitArray
			       								// and compare results with the selected departments
			       								// of a product and the list of active departments
			       								for(int i=0; i<size; i++) {
			       									// Retrieve the department name from the result set
			       									deptName = res.getString(1);
			       									// Divide the name into words
			       									deptNameSpace = deptName.split(" ");
			       									sizeDeptNameSpace = deptNameSpace.length;
			       									// Verify if the department name is composed
			       									// by more than one word
			       									if(sizeDeptNameSpace>1) {
			       										// add underscores to the name
			       										deptName = "";
			       										for(int j=0; j<sizeDeptNameSpace; j++) {
			       											// verify that the selected word is not the last one
			       											if(j<sizeDeptNameSpace-1)
			       												deptName += deptNameSpace[j] + "_";
			       											else
			       												deptName += deptNameSpace[j];
			       										}
			       									}
			       									// Compare the actual product departments with the
			       									// one collected from the active ones in the DB
			       									if(splitArray[i].equals(deptName)) {
			       										// is the same, so add the checked property
									            		checked = "checked";
									            		//System.out.println("Verifying department " + splitArray[i] + " == " + res.getString(1));
									            		break;
									            	} else {
									            		// is not the same
									            		checked = " ";
									            		//System.out.println("Verifying department " + splitArray[i] + " != " + res.getString(1));
									            	}
			       								}
								            	// Verify the counter to know in which column
								            	// of the table the checkbox is added
								            	if(counter==0) {
								            		// first column
%>
													<tr>
			                            				<td><input type="checkbox" name="department" id="<%=res.getString(1)%>"  value="<%=deptName%>" <%=checked%> onclick="return validateSelection();"><label for="<%=res.getString(1)%>"> <%=res.getString(1)%></label></td>
<%
													// Increase the counter
													counter++;
								            	} else if(counter==1) {
								            		// second/middle column
%>
								            			<td><input type="checkbox" name="department" id="<%=res.getString(1)%>"  value="<%=deptName%>" <%=checked%> onclick="return validateSelection();"><label for="<%=res.getString(1)%>"> <%=res.getString(1)%></label></td>
<%
													// Increase the counter
													counter++;
								            	} else {
								            		// third/last column
%>
														<td><input type="checkbox" name="department" id="<%=res.getString(1)%>"  value="<%=deptName%>" <%=checked%> onclick="return validateSelection();"><label for="<%=res.getString(1)%>"> <%=res.getString(1)%></label></td>
			                            			</tr>
<%
													// Reset the counter
													counter=0;
								            	}
								            }
								            // Close the connection to the DB
								            appDBMan.close();
%>
											</table>                
					                    </div>
					                </div> 
					                <!--Buttons-->
					                <div class="buttons">
					                    <button id ="cancel" type="button" onclick="window.location.href='cancelProductSell.jsp';">Cancel</button>
					                    <button id ="submit" type="submit">Submit</button>
					                </div>
					            </form>
					        </div>
<%
					}
				} else {
					// the user can not be authenticated
					// Close any session associated with the user
					session.setAttribute("userName", null);
					session.setAttribute("currentPage", null);
					session.setAttribute("errorProduct", null);
					session.setAttribute("productName", null);
					session.setAttribute("bidInit", null);
					session.setAttribute("dueDate", null);
					session.setAttribute("description", null);
					session.setAttribute("departments", null);
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
				session.setAttribute("errorProduct", null);
				session.setAttribute("productName", null);
				session.setAttribute("bidInit", null);
				session.setAttribute("dueDate", null);
				session.setAttribute("description", null);
				session.setAttribute("departments", null);
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
			session.setAttribute("errorProduct", null);
			session.setAttribute("productName", null);
			session.setAttribute("bidInit", null);
			session.setAttribute("dueDate", null);
			session.setAttribute("description", null);
			session.setAttribute("departments", null);
			// return to the login page
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>
    </body>
</html>