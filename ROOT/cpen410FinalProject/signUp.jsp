<!doctype html> 
<html>
    <head>
        <!--Indicate the character encoding-->
        <meta charset="utf-8">
        <!--Description of the web page-->
        <meta name="description" content="Heaven of Bids Signup Page">
        <!--Keywords of the web page, that search engines use to show the page-->
        <meta name="keywords" content="bid, Heaven of Bids, bids, puerto rico, bid web page, offers, discounts, good prices, signup">
        <!--Authors of the web page-->
        <meta name="author" content="a-carrasquillo, arivesan">
        <!--Define the title of the page-->
        <title>Heaven of Bids Signup</title>
        <!--Importing the CSS style sheet-->
        <link rel="stylesheet" type="text/css" href="css/signUp.css">
        <!--Importing the favicon that is shown in the top-->
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
            <img class = "nube" id="nube3" src="images/nube.png">
            <!--Central message-->
            <h1>Please Signup to enter the Heaven of Bids</h1>
            <!--Right side clouds-->
            <img class = "nube" id="nube4" src="images/nube.png">
            <img class = "nube" id="nube5" src="images/nube.png">
            <img class = "nube" id="nube6" src="images/nube.png">
            <img class = "nube" id="nube7" src="images/nube.png">
            <img class = "nube" id="nube8" src="images/nube.png">
        </div>
        <!--Left side photo-->
        <div class="left_side">
            <img class = "background" id="left_side" src="images/Bids_part1.png">
        </div>
        <!--Center Box-->
        <div class="center">
            <form name="signup" id="signup" action="createAccount.jsp" method="post" onSubmit="return checkform()" autocomplete="off">
                <% 
                    // Define the error variables
                    String errorEmail = "";
                    String errorUsername = "";
                    String errorPassword = "";
                    String errorEmpty = "";
                   
                    // Define the variables that will hold the user information
                    String completeName = "";
                    String userEmail = "";
                    String userName = "";
                    String telephone = "";
                    String postalAddress = "";
                       
                    /* Verify if the error variable is null, if so, this is
                     the first time loading the page. Else, this page is
                     reloaded after an error in the submit */
                    if(session.getAttribute("error")!=null) {
                        // Verify if error was due to empty parameter
                        String error = session.getAttribute("error").toString();
                        if(error.equals("empty")) {
                            // Show the error message
                            errorEmpty = "There is an empty field!!!";
                            // Load user information from session variables
                            completeName = session.getAttribute("completeName").toString();
                            userEmail = session.getAttribute("userEmail").toString();
                            userName = session.getAttribute("userName").toString();
                            telephone = session.getAttribute("telephone").toString();
                            postalAddress = session.getAttribute("postalAddress").toString();
                        } else {
                            // verify if there is an error in the password, 
                            // if so, show a message
                            if(session.getAttribute("errorPassword")!=null)
                                errorPassword = "The passwords do not match!!!";

                            // verify if there is an error with the email, 
                            // if so, show a message
                            if(session.getAttribute("errorEmail")!=null)
                                errorEmail = "The email must have the @";

                            // verify if there is an error with the username,
                            // if so, show a message
                            if(session.getAttribute("errorUsername")!=null)
                                errorUsername = "The username already exists. Use another one.";
                          
                            // Load user information from session variables
                            completeName = session.getAttribute("completeName").toString();
                            userEmail = session.getAttribute("userEmail").toString();
                            userName = session.getAttribute("userName").toString();
                            telephone = session.getAttribute("telephone").toString();
                            postalAddress = session.getAttribute("postalAddress").toString();
                        }
                   
                    }
                    %>
                <!--empty field error message-->
                <input type="text" id="errorEmpty" name="errorEmpty" readonly value="<%=errorEmpty%>">
                <!--Name Section-->
                <div class="row" id="top">
                    <span><b>Name: </b></span>
                    <input type="text" id="completeName" name="completeName" placeholder="Enter your complete name" maxlength="30" required value="<%=completeName%>">
                </div>
                <!--Email Section-->
                <div class="row">
                    <span><b>Email: </b></span>
                    <input type="email" id="userEmail" name="userEmail" placeholder="Enter your email" maxlength="45" required value="<%=userEmail%>">
                </div>
                    <!--Error message-->
                    <input type="text" id="errorEmail" name="errorEmail" readonly value="<%=errorEmail%>">
                <!--Username Section-->
                <div class="row">
                    <span><b>Username: </b></span>
                    <input type="text" id="userName" name="userName" placeholder="Enter an username" maxlength="20" required value="<%=userName%>">
                </div>
                    <!--Error message-->
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
                    <!--Error message-->
                    <input type="text" id="errorPassword" name="errorPassword" readonly value="<%=errorPassword%>">
                <!--Telephone Section-->
                <div class="row">
                    <span><b>Telephone: </b></span>
                    <input type="text" id="telephone" name="telephone" placeholder="(###)-###-####" maxlength="15" required value="<%=telephone%>">
                </div>
                <!--Postal Address Section-->
                <div class="row">
                    <span><b>Postal Address: </b></span>
                    <textarea id="postalAddress" name="postalAddress" placeholder="Enter your Postal Address" maxlength="50" required><%=postalAddress%></textarea> 
                </div>
                <!--Buttons-->
                <div class="buttons">
                    <button id ="cancel" type="button" onclick="window.location.href='cancelSignUp.jsp';">Cancel</button>
                    <button id ="submit" type="submit">Submit</button>
                </div>
            </form>
        </div>
        <!--Right side photo-->
        <div class="right_side">
            <img class = "background" id="right_side" src="images/Bids_part2.png">
        </div>
    </body>
</html>
