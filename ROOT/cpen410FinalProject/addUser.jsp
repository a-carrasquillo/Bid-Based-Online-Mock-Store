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
        // Declare and define the current page, and get the username and the
        // previous page from the session variables
        String currentPage="addUser.jsp";
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
                    session.setAttribute("currentPage", "addUser.jsp");
                    
                    // Create or update a session variable for the username
                    if (session.getAttribute("userName")==null) {
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
                <!--Indicate the character encoding-->
                <meta charset="utf-8">
                <!--Define the authors of the page-->
                <meta name="author" content="a-carrasquillo, arivesan">
                <!--Define the title of the page-->
                <title>Heaven of Bids Administration</title>
                <!--Import the style-sheet for page-->
                <link rel="stylesheet" type="text/css" href="css/addUser.css">
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
                            // There is no error in the email, hence, we empty the error message
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
                
                <div class = "left_side_square">
                    <!--Central message of the left side square-->
                    <h1>Administrator Operations</h1> 
                    <!--Options that the Administrator can choose from-->    
<%
                    // Bring the menu from the database based on the username
                    res = appDBAuth.menuElements(userName);
                    System.out.println("Listing menu...");
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
                <!--Section where the information of the new user is filled-->
                <div class = "right_side_square">
                    <form name="signup" id="signup" action="addNewUser.jsp" method="post" onSubmit="return checkform()" autocomplete="off">
                      <h1>Fill Information to Add a New User</h1>
<% 
                      // Define the error variables
                      String errorEmail = "";
                      String errorUsername = "";
                      String errorPassword = "";
                      String errorEmpty = "";
                       
                      // Define the variables that will hold the user information
                      String completeName = "";
                      String userEmail = "";
                      String newUserName = "";
                      String telephone = "";
                      String postalAddress = "";
                       
                      /* Verify if the error variable is null, if so, this is the first time loading
                      the page. Else, this page is reload after an error in the submit */
                      if(session.getAttribute("error")!=null) {
                        // Verify if error was due to empty parameter
                        String error = session.getAttribute("error").toString();
                        if(error.equals("empty")) {
                          // Show the error message
                          errorEmpty = "There is an empty field!!!";
                          // Load user information from session variables
                          completeName = session.getAttribute("completeName").toString();
                          userEmail = session.getAttribute("userEmail").toString();
                          newUserName = session.getAttribute("newUserName").toString();
                          telephone = session.getAttribute("telephone").toString();
                          postalAddress = session.getAttribute("postalAddress").toString();
                        } else {
                            // check if we got an error in the password
                            if(session.getAttribute("errorPassword")!=null)
                                errorPassword = "The passwords do not match!!!";

                            // check if we got an error in the email
                            if(session.getAttribute("errorEmail")!=null)
                                errorEmail = "The email must have the @";

                            // check if we got an error in the username
                            if(session.getAttribute("errorUsername")!=null)
                                errorUsername = "The username already exists. Use another one.";

                          // Load user information from session variables
                          completeName = session.getAttribute("completeName").toString();
                          userEmail = session.getAttribute("userEmail").toString();
                          newUserName = session.getAttribute("newUserName").toString();
                          telephone = session.getAttribute("telephone").toString();
                          postalAddress = session.getAttribute("postalAddress").toString();
                        }
                       
                      }
%>
                      <!--empty field error message-->
                      <input type="text" id="errorEmpty" name="errorEmpty" readonly value="<%=errorEmpty%>">
                      <!--Name Section-->
                      <div class="row">
                        <span><b>Name: </b></span>
                        <input type="text" id="completeName" name="completeName" placeholder="Enter your complete name" maxlength="30" required value="<%=completeName%>">
                      </div>
                      <!--Email Section-->
                      <div class="row">
                        <span><b>Email: </b></span>
                        <input type="email" id="userEmail" name="userEmail" placeholder="Enter your email" maxlength="45" required value="<%=userEmail%>">
                      </div>
                      <!--Email Error message-->
                      <input type="text" id="errorEmail" name="errorEmail" readonly value="<%=errorEmail%>">
                      <!--Username Section-->
                      <div class="row">
                        <span><b>Username: </b></span>
                        <input type="text" id="userName" name="newUserName" placeholder="Enter an username" maxlength="20" required value="<%=newUserName%>">
                      </div>
                      <!--Username Error message-->
                      <input type="text" id="errorUsername" name="errorUsername" readonly value="<%=errorUsername%>">
                      <!--Password Section-->
                      <div class="row">
                        <span><b>Password: </b></span>
                        <input type="password" id="userPass" name="userPass" placeholder="Enter a password" required value="">
                      </div>
                      <!--Confirm Password Section-->
                      <div class="row">
                        <span><b>Confirm Password: </b></span>
                        <input type="password" id="userPassConfirm" name="userPassConfirm" placeholder="Reenter the password" required value="">
                      </div>
                      <!--Password Error message-->
                      <input type="text" id="errorPassword" name="errorPassword" readonly value="<%=errorPassword%>">
                      <!--Telephone Section-->
                      <div class="row">
                        <span><b>Telephone: </b></span>
                        <input type="text" id="telephone" name="telephone" placeholder="(###)-###-####" maxlength="15" required value="<%=telephone%>">
                      </div>
                      <!--Postal Address Section-->
                      <div class="row">
                        <span><b>Postal Address: </b></span>
                        <textarea id="postalAddress" name="postalAddress" placeholder="Enter your Postal Address" maxlength="50" required ><%=postalAddress%></textarea> 
                      </div>
                      <!--Buttons Section-->
                      <div class="buttons">
                          <button id ="cancel" type="button" onclick="window.location.href='cancelNewUser.jsp';">Cancel</button>
                          <button id ="submit" type="submit">Submit</button>
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
                session.setAttribute("userName", null);
                session.setAttribute("currentPage", null);
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
              session.setAttribute("userName", null);
              session.setAttribute("currentPage", null);
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