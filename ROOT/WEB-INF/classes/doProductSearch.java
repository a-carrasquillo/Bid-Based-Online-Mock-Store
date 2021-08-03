// Import required java libraries
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import org.json.*;
import ut.JAR.CPEN410FINALPROJECT.*;
import java.sql.*;

/**
 *  This Servlet perform a product search in the Database based on
 *	the user input.
 * 	
 *	It returns a JSON object with the information of the products
 *	that match the search.
 *	
 *  Required values:
 *		search value: search
 *		department filter: filter
 *  @author a-carrasquillo
 */
public class doProductSearch extends HttpServlet {
	// Data Fields
	private String search;
	private String filter;

	// Servlet initialization
	public void init() throws ServletException {
    	// Do required initialization
	}

	/**
		<b>doGet method:</b> 
			It is executed when the GET method is used for the HTTP request
			@param request - request made by the user
			@param response - response of the server
	*/
	public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    	// Set response content type
	    response.setContentType("text/html");

	    // Define a PrintWriter object so the message can be send to the client
	    PrintWriter out = response.getWriter();
	      
		// Send the response
		out.println("This Servlet does not support the GET method! \n" + request.getSession().toString());
	}

	/**
		<b>doPost method:</b> 
			This method is executed when the POST method is used
			for the HTTP request.
			Generates a JSON object containing a JSON Array list.
			@param request - request made by the user
			@param response - response of the server
	*/
	public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    	// Retrieve the HTTP request parameters
		this.search = request.getParameter("search");
		this.filter = request.getParameter("filter");

		// Create an JSONObject containing a JSONArray
		JSONObject jsonResult = createFinalJSON();
      
    	// Define a PrintWriter object so the message can be send to the client
    	PrintWriter out = response.getWriter();
	  
		// Set response content type and encoding
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

    	// Send the response
		out.println(jsonResult.toString());
	}

	public void destroy() {
    	// do nothing.
	}
   
	/**
		<b>createFinalJSON method:</b> 
			Create a JSONObject containing a JSONArray
			@return a JSONObject with the array of products' information 
					that match the search.
	*/
	public JSONObject createFinalJSON() {
		// Create the JSONObject	
		JSONObject finalOutput = new JSONObject();
		try {
			// Create the JSONObject containing a JSONArray
			// created using the createJSonArray method
			// name the JSONObject as "products"
			finalOutput.put("products", createJSonArray());
		}catch(Exception e) {
		   e.printStackTrace();
		} finally {
			// Return the JSONObject containing the array
			return finalOutput;
		}
	}
   
    /**
		<b>createJSonArray method: </b>
			Create a JSONArray
			@return A JSONArray containing the list of products' 
					information that match the search. 
    */
	public JSONArray createJSonArray() {
		// Create the JSONArray
		JSONArray jsonArray = new JSONArray();
	   
		// Connect the the database
		applicationDBManager appDBMg = new applicationDBManager();
		System.out.println("Connecting...");
		System.out.println(appDBMg.toString());
		// Declare and initialize a counter
		int i = 0;
		try {
			// declare and initialize the result set
			ResultSet res = null;
			/* 1. Verify if the filter parameter is empty and the search 
			   parameter is filled, which means that the search is
			   perform in all the departments.
			   
			   2. Verify if the filter parameter is not empty and the search 
			   parameter is filled, which means that the search is
			   perform in a specific department.
			*/
			if(this.filter.isEmpty() && !this.search.isEmpty()) {
				// Call the API method that search in all the departments
				res = appDBMg.searchProductAllDepartments(search);
				// The below code line is for debugging purpose
				//System.out.println("All Departments Search...");
			} else if(!this.filter.isEmpty() && !this.search.isEmpty()) {
				// Call the API method that search in a specific departments
				res = appDBMg.searchProductByDepartments(search, filter);
				// The below code line is for debugging purpose
				//System.out.println("Search in Department "+ filter +"...");
			} else {
				System.out.println("Error, the search parameter is empty...");
			}

			// Iterate over the result set
			while(res.next()) {				
				// Add the new JSONObject to the JSONArray in location i
				jsonArray.put(i,createJSon(res));
				// Increase the counter by 1
				i++;
			}
			// close the result set
			res.close();
			// close the connection to the DB
			appDBMg.close();
		
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// Return the JSONArray
			return jsonArray;
		}
	}
   
	/**
		<b>createJSon method: </b>
			This method creates a JSONObject
			@param res - result set with the product id, name, bid, picture URL,
						 and the departments that the product belongs to.
			@return a JSONObject with the value pair containing 
					the product id, name, bid, picture URL, and the departments
					that he product belongs to.
	*/ 
	public JSONObject createJSon(ResultSet res) {
		// Create the JSON Object
		JSONObject json = new JSONObject();
		try {
			// Add the appropriate data to the object
			json.put("productId", res.getString(1));
			json.put("name", res.getString(2));
			json.put("bid", res.getString(3));
			json.put("pictureURL", "cpen410FinalProject/usersData/"+res.getString(4));
			// Connect the the database
			applicationDBManager appDBMg = new applicationDBManager();
			System.out.println("Connecting...");
			System.out.println(appDBMg.toString());
			// Determine the departments that the product belongs to
			ResultSet res2 = appDBMg.departmentsBelongs(res.getString(1));
			// Declare and initialize a variable to hold the departments names
			String departments = "";
			// Declare and initialize a counter for the departments
			int depCounter = 0;
			// Iterate over the result set to determine the amount of departments
			while(res2.next()) {
				depCounter++;
			}
			// reset result set pointer
			res2.beforeFirst();
			// Iterate over the result set
			while(res2.next()) {
				// Verify if the department is not the last one
				if(depCounter>1) {
					// Concatenate the names of the departments
					// separated by commas
					departments += res2.getString(1) + ", ";
					// Decrease the number of departments
					depCounter--;
				} else {
					// Concatenate the last department
					departments += res2.getString(1);
				}
			}
			// close the result set
			res2.close();
			// close the connection to the DB
			appDBMg.close();
			// insert in the JSON the departments
			json.put("departments", departments);
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// return the JSONObject
			return json;
		}
	}
}