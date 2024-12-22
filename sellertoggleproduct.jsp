<%@ page import="java.sql.*, java.util.Map, java.util.HashMap, java.util.List, java.util.ArrayList" %>
<%
    // Fetch username from session
    String username = (String) session.getAttribute("user");
    if (username == null) {
        response.sendRedirect("sellerlogin.html");
        return; // Redirect to login if no username is found
    }

    // Initialize the cart to hold product data
    List<Map<String, Object>> cart = new ArrayList<>();

    try {
        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        // Check if an action was performed
        String actionPid = request.getParameter("pid");
        String actionType = request.getParameter("action"); // 'display' or 'dont_display'

        if (actionPid != null && actionType != null) {
            // Update the `is_displayed` column based on the action
            int newDisplayValue = actionType.equals("display") ? 1 : 0;
            PreparedStatement updatePrst = con.prepareStatement("UPDATE product SET is_displayed = ? WHERE pid = ? AND username = ?");
            updatePrst.setInt(1, newDisplayValue);
            updatePrst.setString(2, actionPid);
            updatePrst.setString(3, username);
            updatePrst.executeUpdate();
        }

        // Fetch product details for the logged-in user
        PreparedStatement prst = con.prepareStatement("SELECT pid, pname, qty, price, is_displayed FROM product WHERE username = ?");
        prst.setString(1, username);
        ResultSet rs = prst.executeQuery();

        // Populate the cart with product details
        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("pid", rs.getString("pid"));
            item.put("pname", rs.getString("pname"));
            item.put("qty", rs.getInt("qty"));
            item.put("price", rs.getDouble("price"));
            item.put("is_displayed", rs.getInt("is_displayed"));
            cart.add(item);
        }

        con.close(); // Close the database connection
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!-- Display Products in a Table -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Product Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        table {
            width: 80%;
            margin: 20px 0;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        a {
            color: #4CAF50;
            text-decoration: none;
            padding: 5px;
            border: 1px solid #4CAF50;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        a:hover {
            background-color: #4CAF50;
            color: white;
        }

        .back-link {
            margin-top: 20px;
            text-align: center;
        }

        .back-link a {
            font-size: 16px;
            color: #333;
            text-decoration: none;
            padding: 10px;
            border-radius: 4px;
            background-color: #f0f0f0;
        }

        .back-link a:hover {
            background-color: #ddd;
        }
    </style>
</head>
<body>

    <table>
        <tr>
            <th>Product ID</th>
            <th>Product Name</th>
            <th>Quantity</th>
            <th>Price</th>
            <th>Action</th>
        </tr>
        <% for (Map<String, Object> product : cart) { %>
            <tr>
                <td><%= product.get("pid") %></td>
                <td><%= product.get("pname") %></td>
                <td><%= product.get("qty") %></td>
                <td><%= product.get("price") %></td>
                <td>
                    <% if ((int) product.get("is_displayed") == 1) { %>
                        <a href="sellertoggleproduct.jsp?pid=<%= product.get("pid") %>&action=dont_display">Don't Display</a>
                    <% } else { %>
                        <a href="sellertoggleproduct.jsp?pid=<%= product.get("pid") %>&action=display">Display</a>
                    <% } %>
                </td>
            </tr>
        <% } %>
    </table>

    <div class="back-link">
        <a href="sellerdesk1.jsp">Dashboard</a>
    </div>
       <br><br>
    <div class="back-link">
        <a href="index.html">Home Page</a>
    </div>

</body>
</html>
