// This class belongs to the ut.JAR.CPEN410FINALPROJECT package
package ut.JAR.CPEN410FINALPROJECT;

// Import the java.sql package for managing the connections, queries and results from the database
import java.sql.* ;

// Import java.util.ArrayList package to use arrayLists
import java.util.ArrayList;

// Import hashing functions
import org.apache.commons.codec.*;

/**
	This class manage a connection to the database and it should be 
    accessed from the front End. Therefore,	this class must contain 
    all needed methods for manipulating data without showing how 
    to access the database.
    @author a-carrasquillo
*/
public class applicationDBManager {
	// myDBConn is an MySQLConnector object for accessing the database
	private MySQLConnector myDBConn;
	
	/**
		<h1>Default constructor</h1>
		    It creates a new MySQLConnector object and open a connection 
            to the database
	*/
	public applicationDBManager() {
		// Create the MySQLConnector object
		myDBConn = new MySQLConnector();
		
		// Open the connection to the database
		myDBConn.doConnection();
	}
	
	/**
		<h1>listAllDepartments method</h1>
			List all departments in the database
			@return
				A ResultSet containing all departments and their status
                in the database 
	*/
	public ResultSet listAllDepartments() {
		// Declare function variables
		String fields, table;
		
		// Define the table where the selection is performed
		table = "departments";
        
		// Define the fields list to retrieve from the table departments
		fields = "departmentName, active";
				
		System.out.println("Listing all departments...");
		
		// Return the ResultSet containing all departments and their status in the database
		return myDBConn.doSelect(fields, table);
    }
    
    /**
        <h1>listInactiveDepartments method</h1>
            List all the inactive departments in the database
            @return
                A ResultSet containing all the inactive departments 
                in the database
    */
    public ResultSet listInactiveDepartments() {
        // Declare function variables
		String field, table, where;
        
        // Define the table where the selection is performed
		table = "departments";
        
		// Define the field list to retrieve from the table departments
		field = "departmentName";
        
        // Define the where condition to filter the inactive departments
        where = "active=0";
        
        System.out.println("Listing inactive departments...");
        
        // Return the ResultSet containing all the inactive departments in the database
		return myDBConn.doSelect(field, table, where);
    }
	
    /**
        <h1>makeDepartmentInactive method</h1>
            Make a department inactive
            @param department - department name to become inactive
            @return
                <h3>boolean value:</h3>
                    <b>true:</b> if the department is now inactive
                    <b>false:</b> the change cannot be made
    */
    public boolean makeDepartmentInactive(String department) {
        // Declare function variables
		String table, assignmentList, where;
        
        // Define the table where the selection is performed
		table = "departments";
		
        // Define the assignment list
        assignmentList = "active=0";
        
        // Define the where condition to update the correct department
        where = "departmentName='" + department + "'";
        
        System.out.println("Making department inactive...");
        
        // Return true or false, depending if the update was perform or not
        return myDBConn.doUpdate(table, assignmentList, where);
    }
    
    /**
        <h1>changeDepartmentName method</h1>
            Allow to change the name of a department
            @param oldDepartmentName - current name of the department
            @param newDepartmentName - new name of the department
            @return
                <h3>boolean value: </h3>
                    <b>true:</b> if the name was change successfully
                    <b>false:</b> the change cannot be made
    */
    public boolean changeDepartmentName(String oldDepartmentName, String newDepartmentName) {
        // Declare function variables
		String table, assignmentList, where;
        
        // Define the table where the selection is performed
		table = "departments";
		
        // Define the assignment list
        assignmentList = "departmentName='" + newDepartmentName + "'";
        
        // Define the where condition to update the correct department
        where = "departmentName='" + oldDepartmentName + "'";
        
        System.out.println("Changing department name...");
        
        // Return true or false, depending if the update was perform or not
        return myDBConn.doUpdate(table, assignmentList, where);
    }
    
    /**
        <h1>changeDepartmentNameAndStatus method</h1>
            Allow to change the name and the status of a department
            @param oldDepartmentName - current name of the department
            @param newDepartmentName - new name of the department
            @param status - new status of the department, (0 for inactive, 
                            1 for active)
            @return
                <h3>boolean value:</h3>
                    <b>true:</b> if the update was perform successfully
                    <b>false:</b> the change cannot be made
    */
    public boolean changeDepartmentNameAndStatus(String oldDepartmentName, String newDepartmentName, String status) {
        // Declare function variables
		String table, assignmentList, where;
        
        // Define the table where the selection is performed
		table = "departments";
		
        // Define the assignment list
        assignmentList = "departmentName='" + newDepartmentName + "', active=" + status;
        
        // Define the where condition to update the correct department
        where = "departmentName='" + oldDepartmentName + "'";
        
        System.out.println("Changing department name and status...");
        
        // Return true or false, depending if the update was perform or not
        return myDBConn.doUpdate(table, assignmentList, where);
    }
    
    /**
        <h1>listAllUsers method</h1>
            List all the users in the database
            @return
                A ResultSet containing all the users in the database
    */
    public ResultSet listAllUsers() {
        // Declare function variables
		String fields, table, where;

        // Define the table where the selection is performed
		table = "useraccess u, roleuser r";

		// Define the list of fields to retrieve from the table
		fields ="u.userName, active";

        // Define the where condition
        where = "u.username=r.username and roleId != 'role1'";
        
        System.out.println("Listing all users...");
        
        // Return the ResultSet containing all the users in the database
		return myDBConn.doSelect(fields, table, where);
    }
    
    /**
        <h1>listAllActiveUsers method</h1>
            List all the active users in the database that 
            are not administrators 
            @return
                A ResultSet containing all the active users 
                in the database that are not administrators
    */
    public ResultSet listAllActiveUsers() {
        // Declare function variables
		String fields, table, where;

        // Define the table where the selection is performed
        table = "useraccess u, roleuser r";

        // Define the list of fields to retrieve from the tables
        fields = "u.userName";

        // Define the where condition
        where = "u.username=r.username and roleId != 'role1'";

        // Define the where condition to filter the active 
        where += " and active=1";
        
        System.out.println("Listing active users...");
        
        // Return the ResultSet containing all the active users 
        // in the database that are not administrators
		return myDBConn.doSelect(fields, table, where);
    }
    
    /**
        <h1>listAllInactiveUsers method</h1>
            List all the inactive users in the database that 
            are not administrators
            @return
                A ResultSet containing all the inactive users 
                in the database that are not administrators
    */
    public ResultSet listAllInactiveUsers() {
        // Declare function variables
		String fields, table, where;

        // Define the table where the selection is performed
        table = "useraccess u, roleuser r";

        // Define the list of fields to retrieve from the tables
        fields = "u.userName";

        // Define the where condition
        where = "u.username=r.username and roleId != 'role1'";

        // Define the where condition to filter the inactive 
        where += " and active=0";
        
        System.out.println("Listing inactive users...");
        
        // Return the ResultSet containing all the inactive users 
        // in the database that are not administrators
		return myDBConn.doSelect(fields, table, where);
    }
    
    /**
        <h1>makeUserInactive method</h1>
            Make a user inactive
            @param user - username to become inactive
            @return
                <h3>boolean value:</h3> 
                    <b>true:</b> if the user is now inactive
                    <b>false:</b> the change cannot be made
    */
    public boolean makeUserInactive(String user) {
        // Declare function variables
		String table, assignmentList, where;
        
        // Define the table where the update is performed
		table = "useraccess";
		
        // Define the assignment list
        assignmentList = "active=0";
        
        // Define the where condition to update the correct user
        where = "userName='" + user + "'";
        
        System.out.println("Making user inactive...");
        
        // Return true or false, depending if the update was perform or not
        return myDBConn.doUpdate(table, assignmentList, where);
    }
    
    /**
        <h1>getAmountProducts support method</h1>
            Allow us to determine the amount of products in the database
            @return
                integer value indicating the amount of products in the database
    */
    private int getAmountProducts() {
        // Declare function variables
        String field, table;
        int amount = 0;

        // Define the field that is going to be retrieved from the database
        field = "productsId";

        // Define the table where the selection is performed
        table = "products";

        // Execute the selection on the database
        ResultSet res = myDBConn.doSelect(field, table);

        // Iterate over the ResulSet containing all products ids in 
        // the database, and count how many tuples were retrieved
        try {
            while(res.next())
                amount++;
            
            // Close the result set
            res.close();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            // return the amount of products in the database
            return amount;
        }
    }

    /**
        <h1>addProduct method</h1>
            add a product to the Database
            @param userName - username of the seller
            @param productName - the name of the new product
            @param description - the description of the new product
            @param initialBid - the initial bid of the new product
            @param pictureURL - the location of the picture in the web server 
            @param dueDate -  due date of the bid
            @param departments - array list of the departments that the 
                                 product belongs to
            @return
                <h3>boolean value:</h3>
                    <b>true:</b> the product was added successfully
                    <b>false:</b> the product cannot be added 
    */
    public boolean addProduct(String userName, String productName, String description, String initialBid, String pictureURL, String dueDate, ArrayList<String> departments) {
        // declaring function variables
        String table, values;

        // Determining the new product id
        int productsId = getAmountProducts()+1;

        // Define the table where the insertion will be performed
        table = "products";

        // Define the values to be inserted in the product table
        values = "" + productsId + ", \"" + productName + "\", \"" + description + "\", " + initialBid + ", \"" +
                pictureURL + "\", \"" + dueDate + "\", 1";

        // Disable the auto commit because we are going to do a transaction
        myDBConn.disableAutoCommit();

        // true or false, depending if the insert was performed or not
        if(myDBConn.doInsert(table, values)) {
           //if the first insert was a success
            //Define the table where the next inserts are going to be performed
            table = "productsdepartments";
            // while we have departments in the array list we performed the insertions in the productsdepartments table 
            while(!departments.isEmpty()) {
                // Define the values to be inserted in the productsdepartments table
                values = "" + productsId + ", \"" + departments.get(0) + "\", now()";
                // if an error occurs return false
                if(!myDBConn.doInsert(table, values)) {
                    // error occurs, rollback to cancel the transaction
                    myDBConn.doRollback();
                    // enable auto-commit for future operations
                    myDBConn.enableAutoCommit();
                    return false;
                }
                // remove the first department since it has been already inserted 
                departments.remove(0);
            }
            // add the seller to the userProducts table
            // Define the table where the insertion will be performed
            table = "userProducts";
            // Define the values to be inserted in the userProducts table
            // Note: 0 means seller
            values = "'" + userName + "', " + productsId + ", 0, curdate(), " + initialBid;
            // perform the insert
            if(myDBConn.doInsert(table, values)) {
                // Since all inserts were made successfully, perform a commit 
                // to save the changes
                myDBConn.doCommit();
                // enable the auto-commit since the transaction has finished
                myDBConn.enableAutoCommit();
                // since all inserts were successful return true
                return true;
            }
        }
        // One of the insertions failed, so we need to rollback to the 
        // state before the transaction starts
        myDBConn.doRollback();
        // enable auto commit for future operations that are not transactions
        myDBConn.enableAutoCommit();
        // return false because the insertion fail
        return false;
    }

    /**
        <h1>infoForListProducts method</h1>
            Method used to retrieve the information that is going to be 
            shown in the product list in the administrator menu with 
            the filter in default value
            @return
                A ResultSet containing the information of the product 
    */
    public ResultSet infoForListProducts() {
        // declaring function variables
        String fields, table;

        // Define the table where the selection is performed
        table = "products";

        // Define the fields list to retrieve from the table 
        fields = "productsId, name, active, bid, pictureURL";

        System.out.println("Listing products information...");

        // return the ResultSet containing the information of the products
        return myDBConn.doSelect(fields, table);
    }

    /**
        <h1>departmentsBelongs method</h1>
            Method to determine the departments that a product belongs to
            @param productId - product identification number that we are 
                               going to determine the departments that 
                               belongs to
            @return
                A ResultSet containing the departments that a product 
                belongs to
    */
    public ResultSet departmentsBelongs(String productId) {
        // Declare function variables
        String field, table, where;
        
        // Define the table where the selection is performed
        table = "productsdepartments";
        
        // Define the field that is going to be retrieved
        field = "distinct departmentName";
        
        // Define the where condition 
        where = "productId = " + productId + " and date in (select date from productsdepartments where " 
        + "abs(timestampdiff(minute, date, (select max(date) from productsdepartments where productid = " + productId + 
        "))) = (select min(abs(timestampdiff(minute, date, (select max(date) from productsdepartments where "
        + "productid = " + productId + ")))) from productsdepartments))";
        
        System.out.println("Listing departments for product identified by " + productId + "...");
        
        // Return the result set containing all the departments that 
        // the products belongs to
        return myDBConn.doSelect(field, table, where);
    }

    /**
        <h1>searchArticleId method</h1>
            Search a specific product in the Database
            @param productId - the id of the product that the 
                               user is searching for
            @return
                A ResultSet containing the specific product the 
                user is searching for
    */
    public ResultSet searchArticleById(String productId) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "products";

        // Define the fields list to retrieve from the table 
        fields = "name, description, bid, pictureURL, dueDate, active";

        // Define the where condition to bring the correct product
        where = "productsId = " + productId;

        System.out.println("Searching product identified by "+ productId + "...");
                
        // Return the ResultSet containing the specific product 
        // that the user search for in the database
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>searchUser method</h1>
            search a specific user information in the Database
            @param userName - username of the user that we want to search 
                              the information
            @return
                A ResultSet containing the specific user information 
                searched for
    */
    public ResultSet searchUser(String userName) {
        // Declare function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "userAccess";

        // Define the fields list to retrieve from the table 
        fields = "userName, name, telephone, postalAddress, active, email";

        // Define the where condition to search the information of the correct user
        where = "userName = '" + userName + "'";

        System.out.println("Searching user identified by "+ userName + " information...");
                
        // Return the ResultSet containing the specific user information 
        // searched for in the database
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>userIsInactive method</h1>
            Determine if a user is inactive in the database
            @param userName - is the user that you are checking if it 
                              is inactive
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the user is inactive 
                    <b>false:</b> the user is active or does not exists
    */
    public boolean userIsInactive(String userName) {
        // Declare function variables
        String field, table, where;

        // Declaring and initializing the result default value
        boolean result = false;

        // Define the table where the selection is performed
        table = "userAccess";

        // Define the fields list to retrieve from the table 
        field = "userName";

        // Define the where condition to filter the inactive 
        // and the specific user
        where = "userName = '" + userName +"' and active=0";
        
        System.out.println("Determining if user is inactive...");
        
        // call the doSelect to determine if the user is inactive
        ResultSet res = myDBConn.doSelect(field, table, where);

        try {
            // Check if the result set has a result and if it does 
            // this means that the user is inactive and returns true,
            // if result set is empty this means that user is
            // active or does not exists hence will return false
            if(res.next())
                result = true;
            else
                result = false;

            // close the result set
            res.close();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            return result;
        }
    }

    /**
        <h1>userIsActive method</h1>
            Determine if a user is active in the database
            @param userName - is the user that you checking if it is active
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the user is active 
                    <b>false:</b> the user is inactive or does not exists
    */
    public boolean userIsActive(String userName) {
        // Declare function variables
        String field, table, where;

        // Declaring and initializing the result default value
        boolean result = false;

        // Define the table where the selection is performed
        table = "userAccess";

        // Define the fields list to retrieve from the table 
        field = "userName";

        // Define the where condition to filter the active and the 
        // specific user
        where = "userName = '" + userName +"' and active=1";
        
        System.out.println("Determining if user is active...");
        
        // call the doSelect to determine if the user is active
        ResultSet res = myDBConn.doSelect(field, table, where);

        try {
            // Check if the result set has a result and if it does 
            // this means that the user is active and returns true.
            // If result set is empty this means that user is inactive 
            // or does not exists, hence will return false
            if(res.next())
                result = true;
            else
                result = false;
            
            // close the result set
            res.close();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            return result;
        }
    }

    /**
        <h1>makeBid method</h1>
            Determine if the user can make a bid and do it
            @param userName - username of the user making the bid
            @param productId - identification of the product offered
            @param bid - bid amount on the product 
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the bid was made successfully 
                    <b>false:</b> the user can not make the bid
    */
    public boolean makeBid(String userName, String productId, String bid) {
        // declaring function variables
        String table, field, values, where;
      // The first step is to determine if the user performing the bid 
      // is not the seller of the same product
        // Define the table that is going to help check if the user
        // is not the seller of the product that is going to be bidded on
        table = "userProducts";

        // Define the where condition to check if the usernames are 
        // not the seller's username of the specific product id
        where = "userName = '" + userName + "' and productId = " + productId + " and sells_buys = 0";   

        // Define the fields list to retrieve from the table 
        field = "userName";

        // Declaring a result set to stored the result of the selection operations
        ResultSet res;

        // call the doSelect to determine if the user making the bid 
        // is also the seller
        res = myDBConn.doSelect(field, table, where);

        try {
            //Check if the result set has a result and if it does this 
            // means that the user is the seller and returns false
            if(res.next()) {
                System.out.println("The seller can not make a bid for its own product...");
                return false;
            }

          // Verify if the bid is higher than the current highest bid
            // Define the table where the selection is going to be performed
            table = "products";

            // Define the fields list to retrieve from the table
            field = "bid";

            // Define the where condition to find the correct product 
            // by its product id
            where = "productsId = " + productId;

            // call the selection method to retrieve the information 
            // from the database, the return should be one tuple
            res = myDBConn.doSelect(field, table, where);

            if(res.next()) {   
                // check if the bid in the database is equal or higher 
                // than the new one, if so, return false
                if(Double.valueOf(res.getString(1)) >= Double.valueOf(bid)) {
                    System.out.println("The bid is equal or lower than the actual bid...");
                    return false;
                }
            } else {
              // the product does not exists in the database
                System.out.println("The product does not exists in the database...");
                return false;
            }
            // close the result set
            res.close();

            // Define the table where the insertion is going to be performed
            table = "userProducts";

            // Define the values to be inserted in the userProduct table
            values = "'" + userName + "', " + productId + ", 1, curdate(), " + bid;

            // Disable the auto commit since we are starting a transaction
            myDBConn.disableAutoCommit();

            // perform insert in userProduct
            if(myDBConn.doInsert(table, values)) {
              // update the bid value in the products table
                // Define the new table where the update is going to 
                // be performed
                table = "products";

                // declaring and initializing assignment list
                String assignmentList = "bid = "+ bid;   

                // Define the where condition to filter the productId 
                // in which the update of the bid is going to be performed
                where = "productsId = " + productId;

                // Check if the doUpdate does the update to the product 
                // table and returns true
                if(myDBConn.doUpdate(table, assignmentList, where)) {
                    // Since all the transaction was a success, we perform 
                    // a commit to save the changes
                    myDBConn.doCommit();
                    // enable the auto commit for later queries
                    myDBConn.enableAutoCommit();
                    // Return true since the bid was successfully made
                    return true;
                }
            }
            // one or more part of the transaction fails, so we need to rollback
            myDBConn.doRollback();
            // enable the auto commit for later queries
            myDBConn.enableAutoCommit();
            // Return false since the bid was not successfully made
            return false;
        } catch(Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
        <h1>infoInactiveProducts method</h1>
            Method used to retrieve the basic information (id, name, 
            highest bid, pictureURL) of the inactive products to the 
            administrator
            @return
                A ResultSet containing the basic information of the product 
    */
    public ResultSet infoInactiveProducts() {
        // declaring function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "products";

        // Define the fields list to retrieve from the table 
        fields = "productsId, name, bid, pictureURL";

        // Define the where condition to filter the inactive products
        where = "active=0";

        System.out.println("Listing inactive product basic information...");

        // return the ResultSet containing the basic information of 
        // the inactive products
        return myDBConn.doSelect(fields, table, where);
    }

    /**
       <h1>infoActiveProducts method</h1>
            Method used to retrieve the basic information (id, name, 
            highest bid, pictureURL) of the active products to the
            administrator 
            @return 
                A ResultSet containing the basic information of the 
                active product 
    */
    public ResultSet infoActiveProducts() {
        // declaring function variables
        String fields, table, where;

        // Define the table where the selection is performed
        table = "products";

        // Define the fields list to retrieve from the table 
        fields = "productsId, name, bid, pictureURL";

        // Define the where condition to filter the active products
        where = "active=1";

        System.out.println("Listing active product basic information...");

        // return the ResultSet containing the basic information of 
        // the active products
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>updateUserInfo method</h1>
            Method used to update the information of a user
            @param userName - username of the client that the information 
                              is being updated 
            @param completeName - new name of the client
            @param tel - new telephone number of the client
            @param postalAd - new postal address of the client
            @param email - new email of the client
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the user information was updated
                    <b>false:</b> the user information was not updated
    */
    public boolean updateUserInfo(String userName, String completeName, String tel, String postalAd, String email) {
        // Declare function variables
        String table, assignmentList, where;
        
        // Define the table where the update is performed
        table = "useraccess";
        
        // Define the assignment list
        assignmentList = "name = '" + completeName + "', telephone = '" + tel + 
                        "', postalAddress = '" + postalAd + "', email = '" + email + "'";
        
        // Define the where condition to update the correct user
        where = "userName='" + userName + "'";
        
        System.out.println("Updating user information...");
        
        // Return true or false, depending if the update was perform or not
        return myDBConn.doUpdate(table, assignmentList, where);
    }

    /**
        <h1>updateUserInfo method</h1>
            Method used to update the information of a user
            @param userName - username of the client that the information
                              is being updated
            @param completeName - new name of the client
            @param tel - new telephone number of the client
            @param postalAd - new postal address of the client
            @param active - new state of the user (active=true, inactive=false)
            @param email - new email of the client
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the user information was updated
                    <b>false:</b> the user information was not updated
    */
    public boolean updateUserInfo(String userName, String completeName, String tel, String postalAd, boolean active, String email) {
        // Declare function variables
        String table, assignmentList, where;
        
        // Define the table where the update is performed
        table = "useraccess";

        // Declare variable to hold the state of the user
        String userState;

        // verify the state and assign 1 for active and 0 for inactive
        if(active)
            userState="1";
        else
            userState="0";
        
        // Define the assignment list
        assignmentList = "name = '" + completeName + "', telephone = '" + tel + 
                        "', postalAddress = '" + postalAd + "', active = " + userState + ", email = '" + email + "'";
        
        // Define the where condition to update the correct user
        where = "userName='" + userName + "'";
        
        System.out.println("Updating user information...");
        
        // Return true or false, depending if the update was perform or not
        return myDBConn.doUpdate(table, assignmentList, where);
    }

    /**
        <h1>updateUserInfo method</h1>
            Method used to update the information of a user
            @param userName - username of the client that the information
                              is being updated
            @param password - new password of the client
            @param completeName - new name of the client
            @param tel - new telephone number of the client
            @param postalAd - new postal address of the client
            @param email - new email of the client
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the user information was updated
                    <b>false:</b> the user information was not updated
    */
    public boolean updateUserInfo(String userName, String password, String completeName, String tel, String postalAd, String email) {
        // Declare function variables
        String table, assignmentList, where, hashingValue;

        // Calling the function that will produce the hashing value 
        // based on the username and the new password
        hashingValue = hashingSha256(userName + password);
        
        // Define the table where the update is performed
        table = "useraccess";
        
        // Define the assignment list
        assignmentList = "hashingValue = '" + hashingValue + "', name = '" + completeName + "', telephone = '" + tel + 
                        "', postalAddress = '" + postalAd + "', email = '" + email + "'";
        
        // Define the where condition to update the correct user
        where = "userName='" + userName + "'";
        
        System.out.println("Updating user information...");
        
        // Return true or false, depending if the update was perform or not
        return myDBConn.doUpdate(table, assignmentList, where);
    }

    /**
        <h1>updateUserInfo method</h1>
            Method used to update the information of a user
            @param userName - username of the client that the information 
                              is being updated
            @param password - new password of the client
            @param completeName - new name of the client
            @param tel - new telephone number of the client
            @param postalAd - new postal address of the client
            @param active - new state of the user (active=true, inactive=false)
            @param  email - new email of the client
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the user information was updated
                    <b>false:</b> the user information was not updated
    */
    public boolean updateUserInfo(String userName, String password, String completeName, String tel, String postalAd, boolean active, String email) {
        // Declare function variables
        String table, assignmentList, where, hashingValue;

        // Calling the function that will produce the hashing value
        // based on the username and the new password
        hashingValue = hashingSha256(userName + password);
        
        // Define the table where the update is performed
        table = "useraccess";

        // Declare variable to hold the state of the user
        String userState;

        // verify the state and assign 1 for active and 0 for inactive
        if(active)
            userState = "1";
        else
            userState = "0";
        
        // Define the assignment list
        assignmentList = "hashingValue = '" + hashingValue + "', name = '" + completeName + "', telephone = '" + tel + 
                        "', postalAddress = '" + postalAd + "', active = " + userState + ", email = '" + email + "'";
        
        // Define the where condition to update the correct user
        where = "userName='" + userName + "'";
        
        System.out.println("Updating user information...");
        
        // Return true or false, depending if the update was perform or not
        return myDBConn.doUpdate(table, assignmentList, where);
    }

    /**
        <h3>hashingSha256 method</h3>
            Generates a hash value using the sha256 algorithm.
            @param plainText - plain text that is going to be converted 
                               to a hashing value
            @return the hash string based on the plainText
    */
    private String hashingSha256(String plainText) {
        // Generate the hashing value
        String sha256hex = org.apache.commons.codec.digest.DigestUtils.sha256Hex(plainText);
        // return the hashing value  
        return sha256hex;
    }

    /**
        <h1>makeProductInactive method</h1>
            Make a product inactive in the database
            @param productId - identification number of the product 
                               that is going to be inactive
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the product is now inactive
                    <b>false:</b> the product is still active
    */
    public boolean makeProductInactive(String productId) {
        // Declare function variables
        String table, assignmentList, where;

        // Define the table where the update is performed
        table = "products";

        // Define the assignment list
        assignmentList = " active = 0";

        // Define the where condition to update the correct product
        where = "productsId = " + productId;
        
        System.out.println("Making Product identified by "+ productId +" inactive...");

        // Return true or false, depending if the update was perform or not 
        return myDBConn.doUpdate(table, assignmentList, where);
    }


    /*********
        <h1>updateProductInfo method</h1>
            Update a specific product information
            @param productId - is the identification of the product that 
                               is going to be updated
            @param name - is the new name of the product
            @param description - is the new description of the product
            @param bid - is the new bid of the product
            @param pictureURL - is the new pictureURL of the product
            @param dueDate - is the new dueDate of the product
            @param departments - array list of the departments that the 
                                 product belongs to
            @param active - is the new state of the product
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the product was successfully updated
                    <b>false:</b> the product was not successfully updated
    */
    public boolean updateProductInfo(String productId, String name, String description, String bid, 
                    String pictureURL, String dueDate, ArrayList<String> departments, String active)
    {
        // Declare function variables
        String table, assignmentList, where;

        // Define the table where the update is performed
        table = "products";

        // Define the assignment list
        assignmentList = "name = '" + name + "', description = '" + description + "', bid = " + bid 
                         + ", pictureURL = '" + pictureURL + "', dueDate = '" + dueDate + "', active = " + active;

        // Define the where condition to update the correct user
        where = "productsId = " + productId;
        
        // Disable the auto commit because we are going to do a transaction
        myDBConn.disableAutoCommit();

        System.out.println("Updating information of product identified by "+ productId +"...");

        // true or false, depending if the update was perform or not 
        if(myDBConn.doUpdate(table, assignmentList, where)) {
          // if the update was a success
            // Define the variable that will hold the departments inserts
            String values;
            // Define the table where the next inserts are going to be performed
            table = "productsdepartments";
            // while we have departments in the array list we performed 
            // the insertions in the productsDepartments table 
            while(!departments.isEmpty()) {
                // Define the values to be inserted in the productsDepartments table
                values = "" + productId + ", \"" + departments.get(0) + "\", now()";
                // if an error occurs return false
                if(!myDBConn.doInsert(table, values)) {
                    // error occurs, rollback to cancel the changes
                    myDBConn.doRollback();
                    myDBConn.enableAutoCommit();
                    return false;
                }
                // remove the first department since it has been already inserted 
                departments.remove(0);
            }
            // All departments where inserted
            // Since all inserts and the update were made successfully, 
            // perform a commit to save the changes
            myDBConn.doCommit();
            // enable the auto commit since the transaction has finish
            myDBConn.enableAutoCommit();
            // if all inserts and the update were successful return true
            return true;
        } else {
          // Update fail
            // Rollback the changes
            myDBConn.doRollback();
            // Enable auto-commit for future operations
            myDBConn.enableAutoCommit();
            // return false
            return false;
        }
    }

    /**
        <h1>updateProductInfo method</h1>
            Update a specific product information
            @param productId - is the identification of the product 
                               that is going to be updated
            @param name - is the new name of the product
            @param description - is the new description of the product
            @param bid - is the new bid of the product
            @param dueDate - is the new dueDate of the product
            @param departments - array list of the departments that the 
                                 product belongs to
            @param active - is the new state of the product
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the product was successfully updated
                    <b>false:</b> the product was not successfully updated
    */
    public boolean updateProductInfo(String productId, String name, String description, String bid, 
                                     String dueDate, ArrayList<String> departments, String active)
    {
        // Declare function variables
        String table, assignmentList, where;

        // Define the table where the update is performed
        table = "products";

        // Define the assignment list
        assignmentList = "name = '" + name + "', description = '" + description + "', bid = " + bid 
                         + ", dueDate = '" + dueDate + "', active = " + active;

        // Define the where condition to update the correct user
        where = "productsId = " + productId;
        
        // Disable the auto commit because we are going to do a transaction
        myDBConn.disableAutoCommit();

        System.out.println("Updating information of product identified by "+ productId +"...");

        // true or false, depending if the update was perform or not 
        if(myDBConn.doUpdate(table, assignmentList, where)) {
          // if the update was a success
            // Define the variable that will hold the departments inserts
            String values;
            // Define the table where the next inserts are going to be performed
            table = "productsdepartments";
            // while we have departments in the array list we performed 
            // the insertions in the productsDepartments table 
            while(!departments.isEmpty()) {
                // Define the values to be inserted in the productsDepartments table
                values = "" + productId + ", \"" + departments.get(0) + "\", now()";
                // if an error occurs return false
                if(!myDBConn.doInsert(table, values)) {
                    // Rollback the changes
                    myDBConn.doRollback();
                    // Enable auto-commit for future operations
                    myDBConn.enableAutoCommit();
                    // return false
                    return false;
                }
                // remove the first department since it has been 
                // already inserted 
                departments.remove(0);
            }
            // All departments where inserted
            // Since all inserts and the update were made successfully, 
            // perform a commit to save the changes
            myDBConn.doCommit();
            // enable the auto commit since the transaction has finish
            myDBConn.enableAutoCommit();
            // if all inserts and the update were successful return true
            return true;
        } else {
          // Update fail
            // Rollback the changes
            myDBConn.doRollback();
            // Enable auto-commit for future operations
            myDBConn.enableAutoCommit();
            // return false
            return false;
        }
    }

    /**
        <h1>updateProductInfo method</h1>
            Update a specific product information
            @param productId - is the identification of the product 
                               that is going to be updated
            @param name - is the new name of the product
            @param description - is the new description of the product
            @param bid - is the new bid of the product
            @param pictureURL - is the new pictureURL of the product
            @param dueDate - is the new dueDate of the product
            @param departments - array list of the departments that the 
                                 product belongs to
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the product was successfully updated
                    <b>false:</b> the product was not successfully updated
    */
    public boolean updateProductInfo(String productId, String name, String description, String bid, 
                                     String pictureURL, String dueDate, ArrayList<String> departments)
    {
        // Declare function variables
        String table, assignmentList, where;

        // Define the table where the update is performed
        table = "products";

        // Define the assignment list
        assignmentList = "name = '" + name + "', description = '" + description + "', bid = " 
                         + bid + ", pictureURL = '" + pictureURL + "', dueDate = '" + dueDate +"'";

        // Define the where condition to update the correct user
        where = "productsId = " + productId;

        // Disable the auto commit because we are going to do a transaction
        myDBConn.disableAutoCommit();
        
        System.out.println("Updating information of product identified by "+ productId +"...");

        // true or false, depending if the update was perform or not 
        if(myDBConn.doUpdate(table, assignmentList, where)) {
          // if the update was a success
            // Define the variable that will hold the departments inserts
            String values;
            // Define the table where the next inserts are going to be performed
            table = "productsdepartments";
            // while we have departments in the array list we performed 
            // the insertions in the productsDepartments table 
            while(!departments.isEmpty()) {
                // Define the values to be inserted in the productsDepartments table
                values = "" + productId + ", \"" + departments.get(0) + "\", now()";
                // if an error occurs return false
                if(!myDBConn.doInsert(table, values)) {
                    // Rollback the changes
                    myDBConn.doRollback();
                    // Enable auto-commit for future operations
                    myDBConn.enableAutoCommit();
                    // return false
                    return false;
                }
                // remove the first department since it has been already inserted 
                departments.remove(0);
            }
            // All departments where inserted
            // Since all inserts and the update were made successfully, 
            // perform a commit to save the changes
            myDBConn.doCommit();
            // enable the auto commit since the transaction has finish
            myDBConn.enableAutoCommit();
            // if all inserts and the update were successful return true
            return true;
        } else {
          // Update fail
            // Rollback the changes
            myDBConn.doRollback();
            // Enable auto-commit for future operations
            myDBConn.enableAutoCommit();
            // return false
            return false;
        }
    }

    /**
        <h1>updateProductInfo method</h1>
            Update a specific product information
            @param productId - is the identification of the product that 
                               is going to be updated
            @param name - is the new name of the product
            @param description - is the new description of the product
            @param bid - is the new bid of the product
            @param dueDate - is the new dueDate of the product
            @param departments - array list of the departments that the 
                                 product belongs to
            @return
                <h3>boolean values:</h3>
                    <b>true:</b> the product was successfully updated
                    <b>false:</b> the product is yet to be updated
    */
    public boolean updateProductInfo(String productId, String name, String description, String bid, 
                                     String dueDate, ArrayList<String> departments)
    {
        // Declare function variables
        String table, assignmentList, where;

        // Define the table where the update is performed
        table = "products";

        // Define the assignment list
        assignmentList = "name = '" + name + "', description = '" + description + "', bid = " 
                         + bid + ", dueDate = '" + dueDate +"'";

        // Define the where condition to update the correct user
        where = "productsId = " + productId;
        
        // Disable the auto commit because we are going to do a transaction
        myDBConn.disableAutoCommit();

        System.out.println("Updating information of product identified by "+ productId +"...");

        // true or false, depending if the update was perform or not 
        if(myDBConn.doUpdate(table, assignmentList, where)) {
          // if the update was a success
            // Define the variable that will hold the departments inserts
            String values;
            // Define the table where the next inserts are going to be performed
            table = "productsdepartments";
            // while we have departments in the array list we performed 
            // the insertions in the productsDepartments table 
            while(!departments.isEmpty()) {
                // Define the values to be inserted in the productsDepartments table
                values = "" + productId + ", \"" + departments.get(0) + "\", now()";
                // if an error occurs return false
                if(!myDBConn.doInsert(table, values)) {
                    // Rollback the changes
                    myDBConn.doRollback();
                    // Enable auto-commit for future operations
                    myDBConn.enableAutoCommit();
                    // return false
                    return false;
                }
                // remove the first department since it has been already inserted 
                departments.remove(0);
            }
            // All departments where inserted
            // Since all inserts and the update were made successfully, 
            // perform a commit to save the changes
            myDBConn.doCommit();
            // enable the auto commit since the transaction has finish
            myDBConn.enableAutoCommit();
            // if all inserts and the update were successful return true
            return true;
        } else {
          // Update fail
            // Rollback the changes
            myDBonn.doRollback();
            // Enable auto-commit for future operations
            myDBConn.enableAutoCommit();
            // return false
            return false;
        }
    }

    /**
        <h1>listActiveDepartments method</h1>
            List all the active departments in the database
            @return
                A ResultSet containing all the active departments in the database
    */
    public ResultSet listActiveDepartments() {
        // Declare function variables
        String field, table, where;
        
        // Define the table where the selection is performed
        table = "departments";
        
        // Define the fields list to retrieve from the table departments
        field = "departmentName";
        
        // Define the where condition to filter the active departments
        where = "active=1";
        
        System.out.println("Listing active departments...");
        
        // Return the ResultSet containing all the active departments in the database
        return myDBConn.doSelect(field, table, where);
    }
    /**
        <h1>addDepartment method</h1>
            Method used to add a department to the system
            @param department - the name of the department that is going 
                                to be added to the database
            @return
                <h3>boolean value:</h3>
                    <b>true:</b> the department was added successfully
                    <b>false:</b> the department cannot be added
    */
    public boolean addDepartment(String department) {
        // Declare function variables
        String table, values;

        // Define the table where the department information is inserted
        table = "departments";

        // Define the values to be inserted
        values = "'" + department + "', 1";

        System.out.println("Adding new department...");

        // return true if the new department is added to the database,
        // else, false
        return myDBConn.doInsert(table, values);
    }

    /**
        <h1>isDepartmentActive method</h1>
            Method used to determine if a department is active in the system
            @param department - the name of the department to be check
            @return
                <h3>boolean value:</h3>
                    <b>true:</b> the department is active in the system
                    <b>false:</b> the department is inactive or does 
                                  not exists in the system
    */
    public boolean isDepartmentActive(String department) {
        // Declare function variables
        String field, table, where;

        // Declaring and initializing the result default value
        boolean result = false;

        // Define the table where the selection is performed
        table = "departments";

        // Define the fields list to retrieve from the table 
        field = "departmentName";

        // Define the where condition to filter the results
        where = "departmentName='" + department + "' and active=1";
        
        System.out.println("Determining if department is active...");
        
        // call the doSelect to determine if the department is active
        ResultSet res = myDBConn.doSelect(field, table, where);

        try {
            // Check if the result set has a result and if it does 
            // this means that the department is active and returns true
            // if result set is empty this means that department is inactive
            // or does not exists hence will return false
            if(res.next()) {
                result = true;
                System.out.println("Department is active...");
            } else {
                result = false;
                System.out.println("Department is inactive or does not exists...");
            }
            // close result set
            res.close();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            return result;
        }
    }

    /**
        <h1>isDepartmentInactive method</h1>
            Method used to determine if a department is inactive in the system
            @param department - the name of the department to be check
            @return
                <h3>boolean value:</h3>
                    <b>true:</b> the department is inactive in the system
                    <b>false:</b> the department is active or does not 
                                  exists in the system
    */
    public boolean isDepartmentInactive(String department) {
        // Declare function variables
        String field, table, where;

        // Declaring and initializing the result default value
        boolean result = false;

        // Define the table where the selection is performed
        table = "departments";

        // Define the fields list to retrieve from the table 
        field = "departmentName";

        // Define the where condition to filter the results
        where = "departmentName='" + department +"' and active=0";
        
        System.out.println("Determining if department is inactive...");
        
        // call the doSelect to determine if the department is active
        ResultSet res = myDBConn.doSelect(field, table, where);

        try {
            // Check if the result set has a result and if it does this 
            // means that the department is inactive and returns true
            // if result set is empty this means that department is active
            // or does not exists hence will return false
            if(res.next()) {
                result = true;
                System.out.println("Department is inactive...");
            } else {
                result = false;
                System.out.println("Department is active or does not exists...");
            }
            // Close the result set
            res.close();
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            return result;
        }
    }

    /**
        <h1>searchProductAllDepartments method</h1>
            Search products in all departments in the database 
            by their name and comparing it with the client search
            @param search - the search performed by the client
            @return
                A ResultSet containing the results of the search 
                in the database
    */
    public ResultSet searchProductAllDepartments(String search) {
        // Declare function variables
        String fields, table, where;
        
        // Define the table where the selection is performed
        table = "products";
        
        // Define the fields list to retrieve from the table products
        fields = "distinct productsId, name, bid, pictureURL";
        
        // Define the where condition empty at first
        where = "";   

        // Split the search into words
        String[] splitArray = search.split(" ");
        
        // determine the size of the array containing the words
        int size = splitArray.length;
        
        // declare the variable that will hold the result for each
        // combination of words
        String result = "";

        // Iterate through the array containing the words and mix them together
        for(int i=0; i<size; i++) {
            // Take the word in the i position
            result = splitArray[i];
            for(int j=0; j<size; j++) {
                // if the i and the j are not the same we concatenate 
                // the other word
                if(i!=j)
                    result = result + " " + splitArray[j];
                
            }
            // is the first iteration?
            if(i==0) {
                //it is the first iteration, hence the where condition
                // is defined as follows
                where = "(name LIKE '%" + result + "%'";
            } else {
                //is not the first iteration, hence the where condition
                // is defined as follows
                where += " OR name LIKE '%" + result + "%'";
            }
        }
        // making sure that the product is active to show it
        where += ") and active=1 and dueDate>=curdate()";
        System.out.println("Listing products...");
        
        // Return the ResultSet containing all the matching products 
        // with the search
        return myDBConn.doSelect(fields, table, where);
    }

    /**
        <h1>searchProductByDepartments method</h1>
            Search products in the database by their name and comparing
            it with the client search and the selected department
            @param search - the search performed by the client
            @param department - the department selected by the client 
                                to search in for the product
            @return
                A ResultSet containing the results of the search in 
                the database
    */
    public ResultSet searchProductByDepartments(String search, String department) {
        // Declare function variables
        String fields, tables, where, name;
        
        // Define the tables where the selection is performed
        tables = "products p, productsdepartments pd";
        
        // Define the fields list to retrieve from the tables
        fields = "distinct p.productsid, name, bid, pictureURL";
        
        // Define the names of the product
        name = "";   

        // Split the search into words
        String[] splitArray = search.split(" ");
        
        // determine the size of the array containing the words
        int size = splitArray.length;
        
        // declare the variable that will hold the result
        // for each combination of words
        String result = "";

        // Iterate through the array containing the words and mix them together
        for(int i=0; i<size; i++) {
            // Take the word in the i position
            result = splitArray[i];
            for(int j=0; j<size; j++) {
                // if the i and the j are not the same we concatenate 
                // the other word
                if(i!=j)
                    result = result + " " + splitArray[j];
            }
            // is the first iteration?
            if(i==0)
                name = "(name LIKE '%" + result + "%'";
            else
                name += " OR name LIKE '%" + result + "%'";
        }
        // Add the closing parenthesis
        name += ")";
        // define the where condition
        where = " pd.productid=p.productsid and " + name + " and date in " 
                + "(select date from productsdepartments, products where " + name + " and" 
                + " abs(timestampdiff(minute,date, (select max(date) from productsdepartments pd, products p"
                + " where pd.productid=p.productsid and " + name + " ))) = (select min(abs(timestampdiff(minute, " 
                + "date, (select max(date) from productsdepartments pd, products p where pd.productid=p.productsid"
                + " and " + name + " )))) from productsdepartments, products))"
                + " and active=1 and departmentName='" + department + "' and dueDate>=curdate()";
        
        System.out.println("Listing products...");
        
        // Return the ResultSet containing all the matching products 
        // with the search
        return myDBConn.doSelect(fields, tables, where);
    }

    /**
		<h1>close method</h1>
			Close the connection to the database.
			This method must be called at the end of each 
            page/object that instantiates a applicationDBManager object
	*/
	public void close()	{
		//Close the connection
		myDBConn.closeConnection();
	}

	/**
		<h1>Debugging method</h1>
			@param args[]: String array 
	*/
	public static void main(String[] args) {
		
		try {
			// Create a applicationDBManager object
			applicationDBManager appDBMnger = new applicationDBManager();
			System.out.println("Connecting...");
			System.out.println(appDBMnger.toString());
			
            // Test for the updateUserInfo method
            // Declare variables
            String userName, password, completeName, tel, postalAd, email;
            // Initialize variables
            userName = "arivesan";
            password = "test";
            completeName = "A Rive";
            tel = "(787)-777-7777";
            postalAd = "Test...";
            email = "test@gmail.com";

            boolean active = true; 
            // try to update the user information
            if(appDBMnger.updateUserInfo(userName, password, completeName, tel, postalAd, active, email))
                System.out.println("The user has been updated...");
            else
                System.out.println("The user can not be updated...");

			// Close the database connection
			appDBMnger.close();
			
		} catch(Exception e) {
			e.printStackTrace();
		}		
	}
}