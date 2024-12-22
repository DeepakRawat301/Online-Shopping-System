<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    String username = (String) session.getAttribute("user");

    if (username == null) {
        response.sendRedirect("login.html");
        return;
    }

    boolean isValidUser = false;
    List<Map<String, Object>> cart = new ArrayList<>();
    
    try {
        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        // Fetch items for the logged-in seller
        PreparedStatement prst = con.prepareStatement("SELECT pid, pname, qty, price FROM product WHERE username = ?");
        prst.setString(1, username);
        ResultSet rs = prst.executeQuery();

        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("pid", rs.getString("pid"));
            item.put("pname", rs.getString("pname"));
            item.put("qty", rs.getString("qty"));
            item.put("price", rs.getString("price"));
            cart.add(item);
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
    <title>Your Products</title>
    <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 900px;
        }

        h1 {
            color: #4CAF50;
            text-align: center;
        }

        h2 {
            color: #555;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        td a {
            color: #4CAF50;
            text-decoration: none;
            padding: 5px 10px;
            border: 1px solid #4CAF50;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        td a:hover {
            background-color: #45a049;
            color: white;
        }

        .action-links {
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .action-links a {
            padding: 6px 12px;
            background-color: #f44336;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }

        .action-links a:hover {
            background-color: #e53935;
        }

        .logout-form {
            margin-top: 20px;
            text-align: center;
        }

        .logout-form input[type="submit"] {
            padding: 12px;
            background-color: #f44336;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 1.1em;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .logout-form input[type="submit"]:hover {
            background-color: #e53935;
        }

        .return-link {
            text-align: center;
            margin-top: 20px;
        }

        .return-link a {
            font-size: 1.1em;
            text-decoration: none;
            color: #333;
        }

        .return-link a:hover {
            color: #4CAF50;
        }

    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome, <%= username %></h1>
        <h2>Your Products</h2>

        <%
            if (cart.isEmpty()) {
        %>
        <p>Your product list is empty!</p>
        <%
            } else {
        %>
        <table>
            <thead>
                <tr>
                    <th>Product ID</th>
                    <th>Product Name</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Action</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Map<String, Object> item : cart) {
                        String productid = (String) item.get("pid");
                        String pname = (String) item.get("pname");
                        String qty = (String) item.get("qty");
                        String price = (String) item.get("price");
                %>
                <tr>
                    <td><%= productid %></td>
                    <td><%= pname %></td>
                    <td><%= qty %></td>
                    <td><%= price %></td>
                    <td>
                        <a href="updateProduct.jsp?pid=<%= productid %>&pname=<%= pname %>&qty=<%= qty %>&price=<%= price %>">Edit</a>
                    </td>
                    <td>
                        <% 
                            int isDisplayed = (Integer) item.getOrDefault("is_displayed", 1); // Default to displayed
                        %>
                        <%= isDisplayed == 1 ? "Displayed" : "Not Displayed" %>
                        <a href="sellertoggleproduct.jsp?pid=<%= productid %>&action=<%= isDisplayed == 1 ? "hide" : "show" %>">
                            <%= isDisplayed == 1 ? "Don't Display" : "Display" %>
                        </a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
            }
        %>

        <div class="logout-form">
            <form action="sellerlogout.jsp" method="post">
                <input type="submit" value="Logout">
            </form>
        </div>

        <div class="return-link">
            <a href="sellerdesk1.jsp">Back to Dashboard</a>
        </div>

        <div class="return-link">
            <a href="index.html">Return to Home Page</a>
        </div>
    </div>
</body>
</html>
