<%@ page import="java.lang.*"%>
<%// Import the package where the API is located%>
<%@ page import="ut.JAR.CPEN410FINALPROJECT.*"%>
<%// Import the java.sql package to use MySQL related methods %>
<%@ page import="java.sql.*"%>
<%
  // Retrieve parameters from the form and remove the unnecessary
  // spaces from the start and end
  String completeName = request.getParameter("completeName").trim();
  String email = request.getParameter("userEmail").trim();
  String userName = request.getParameter("userName").trim();
  String userPass = request.getParameter("userPass");
  String userPassConfirm = request.getParameter("userPassConfirm");
  String userTelephone = request.getParameter("telephone").trim();
  String postalAddress = request.getParameter("postalAddress").trim();
   
   // Perform Server-side validation
   // 1. Validate if there is any empty parameter
   if(completeName.isEmpty()||email.isEmpty()||userName.isEmpty()||userPass.isEmpty()||
        userPassConfirm.isEmpty()||userTelephone.isEmpty()||postalAddress.isEmpty()) {
      // Create a session variable to indicate that an error occur due
      // to empty parameters
      session.setAttribute("error", "empty");
      // Create and fill the parameters of the user information, as session
      // variables, before redirecting
      session.setAttribute("completeName", completeName);
      session.setAttribute("userEmail", email);
      session.setAttribute("userName", userName);
      session.setAttribute("telephone", userTelephone);
      session.setAttribute("postalAddress", postalAddress);
      // redirect to the signup page
      response.sendRedirect("signUp.jsp");
   } else {
     // There are no empty parameters
      // 2. Validate that the email at least have the @
      boolean errorEmail = email.indexOf("@") != -1 ? false : true;
      // verify if there is an error in the email field, if so,
      // create a session variable to indicate this problem
      if(errorEmail)
        session.setAttribute("errorEmail", "true");
      
      // 3. Validate that the passwords are the same
      boolean errorPassword = !(userPass.equals(userPassConfirm));
      // verify if there is an error with the password, if so,
      // create a session variable indicating that error
      if(errorPassword)
        session.setAttribute("errorPassword", "true");
      
      // Verify if there is an error with the email or the password
      if(errorEmail || errorPassword) {
        // if there is an error with the email or the password, perform the following:
        // Create a session variable indicating that there is an error
        session.setAttribute("error", "true");
        // Create and fill the parameters of the user information before redirecting
        session.setAttribute("completeName", completeName);
        session.setAttribute("userEmail", email);
        session.setAttribute("userName", userName);
        session.setAttribute("telephone", userTelephone);
        session.setAttribute("postalAddress", postalAddress);
        // redirect to the signup page
        response.sendRedirect("signUp.jsp");
      } else {
        // There are no empty parameters neither problems with the password or email
        // Try to connect the database using the applicationDBAuthentication class
        try {
          // Create the appDBAuth object
          applicationDBAuthentication appDBAuth = new applicationDBAuthentication();
          System.out.println("Connecting...");
          System.out.println(appDBAuth.toString());
          // Try to add the user to the system
          boolean res = appDBAuth.addUser(completeName, email, userName, userPass, userTelephone, postalAddress);
        
          // Verify if the user has been added
          if(res) {
            // Added successfully
            // delete all session variables
            session.setAttribute("error", null);
            session.setAttribute("errorPassword", null);
            session.setAttribute("errorEmail", null);
            session.setAttribute("errorUsername", null);
            session.setAttribute("completeName", null);
            session.setAttribute("userEmail", null);
            session.setAttribute("userName", null);
            session.setAttribute("telephone", null);
            session.setAttribute("postalAddress", null);
            session.setAttribute("loginError", null);
            // HTML code to generate a message indicating
            // that the user was added successfully 
%>
            <!DOCTYPE html>
            <html>
              <head>
                <title>Redirecting...</title>
                <meta http-equiv="Refresh" content="8;url=login.jsp">
                <style type="text/css">
                  h1 {
                      position: relative;
                      margin-top: 25%;
                      text-align: center;
                  }
                  body {
                      background-color: rgb(59, 191, 151);
                  }
                </style>
              </head>
              <body>
                <h1>User created successfully, redirecting to login page, please use your new credentials to login...</h1>
              </body>
            </html>
<%
          } else {
            // Error while adding the user
            // Create a session variable to indicate that there has been an error
            session.setAttribute("error", "true");
            // create a session variable to indicate that the user already exists
            session.setAttribute("errorUsername", "true");
            // Reset the session variables of errors due to password or email
            session.setAttribute("errorPassword", null);
            session.setAttribute("errorEmail", null);
            // Create and fill the parameters of the user information before redirecting
            session.setAttribute("completeName", completeName);
            session.setAttribute("userEmail", email);
            session.setAttribute("userName", userName);
            session.setAttribute("telephone", userTelephone);
            session.setAttribute("postalAddress", postalAddress);
            // redirect to the signup page
            response.sendRedirect("signUp.jsp");
          } 
          // Close the connection to the database
          appDBAuth.close();
        } catch(Exception e) {
          System.out.println("Exception...");
          e.printStackTrace();
        } finally {
          System.out.println("");
        }
      }
   }
%>  