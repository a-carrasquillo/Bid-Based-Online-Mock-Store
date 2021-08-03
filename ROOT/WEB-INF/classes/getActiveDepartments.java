// Import required java libraries
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import org.json.*;
import ut.JAR.CPEN410FINALPROJECT.*;
import java.sql.*;

/**
 *  This Servlet generates a JSON object with the name of all
 *	active departments in the DB.
 *	
 *	It does not required any parameter.
 * 
 *  @author a-carrasquillo
 */
public class getActiveDepartments extends HttpServlet {
   
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
		// Create an JSON Object containing a JSONArray
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
			@return a JSONObject with the array of active departments
	*/
	public JSONObject createFinalJSON() {
		// Create the JSONObject	
		JSONObject finalOutput = new JSONObject();
		try {
			// Create the JSONObject containing a JSONArray
			// created using the createJSonArray method
			// name the JSONObject as "departments"
			finalOutput.put("departments", createJSonArray());
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
				@return A JSONArray containing the list of active departments 
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
			// Call the respective API method to get all the active departments
			ResultSet res = appDBMg.listActiveDepartments();
			// Iterate over the result set
			while (res.next()) {				
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
			@param res - result set with the department name
			@return a JSONObject with the value pair containing
					the name of the department
	*/ 
	public JSONObject createJSon(ResultSet res) {
		// Create the JSONObject
		JSONObject json = new JSONObject();
		try {
			// Add the appropriate data to the object
			json.put("dept_name", res.getString(1));
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// return the JSON Object
			return json;
		}
	}
}