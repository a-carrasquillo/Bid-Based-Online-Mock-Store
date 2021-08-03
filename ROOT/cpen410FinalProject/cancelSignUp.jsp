<%
   // Delete all session variables
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
   // redirect to the login page
   response.sendRedirect("login.jsp");
%>