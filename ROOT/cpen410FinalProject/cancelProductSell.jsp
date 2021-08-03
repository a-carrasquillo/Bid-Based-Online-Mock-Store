<%
	// Clear session variables
	session.setAttribute("errorProduct", null);
	session.setAttribute("productName", null);
	session.setAttribute("bidInit", null);
	session.setAttribute("dueDate", null);
	session.setAttribute("description", null);
	session.setAttribute("departments", null);
	// Redirect to welcomeMenu
	response.sendRedirect("welcomeMenu.jsp");
%>