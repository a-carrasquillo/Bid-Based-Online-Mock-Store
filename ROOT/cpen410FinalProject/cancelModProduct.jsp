<%
	// Clear session variables
	session.setAttribute("errorProduct", null);
	session.setAttribute("productName", null);
	session.setAttribute("bid", null);
	session.setAttribute("dueDate", null);
	session.setAttribute("description", null);
	// Redirect to the login page
	response.sendRedirect("detailsProduct.jsp");
%>