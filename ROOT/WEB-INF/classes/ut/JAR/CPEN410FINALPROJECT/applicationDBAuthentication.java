// This class belongs to the ut.JAR.CPEN410FINALPROJECT package
package ut.JAR.CPEN410FINALPROJECT;

// Import the java.sql package for managing the connections, queries and results from the database
import java.sql.* ;

// Import hashing functions
import org.apache.commons.codec.*;

/**
	This class authenticate users using userName and passwords.
	Also have methods required in some operations before the 
	user arrive to the welcome page. This class can be accessed 
	from the front-end.
	@author a-carrasquillo
*/
public class applicationDBAuthentication {
	// myDBConn is an MySQLConnector object for accessing the database
	private MySQLConnector myDBConn;
	
	/**
		<h1>Default constructor</h1>
			It creates a new MySQLConnector object and
			open a connection to the database
	*/
	public applicationDBAuthentication() {
		// Create the MySQLConnector object
		myDBConn = new MySQLConnector();
		
		// Open the connection to the database
		myDBConn.doConnection();
	}
		
	/**
		<h1>authenticate method</h1>
			Authentication method
			@param userName - the username of the user
			@param userPass - password entered by the user
			@return
				A ResultSet containing the user's username, 
				all roles assigned to the user and the user's name.
	*/
	public ResultSet authenticate(String userName, String userPass) {
		// Declare function variables
		String fields, tables, whereClause, hashingVal;
		
		// Define the tables where the selection is performed
		tables = "userAccess, roleuser";

		// Define the fields list to retrieve
		fields = "userAccess.userName, roleuser.roleId, userAccess.Name";

		// determining the hashing value to compare it with the one in the database
		hashingVal = hashingSha256(userName + userPass);

		// Declare the where condition
		whereClause = "userAccess.userName = roleuser.userName and userAccess.userName='" + userName +"' and hashingValue='" + hashingVal + "' and active=1";
				
		System.out.println("Authenticating user and listing username, roles and name...");
		
		// Return the ResultSet containing the user username, all roles assigned to the user and the user name
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	/**
		<h1>isAdministrator method</h1>
			Method used to determine if a user is an administrator
			@param roleId - identification of the role that is going to be processed
			@return
				<h3>boolean value:</h3>
	                    <b>true:</b> the user is an administrator
	                    <b>false:</b> the user is not an administrator
	*/
	public boolean isAdministrator(String roleId) {
		// Declare function variables
		String fields, tables, whereClause;
		
		// Word that we are looking for
		String keyword = "admin";

		// declare and define the default return of the function
		boolean result = false;

		// Define the table where the selection is performed
		tables = "role";

		// Define the fields list to retrieve the role name
		fields = "name";

		// Declare the where condition
		whereClause = "roleId='" + roleId + "'";
				
		System.out.println("Listing roles name...");
		
		// declare the ResultSet containing the name of the role
		ResultSet res = myDBConn.doSelect(fields, tables, whereClause);

		System.out.println("Checking if user is administrator...");
		try {
			if(res.next()) {
				if(res.getString(1).toLowerCase().indexOf(keyword.toLowerCase()) != -1) {
					System.out.println("User is administrator.");
					result = true;
				} else {
					System.out.println("User is not administrator.");
					result = false;
				}
			} else {
				System.out.println("The roleId does not exists.");
				result = false;
			}
			res.close();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			return result;
		}
	}

	/**
		<h1>menuElements method</h1>
			Bring the menu related with a role
			@param userName - the username of the user that we want to bring
							  his/her menu
			@return
				A ResultSet containing the pageURL, the category of the 
				menu (user, product, department) and the page title
	*/
	public ResultSet menuElements(String userName) {
		// Declare function variables
		String fields, tables, whereClause, orderBy;
		
		// Define the tables where the selection is performed
		tables = "roleuser, role, rolewebpage, menuElement, webpage ";

		// Define the fields list to retrieve page URL, the category of 
		// the menu (user, product, department) and the page title
		fields = "rolewebpage.pageURL, menuElement.title, webpage.pageTitle";

		// Define where clause
		whereClause = " roleuser.roleID=role.roleID and role.roleID=rolewebpage.roleId and menuElement.menuID = webpage.menuId";
		whereClause += " and rolewebpage.pageURL=webpage.pageURL";
		whereClause += " and userName='"+ userName+"' and not webpage.menuId=0";
		
		// Define the conditions of order
		orderBy = "menuElement.title desc, webpage.pagetitle asc";
		
		System.out.println("Listing menu...");
		
		// Return the ResultSet containing pageURL, the category of the menu (user, product, department) and the page title
		return myDBConn.doSelect(fields, tables, whereClause, orderBy);
	}	
	
	/**
		<h1>verifyUserPageFlow method<h1>
			Method to verify the page-flow of the user and bring the 
			roles of the user
			@param userName - the username of the user 
			@param currentPage - the page that the user is trying to access
			@param previousPage - the page from where the user comes
			@return
				A ResultSet containing all roles assigned to the user, 
				the username and the name of the user
	*/
	public ResultSet verifyUserPageFlow(String userName, String currentPage, String previousPage) {
		// Declare function variables
		String fields, tables, whereClause;
		
		// Define the tables where the selection is performed
		tables = "roleuser, role, rolewebpage, webpage, userAccess, webpageprevious";

		// Define the fields list to retrieve assigned roles to the user, the username and the name of the user
		fields = " distinct roleuser.roleId, userAccess.userName, userAccess.Name ";

		// Declaring the where clause
		whereClause = " userAccess.userName = roleuser.userName and userAccess.userName='" + userName +"' and role.roleId=roleuser.roleId and ";
		whereClause += " rolewebpage.roleId=role.roleId and rolewebpage.pageURL=webpage.pageURL and webpageprevious.currentPageURL='" + currentPage; 
		whereClause += "' and webpageprevious.previousPageURL='"+previousPage+"'";
		
		System.out.println("Verifying user page flow and listing his/her roles...");
		
		// Return the ResultSet containing all roles assigned to the user, the username and the name of the user
		return myDBConn.doSelect(fields, tables, whereClause);
	}

	/**
		<h1>verifyUserPageAccess method</h1>
			Method used to determine if a user have access to a certain page
			@param userName - the username of the user 
			@param pageTryingToGainAccess - the page that the user is trying 
											to gain access
			@return
				<h3>boolean value:</h3>
	                    <b>true:</b> the user have access to the requested page
	                    <b>false:</b> the user does not have access to the 
	                    			  requested page
	*/
	public boolean verifyUserPageAccess(String userName, String pageTryingToGainAccess)	{
		// Declare function variables
		String fields, tables, whereClause;
		
		// Declare and define the default return value of the function
		boolean result = false;

		// Define the tables where the selection is performed
		tables = "useraccess, roleuser, role, rolewebpage";

		// Define the fields list
		fields = " useraccess.username, useraccess.name, roleuser.roleid, rolewebpage.pageURL ";

		// Define the where clause
		whereClause = " useraccess.username=roleuser.username and roleuser.roleId=role.roleId and role.roleId=rolewebpage.roleId and ";
		whereClause += " rolewebpage.pageURL='" + pageTryingToGainAccess + "' and roleuser.username='" + userName + "'"; 
		
		System.out.println("Verifying user access to page " + pageTryingToGainAccess + "...");

		// Calling the doSelect method to determine if the user have access to the page that is requesting
		ResultSet res = myDBConn.doSelect(fields, tables, whereClause);

		/*If the result set have a result this means that the user have access 
		to the page, else, the user does not have access to the page that 
		is requesting*/
		try {
			if(res.next())
				result = true;
			else
				result = false;
			
			// Close the result set
			res.close();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// return the result
			return result;
		}		
	}

	/**
		<h1>addUser method</h1>
			Method used to add a user to the system
			@param completeName - name of the new user
			@param email - email of the new user
			@param userName - username of the new user
			@param userPass - password of the new user
			@param userTelephone - telephone of the new user
			@param postalAddress - postal address of the new user
			@return
				<h3>boolean value:</h3>
	                    <b>true:</b> the user was added successfully
	                    <b>false:</b> the user cannot be added
	*/
	public boolean addUser(String completeName, String email, String userName, String userPass, String userTelephone, String postalAddress)	{
		// Declare function variables
		String table, values, hashingValue;

		// Calling the function that will produce the hashing value based on the username and the password
		hashingValue = hashingSha256(userName + userPass);

		// Define the table where the user information is going to be inserted
		table = "userAccess";

		// Define the values to be inserted
		values = "'" + userName + "', '" + hashingValue + "', '" + completeName + "', '" + userTelephone + "', '" + postalAddress +"', 1, '" + email + "'";

		System.out.println("Adding new user...");

		// Disable the auto-commit since a transaction is going to be performed
		myDBConn.disableAutoCommit();

		// Adding new user to the database
		if(myDBConn.doInsert(table, values)) {
		   // The user was added successfully
			// Define the table where the user role is inserted
			table = "roleUser";

			// Define the values to be inserted
			values = "'" + userName + "', 'role2', curdate()";

			System.out.println("Adding new user role...");
			
			// Adding new user role to the database
			if(myDBConn.doInsert(table, values)) {
				// both inserts were a success
				// Perform a commit to save both inserts
				myDBConn.doCommit();
				// enable auto-commit for future queries
				myDBConn.enableAutoCommit();
				// Return true indicating that all inserts were successful, hence de user was added
				return true;
			}
		}
		// one of the inserts fail
		// Since one of the queries fail, we need to perform a rollback
		myDBConn.doRollback();
		// enable auto-commit for future queries
		myDBConn.enableAutoCommit();
		// Return false, indicating that the user was not added due to an error
		return false;
	}
	
	/**
		<h1>hashingSha256 method</h1>
			Generates a hash value using the sha256 algorithm.
			@param plainText - plaintext to be converted to hashing value
			@return the hash string based on the plainText
	*/
	private String hashingSha256(String plainText) {
		// Generate the hashing value
		String sha256hex = org.apache.commons.codec.digest.DigestUtils.sha256Hex(plainText);
		// return the hashing value 
		return sha256hex;
	}
	
	/**
		</h1>close method</h1>
			Close the connection to the database.
			This method must be called at the end of each page/object 
			that instantiates a applicationDBManager object
	*/
	public void close()	{
		//Close the connection
		myDBConn.closeConnection();
	}

	/**
		<h1>Debugging method</h1>
			This method is used to test the applicationDBAuthentication class
			@param args[]: String array 
			@return
	*/
	public static void main(String[] args)
	{
		// Create an appDBAuth object to connect to the database
		applicationDBAuthentication appDBAuth = new applicationDBAuthentication();
		// Declare the variable that will hold the username
		String userName;
		//Define the username
		userName = "arivesan";

		try {
			// Bring the menu elements 
			ResultSet res = appDBAuth.menuElements(userName);
			System.out.println("Listing menu...");
			String previousTitle = "";
			if(!res.isAfterLast()) {
				while(res.next()) {
					//verify if the title is the same as the previous
					if(!previousTitle.equals(res.getString(2)))
						System.out.println("title = " + res.getString(2));
					 
					System.out.print("pagetitle = " + res.getString(3));
					System.out.println("\t\tpageURL = " + res.getString(1));
									
					previousTitle = res.getString(2);
				}
			} else {
				System.out.println("The user does not have a menu option...");
			}
			//close the result set
			res.close();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			// close the connection to the database
			appDBAuth.close();
		}	
	}
}