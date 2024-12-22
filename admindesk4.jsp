<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // Check if admin is logged in
    String username = (String) session.getAttribute("user");
    if (username == null) {
        response.sendRedirect("adminlogin.html");
        return;
    }

    // List to store details of all products
    List<Map<String, String>> products = new ArrayList<>();

    try {
        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        // Fetch details of all products
        PreparedStatement prst = con.prepareStatement("SELECT * FROM product");
        ResultSet rs = prst.executeQuery();

        // Iterate through the ResultSet and add details to the list
        while (rs.next()) {
            Map<String, String> product = new HashMap<>();
            product.put("username", rs.getString("username"));
            product.put("pid", rs.getString("pid"));
            product.put("pname", rs.getString("pname"));
            product.put("qty", rs.getString("qty"));
            product.put("price", rs.getString("price"));
            products.add(product);
        }

        con.close(); // Close the connection
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Products</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }
        h1, h2 {
            text-align: center;
            margin-top: 20px;
            color: #333;
        }
        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        table th, table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        table th {
            background-color: #0077cc;
            color: #fff;
        }
        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        table tr:hover {
            background-color: #f1f1f1;
        }
        .form-container {
            text-align: center;
            margin: 20px 0;
        }
        .form-container input[type="submit"] {
            background-color: #0077cc;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .form-container input[type="submit"]:hover {
            background-color: #005bb5;
        }
        .button {
            display: inline-block;
            padding: 8px 12px;
            margin: 20px auto;
            background-color: #0077cc;
            color: #fff;
            text-align: center;
            text-decoration: none;
            border-radius: 4px;
        }
        .button:hover {
            background-color: #005bb5;
        }
    </style>
</head>
<body>
    <h1>Welcome, <%= username %></h1>

    <h2>All Products</h2>
    <table>
        <tr>
            <th>Username</th>
            <th>Product ID</th>
            <th>Product Name</th>
            <th>Quantity</th>
            <th>Price</th>
        </tr>
        <% for (Map<String, String> product : products) { %>
        <tr>
            <td><%= product.get("username") %></td>
            <td><%= product.get("pid") %></td>
            <td><%= product.get("pname") %></td>
            <td><%= product.get("qty") %></td>
            <td><%= product.get("price") %></td>
        </tr>
        <% } %>
    </table>

    <div class="form-container">
        <form action="sellerlogout.jsp" method="post">
            <input type="submit" value="Logout">
        </form>
    </div>

    <div style="text-align: center;">
        <a href="index.html" class="button">Return to Home Page</a>
    </div>
</body>
</html>
