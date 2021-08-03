# Bid-Based-Online-Mock-Store
A bid-based-online mock store web application capable to communicate with an Android simplified version of the application.

<b>Description</b><br>
This project aims to design and implement a bid-based online mock store that is divided into two parts. The first one being the web application and the second one being the Android application, which is a simplified version of the web application.

The <b>requirements for the web application</b> are the following: 
  1. The system should provide user accounts including sign-up and login.
  2. The products must be classified by departments.
  3. The user must be able to sell a product classified in up to three departments. When registering the product, the user must include a product name, a description, a starting bid value, an image and a due date.
  4. The system must provide a search box with the capability of refine the search based on department. However, the default search must be executed on the entire product database.
  5. The searching results must be list with the product brief description, which includes the name, department/s, and current bid, and a picture.
  6. Once the user selects a product, the system must present a new page with the complete product description including a bigger picture.
  7. Once the user intent to make a bid for a product, he/she must enter the bid value, and the system must refresh and show the new highest bid for the product.
  8. A user can not bid on their own products or bid a lower amount than the current highest bid.
  9. The system must provide an administrator role with the ability to add, modify, and remove users, products, and departments.
 
The <b>requirements for the Android application</b> are the following:
  1. The mobile application must communicate with the backend via HTTP (JSON).
  2. The user must be able to log in with the same account created in the web application.
  3. The administrators can only use the web application.
  4. The system must provide a search box with the capability of refining the search based on department. However, the default search must be executed on the entire product database.
  5. The searching results must be a list with the product description (Name, department, and current bid) and a picture.
  6. Once the user selects a product, the system must present a new activity with the complete product description including a bigger picture.
  7. Once the user intent to make a bid for a product, he/she must enter the bid value, and the system must refresh and show the new highest bid for the product.
  8. A user can not bid on their own products or bid a lower amount than the current highest bid.
  9. Every transaction performed on the mobile application must be registered at the central database system.

<b>Information regarding the database:</b>

The databaseScript is the file that you should run for a newly created application and will not have any products, users, etc. Additionally, the admin needs to be added manually, after adding a regular user with the signup page you can go to the DB and change his/her role to be an administrator.

The entity–relationship model is presented below:<br>
![ER_Diagram](https://user-images.githubusercontent.com/84880545/128072836-03e7a676-c105-4be9-9ac4-4e724c21a19c.JPG)

<b>Page-flow information:</b><br>
The page flow indicates where you can go from a specific web page and the required condition to be able to move to that page. When we referred to hidden pages in the image we refer to those JSPs that their URLs cannot be seen in the web browser search bar.
<br>
![page_flow](https://user-images.githubusercontent.com/84880545/128074394-c9f788a4-317e-4cc5-a338-f53ab3625b3e.JPG)

<b>Environment variables:</b><br>
CATALINA is an environment variable indicating the location of TOMCAT in the system. While the classpath variable value should have the following:<br>
.;<br>
%CATALINA%\lib\servlet-api.jar;<br>
%CATALINA%\webapps\ROOT\WEB-INF\classes\;<br>
%CATALINA%\lib\mysql-connector-java-8.0.19.jar;<br>
%CATALINA%\lib\commons-codec-1.11.jar;<br>
%CATALINA%\lib\commons-fileupload-1.4.jar;<br>
%CATALINA%\lib\commons-io-2.6.jar;<br>
%CATALINA%\lib\java-json.jar;<br>

<h1>This project is for educational purposes only!</h1>
Copyright Disclaimer under section 107 of the Copyright Act 1976, allowance is made for “fair use” for purposes such as criticism, comment, news reporting, teaching, scholarship, education and research.
Non-profit or educational use leans the balance in favor of fair use.
