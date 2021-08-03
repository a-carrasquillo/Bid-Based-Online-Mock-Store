<%
	// Clear session variables
	session.setAttribute("errorDept", null);
	
	// Redirect to the listDepartments page
	response.sendRedirect("listDepartments.jsp");
%>