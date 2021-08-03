<%@ page import="java.lang.*"%>

<%
    // Deleting session variables
	session.setAttribute("userName",null);
	session.setAttribute("currentPage",null);
	session.setAttribute("search", null);
	session.setAttribute("search_filter", null);
	session.setAttribute("errorBid", null);
    // Redirecting to the login page
	response.sendRedirect("login.jsp");
%>