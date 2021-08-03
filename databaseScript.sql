CREATE DATABASE IF NOT EXISTS cpen410FinalProject; 
USE cpen410FinalProject;

DROP TABLE IF EXISTS roleUser;
DROP TABLE IF EXISTS roleWebPage;
DROP TABLE IF EXISTS webPagePrevious;
DROP TABLE IF EXISTS userProducts;
DROP TABLE IF EXISTS productsDepartments;
DROP TABLE IF EXISTS userAccess;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS webPage;
DROP TABLE IF EXISTS menuElement;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS departments;


CREATE TABLE userAccess (
  userName VARCHAR(20) NOT NULL,
  hashingValue MEDIUMTEXT NOT NULL,
  name VARCHAR(30) NOT NULL,
  telephone VARCHAR(20) NULL,
  postalAddress VARCHAR(50) NOT NULL,
  active TINYINT(1) NOT NULL,
  email VARCHAR(45) NOT NULL,
  PRIMARY KEY (userName));

CREATE TABLE role (
  roleId VARCHAR(20) NOT NULL,
  name VARCHAR(20) NOT NULL,
  description MEDIUMTEXT NOT NULL,
  PRIMARY KEY (roleId));

CREATE TABLE roleUser (
  userName VARCHAR(20) NOT NULL,
  roleId VARCHAR(20) NOT NULL,
  dateAssign DATE NOT NULL,
  PRIMARY KEY (roleId, userName),
  CONSTRAINT userName
    FOREIGN KEY (userName)
    REFERENCES userAccess(userName)
    ON DELETE CASCADE,
  CONSTRAINT roleId
    FOREIGN KEY (roleId)
    REFERENCES role(roleId)
    ON DELETE CASCADE);

CREATE TABLE menuElement (
  menuId INT(2) NOT NULL,
  title VARCHAR(40) NOT NULL,
  description MEDIUMTEXT NOT NULL,
  PRIMARY KEY (menuId));

CREATE TABLE webPage (
  pageURL VARCHAR(40) NOT NULL,
  pageTitle VARCHAR(40) NOT NULL,
  description MEDIUMTEXT NOT NULL,
  menuId INT(2) NULL,
  PRIMARY KEY (pageURL),
  CONSTRAINT menu
    FOREIGN KEY (menuId)
    REFERENCES menuElement (menuId)
    ON DELETE CASCADE);

CREATE TABLE roleWebPage (
  roleId VARCHAR(20) NOT NULL,
  pageURL VARCHAR(40) NOT NULL,
  dateAssign DATE NOT NULL,
  PRIMARY KEY (roleId, pageURL),
  CONSTRAINT roleId2
    FOREIGN KEY (roleId)
    REFERENCES role (roleId)
    ON DELETE CASCADE,
  CONSTRAINT pageURL
    FOREIGN KEY (pageURL)
    REFERENCES webPage (pageURL)
    ON DELETE CASCADE);

CREATE TABLE webPagePrevious (
  currentPageURL VARCHAR(40) NOT NULL,
  previousPageURL VARCHAR(40) NOT NULL,
  PRIMARY KEY (currentPageURL, previousPageURL),
  CONSTRAINT currentURL
    FOREIGN KEY (currentPageURL)
    REFERENCES webPage (pageURL)
    ON DELETE CASCADE,
  CONSTRAINT previousURL
    FOREIGN KEY (previousPageURL)
    REFERENCES webPage (pageURL)
    ON DELETE CASCADE);

CREATE TABLE products (
  productsId INT(10) NOT NULL,
  name VARCHAR(40) NOT NULL,
  description MEDIUMTEXT NOT NULL,
  bid DECIMAL(15,2) NOT NULL,
  pictureURL VARCHAR(30) NOT NULL,
  dueDate DATE NOT NULL,
  active TINYINT(1) NOT NULL,
  PRIMARY KEY (productsId));

CREATE TABLE userProducts (
  userName VARCHAR(20) NOT NULL,
  productId INT(10) NOT NULL,
  sells_buys TINYINT(1) NOT NULL,
  date DATE NOT NULL,
  bid DECIMAL(15,2) NOT NULL,
  PRIMARY KEY (userName, productId, bid),
  CONSTRAINT userName2
    FOREIGN KEY (userName)
    REFERENCES userAccess (userName)
    ON DELETE CASCADE,
  CONSTRAINT productId
    FOREIGN KEY (productId)
    REFERENCES products (productsId)
    ON DELETE CASCADE);

CREATE TABLE departments (
  departmentName VARCHAR(40) NOT NULL,
  active TINYINT(1) NOT NULL,
  PRIMARY KEY (departmentName));

CREATE TABLE productsDepartments (
  productId INT(10) NOT NULL,
  departmentName VARCHAR(40) NOT NULL,
  date DATETIME NOT NULL,
  PRIMARY KEY (productId, departmentName, date),
  CONSTRAINT productId2
    FOREIGN KEY (productId)
    REFERENCES products (productsId)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT department
    FOREIGN KEY (departmentName)
    REFERENCES departments (departmentName)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

CREATE USER 'client'@'localhost' IDENTIFIED BY 'YourPassword';
GRANT SELECT, INSERT, UPDATE on cpen410FinalProject.* to 'client'@'localhost';

INSERT INTO role VALUES("role1","Administrator","Person that has the higher level of access to the web application. Includes Adding, Modifying, and Removing users/clients, products and departments.");
INSERT INTO role VALUES("role2","Client","Person that can only search, sell and make a bid to a product.");

INSERT INTO menuElement VALUES(0, "General Pages", "Pages that are not shown as a menu option.");
INSERT INTO menuElement VALUES(1, "Users", "Pages for users management by the administrator.");
INSERT INTO menuElement VALUES(2, "Products", "Pages for products management by the administrator.");
INSERT INTO menuElement VALUES(3, "Departments", "Pages for departments management by the administrator.");

INSERT INTO webPage VALUES("login.jsp", "Login", "This page allow the users to login.", 0);
INSERT INTO webPage VALUES("signUp.jsp", "Sign Up", "This page allow the user to create an account", 0);
INSERT INTO webPage VALUES("createAccount.jsp", "Create Account", "Based on the information filled in the sign up page, the system creates a new client.", 0);
INSERT INTO webPage VALUES("validation.jsp", "Validation", "This is were the validation/authentication is performed.", 0);
INSERT INTO webPage VALUES("welcomeMenu.jsp", "Welcome", "This is the welcome page, where the menu is presented to the user.", 0);
INSERT INTO webPage VALUES("search.jsp", "Search", "This hidden JSP allow us to search a product and see the list of results in welcomeMenu.", 0);
INSERT INTO webPage VALUES("detailsProduct.jsp", "Details of Product", "This page show use a more detailed information of a product.", 0);
INSERT INTO webPage VALUES("makeBid.jsp", "Make a Bid", "This hidden JSP allow us to perform a bid.", 0);
INSERT INTO webPage VALUES("sellProduct.jsp", "Add Product", "This page allow us to sell a product.", 2);
INSERT INTO webPage VALUES("addProduct.jsp", "Add Product", "This JSP allows to add a product to the system.", 0);
INSERT INTO webPage VALUES("signout.jsp", "Signout", "This hidden JSP allow the user to logout of the system.", 0);
INSERT INTO webPage VALUES("addUser.jsp", "Add User", "This page allow the administrator to add users to the system.", 1);
INSERT INTO webPage VALUES("addNewUser.jsp", "Add New User", "This JSP allows to add users to the system.", 0);
INSERT INTO webPage VALUES("listUsers.jsp", "List Users", "This page allow the administrator to see a list of all the users", 1);
INSERT INTO webPage VALUES("modifyUser.jsp", "Modify User", "This page allow the administrator to modify a user.", 0);
INSERT INTO webPage VALUES("modifyUserInfo.jsp", "Modify User Information", "This JSP allows to save the modified information of a user.", 0);
INSERT INTO webPage VALUES("removeUser.jsp", "Remove User", "This JSP allows the administrator to remove a user.", 0);
INSERT INTO webPage VALUES("listProducts.jsp", "List of Products", "This page allow the administrator to see a list of all the products.", 2);
INSERT INTO webPage VALUES("modifyProduct.jsp", "Modify Product", "This page allow the administrator to modify a product.", 0);
INSERT INTO webPage VALUES("changeProductInfo.jsp", "Change Product Information", "This hidden JSP allow the administrator to save a modified product.", 0);
INSERT INTO webPage VALUES("removeProduct.jsp", "Remove Product", "This JSP allow the administrator to remove a product.", 0);
INSERT INTO webPage VALUES("addDepartment.jsp", "Add Department", "This page allow the administrator to add a department.", 3);
INSERT INTO webPage VALUES("addNewDepartment.jsp", "Add New Department", "This JSP allow the administrator to save the new department.", 0);
INSERT INTO webPage VALUES("listDepartments.jsp", "List of Departments", "This page allow the administrator to see a list of all the active departments.", 3);
INSERT INTO webPage VALUES("modifyDepartment.jsp", "Modify Department", "This page allow the administrator to modify a department.", 0);
INSERT INTO webPage VALUES("changeDepartmentInfo.jsp", "Change Department Information", "This page allow the administrator to save the modified department.", 0);
INSERT INTO webPage VALUES("removeDepartment.jsp", "Remove Department", "This JSP allow the administrator to remove a department.", 0);

INSERT INTO webPagePrevious VALUES("welcomeMenu.jsp", "validation.jsp");
INSERT INTO webPagePrevious VALUES("welcomeMenu.jsp", "search.jsp");
INSERT INTO webPagePrevious VALUES("welcomeMenu.jsp", "detailsProduct.jsp");
INSERT INTO webPagePrevious VALUES("welcomeMenu.jsp", "sellProduct.jsp");
INSERT INTO webPagePrevious VALUES("welcomeMenu.jsp", "addProduct.jsp");
INSERT INTO webPagePrevious VALUES("welcomeMenu.jsp", "addUser.jsp");
INSERT INTO webPagePrevious VALUES("welcomeMenu.jsp", "addNewUser.jsp");
INSERT INTO webPagePrevious VALUES("welcomeMenu.jsp", "addDepartment.jsp");
INSERT INTO webPagePrevious VALUES("welcomeMenu.jsp", "addNewDepartment.jsp");

INSERT INTO webPagePrevious VALUES("search.jsp", "welcomeMenu.jsp");
INSERT INTO webPagePrevious VALUES("search.jsp", "detailsProduct.jsp");

INSERT INTO webPagePrevious VALUES("detailsProduct.jsp", "welcomeMenu.jsp");
INSERT INTO webPagePrevious VALUES("detailsProduct.jsp", "makeBid.jsp");

INSERT INTO webPagePrevious VALUES("makeBid.jsp", "detailsProduct.jsp");

INSERT INTO webPagePrevious VALUES("sellProduct.jsp", "welcomeMenu.jsp");

INSERT INTO webPagePrevious VALUES("addProduct.jsp", "sellProduct.jsp");

INSERT INTO webPagePrevious VALUES("addNewUser.jsp", "addUser.jsp");

INSERT INTO webPagePrevious VALUES("modifyUserInfo.jsp", "modifyUser.jsp");

INSERT INTO webPagePrevious VALUES("modifyUser.jsp", "listUsers.jsp");

INSERT INTO webPagePrevious VALUES("removeUser.jsp", "listUsers.jsp");

INSERT INTO webPagePrevious VALUES("changeProductInfo.jsp", "modifyProduct.jsp");

INSERT INTO webPagePrevious VALUES("modifyProduct.jsp", "detailsProduct.jsp");

INSERT INTO webPagePrevious VALUES("removeProduct.jsp", "detailsProduct.jsp");

INSERT INTO webPagePrevious VALUES("addNewDepartment.jsp", "addDepartment.jsp");

INSERT INTO webPagePrevious VALUES("changeDepartmentInfo.jsp", "modifyDepartment.jsp");

INSERT INTO webPagePrevious VALUES("modifyDepartment.jsp", "listDepartments.jsp");

INSERT INTO webPagePrevious VALUES("removeDepartment.jsp", "listDepartments.jsp");

INSERT INTO webPagePrevious VALUES("addUser.jsp", "welcomeMenu.jsp");
INSERT INTO webPagePrevious VALUES("addUser.jsp", "listUsers.jsp");
INSERT INTO webPagePrevious VALUES("addUser.jsp", "sellProduct.jsp");
INSERT INTO webPagePrevious VALUES("addUser.jsp", "listProducts.jsp");
INSERT INTO webPagePrevious VALUES("addUser.jsp", "addDepartment.jsp");
INSERT INTO webPagePrevious VALUES("addUser.jsp", "listDepartments.jsp");

INSERT INTO webPagePrevious VALUES("listUsers.jsp", "welcomeMenu.jsp");
INSERT INTO webPagePrevious VALUES("listUsers.jsp", "addUser.jsp");
INSERT INTO webPagePrevious VALUES("listUsers.jsp", "sellProduct.jsp");
INSERT INTO webPagePrevious VALUES("listUsers.jsp", "listProducts.jsp");
INSERT INTO webPagePrevious VALUES("listUsers.jsp", "addDepartment.jsp");
INSERT INTO webPagePrevious VALUES("listUsers.jsp", "listDepartments.jsp");
INSERT INTO webPagePrevious VALUES("listUsers.jsp", "modifyUser.jsp");
INSERT INTO webPagePrevious VALUES("listUsers.jsp", "modifyUserInfo.jsp");
INSERT INTO webPagePrevious VALUES("listUsers.jsp", "removeUser.jsp");

INSERT INTO webPagePrevious VALUES("sellProduct.jsp", "addUser.jsp");
INSERT INTO webPagePrevious VALUES("sellProduct.jsp", "listUsers.jsp");
INSERT INTO webPagePrevious VALUES("sellProduct.jsp", "listProducts.jsp");
INSERT INTO webPagePrevious VALUES("sellProduct.jsp", "addDepartment.jsp");
INSERT INTO webPagePrevious VALUES("sellProduct.jsp", "listDepartments.jsp");

INSERT INTO webPagePrevious VALUES("detailsProduct.jsp", "modifyProduct.jsp");
INSERT INTO webPagePrevious VALUES("detailsProduct.jsp", "changeProductInfo.jsp");
INSERT INTO webPagePrevious VALUES("detailsProduct.jsp", "listProducts.jsp");

INSERT INTO webPagePrevious VALUES("listProducts.jsp", "detailsProduct.jsp");
INSERT INTO webPagePrevious VALUES("listProducts.jsp", "removeProduct.jsp");
INSERT INTO webPagePrevious VALUES("listProducts.jsp", "welcomeMenu.jsp");
INSERT INTO webPagePrevious VALUES("listProducts.jsp", "addUser.jsp");
INSERT INTO webPagePrevious VALUES("listProducts.jsp", "listUsers.jsp");
INSERT INTO webPagePrevious VALUES("listProducts.jsp", "sellProduct.jsp");
INSERT INTO webPagePrevious VALUES("listProducts.jsp", "addDepartment.jsp");
INSERT INTO webPagePrevious VALUES("listProducts.jsp", "listDepartments.jsp");

INSERT INTO webPagePrevious VALUES("addDepartment.jsp", "welcomeMenu.jsp");
INSERT INTO webPagePrevious VALUES("addDepartment.jsp", "addUser.jsp");
INSERT INTO webPagePrevious VALUES("addDepartment.jsp", "listUsers.jsp");
INSERT INTO webPagePrevious VALUES("addDepartment.jsp", "sellProduct.jsp");
INSERT INTO webPagePrevious VALUES("addDepartment.jsp", "listProducts.jsp");
INSERT INTO webPagePrevious VALUES("addDepartment.jsp", "listDepartments.jsp");

INSERT INTO webPagePrevious VALUES("listDepartments.jsp", "welcomeMenu.jsp");
INSERT INTO webPagePrevious VALUES("listDepartments.jsp", "addUser.jsp");
INSERT INTO webPagePrevious VALUES("listDepartments.jsp", "listUsers.jsp");
INSERT INTO webPagePrevious VALUES("listDepartments.jsp", "sellProduct.jsp");
INSERT INTO webPagePrevious VALUES("listDepartments.jsp", "listProducts.jsp");
INSERT INTO webPagePrevious VALUES("listDepartments.jsp", "addDepartment.jsp");
INSERT INTO webPagePrevious VALUES("listDepartments.jsp", "changeDepartmentInfo.jsp");
INSERT INTO webPagePrevious VALUES("listDepartments.jsp", "modifyDepartment.jsp");
INSERT INTO webPagePrevious VALUES("listDepartments.jsp", "removeDepartment.jsp");

INSERT INTO roleWebPage VALUES("role1", "welcomeMenu.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "detailsProduct.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "sellProduct.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "addUser.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "listUsers.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "modifyUser.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "modifyProduct.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "listProducts.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "addDepartment.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "modifyDepartment.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "listDepartments.jsp", curdate());

INSERT INTO roleWebPage VALUES("role2", "welcomeMenu.jsp", curdate());
INSERT INTO roleWebPage VALUES("role2", "detailsProduct.jsp", curdate());
INSERT INTO roleWebPage VALUES("role2", "sellProduct.jsp", curdate());


INSERT INTO roleWebPage VALUES("role1", "addProduct.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "addNewUser.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "modifyUserInfo.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "removeUser.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "changeProductInfo.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "removeProduct.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "addNewDepartment.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "changeDepartmentInfo.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "removeDepartment.jsp", curdate());

INSERT INTO roleWebPage VALUES("role2", "search.jsp", curdate());
INSERT INTO roleWebPage VALUES("role2", "makeBid.jsp", curdate());
INSERT INTO roleWebPage VALUES("role2", "addProduct.jsp", curdate());

ALTER TABLE products ADD CONSTRAINT uniquePictureURL UNIQUE (pictureURL);
INSERT INTO webPagePrevious VALUES("sellProduct.jsp", "addProduct.jsp");

INSERT INTO webPage VALUES("usersFilter.jsp", "Users Filter", "This hidden JSP allow the administrator to filter the list of users by all, active, or inactive users.", 0);
INSERT INTO webPage VALUES("productsFilter.jsp", "Products Filter", "This hidden JSP allow the administrator to filter the list of products by all, active, or inactive products.", 0);
INSERT INTO webPage VALUES("departmentsFilter.jsp", "Departments Filter", "This hidden JSP allow the administrator to filter the list of departments by all, active, or inactive departments.", 0);

INSERT INTO webPagePrevious VALUES("listUsers.jsp", "usersFilter.jsp");
INSERT INTO webPagePrevious VALUES("usersFilter.jsp", "listUsers.jsp");

INSERT INTO webPagePrevious VALUES("listProducts.jsp", "productsFilter.jsp");
INSERT INTO webPagePrevious VALUES("productsFilter.jsp", "listProducts.jsp");

INSERT INTO webPagePrevious VALUES("listDepartments.jsp", "departmentsFilter.jsp");
INSERT INTO webPagePrevious VALUES("departmentsFilter.jsp", "listDepartments.jsp");

INSERT INTO roleWebPage VALUES("role1", "usersFilter.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "productsFilter.jsp", curdate());
INSERT INTO roleWebPage VALUES("role1", "departmentsFilter.jsp", curdate());

INSERT INTO webPagePrevious VALUES("addUser.jsp", "addNewUser.jsp");
INSERT INTO webPagePrevious VALUES("modifyUser.jsp", "modifyUserInfo.jsp");
INSERT INTO webPagePrevious VALUES("modifyProduct.jsp", "changeProductInfo.jsp");
INSERT INTO webPagePrevious VALUES("modifyDepartment.jsp", "changeDepartmentInfo.jsp");
INSERT INTO webPagePrevious VALUES("addDepartment.jsp", "addNewDepartment.jsp");

INSERT INTO departments VALUES("Automotive",1);
INSERT INTO departments VALUES('Babies',1);
INSERT INTO departments VALUES('Books',1);
INSERT INTO departments VALUES('Ceiling Fan',1);
INSERT INTO departments VALUES('Computers',1);
INSERT INTO departments VALUES('Electronics',1);
INSERT INTO departments VALUES('Garden',1);
INSERT INTO departments VALUES('Toys and Games',1);
INSERT INTO departments VALUES('Video Games',1);