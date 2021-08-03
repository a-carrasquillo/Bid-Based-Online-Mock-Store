<%
	// Clear session variables
	session.setAttribute("errorDept", null);
	session.setAttribute("departmentName", null);
	// Redirect to the welcomeMenu page
	response.sendRedirect("welcomeMenu.jsp");
%>