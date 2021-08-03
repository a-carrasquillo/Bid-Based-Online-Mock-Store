// Define the project package
package edu.suagm.ut.cpen410.finalprojectmobilebidsystem;
// Import the required libraries
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;

/** Class that allows us to execute the logic of the 
 *  main activity.
 *  @author a-carrasquillo
 * 
 * */
public class MainActivity extends AppCompatActivity {
    // User name and password
    private EditText uname, pwd;
    // Shared object though the application
    SharedPreferences pref;
    // Server default response
    private String serverResponse = "not";
    // Strings variables for the username and password
    private String username, password;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Link activity's controls with Java variables
        setContentView(R.layout.activity_main);
        uname = findViewById(R.id.txtName);
        pwd = findViewById(R.id.txtPwd);
        Button loginBtn = findViewById(R.id.btnLogin);

        // Create local session variables
        pref = getSharedPreferences("user_details",MODE_PRIVATE);
        // Delete local session variables because some bugs
        SharedPreferences.Editor editor = pref.edit();
        editor.clear();
        editor.apply();

        // Checks for session variables
        if(pref.contains("username") && pref.contains("password") && pref.contains("sessionValue")) {
            // The user has been logon
            // Retrieve the username and password from the local session variables
            username = pref.getString("username",null);
            password = pref.getString("sessionValue",null);
            // authenticate credentials
            new GetItems(MainActivity.this).execute();

        } else {
            // The user has not been authenticated
            loginBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    // Retrieve the username and password from the input boxes
                    username = uname.getText().toString();
                    password = pwd.getText().toString();

                    // validate that the fields are not empty
                    if(username.isEmpty()||password.isEmpty()) {
                        // show a message indicating the empty boxes
                        Toast.makeText(MainActivity.this, "Fill every field...", Toast.LENGTH_LONG).show();
                    } else {
                        // Authenticate the user via web-services
                        new GetItems(MainActivity.this).execute();
                    }
                }
            });
        }
    }

/**
 *  This class define a thread for networks transactions
 */
private class GetItems extends AsyncTask<Void, Void, Void> {

    // Context: every transaction in a Android application must be attached to a context
    private Activity activity;
    // URL of the servlet
    private String url;

    /**
     * Special constructor: assigns the context to the thread,
     * declare and initialize the host address, and the servlet
     * name. Also build the URL of the servlet.
     *
     *      @param activity: Context
     */
    //@Override
    protected GetItems(Activity activity) {
        // Server IP address and port
        String hostAddress = "yourIPAddress:YourPort";
        // Authentication servlet name
        String servletName="doAuthentication";
        // Define the servlet URL
        url = "http://" + hostAddress +"/"+ servletName;
        // Assign the context
        this.activity = activity;
    }

    /**
     *  on PreExecute method: runs after 
     *  the constructor is calledand before
     *  the thread runs
     */
    protected void onPreExecute() {
        super.onPreExecute();
        // Show a message in the screen that the user is being authenticated
        Toast.makeText(MainActivity.this, "Authenticating...", Toast.LENGTH_LONG).show();
    }

    /**
     *  Main thread
     * @param arg0: argument receive by the method
     *
     */
    protected Void doInBackground(Void... arg0) {
        // Declare string variables to hold the user credentials
        String userName, passWord;

        // Read GUI inputs
        userName = ((EditText) findViewById(R.id.txtName)).getText().toString();
        passWord = ((EditText) findViewById(R.id.txtPwd)).getText().toString();

        // Define a HttpHandler
        HttpHandler handler = new HttpHandler();

        // perform the authentication process and capture
        // the result in serverResponse variable
        serverResponse = handler.authenticateUser(url, userName, passWord);

        // Clean response
        serverResponse=serverResponse.trim();
        return null;
    }


    /**
     *  This method verify the authentication result
     *  If authenticated, it creates local session variables for the
     *  username and the user complete name and open an activity for
     *  product search, otherwise, it shows a error message
     *
     */
    protected void onPostExecute (Void result) {
        // Declare the toast message
        String msgToast;

        // Verify the authentication result
        // not: the user could not be authenticated, admin: the user is an administrator
        if(!serverResponse.equals("not")&&!serverResponse.equals("admin")) {
            // The user has been authenticated
            // Update local session variables
            SharedPreferences.Editor editor = pref.edit();
            editor.putString("username", username);
            editor.putString("completeName", serverResponse);
            editor.apply();

            // Define the next activity
            Intent intent = new Intent(MainActivity.this, welcomeSearch.class);

            // call the DetailsActivity
            startActivity(intent);
        } else if(serverResponse.equals("admin")) {
            // The user was authenticated, but was an administrator,
            // hence destroy session variables
            SharedPreferences.Editor editor = pref.edit();
            editor.clear();
            editor.apply();

            // Toast message
            msgToast = "Administrators should only use the Web Application!";
            Toast.makeText(getApplicationContext(),
                    msgToast,
                    Toast.LENGTH_LONG).show();
        } else {
            // The user could not been authenticated,
            // destroy session variables
            SharedPreferences.Editor editor = pref.edit();
            editor.clear();
            editor.apply();

            // Toast message
            msgToast= "Wrong user or password";
            Toast.makeText(getApplicationContext(),
                    msgToast,
                    Toast.LENGTH_LONG).show();
        }
    }
    }
}