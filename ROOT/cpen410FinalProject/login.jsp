<!doctype html>
<html>
    <head>
        <!--Indicate the character encoding-->
        <meta charset="utf-8">
        <!--Description of the web page-->
        <meta name="description" content="Heaven of Bids Login Page">
        <!--Keywords of the web page, that search engines use to show the page-->
        <meta name="keywords" content="bid, Heaven of Bids, bids, puerto rico, bid web page, offers, discounts, good prices, Login">
        <!--Authors of the web page-->
        <meta name="author" content="a-carrasquillo, arivesan">
        <title>Heaven of Bids Login</title>
        <!--Importing the CSS style-sheet-->
        <link rel="stylesheet" type="text/css" href="css/login.css">
        <!--Importing the favicon that is shown in the top-->
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
    </head>
    <body>
        <div class="header">
            <!--Central message of the header-->
            <h1>Welcome to the Heaven of Bids</h1>
            <!--Left side clouds-->
            <img class = "nube" id="nube1" src="images/nube.png">
            <img class = "nube" id="nube2" src="images/nube.png">
            <img class = "nube" id="nube3" src="images/nube.png">
            <img class = "nube" id="nube4" src="images/nube.png">
            <img class = "nube" id="nube5" src="images/nube.png">
            <!--Right side clouds-->
            <img class = "nube" id="nube6" src="images/nube.png">
            <img class = "nube" id="nube7" src="images/nube.png">
            <img class = "nube" id="nube8" src="images/nube.png">
            <img class = "nube" id="nube9" src="images/nube.png">
            <img class = "nube" id="nube10" src="images/nube.png">
        </div>
        <!--Background image-->
        <div class = "background"><img src="images/bidMan.png"></div>
        <!--White box area where login information is filled-->
        <div class="main_body">
            <form id="login" action="validation.jsp" method="post" autocomplete="off">
                <div class = "top_tag"><b><h1>Login</h1></b></div>
                <!--Username Section-->
                <div class = "tag"><b>Username:</b></div>
                <input type="text" id="userName" name="userName" placeholder="Enter your username" maxlength="20" required><br>
                <!--Password Section-->
                <div class = "tag"><b>Password:</b></div>
                <input type="password" id="userPass" name="userPass" placeholder="Enter your password" required><br>
                <% // verify if we are redirected here due to an error
                   String error = "";
                   if(session.getAttribute("loginError")!=null) {
                        // Define the error message
                        error = "Username or password is incorrect!!!";
                   }
                %>
                <!--Error message area-->
                <input type="text" id="errorUserNamePass" name="errorUserNamePass" readonly value="<%=error%>">
                <!--Submit button-->
                <button id ="loginButton" type="submit" accesskey="enter">Login</button>
            </form>
            <!--Signup Redirection area-->
            <b><a id="signUp" href="signUp.jsp">Don't have an account? Click Here to Signup</a></b>
        </div>
    </body>
</html>