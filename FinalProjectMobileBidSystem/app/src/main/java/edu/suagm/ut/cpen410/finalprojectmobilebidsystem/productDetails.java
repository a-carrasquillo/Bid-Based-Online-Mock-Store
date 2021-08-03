// Define the project package
package edu.suagm.ut.cpen410.finalprojectmobilebidsystem;
// Import the required libraries
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.ImageView;
import android.widget.Toast;
import java.io.InputStream;
import java.net.URL;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import androidx.appcompat.app.AppCompatActivity;

/** Class that allows us to execute the
 *  logic for the product details interface.
 * @author a-carrasquillo
 * 
 * */
public class productDetails extends AppCompatActivity {
    // Local Session Variable holder
    SharedPreferences prf;

    // This is for debugging
    private String TAG = productDetails.class.getSimpleName();

    // Web server's IP address
    private String hostAddress;

    // Product Id
    private String productId;

    // Product Information Structure Initialization
    private productInformation productInfo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Load the layout
        setContentView(R.layout.product_details);

        // Retrieve the shared object
        Intent i = getIntent();

        // Retrieve the product id from the intent
        productId = i.getStringExtra("productId");

        // Log the product id retrieve from the intent
        Log.e(TAG, "The retrieve product id from the intent is: " + productId);

        // access the local session variables
        prf = getSharedPreferences("user_details", MODE_PRIVATE);

        // Define the web server's IP address
        hostAddress = "yourIPAddress:yourPort";

        // Link activity's controls with Java variables
        Button btnMakeBid = findViewById(R.id.btnMakeBid);

        // Listener for the Make bid button
        btnMakeBid.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Get the value from the new bid field
                String newBid = ((EditText)findViewById(R.id.newBid)).getText().toString();
                // Verify if there is an error with the bid
                Boolean errorBid = !(Double.valueOf(newBid) > Double.valueOf(productInfo.productCurrentBid));

                // Validate that there is a value in the field and there is no error
                if(!newBid.isEmpty()&& !errorBid) {
                    // Create and start the thread
                    new performBid(productDetails.this, newBid).execute();
                } else if(errorBid) {
                    Toast.makeText(productDetails.this, "The Bid Offer is equal or lower than the highest...", Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(productDetails.this, "The Bid Offer field is empty...", Toast.LENGTH_LONG).show();
                }
            }
        });

        // Create and start the thread
        new getProductDetails(this).execute();
    }

    /**
     *  This class is a thread for receiving and process data related
     *  with a specific product from the Web server
     *  @author a-carrasquillo
     */
    private class getProductDetails extends AsyncTask<Void, Void, Void> {

        // Context: every transaction in a Android application must be attached to a context
        private Activity activity;

        /***
         * Special constructor: assigns the context to the thread
         *
         *      @param activity: Context
         */
        //@Override
        protected getProductDetails(Activity activity) {
            this.activity = activity;
        }

        /**
         *  on PreExecute method: runs after the constructor
         *  is called and before the thread runs
         */
        protected void onPreExecute() {
            super.onPreExecute();
            // Show a message that the product information is downloading
            Toast.makeText(productDetails.this, "Product information is downloading...", Toast.LENGTH_LONG).show();
        }

        /**
         *  Main thread
         *      @param arg0: parameter received by the method
         *
         */
        protected Void doInBackground(Void... arg0) {
            // Create a HttpHandler object
            HttpHandler sh = new HttpHandler();

            // Making a request to url and getting response
            String url = "http://" + hostAddress + "/doProductSearchById";

            // Download data from the web server using JSON;
            String jsonStr = sh.productSearchById(url, productId);

            // Log download's results
            Log.e(TAG, "Response from url: " + jsonStr);

            // The JSON data must contain an array of JSON objects
            if (jsonStr != null) {
                try {
                    // Define a JSON object from the received data
                    JSONObject jsonObj = new JSONObject(jsonStr);

                    // Getting JSON Array node
                    JSONArray items = jsonObj.getJSONArray("productDetails");

                    // looping through All Items
                    for (int i = 0; i < items.length(); i++) {
                        JSONObject c = items.getJSONObject(i);
                        // Retrieve the product information from the JSON
                        String productId = c.getString("productId");
                        String productName = c.getString("name");
                        String productDescription = c.getString("description");
                        String productCurrentBid = c.getString("bid");
                        String productImageLocation = c.getString("pictureURL");
                        String productDueDate = c.getString("dueDate");
                        String productDepartments = c.getString("departments");

                        // Create URL for each image
                        String imageURL = "http://" + hostAddress + "/" + productImageLocation;

                        // Download the actual image using the imageURL
                        Drawable actualImage= LoadImageFromWebOperations(imageURL);

                        // Create an object and add the product info
                        productInfo = new productInformation(productId, productName, productDescription,
                                            productCurrentBid, actualImage, productDueDate, productDepartments);
                    }
                } // Log any problem with received data
                catch(final JSONException e) {
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
        protected void onPostExecute (Void result) {
            super.onPostExecute(result);
            // Link activity's controls with Java variables
            TextView productName = findViewById(R.id.productName);
            ImageView productImage = findViewById(R.id.productImage);
            TextView productsDepartments = findViewById(R.id.productDepartments);
            TextView productDueDate = findViewById(R.id.productDueDate);
            TextView productBid = findViewById(R.id.productBid);
            TextView productDescription = findViewById(R.id.productDescription);

            // Populate the data into the template view using the productInfo object
            productName.setText(productInfo.productName);
            productImage.setImageDrawable(productInfo.productImage);
            String departmentInfo = "Department/s: " + productInfo.productDepartments;
            productsDepartments.setText(departmentInfo);
            String dueDateInfo = "Due Date: " + productInfo.productDueDate;
            productDueDate.setText(dueDateInfo);
            String productBidInfo = "Current Highest Bid: $" + productInfo.productCurrentBid;
            productBid.setText(productBidInfo);
            String descriptionInfo = "Description: " + productInfo.productDescription;
            productDescription.setText(descriptionInfo);
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
                Drawable d = Drawable.createFromStream(is, "src name");

                return d; }
            catch (Exception e) {
                return null;
            }
        }
    }

    /**
     *  This class is a thread for sending the bid to the
     *  server and receive the server response
     */
    private class performBid extends AsyncTask<Void, Void, Void> {

        // Context: every transaction in a Android application
        // must be attached to a context
        private Activity activity;
        // new bid for the product
        private String newBid;
        // response of the server
        private String serverResponse;

        /**
         * Special constructor: assigns the context to the thread,
         * and the new bid value
         *
         *      @param activity: Context
         *      @param newBid: new bid for the product
         */
        protected performBid(Activity activity, String newBid) {
            this.activity = activity;
            this.newBid = newBid;
        }

        /**
         *  on PreExecute method: runs after the constructor
         *  is called and before the thread runs
         */
        protected void onPreExecute() {
            super.onPreExecute();
            // Show a message that the bid is being performed
            Toast.makeText(productDetails.this, "The bid is being performed...", Toast.LENGTH_LONG).show();
        }

        /**
         *  Main thread
         * @param arg0: parameter of the method
         *
         */
        protected Void doInBackground(Void... arg0) {
            // Create a HttpHandler object
            HttpHandler sh = new HttpHandler();

            // Making a request to url and getting response
            String url = "http://"+hostAddress+"/doBid";

            // Download data from the web server
            serverResponse = sh.makeBid(url, prf.getString("username",null), productInfo.productId, newBid);

            // Clean response
            serverResponse=serverResponse.trim();

            // Log download's results
            Log.e(TAG, "Response from URL: " + serverResponse);

            return null;
        }

        /***
         *  This method runs after thread completion
         *  Set up the List view using the ArrayAdapter
         *
         *      @param result: result of the thread
         */
        protected void onPostExecute (Void result) {
            super.onPostExecute(result);
            // Verify the response of the server
            if(serverResponse.equals("true")) {
                // the bid was successful
                // Create an intent in order to call the other activity
                Intent i = new Intent(productDetails.this, productDetails.class);

                // Add the product id to the intent
                i.putExtra("productId", productInfo.productId);

                // Start the other activity
                startActivity(i);
                // remove the activity from the execution stack
                finish();
            } else if(serverResponse.equals("false")) {
                // bid was not successful
                Toast.makeText(getApplicationContext(),"The Bid failed...", Toast.LENGTH_LONG).show();
            } else {
                // error, value not recognized
                Toast.makeText(getApplicationContext(),"Server response not recognized, try again later...", Toast.LENGTH_LONG).show();
            }
        }
    }

    /**
     *  This class generates a Data structure for manipulating
     *  the product information in the application
     */
    public class productInformation {
        // Product's ID
        public String productId;
        // Product's Name
        public String productName;
        // Product's Description
        public String productDescription;
        // Product's Current Bid
        public String productCurrentBid;
        // Product's Image
        public Drawable productImage;
        // Product's Due Date
        public String productDueDate;
        // Product's department/s
        public String productDepartments;

        /** Special Constructor
         *      @param productId: Product's ID
         *      @param productName: Product's Name
         *      @param productDescription: Product's Description
         *      @param productCurrentBid: Product's Current Bid
         *      @param productImage: Product's Image
         *      @param productDueDate: Product's Due Date
         *      @param productDepartments: Product's department/s
         * */
        public productInformation(String productId, String productName, String productDescription, String productCurrentBid,
                           Drawable productImage, String productDueDate, String productDepartments) {
            this.productId = productId;
            this.productName = productName;
            this.productDescription = productDescription;
            this.productCurrentBid = productCurrentBid;
            this.productImage = productImage;
            this.productDueDate = productDueDate;
            this.productDepartments = productDepartments;
        }
    }
}