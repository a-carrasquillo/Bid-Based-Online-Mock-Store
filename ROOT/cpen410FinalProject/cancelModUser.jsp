<%
	// Delete session variables, related with temporal information
	session.setAttribute("errorUserMod", null);
	session.setAttribute("errorPassword", null);
	session.setAttribute("errorEmail", null);
	session.setAttribute("name", null);
	session.setAttribute("telephone", null);
	session.setAttribute("postalAddress", null);
	session.setAttribute("active", null);
	session.setAttribute("email", null);
	session.setAttribute("usernameID", null);
	// Redirect to listUsers
	response.sendRedirect("listUsers.jsp");
%>