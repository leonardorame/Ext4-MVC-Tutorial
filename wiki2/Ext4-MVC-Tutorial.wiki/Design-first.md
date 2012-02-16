The aim of this tutorial, is to help those programmers who want to start creating ExtJs 4 apps, with a little more complexity than the one showed in [this document](http://docs.sencha.com/ext-js/4-0/#!/guide/mvc_pt1). 

Here I'll try to guide you from a blank page all the way up to a complete ExtJs 4.x MVC application, with Authentication, removable views and CRUD windows all joined to a Lazarus/FreePascal CGI backend. I hope you enjoy the learning process as much as I did creating it.

## What do we want to achieve?

Before starting any project, it is important to have a clear definition of what our goal is, and the steps needed to get it. In this case, we'll create a basic CRM (Customer Relationship Management) application, hence our goal will be something like this:

> Create an application that allow the user to Create, Read, Update, Delete and List customers. The application also has to have user authentication, and all the data must be stored in a backend database.

### Let's do some sketches

Apart from the definition of our goal, generally it's useful to "visualize" the project with an UI (User Interface) prototype.

**Login page**. After the user types in the username and password, a request is made to the server. If the response is "success", the login window is closed and the main screen is sown.

![login form](login.png)

**Main window**. The main window contains a grid that lists all customers. Above the grid, there's a toolbar with common CRUD operations, like Insert/Edit/Delete. There's also a LogOut button that closes a session and bring back the LogIn window.

![main window](main.png)

**Edit customer data**. When the user selects a row in the grid, and click Edit, this dialog is shown, allowing the user to change customer data. The same dialog appears when the user clicks Insert.

![edit dialog](edit.png)