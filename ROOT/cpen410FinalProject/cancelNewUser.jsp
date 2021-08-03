<%
   // Delete all session variables
   session.setAttribute("error", null);
   session.setAttribute("errorPassword", null);
   session.setAttribute("errorEmail", null);
   session.setAttribute("errorUsername", null);
   session.setAttribute("completeName", null);
   session.setAttribute("userEmail", null);
   session.setAttribute("newUserName", null);
   session.setAttribute("telephone", null);
   session.setAttribute("postalAddress", null);
   
   // Redirect to welcomeMenu
   response.sendRedirect("welcomeMenu.jsp");
%>