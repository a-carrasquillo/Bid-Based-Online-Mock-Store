// Define the project package
package edu.suagm.ut.cpen410.finalprojectmobilebidsystem;
// Import the required libraries
import android.util.Log;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

/**
 *  CPEN 410 - Mobile, Web, and Internet Programming
 *
 *  This class downloads the data from a web server.
 *  @author a-carrasquillo
 * */
public class HttpHandler {

    // This for debugging purposes
    private static final String TAG = HttpHandler.class.getSimpleName();

    /**
     *  Default constructor
     */
    public HttpHandler() {
    }

    /***
     *  This method authenticate the user using the given 
     *  servlet in the URL with the respective 
     *  username and password
     *      @param reqUrl: target URL
     *      @param userName: username of the user
     *      @param pass: password of the user
     *      @return response: response of the server
     */
    public String authenticateUser(String reqUrl, String userName, String pass) {
        // HTTP Response
        String response = null;
        try {
            // Generate a URL object from the requested URL
            URL url = new URL(reqUrl);

            // Create a HTTP Connection
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            // Define Request POST
            conn.setRequestMethod("POST");

            // Define the parameters list
            String parameters = "user=" + userName + "&pass=" + pass;

            // Establish the option for sending parameters
            // using the POST method
            conn.setDoOutput(true);

            // Add the parameters list to the HTTP request
            conn.getOutputStream().write(parameters.getBytes("UTF-8"));

            // read the response
            InputStream in = new BufferedInputStream(conn.getInputStream());

            // Convert the InputStream in a String
            response = convertStreamToString(in);
        } catch (MalformedURLException e) {
            Log.e(TAG, "MalformedURLException: " + e.getMessage());
        } catch (ProtocolException e) {
            Log.e(TAG, "ProtocolException: " + e.getMessage());
        } catch (IOException e) {
            Log.e(TAG, "IOException: " + e.getMessage());
        } catch (Exception e) {
            Log.e(TAG, "Exception: " + e.getMessage());
        }
        return response;
    }

    /**
     *  This method performs a products search in the system
     *  using a servlet indicated in the URL with
     *  the respective search value and filter as parameters
     *      @param reqUrl: Target URL
     *      @param search: Search value entered by the user
     *      @param filter: department filter selected by the user
     *      @return response: response of the server
     */
    public String productSearch(String reqUrl, String search, String filter) {
        // HTTP Response
        String response = null;
        try {
            // Generate a URL object from the requested URL
            URL url = new URL(reqUrl);

            // Create a HTTP Connection
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            // Define Request POST
            conn.setRequestMethod("POST");
            // If All Departments filter was chosen then empty the variable
            if(filter.equals("All Departments")) {
                filter = "";
            }

            // Define the parameters list
            String parameters = "search=" + search + "&filter=" + filter;

            // Establish the option for sending parameters
            // using the POST method
            conn.setDoOutput(true);

            // Add the parameters list to the HTTP request
            conn.getOutputStream().write(parameters.getBytes("UTF-8"));

            // read the response
            InputStream in = new BufferedInputStream(conn.getInputStream());

            // Convert the InputStream in a String
            response = convertStreamToString(in);
        } catch (MalformedURLException e) {
            Log.e(TAG, "MalformedURLException: " + e.getMessage());
        } catch (ProtocolException e) {
            Log.e(TAG, "ProtocolException: " + e.getMessage());
        } catch (IOException e) {
            Log.e(TAG, "IOException: " + e.getMessage());
        } catch (Exception e) {
            Log.e(TAG, "Exception: " + e.getMessage());
        }
        return response;
    }

    /**
     *  This method performs an specific product search
     *  in the system using a servlet indicated in the URL
     *  using the product id as parameter of the search
     *      @param reqUrl: Target URL
     *      @param productId: id of the product to be searched
     *      @return response: response of the server
     */
    public String productSearchById(String reqUrl, String productId) {
        // HTTP Response
        String response = null;
        try {
            // Generate a URL object from the requested URL
            URL url = new URL(reqUrl);

            // Create a HTTP Connection
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            // Define Request POST
            conn.setRequestMethod("POST");

            // Define the parameters list
            String parameters = "productId=" + productId;

            // Establish the option for sending parameters
            // using the POST method
            conn.setDoOutput(true);

            // Add the parameters list to the HTTP request
            conn.getOutputStream().write(parameters.getBytes("UTF-8"));

            // read the response
            InputStream in = new BufferedInputStream(conn.getInputStream());

            // Convert the InputStream in a String
            response = convertStreamToString(in);
        } catch (MalformedURLException e) {
            Log.e(TAG, "MalformedURLException: " + e.getMessage());
        } catch (ProtocolException e) {
            Log.e(TAG, "ProtocolException: " + e.getMessage());
        } catch (IOException e) {
            Log.e(TAG, "IOException: " + e.getMessage());
        } catch (Exception e) {
            Log.e(TAG, "Exception: " + e.getMessage());
        }
        return response;
    }

    /**
     *  This method performs a bid to a specific product
     *      @param reqUrl: Target URL
     *      @param username: username of the user
     *      @param productId: id of the product to be searched
     *      @param bid: bid performed by the user
     *      @return response: response of the server
     */
    public String makeBid(String reqUrl, String username, String productId, String bid) {
        // HTTP Response
        String response = null;
        try {
            // Generate a URL object from the requested URL
            URL url = new URL(reqUrl);

            // Create a HTTP Connection
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            // Define Request POST
            conn.setRequestMethod("POST");

            // Define the parameters list
            String parameters = "userName=" + username + "&productId=" + productId + "&bid=" + bid;

            // Establish the option for sending parameters
            // using the POST method
            conn.setDoOutput(true);

            // Add the parameters list to the HTTP request
            conn.getOutputStream().write(parameters.getBytes("UTF-8"));

            // read the response
            InputStream in = new BufferedInputStream(conn.getInputStream());

            // Convert the InputStream in a String
            response = convertStreamToString(in);
        } catch (MalformedURLException e) {
            Log.e(TAG, "MalformedURLException: " + e.getMessage());
        } catch (ProtocolException e) {
            Log.e(TAG, "ProtocolException: " + e.getMessage());
        } catch (IOException e) {
            Log.e(TAG, "IOException: " + e.getMessage());
        } catch (Exception e) {
            Log.e(TAG, "Exception: " + e.getMessage());
        }
        return response;
    }

    /**
     *  This method downloads the JSON data from a Request URL
     *
     *      @param reqUrl: Target URL
     *      @return response: the response of the server
     */
    public String makeServiceCall(String reqUrl) {
        // HTTP Response
        String response = null;
        try {
            // Generate a URL object from the requested URL
            URL url = new URL(reqUrl);
            // Create a HTTP Connection
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            // Define Request POST
            conn.setRequestMethod("POST");
            System.out.println(conn.getRequestProperties().toString());
            // read the response
            InputStream in = new BufferedInputStream(conn.getInputStream());
            // Convert the InputStream in a String
            response = convertStreamToString(in);
        } catch (MalformedURLException e) {
            Log.e(TAG, "MalformedURLException: " + e.getMessage());
        } catch (ProtocolException e) {
            Log.e(TAG, "ProtocolException: " + e.getMessage());
        } catch (IOException e) {
            Log.e(TAG, "IOException: " + e.getMessage());
        } catch (Exception e) {
            Log.e(TAG, "Exception: " + e.getMessage());
        }
        return response;
    }

    /**
     *  This method generates a String  from a InputStream
     *      @param is: InputStream
     *      @return string conversion of the input stream
     */
    private String convertStreamToString(InputStream is) {
        // Generate a BufferedReader from a InputStream
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        // Create a StringBuilder
        StringBuilder sb = new StringBuilder();

        String line;
        try {
            // Traverse the inputStream and generate a String
            while((line = reader.readLine()) != null) {
                sb.append(line).append('\n');
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        // Return the String
        return sb.toString();
    }
}
