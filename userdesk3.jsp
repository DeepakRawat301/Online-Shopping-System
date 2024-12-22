<%@page import="java.sql.*"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList, java.util.HashMap, java.util.List, java.util.Map" %>
<%
    String searchQuery = request.getParameter("search");
    List<Map<String, String>> searchResults = new ArrayList<>();
    String selectedProductId = request.getParameter("productId");
    Map<String, String> selectedProductDetails = null;
    String addToCartMessage = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        // Fetch matching products if search query is provided
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            PreparedStatement prst = con.prepareStatement("SELECT * FROM product WHERE pname LIKE ? AND is_displayed = 1");
            prst.setString(1, "%" + searchQuery + "%");
            ResultSet rs = prst.executeQuery();

            while (rs.next()) {
                Map<String, String> product = new HashMap<>();
                product.put("pid", rs.getString("pid"));
                product.put("pname", rs.getString("pname"));
                searchResults.add(product);
            }
        }

        // Fetch selected product details if a product ID is provided
        if (selectedProductId != null && !selectedProductId.trim().isEmpty()) {
            PreparedStatement prst = con.prepareStatement("SELECT * FROM product WHERE pid = ? AND is_displayed = 1");
            prst.setString(1, selectedProductId);
            ResultSet rs = prst.executeQuery();

            if (rs.next()) {
                selectedProductDetails = new HashMap<>();
                selectedProductDetails.put("pid", rs.getString("pid"));
                selectedProductDetails.put("pname", rs.getString("pname"));
                selectedProductDetails.put("qty", rs.getString("qty"));
                selectedProductDetails.put("price", rs.getString("price"));
            }
        }

        // Add to Cart Logic
        String cartProductId = request.getParameter("cartProductId");
        String cartQuantity = request.getParameter("cartQuantity");

        if (cartProductId != null && cartQuantity != null) {
            if (selectedProductDetails == null) {
                // Refetch product details
                PreparedStatement fetchProduct = con.prepareStatement("SELECT * FROM product WHERE pid = ? AND is_displayed = 1");
                fetchProduct.setString(1, cartProductId);
                ResultSet rs = fetchProduct.executeQuery();
        
                if (rs.next()) {
                    selectedProductDetails = new HashMap<>();
                    selectedProductDetails.put("pid", rs.getString("pid"));
                    selectedProductDetails.put("pname", rs.getString("pname"));
                    selectedProductDetails.put("qty", rs.getString("qty"));
                    selectedProductDetails.put("price", rs.getString("price"));
                }
            }
        
            if (selectedProductDetails != null) {
                int availableQty = Integer.parseInt(selectedProductDetails.get("qty"));
                int requestedQty = Integer.parseInt(cartQuantity);
        
                if (availableQty >= requestedQty) {
                    // Insert item into cart
                    PreparedStatement insertCart = con.prepareStatement(
                        "INSERT INTO cart (username, pid, pname, quantity, price) VALUES (?, ?, ?, ?, ?)");
                    String username = (String) session.getAttribute("user");
                    insertCart.setString(1, username);
                    insertCart.setString(2, cartProductId);
                    insertCart.setString(3, selectedProductDetails.get("pname"));
                    insertCart.setInt(4, requestedQty);
                    insertCart.setDouble(5, Double.parseDouble(selectedProductDetails.get("price")));
        
                    int rowsInserted = insertCart.executeUpdate();
                    if (rowsInserted > 0) {
                        // Update product quantity in the database
                        PreparedStatement updateProductQty = con.prepareStatement(
                            "UPDATE product SET qty = qty - ? WHERE pid = ?");
                        updateProductQty.setInt(1, requestedQty);
                        updateProductQty.setString(2, cartProductId);
        
                        int rowsUpdated = updateProductQty.executeUpdate();
                        if (rowsUpdated > 0) {
                            addToCartMessage = "Item successfully added to cart! Quantity updated.";
                        } else {
                            addToCartMessage = "Item added to cart, but failed to update product quantity.";
                        }
                    }
                } else {
                    addToCartMessage = "Insufficient stock. Only " + availableQty + " items available.";
                }
            } else {
                addToCartMessage = "Error: Product details not found. Unable to add to cart.";
            }
        }
        
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
        addToCartMessage = "An error occurred while processing your request.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Product</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f8f8;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }

        h1 {
            color: #333;
            font-size: 32px;
            margin-top: 20px;
        }

        form {
            margin: 20px 0;
            text-align: center;
        }

        input[type="text"] {
            padding: 10px;
            width: 300px;
            margin-right: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        input[type="submit"] {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }

        .product-list {
            list-style: none;
            padding: 0;
            margin-top: 20px;
            width: 80%;
            max-width: 600px;
            text-align: left;
        }

        .product-list li {
            padding: 10px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 10px;
            transition: background-color 0.3s;
        }

        .product-list li:hover {
            background-color: #f0f0f0;
        }

        .product-list a {
            text-decoration: none;
            color: #333;
        }

        .product-details {
            margin-top: 30px;
            width: 80%;
            max-width: 600px;
            padding: 20px;
            background-color: white;
            border-radius: 5px;
            border: 1px solid #ddd;
            text-align: left;
        }

        .product-details p {
            margin: 10px 0;
        }

        .product-details label {
            font-weight: bold;
        }

        input[type="number"] {
            padding: 5px;
            width: 60px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .cart-message {
            margin-top: 20px;
            color: #d32f2f;
            font-weight: bold;
        }

        .actions {
            margin-top: 30px;
            text-align: center;
        }

        .actions input[type="submit"] {
            width: 100%;
            max-width: 200px;
            font-size: 16px;
        }

        .actions a {
            color: #4CAF50;
            font-size: 18px;
            text-decoration: none;
            margin-top: 10px;
            display: inline-block;
        }

    </style>
</head>
<body>

    <%
    String s1 = (String) session.getAttribute("user");
    if (s1 != null) {
        out.println("<h2>Welcome, " + s1 + "</h2>");
    }
    %>
    
    <h1>Search Product</h1>
    <form method="get" action="userdesk3.jsp">
        <input type="text" name="search" placeholder="Enter product name" required>
        <input type="submit" value="Search">
    </form>

    <% if (!searchResults.isEmpty()) { %>
        <h2>Matching Products:</h2>
        <ul class="product-list">
            <% for (Map<String, String> product : searchResults) { %>
                <li>
                    <a href="userdesk3.jsp?productId=<%= product.get("pid") %>">
                        <%= product.get("pname") %>
                    </a>
                </li>
            <% } %>
        </ul>
    <% } else if (searchQuery != null) { %>
        <p>No matching products found for "<%= searchQuery %>".</p>
    <% } %>

    <% if (selectedProductDetails != null) { %>
        <div class="product-details">
            <h2>Product Details:</h2>
            <p><strong>Name:</strong> <%= selectedProductDetails.get("pname") %></p>
            <p><strong>Quantity Available:</strong> <%= selectedProductDetails.get("qty") %></p>
            <p><strong>Price:</strong> <%= selectedProductDetails.get("price") %></p>

            <h3>Add to Cart</h3>
            <form method="post" action="userdesk3.jsp">
                <input type="hidden" name="cartProductId" value="<%= selectedProductDetails.get("pid") %>">
                <label for="cartQuantity">Quantity:</label>
                <input type="number" name="cartQuantity" min="1" max="<%= selectedProductDetails.get("qty") %>" required>
                <input type="submit" value="Add to Cart">
            </form>
        </div>
    <% } %>

    <% if (addToCartMessage != null) { %>
        <div class="cart-message">
            <p><%= addToCartMessage %></p>
        </div>
    <% } %>

    <div class="actions">
        <form action="userlogout.jsp" method="post">
            <input type="submit" value="Logout">
        </form>
        <a href="userdesk1.jsp">Back to Dashboard</a>
        <br>

        <a href="index.html">Return to Home Page</a>
    </div>

</body>
</html>

