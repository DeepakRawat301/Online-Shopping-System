<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    String username = (String) session.getAttribute("user");

    if (username == null) {
        response.sendRedirect("login.html");
        return;
    }

    // Initialize a map to store user details
    Map<String, String> userDetails = new HashMap<>();
    
    try {
        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        // Fetch user details for the logged-in user
        PreparedStatement prst = con.prepareStatement("SELECT * FROM admin WHERE username = ?");
        prst.setString(1, username);
        ResultSet rs = prst.executeQuery();

        // If user is found, store details in the map
        if (rs.next()) {
            userDetails.put("username", rs.getString("username"));
            userDetails.put("password", rs.getString("password"));
            userDetails.put("name", rs.getString("name"));
            userDetails.put("email", rs.getString("email"));
            userDetails.put("city", rs.getString("city"));
        }

        // Handle form submission to update user profile
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String newUsername = request.getParameter("username");
            String newPassword = request.getParameter("password");
            String confirmPassword = request.getParameter("confirm_password");
            String newName = request.getParameter("name");
            String newEmail = request.getParameter("email");
            String newCity = request.getParameter("city");

            // Validate password
            if (!newPassword.equals("") && !newPassword.equals(confirmPassword)) {
                out.println("Passwords do not match. Please try again.");
                return;
            }

            // Update the database with new details if provided
            StringBuilder updateQuery = new StringBuilder("UPDATE admin SET ");
            boolean isFirstUpdate = true;

            // Add fields to the query only if they're not empty
            if (newUsername != null && !newUsername.trim().isEmpty() && !newUsername.equals(username)) {
                updateQuery.append(isFirstUpdate ? "username = ?" : ", username = ?");
                isFirstUpdate = false;
            }
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                updateQuery.append(isFirstUpdate ? "password = ?" : ", password = ?");
                isFirstUpdate = false;
            }
            if (newName != null && !newName.trim().isEmpty()) {
                updateQuery.append(isFirstUpdate ? "name = ?" : ", name = ?");
                isFirstUpdate = false;
            }
            if (newEmail != null && !newEmail.trim().isEmpty()) {
                updateQuery.append(isFirstUpdate ? "email = ?" : ", email = ?");
                isFirstUpdate = false;
            }
            if (newCity != null && !newCity.trim().isEmpty()) {
                updateQuery.append(isFirstUpdate ? "city = ?" : ", city = ?");
                isFirstUpdate = false;
            }

            // If no fields are updated, inform the user
            if (isFirstUpdate) {
                out.println("No changes were made.");
                return;
            }

            // Append the WHERE clause to identify the correct user
            updateQuery.append(" WHERE username = ?");

            // Prepare the statement
            PreparedStatement updateStmt = con.prepareStatement(updateQuery.toString());

            // Set the parameters in the update statement
            int index = 1;
            if (newUsername != null && !newUsername.trim().isEmpty() && !newUsername.equals(username)) {
                updateStmt.setString(index++, newUsername);
            }
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                updateStmt.setString(index++, newPassword);
            }
            if (newName != null && !newName.trim().isEmpty()) {
                updateStmt.setString(index++, newName);
            }
            if (newEmail != null && !newEmail.trim().isEmpty()) {
                updateStmt.setString(index++, newEmail);
            }
            if (newCity != null && !newCity.trim().isEmpty()) {
                updateStmt.setString(index++, newCity);
            }
            updateStmt.setString(index, username); // Set the username at the end of the WHERE clause

            int rowsUpdated = updateStmt.executeUpdate();
            if (rowsUpdated > 0) {
                // Update the session username if the username was changed
                if (newUsername != null && !newUsername.trim().isEmpty() && !newUsername.equals(username)) {
                    session.setAttribute("user", newUsername);
                }

                // Update the user details map with new information
                userDetails.put("username", newUsername != null && !newUsername.trim().isEmpty() ? newUsername : username);
                userDetails.put("password", newPassword != null && !newPassword.trim().isEmpty() ? newPassword : userDetails.get("password"));
                userDetails.put("name", newName != null && !newName.trim().isEmpty() ? newName : userDetails.get("name"));
                userDetails.put("email", newEmail != null && !newEmail.trim().isEmpty() ? newEmail : userDetails.get("email"));
                userDetails.put("city", newCity != null && !newCity.trim().isEmpty() ? newCity : userDetails.get("city"));

                out.println("Profile updated successfully!");
            }
        }

        con.close();  // Close the connection after the operation
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        out.println("JDBC Driver not found: " + e.getMessage());
        return;
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("Database error: " + e.getMessage());
        return;
    } catch (Exception e) {
        e.printStackTrace();
        out.println("An unexpected error occurred: " + e.getMessage());
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }

        h1 {
            color: #333;
            text-align: center;
        }

        h2 {
            color: #333;
            margin-top: 20px;
            font-size: 24px;
        }

        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        td {
            background-color: #f9f9f9;
        }

        form {
            width: 60%;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
        }

        input[type="text"], input[type="password"], input[type="email"], input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        input[type="submit"] {
            background-color: #007bff;
            color: white;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .logout-button {
            text-align: center;
            margin-top: 20px;
        }

        .return-link {
            text-align: center;
            margin-top: 20px;
        }

        .return-link a {
            color: #007bff;
            text-decoration: none;
            font-size: 16px;
        }

        .return-link a:hover {
            text-decoration: underline;
        }

        .btn-logout {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-logout:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <h1>Welcome, <%= username %></h1>

    <h2>Your Profile</h2>
    <table>
        <tr>
            <th>Username</th>
            <td><%= userDetails.get("username") %></td>
        </tr>
        <tr>
            <th>Password</th>
            <td><%= userDetails.get("password") %></td>
        </tr>
        <tr>
            <th>Name</th>
            <td><%= userDetails.get("name") %></td>
        </tr>
        <tr>
            <th>Email</th>
            <td><%= userDetails.get("email") %></td>
        </tr>
        <tr>
            <th>City</th>
            <td><%= userDetails.get("city") %></td>
        </tr>
    </table>

    <h3>Update Your Profile</h3>
    <form action="adminpud.jsp" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" value="<%= userDetails.get("username") %>"><br><br>
        
        <label for="password">New Password:</label>
        <input type="password" id="password" name="password"><br><br>
        
        <label for="confirm_password">Confirm Password:</label>
        <input type="password" id="confirm_password" name="confirm_password"><br><br>
        
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<%= userDetails.get("name") %>"><br><br>
        
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<%= userDetails.get("email") %>"><br><br>
        
        <label for="city">City:</label>
        <input type="text" id="city" name="city" value="<%= userDetails.get("city") %>"><br><br>
        
        <input type="submit" value="Update Profile">
    </form>

    <div class="logout-button">
        <form action="sellerlogout.jsp" method="post">
            <input type="submit" value="Logout" class="btn-logout">
        </form>
    </div>

    <div class="return-link">
        <a href="admindesk1.jsp">Back to Dashboard</a>
    </div>

    <div class="return-link">
        <a href="index.html">Return to Home Page</a>
    </div>
</body>
</html>

