<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.CPEN410FINALPROJECT.*"%>
<%// Import the java.sql package to use MySQL related methods%>
<%@ page import="java.sql.*"%>
<%// Import java.util.ArrayList package%>
<%@ page import="java.util.ArrayList"%>
<%// Import the related packages to upload the picture to TOMCAT%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>

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
		String currentPage="addProduct.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		
		// Try to connect the database and also try to upload the picture to the server
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
					session.setAttribute("currentPage", "addProduct.jsp");
					
					// Create or update a session variable for the username
					if(session.getAttribute("userName")==null) {
						// create the session variable
						session.setAttribute("userName", userName);
					} else {
						// Update the session variable
						session.setAttribute("userName", userName);
					}
					// Preparation to upload information
					File file;
    				int maxFileSize = 5000 * 1024;
    				int maxMemSize = 5000 * 1024;
    				// Directory where the picture will be stored in
    				String filePath = "C:\\Program Files\\Apache Software Foundation\\Tomcat 8.5\\webapps\\ROOT\\cpen410FinalProject\\usersData\\";
    				String contentType = request.getContentType();
    				// Verify the encryption type
    				if((contentType.indexOf("multipart/form-data") >= 0)) {
    					DiskFileItemFactory factory = new DiskFileItemFactory();
        				factory.setSizeThreshold(maxMemSize);
        				factory.setRepository(new File("c:\\temp"));
        				ServletFileUpload upload = new ServletFileUpload(factory);
        				upload.setSizeMax(maxFileSize);

        				List fileItems = upload.parseRequest(request);
			            Iterator i = fileItems.iterator();
			            // Declaring the variables that will hold the form information
			            String fileName = "";
			            String productName = "";
			            String bidInit = "";
			            String dueDate = "";
			            String description = "";
			            String departments = "";
			            String allDepartments = "";
			            ArrayList<String> departmentsArrayList = new ArrayList<String>();
			            // while the iterator can move forward collect the information
			            while(i.hasNext()) {
			                FileItem fi = (FileItem)i.next();
			                // Verify if the parameter is a file or an input field
			                if(!fi.isFormField()) {
			                  // is a file
			                    // Retrieve the file name
			                    fileName = fi.getName();
			                    // verify the length of the file name
			                    if(fileName.length()<=30&&fileName.length()>=5) {
			                    	boolean isInMemory = fi.isInMemory();
				                    long sizeInBytes = fi.getSize();
				                    // Instantiate a new file object with the file path concatenated with the file name
				                    file = new File(filePath + fileName);
				                    // Upload the file to the server (TOMCAT)
				                    fi.write(file);
				                    System.out.println("Uploaded File: " + filePath + fileName);
			                    }
			                } else {
			                  // is an input field
			                	// Search for the productName parameter and get its value
			                	if(fi.getFieldName().equals("productName"))
			                        productName = fi.getString();
			                    
			                	// Search for the bidInit parameter and get its value
			                    if(fi.getFieldName().equals("bidInit")) 
			                        bidInit = fi.getString();
			                    
			                    // Search for the dueDate parameter and get its value
			                    if(fi.getFieldName().equals("dueDate")) 
			                        dueDate = fi.getString();
			                    
			                    // Search for the description parameter and get its value
			                    if(fi.getFieldName().equals("description"))
			                        description = fi.getString();
			                    
			                    // Search for the department parameter
			                    if(fi.getFieldName().equals("department")) 
			                    {
			                    	// get the value/s from the department parameter
			                        departments = fi.getString();

			                        // Split the departments into individual
			                        // departments since if there is more than 
			                        // one checkbox selected the parameter will
			                        // be an array divided by spaces
			                        String[] splitArray = departments.split(" ");

			                        // determine the size of the array containing
			                        // the individual departments
			                        int size = splitArray.length;
			                        // Verify that the amount of selected 
			                        // departments is equal or less than 3
			                        if(size<=3) {
			                        	// variables to hold the department names with _
			                        	String[] deptNameSpace;
						                String deptName = "";
						                int sizeDeptNameSpace = 0;
			                        	for(int j=0; j<size; j++) {
				                        	// Take the word in the j position
				                        	deptName = splitArray[j];
				                        	// Verify if the word has
				                        	// underscores _
			       							deptNameSpace = deptName.split("_");
			       							sizeDeptNameSpace = deptNameSpace.length;
			       							if(sizeDeptNameSpace>1)	{
			       								deptName = "";
			       								// Take each word and
			       								// concatenate them using 
			       								// one space
			       								for(int k=0; k<sizeDeptNameSpace; k++) {
			       									// Verify if the word is not
			       									// the last one
			       									if(k<sizeDeptNameSpace-1)
			       										deptName += deptNameSpace[k] + " ";
			       									else
			       										deptName += deptNameSpace[k];
			       								}
			       							}
			       							// Add the department name to the ArrayList
				                            departmentsArrayList.add(deptName);
				                            // Keep the department names with 
				                            // the underscores in case that any
				                            // error occurs they can be returned
				                            // to sellProduct page
				                            allDepartments += splitArray[j] + " ";
				                        }
				                        // Information for debugging purposes
				                        /*System.out.println("Server side... Departments Selected: ");
				                        for(int j=0; j<departmentsArrayList.size(); j++)
				                        {
				                            System.out.println (departmentsArrayList.get(j));
				                        }*/
			                        } else {
			                          // error, code manipulation that allow the
			                          // selection of more than 3 departments
			                        	// Create a session variable holding
			                        	// an error message
										session.setAttribute("errorProduct", "You can only select three departments maximum!!!");
										System.out.println("Server side... You can only select three departments maximum!!!");
										// Create session variables to hold
										// product info
										session.setAttribute("productName", productName);
										session.setAttribute("bidInit", bidInit);
										session.setAttribute("dueDate", dueDate);
										session.setAttribute("description", description);
										// Redirect to sellProduct
										System.out.println("Redirecting to sellProduct.jsp ...");
										response.sendRedirect("sellProduct.jsp");
			                        }
			                    }
						    }
						}
						// Verify if there was an empty field
						if(fileName.isEmpty()||productName.isEmpty()||bidInit.isEmpty()||dueDate.isEmpty() || description.isEmpty()||departments.isEmpty()) {
							// Create a session variable holding an error message
							session.setAttribute("errorProduct", "There is an empty field. Remember to select at least one department.");
							//System.out.println("Server side... There is an empty field. Remember to select at least one department.");
							// Create session variables to hold product info
							session.setAttribute("productName", productName);
							session.setAttribute("bidInit", bidInit);
							session.setAttribute("dueDate", dueDate);
							session.setAttribute("description", description);
							session.setAttribute("departments", allDepartments.trim());
							// Redirect to sellProduct
							System.out.println("Redirecting to sellProduct.jsp ...");
							response.sendRedirect("sellProduct.jsp");
						} else if((fileName.length()<=30&&fileName.length()>=5)) {
						  // All the fields were filled and the fileName length
						  // is the adequate
							// Perform the connection to the DB
							applicationDBManager appDBMan = new applicationDBManager();
							System.out.println("Connecting...");
							System.out.println(appDBMan.toString());
							// Call the method from the API that allows to add
							// a product to the system
							if(appDBMan.addProduct(userName, productName, description, bidInit, fileName, dueDate, departmentsArrayList)) {
							  // product added successfully
								// Delete any session variable related with an error
								session.setAttribute("errorProduct", null);
								session.setAttribute("productName", null);
								session.setAttribute("bidInit", null);
								session.setAttribute("dueDate", null);
								session.setAttribute("description", null);
								session.setAttribute("departments", null);
								// HTML code to generate a message indicating that
								// the product was added successfully
%>
								<!DOCTYPE html>
								<html>
									<head>
										<title>Redirecting...</title>
										<meta http-equiv="Refresh" content="8;url=welcomeMenu.jsp">
										<link rel="icon" type="image/x-icon" href="images/favicon.ico">
										<meta charset="utf-8">
										<style type="text/css">
											h1 {position: relative; margin-top: 25%; text-align: center;}
											body {background-color: rgb(59, 191, 151);}
										</style>
									</head>
									<body>
										<h1>Product added successfully, redirecting to welcomeMenu...</h1>
									</body>
								</html>
<%
							} else {
							  // Product can be added, high chance that the problem
							  // is that the picture name already exists in the DB
								// Create a session variable holding an error message
								session.setAttribute("errorProduct", "Rename your picture since its name already exists in the system.");
								//System.out.println("Server side... Rename your picture since its name already exists in the system.");
								//Create session variables to hold product info
								session.setAttribute("productName", productName);
								session.setAttribute("bidInit", bidInit);
								session.setAttribute("dueDate", dueDate);
								session.setAttribute("description", description);
								session.setAttribute("departments", allDepartments.trim());
								// Redirect to sellProduct
								System.out.println("Departments inside server: " + allDepartments.trim());
								System.out.println("Redirecting to sellProduct.jsp ...");
								response.sendRedirect("sellProduct.jsp");
							}
							
							// Close the connection to the database
							appDBMan.close();
						} else {
						  // file name length too long
							// Create a session variable holding an error message
							session.setAttribute("errorProduct", "Rename your picture since its name is too long.");
							//System.out.println("Server side... Rename your picture since its name is too long.");
							// Create session variables to hold product info
							session.setAttribute("productName", productName);
							session.setAttribute("bidInit", bidInit);
							session.setAttribute("dueDate", dueDate);
							session.setAttribute("description", description);
							session.setAttribute("departments", allDepartments.trim());
							// Redirect to sellProduct
							System.out.println("Redirecting to sellProduct.jsp ...");
							response.sendRedirect("sellProduct.jsp");
						}
				    } else {
				    	System.out.println("Error in encryption type...The HTML code was manipulated...");
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