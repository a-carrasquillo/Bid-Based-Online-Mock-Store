// Define the project package
package edu.suagm.ut.cpen410.finalprojectmobilebidsystem;
// Import the required libraries
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.ImageView;
import android.widget.Toast;
import java.io.InputStream;
import java.net.URL;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.List;
import android.widget.ArrayAdapter;
import androidx.appcompat.app.AppCompatActivity;

/** Class that allows us to execute the
 *  logic for the product search and result interface.
 *  @author a-carrasquillo
 * 
 * */
public class welcomeSearch extends AppCompatActivity {
    // Local Session Variable holder
    SharedPreferences prf;

    // This is for debugging
    private String TAG = welcomeSearch.class.getSimpleName();
    // Web server's IP address
    private String hostAddress;
    // Item list for storing data from the web server
    private List<String> departmentsList;
    // Adapter for the spinner
    private ArrayAdapter<String> spinnerAdapter;
    // Manage the spinner
    private Spinner departmentsFilter;
    // This is for managing the ListView in the activity
    private ListView lv;
    // Users adapter
    private UsersAdapter adapter;
    // Item list for storing data from the web server
    private ArrayList<userItem> itemUserList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Load the layout
        setContentView(R.layout.welcome_search);

        // Link activity's controls with Java variables
        TextView welcome = findViewById(R.id.welcomeMessage);
        Button btnLogOut = findViewById(R.id.btnLogOut);
        TextView searchMessage = findViewById(R.id.searchMessage);
        EditText searchValue = findViewById(R.id.searchValue);
        departmentsFilter = findViewById(R.id.departmentFilter);
        ImageButton searchButton = findViewById(R.id.searchButton);

        // access the local session variables
        prf = getSharedPreferences("user_details",MODE_PRIVATE);

        // Display on the screen the welcome message
        String message = "Hello, " + prf.getString("completeName",null);
        welcome.setText(message);

        // Define the web server's IP address
        hostAddress = "yourIPAddress:yourPort";

        // Instantiate the departments list
        departmentsList = new ArrayList<>();

        // Add the default search filter
        departmentsList.add("All Departments");

        // defines the adapter for the spinner
        spinnerAdapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, departmentsList);

        // Drop down layout style - list view with radio button
        spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        // Create and start the thread
        new getDepartments(this).execute();

        // Verify if the search and filter session variables are available
        if(!(prf.contains("search")&&prf.contains("filter"))) {
            // Display on the screen the search message
            String searchMsg = "The results of your search will be shown here.";
            searchMessage.setText(searchMsg);
        } else {
            // Instantiate the Item list
            itemUserList = new ArrayList<>();

            // Defines the adapter: Receives the context (Current activity) and the ArrayList
            adapter = new UsersAdapter(this, itemUserList);

            // Create a accessor to the ListView in the activity
            lv = findViewById(R.id.itemList);
            // Get the search and filter values from the session variables
            String search = prf.getString("search",null);
            String filter = prf.getString("filter",null);
            // Set the search box to the value collected from the session variable
            searchValue.setText(search);

            // Log download's results
            Log.e(TAG, "Your search was " + search + " using the filter " + filter);

            // Create and start the thread
            new GetItems(welcomeSearch.this, search, filter).execute();
        }
        // Click listener for the logout button
        btnLogOut.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Logout
                // Destroy local session variables
                SharedPreferences.Editor editor = prf.edit();
                editor.clear();
                editor.apply();

                // finish the activity as well as all the below Activities in the execution stack.
                welcomeSearch.this.finishAffinity(); // supported from API 16

                // call the MainActivity for login
                Intent intent = new Intent(welcomeSearch.this,MainActivity.class);
                startActivity(intent);
            }
        });
        // Click listener for the search button
        searchButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Retrieve the values from the search box and
                // the filter from the spinner (drop box)
                String search = ((EditText) findViewById(R.id.searchValue)).getText().toString();
                String filter = departmentsFilter.getSelectedItem().toString();
                
                // Verify that if the search box is empty
                if(search.isEmpty()) {
                    // show an error message
                    Toast.makeText(welcomeSearch.this, "Search Bar is empty...", Toast.LENGTH_LONG).show();
                } else {
                    // the search box is not empty
                    // Create session variables for the search and the filter
                    SharedPreferences.Editor editor = prf.edit();
                    editor.putString("search", search);
                    editor.putString("filter", filter);
                    editor.apply();

                    // Log download's results
                    Log.e(TAG, "Your search is " + search + " using the filter " + filter);

                    // call the welcomeSearch activity to load the products
                    Intent intent = new Intent(welcomeSearch.this,welcomeSearch.class);
                    startActivity(intent);
                }
            }
        });
    }

    /***
     *  This class is a thread for receiving and
     *  process the department data from the Web server
     *  @author a-carrasquillo
     */
    private class getDepartments extends AsyncTask<Void, Void, Void> {

        // Context: every transaction in a Android application
        // must be attached to a context
        private Activity activity;

        /**
         * Special constructor: assigns the context to the thread
         *
         *      @param activity: Context
         */
        protected getDepartments(Activity activity) {
            this.activity = activity;
        }

        /**
         *  on PreExecute method: runs after the constructor
         *  is called and before the thread runs
         */
        protected void onPreExecute() {
            super.onPreExecute();
            // show a message that the departments are downloading
            Toast.makeText(welcomeSearch.this, "Department list is downloading...", Toast.LENGTH_LONG).show();
        }

        /**
         *  Main thread
         * @param arg0: argument receive by the method
         *
         */
        protected Void doInBackground(Void... arg0) {
            // Create a HttpHandler object
            HttpHandler sh = new HttpHandler();

            // Making a request to URL and getting response
            String url = "http://"+hostAddress+"/getActiveDepartments";

            // Download data from the web server using JSON;
            String jsonStr = sh.makeServiceCall(url);

            // Log download's results
            Log.e(TAG, "Response from URL: " + jsonStr);

            // The JSON data must contain an array of JSON objects
            if (jsonStr != null) {
                try {
                    // Define a JSON object from the received data
                    JSONObject jsonObj = new JSONObject(jsonStr);

                    // Getting JSON Array node
                    JSONArray items = jsonObj.getJSONArray("departments");

                    // looping through All Items
                    for (int i = 0; i < items.length(); i++) {
                        JSONObject c = items.getJSONObject(i);
                        // Retrieve the department name from the JSON
                        String departmentName = c.getString("dept_name");

                        // Add the department name to the ArrayList
                        departmentsList.add(departmentName);
                    }
                } // Log any problem with received data
                catch (final JSONException e) {
                    Log.e(TAG, "JSON parsing error: " + e.getMessage());
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(getApplicationContext(),
                                    "JSON parsing error: " + e.getMessage(),
                                    Toast.LENGTH_LONG).show(); }
                    });
                }
            } else {
                Log.e(TAG, "Couldn't get JSON from server.");
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        Toast.makeText(getApplicationContext(),
                                "Couldn't get JSON from server. Check LogCat for possible errors!",
                                Toast.LENGTH_LONG).show();
                    }
                });
            }
            return null;
        }

        /**
         *  This method runs after thread completion
         *  Set up the List view using the ArrayAdapter
         *
         * @param result: result of the thread
         */
        protected void onPostExecute (Void result){
            super.onPostExecute(result);
            // set the adapter
            departmentsFilter.setAdapter(spinnerAdapter);
            // Retrieve the filter from the session variables
            String filter = prf.getString("filter",null);
            // Verify which department was selected and show it in the spinner
            int selectedFilterPosition = spinnerAdapter.getPosition(filter);
            departmentsFilter.setSelection(selectedFilterPosition);
        }

    }

    /**
     *  This class is a thread for receiving and process
     *  the product search from the Web server
     *  @author a-carrasquillo
     */
    private class GetItems extends AsyncTask<Void, Void, Void> {

        // Context: every transaction in a Android application must be attached to a context
        private Activity activity;
        // Search performed by the user
        private String search;
        // Filter selected by the user
        private String filter;
        // Link the layout object with an object in JAVA
        private TextView msg = findViewById(R.id.searchMessage);
        // Boolean variable to indicate if the search has no results
        private Boolean hasResults;

        /***
         * Special constructor: assigns the context to the thread,
         * the search value and the selected filter
         *
         *      @param activity: Context
         *      @param search: user's search
         *      @param filter: selected filter by the user
         */
        protected GetItems(Activity activity, String search, String filter) {
            // set the data fields
            this.activity = activity;
            this.search = search;
            this.filter = filter;
            hasResults = true;
        }

        /**
         *  on PreExecute method: runs after the constructor
         *  is called and before the thread runs
         */
        protected void onPreExecute() {
            super.onPreExecute();
            // Show a message that the product list is downloading
            Toast.makeText(welcomeSearch.this, "Items list is downloading...", Toast.LENGTH_LONG).show();
        }

        /**
         *  Main thread
         *      @param arg0: argument receive by the method
         *
         */
        protected Void doInBackground(Void... arg0) {
            // Create a HttpHandler object
            HttpHandler sh = new HttpHandler();

            // Making a request to URL and getting response
            String url = "http://"+hostAddress+"/doProductSearch";

            // Download data from the web server using JSON;
            String jsonStr = sh.productSearch(url, search, filter);

            // Log download's results
            Log.e(TAG, "Response from URL: " + jsonStr);

            // The JSON data must contain an array of JSON objects
            if(jsonStr != null) {
                try {
                    // Define a JSON object from the received data
                    JSONObject jsonObj = new JSONObject(jsonStr);

                    // Getting JSON Array node
                    JSONArray items = jsonObj.getJSONArray("products");
                    // Verify if there are no results for the search
                    if(items.length()==0)
                        hasResults = false;
                    

                    // looping through All Items
                    for (int i = 0; i < items.length(); i++) {
                        JSONObject c = items.getJSONObject(i);
                        // Retrieve the product information from the JSON
                        String productId = c.getString("productId");
                        String productName = c.getString("name");
                        String productBid = c.getString("bid");
                        String productImageLocation = c.getString("pictureURL");
                        String productDepartments = c.getString("departments");

                        // Create URL for each image
                        String imageURL = "http://" + hostAddress + "/" + productImageLocation;
                        // Download the actual image using the imageURL
                        Drawable actualImage= LoadImageFromWebOperations(imageURL);

                        // Create an userItem object and add it to the items' list
                        itemUserList.add(new userItem(productId, productName, productBid, actualImage, productDepartments));
                    }
                } // Log any problem with received data
                catch (final JSONException e) {
                    Log.e(TAG, "JSON parsing error: " + e.getMessage());
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(getApplicationContext(),
                                    "JSON parsing error: " + e.getMessage(),
                                    Toast.LENGTH_LONG).show(); }
                    });
                }
            } else {
                Log.e(TAG, "Couldn't get JSON from server.");
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {

                        Toast.makeText(getApplicationContext(),
                                "Couldn't get JSON from server. Check LogCat for possible errors!",
                                Toast.LENGTH_LONG).show();
                    }
                });
            }
            return null;
        }

        /**
         *  This method runs after thread completion
         *  Set up the List view using the ArrayAdapter
         *
         *      @param result: result of the thread
         */
        protected void onPostExecute (Void result){
            super.onPostExecute(result);
            // Set the List View adapter
            lv.setAdapter(adapter);
            // Verify if there were no results for the search
            if(!hasResults) {
                // Display on the screen the search message
                msg.setText("There are no results for your current search...\nTry another search and/or filter.");
            }
        }

        /**
         *  This method downloads a image from a web server using an URL
         *      @param url: Image URL
         *      @return  d: android.graphics.drawable.Drawable;
         * */
        public Drawable LoadImageFromWebOperations(String url) {
            try {
                // Request the image to the web server
                InputStream is = (InputStream) new URL(url).getContent();

                // Generates an android.graphics.drawable.Drawable object
                return Drawable.createFromStream(is, "src name"); }
            catch (Exception e) {
                return null;
            }
        }
    }

    /**
     * This class defines a ArrayAdapter for the ListView manipulation
     * @author a-carrasquillo
     */
    public class UsersAdapter extends ArrayAdapter<userItem> {

        /**
         *  Constructor:
         *      @param context: Activity
         *      @param users: ArrayList for storing Items list
         */
        public UsersAdapter(Context context, ArrayList<userItem> users) {
            super(context, 0, users);
        }

        /**
         *  This method generates a view for manipulating the item list
         *  This method is called from the ListView.
         *
         *      @param position: Item's position in the ArrayList
         *      @param convertView:
         *      @param parent:
         *      @return the item layout
         */
        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            // Get the data item for this position
            userItem user = getItem(position);
            // Check if an existing view is being reused, otherwise inflate the view
            if (convertView == null) {
                convertView = LayoutInflater.from(getContext()).inflate(R.layout.list_item, parent, false);
            }
            // Lookup view for data population
            TextView itemName = convertView.findViewById(R.id.itemName);
            TextView itemDepartments = convertView.findViewById(R.id.itemDepartments);
            TextView itemBid = convertView.findViewById(R.id.itemCurrentBid);
            ImageView itemImage = convertView.findViewById(R.id.productImage);

            // Populate the data into the template view using the data object
            if(user!=null) {
                itemName.setText(user.name);
                itemDepartments.setText(user.departments);
                itemBid.setText("$"+user.bid);
                itemImage.setImageDrawable(user.image);
            }

            // Return the completed view to render on screen
            convertView.setTag(position);

            // Create Listener to detect a click
            convertView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    // Retrieve the position of the selection
                    int position = (Integer) view.getTag();

                    // Create an intent in order to call the other activity
                    Intent i = new Intent(welcomeSearch.this, productDetails.class);

                    // Add the product id to the intent
                    i.putExtra("productId", itemUserList.get(position).id);

                    // Start the other activity
                    startActivity(i);
                }
            });
            return convertView;
        }
    }

    /**
     *  This class generates a Data structure
     *  for manipulating each Item in the application
     *  @author a-carrasquillo
     */
    public class userItem {
        // Item's Id
        public String id;
        // Item's name
        public String name;
        // Item's price
        public String bid;
        // Item's image
        public Drawable image;
        // Item's department/s
        public String departments;

        /**
         *  Special constructor:
         *      @param id: Item's id
         *      @param name: Item's name
         *      @param bid: Item's bid
         *      @param image: Item's image
         *      @param departments: Item's department/s
         */
        public userItem(String id, String name, String bid, Drawable image, String departments) {
            this.id = id;
            this.name = name;
            this.bid = bid;
            this.image = image;
            this.departments = departments;
        }
    }
}