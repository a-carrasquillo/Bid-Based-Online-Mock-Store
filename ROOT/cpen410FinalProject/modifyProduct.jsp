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
		String currentPage = "modifyProduct.jsp";
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
					session.setAttribute("currentPage", "modifyProduct.jsp");
					
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
					        <link rel="stylesheet" type="text/css" href="css/modifyProduct.css">
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
								    	// Verify if the checkbox is selected and increase the counter if so
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
					        <!--Section where the product information is presented-->
					        <div class = "center_square">            
					            <form action="changeProductInfo.jsp" method="post" autocomplete="off" enctype="multipart/form-data">
					                <h1>Editing Product Information</h1>
<%
									// Retrieve the ID of the product, either from a session
									// variable or as the parameter of the request
									String ID = "";
									if(session.getAttribute("errorProduct")!=null) {
										// Get the ID from a session variable
										ID = session.getAttribute("ID").toString();
									} else {
										// Get the ID from the form in the previous page
										ID = request.getParameter("ID").trim();
										// Set a session variable for the product ID
										session.setAttribute("ID", ID);
									}
									// Create an applicationDBManager object to connect to the DB
									applicationDBManager appDBMan = new applicationDBManager();
									System.out.println("Connecting...");
									System.out.println(appDBMan.toString());
									// Perform Product Search by ID
									res = appDBMan.searchArticleById(ID);
									// retrieve the information and store it in string variables
									String currentProductName="", currentProductDescription="", currentProductBid="", currentProductPictureURL="", currentProductDueDate="", currentDepartments="", currentActive="";
									// If the results et have a result, retrieve the information 
									if(res.next()) {
										// product found
										currentProductName = res.getString(1);
										currentProductDescription = res.getString(2);
										currentProductBid = res.getString(3);
										currentProductPictureURL = res.getString(4);
										currentProductDueDate = res.getString(5);
										currentActive = res.getString(6);
										// Determine the departments that the product belongs to
										res = appDBMan.departmentsBelongs(ID);
							            // Split array for department names with space
						                String[] deptNameSpace;
						                String deptName = "";
						                int sizeDeptNameSpace = 0;
						                // Iterate over the departments result set
							            while(res.next()) {
											// Retrieve the department name
											deptName = res.getString(1);
											// try to separate the department name into words
			       							deptNameSpace = deptName.split(" ");
			       							// Verify the length of the array containing the words
			       							sizeDeptNameSpace = deptNameSpace.length;
			       							// If the length of the array is greater than 1,
			       							// this means that the department name has spaces
			       							// and we need to add underscores to the name
			       							if(sizeDeptNameSpace>1) {
			       								// dept name with spaces
			       								deptName = "";
			       								for(int j=0; j<sizeDeptNameSpace; j++) {
			       									// Verify that the selected word is not the last one
			       									if(j<sizeDeptNameSpace-1)
			       										deptName += deptNameSpace[j] + "_";
			       									else
			       										deptName += deptNameSpace[j];
			       								}
			       							}
			       							// Add the department name with underscores to the list
			       							currentDepartments += deptName + " ";
										}
										// eliminate space at the end
										currentDepartments = currentDepartments.trim();
										// close the connection to the DB
										appDBMan.close();
									} else {
										// error, product ID not found due to manipulation of the HTML code
										System.out.println("Error!!! Product ID not found due to manipulation of the HTML code... Redirecting to login page...");
										// Clear session variables
										session.setAttribute("currentPage", null);
										session.setAttribute("userName", null);
										session.setAttribute("errorProduct", null);
										session.setAttribute("productName", null);
										session.setAttribute("bid", null);
										session.setAttribute("dueDate", null);
										session.setAttribute("description", null);
										session.setAttribute("departments", null);
										session.setAttribute("ID", null);
										// return to the login page
										response.sendRedirect("login.jsp");
									}
									// Declare and initialize string variables to hold the product
									// information, at first the information will be the original one,
									// but if an error occurs the stored information will be the modified one
									String error = "", productName="", bid="", dueDate="", description="", departments="", productPictureURL="", active="";
									// Verify if there is an error
									if(session.getAttribute("errorProduct")!=null) {
										// Retrieve the error and product information from the
										// session variables
										error = session.getAttribute("errorProduct").toString();
										productName = session.getAttribute("productName").toString();
										bid = session.getAttribute("bid").toString();
										dueDate = session.getAttribute("dueDate").toString();
										description = session.getAttribute("description").toString();
										departments = session.getAttribute("departments").toString();
										active = session.getAttribute("active").toString();
									} else {
										// Since there is no error, the product information
										// is the original one
										productName = currentProductName;
										bid = currentProductBid;
										dueDate = currentProductDueDate;
										description = currentProductDescription;
										departments = currentDepartments;
										active = currentActive;
									}									
%>
									<!--Error Section-->
					                <input type="text" id="errorEmpty" name="errorEmpty" readonly value="<%=error%>">
					                <!--Product Name Section-->
					                <div class="row">
					                    <span><b>Product Name: </b></span>
					                    <input type="text" id="productName" name="productName" placeholder="<%=currentProductName%>" maxlength="40" value="<%=productName%>" required>
					                </div>
					                <!--Initial Bid Section-->
					                <div class="row" id="initialBid">
					                    <span id="bidTag"><b>Actual Bid: </b></span>
					                    <div class="currency">
					                        <span class="currencySign">$</span>
					                        <input type="number" name="bid" id="currency_field" pattern="(\d{1-13}.\d{0-2})?$" placeholder="<%=currentProductBid%>" maxlength="16" min="0.00" step=".01" value="<%=bid%>" required>
					                    </div>
					                </div>
					                <!--Picture Section-->
					                <div class="row">
					                    <span id="pictureTag"><b>Picture: </b></span>
					                    <img id="productActualImage" src="usersData/<%=currentProductPictureURL%>">
					                    <input type="file" accept="image/*" id="productImage" name="productImage" title="Change Picture">
					                </div>
					                <!--Due Date Section-->
					                <div class="row">
					                    <span><b>Due Date: </b></span>
					                    <input type="date" id="dueDate" name="dueDate" required value="<%=dueDate%>" placeholder="<%=dueDate%>">
					                </div>
					                <!--Description Section-->
					                <div class="row" id="desc">
					                    <span id="descTag"><b>Description: </b></span>
					                    <textarea id="description" name="description" placeholder="<%=currentProductDescription%>" required rows="4"><%=description%></textarea> 
					                </div> 
					                <!--Departments Section-->
					                <div class="row">
					                    <span><b>Department/s that belongs: </b></span>
					                    <div class="checkboxes">
					                        <table>
<%
											// Create an applicationDBManager object to connect
											// to the DB
											applicationDBManager appDBMan2 = new applicationDBManager();
											System.out.println("Connecting...");
											System.out.println(appDBMan2.toString());
											// retrieve the list of active departments 
								            res = appDBMan2.listActiveDepartments();
								            // Declare and initialize a counter
								            int counter = 0;
								            // Variables to work with the selected departments of
								            // a product
								            String checked = "", boldF="", boldB="";
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
			       								// Perform a loop to search in the splitArray and compare results with the selected departments of a product and the list of active departments
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
			       											// verify that the selected word is not
			       											// the last one
			       											if(j<sizeDeptNameSpace-1)
			       												deptName += deptNameSpace[j] + "_";
			       											else
			       												deptName += deptNameSpace[j];
			       										}
			       									}
			       									// Compare the actual product departments with
			       									// the one collected from the active ones in the DB
			       									if(splitArray[i].equals(deptName)) {
			       										// is the same, so add the checked property
			       										// and make the name bold
									            		checked = "checked";
									            		boldF = "<b>";
									            		boldB = "</b>";
									            		//System.out.println("Verifying department " + splitArray[i] + " == " + res.getString(1));
									            		break;
									            	} else {
									            		// is not the same, so the checked and bold properties
									            		// are not added
									            		checked = " ";
									            		boldF = "";
									            		boldB = "";
									            		//System.out.println("Verifying department " + splitArray[i] + " != " + res.getString(1));
									            	}
			       								}
								            	// Verify the counter to know in which column of
								            	// the table the checkbox is added
								            	if(counter==0) {
								            		// first column
%>
													<tr>
			                            				<td><input type="checkbox" name="department" id="<%=res.getString(1)%>"  value="<%=deptName%>" <%=checked%> onclick="return validateSelection();"><label for="<%=res.getString(1)%>"> <%=boldF%><%=res.getString(1)%><%=boldB%></label></td>
<%
													// Increase the counter
													counter++;
								            	} else if(counter==1) {
								            		// second/middle column
%>
								            			<td><input type="checkbox" name="department" id="<%=res.getString(1)%>"  value="<%=deptName%>" <%=checked%> onclick="return validateSelection();"><label for="<%=res.getString(1)%>"> <%=boldF%><%=res.getString(1)%><%=boldB%></label></td>
<%
													// Increase the counter
													counter++;
								            	} else {
								            		// third/last column
%>
														<td><input type="checkbox" name="department" id="<%=res.getString(1)%>"  value="<%=deptName%>" <%=checked%> onclick="return validateSelection();"><label for="<%=res.getString(1)%>"> <%=boldF%><%=res.getString(1)%><%=boldB%></label></td>
			                            			</tr>
<%
													// Reset the counter
													counter=0;
								            	}
								            }
								            // Close the connection to the DB
								            appDBMan2.close();
%>
											</table>
					                    </div>
					                </div>
<%
									// verify if the current state of the product is inactive
									if(currentActive.equals("0")) {
										// the product is inactive
%>
										<div class="row">
					                    	<b>This Product is Inactive. Select the following box to make it available again. </b>
						                </div>
<%
										// verify the state of the product after being modified
										if(active.equals("0")) {
											// inactive product
%>
							                <!--Checkbox for activating a product-->
							                <input type="checkbox" id="activateProduct" name="activate" value="activate"><span id="activateProductTag"><label for="activateProduct"> Activate Product</label></span>
<%
										} else if(active.equals("1")) {
											// active product, so the checkbox has the checked property
%>
							                <!--Checkbox for activating a product-->
							                <input type="checkbox" id="activateProduct" name="activate" value="activate" checked><span id="activateProductTag"><label for="activateProduct"> Activate Product</label></span>
<%
										} else {
											System.out.println("Error!!! Product Active value not recognized ... Redirecting to login page...");
											// Clear session variables
											session.setAttribute("currentPage", null);
											session.setAttribute("userName", null);
											session.setAttribute("errorProduct", null);
											session.setAttribute("productName", null);
											session.setAttribute("bid", null);
											session.setAttribute("dueDate", null);
											session.setAttribute("description", null);
											session.setAttribute("departments", null);
											session.setAttribute("ID", null);
											// return to the login page
											response.sendRedirect("login.jsp");
										}
									}
%>
					                <!--Buttons-->
					                <div class="buttons">
					                    <button id ="cancel" type="button" onclick="window.location.href='cancelModProduct.jsp';">Cancel</button>
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
				} else {
					// the user can not be authenticated
					// Clear session variables
					session.setAttribute("currentPage", null);
					session.setAttribute("userName", null);
					session.setAttribute("errorProduct", null);
					session.setAttribute("productName", null);
					session.setAttribute("bid", null);
					session.setAttribute("dueDate", null);
					session.setAttribute("description", null);
					session.setAttribute("departments", null);
					session.setAttribute("ID", null);
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
				session.setAttribute("bid", null);
				session.setAttribute("dueDate", null);
				session.setAttribute("description", null);
				session.setAttribute("departments", null);
				session.setAttribute("ID", null);
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
			session.setAttribute("bid", null);
			session.setAttribute("dueDate", null);
			session.setAttribute("description", null);
			session.setAttribute("departments", null);
			session.setAttribute("ID", null);
			// return to the login page
			response.sendRedirect("login.jsp");
		} finally {
			System.out.println("");
		}
	}
%>