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

        // Fetch cart items for the logged-in user
        PreparedStatement cartStmt = con.prepareStatement("SELECT pname, quantity, price FROM cart WHERE username = ?");
        cartStmt.setString(1, username);
        ResultSet cartResult = cartStmt.executeQuery();

        while (cartResult.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("pname", cartResult.getString("pname"));
            item.put("quantity", cartResult.getString("quantity"));
            item.put("price", cartResult.getString("price"));
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
    <title>Your Cart</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        h1 {
            font-size: 28px;
            color: #333;
        }

        h2 {
            font-size: 24px;
            color: #333;
            margin-top: 20px;
        }

        .cart-container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 800px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #ddd;
        }

        .empty-cart {
            font-size: 18px;
            color: #777;
            margin-top: 20px;
        }

        .actions {
            margin-top: 20px;
            text-align: center;
        }

        .actions form {
            margin-bottom: 10px;
        }

        .actions a {
            color: #4CAF50;
            font-size: 18px;
            text-decoration: none;
            margin-top: 10px;
            display: inline-block;
        }

        .actions input[type="submit"] {
            background-color: #f44336;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            max-width: 200px;
            transition: background-color 0.3s;
        }

        .actions input[type="submit"]:hover {
            background-color: #d32f2f;
        }
    </style>
</head>
<body>

    <h1>Welcome, <%= username %></h1>

    <div class="cart-container">
        <h2>Your Cart</h2>

        <%
            if (cart.isEmpty()) {
        %>
            <p class="empty-cart">Your cart is empty!</p>
        <%
            } else {
        %>
            <table>
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Total Amount</th>
                        <th>Review</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Map<String, Object> item : cart) {
                            String productName = (String) item.get("pname");
                            String quantity = (String) item.get("quantity");
                            String price = (String) item.get("price");
                            double amount = Double.parseDouble(quantity) * Double.parseDouble(price);
                            %>
                            <tr>
                                <td><%= productName %></td>
                                <td><%= quantity %></td>
                                <td><%= price %></td>
                                <td><%= amount %></td>
                                <td>
                                    <form action="submitReview.jsp" method="post">
                                        <input type="hidden" name="pname" value="<%= productName %>">
                                        <textarea name="review" rows="2" cols="20" placeholder="Write your review here..." required></textarea>
                                        <br>
                                        <button type="submit">Submit Review</button>
                                    </form>
                                </td>
                                <td>
                                    <form action="UserdeleteFromCart.jsp" method="post">
                                        <input type="hidden" name="pname" value="<%= productName %>">
                                        <input type="hidden" name="quantity" value="<%= quantity %>">
                                        <button type="submit" style="background-color: #f44336; color: white; padding: 8px; border: none; border-radius: 4px; cursor: pointer;">Delete</button>
                                    </form>
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
            </div>

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
