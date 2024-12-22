<%@ page import="java.sql.*" %>
<%
    String pid = request.getParameter("pid");
    String pname = request.getParameter("pname");
    String qty = request.getParameter("qty");
    String price = request.getParameter("price");

    // If no parameters are found, redirect to the product listing page
    if (pid == null || pname == null || qty == null || price == null) {
        response.sendRedirect("sellerdesk3.jsp");
        return;
    }

    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Get the updated values from the form
        String updatedPname = request.getParameter("pname");
        String updatedQty = request.getParameter("qty");
        String updatedPrice = request.getParameter("price");

        try {
            // Connect to the database
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

            // Prepare SQL query to update product details
            String query = "UPDATE product SET pname = ?, qty = ?, price = ? WHERE pid = ?";
            PreparedStatement prst = con.prepareStatement(query);
            prst.setString(1, updatedPname);
            prst.setString(2, updatedQty);
            prst.setString(3, updatedPrice);
            prst.setString(4, pid);

            int rowsUpdated = prst.executeUpdate();

            if (rowsUpdated > 0) {
                out.println("<p>Product updated successfully.</p>");
                response.sendRedirect("sellerdesk3.jsp"); // Redirect back to the product listing page
            } else {
                out.println("<p>Failed to update product.</p>");
            }

            con.close();  // Close the connection after the operation
        } catch (ClassNotFoundException | SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Product</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: white;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 8px;
            width: 400px;
            text-align: center;
        }

        h1 {
            font-size: 24px;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        label {
            text-align: left;
            font-weight: bold;
            font-size: 14px;
            color: #333;
        }

        input[type="text"], input[type="number"] {
            padding: 10px;
            font-size: 14px;
            border-radius: 4px;
            border: 1px solid #ddd;
            outline: none;
        }

        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }

        .back-link {
            margin-top: 20px;
            font-size: 14px;
        }

        .back-link a {
            color: #333;
            text-decoration: none;
            border: 1px solid #ddd;
            padding: 8px 12px;
            border-radius: 4px;
            background-color: #f1f1f1;
        }

        .back-link a:hover {
            background-color: #ddd;
        }

        .footer {
            margin-top: 20px;
            text-align: center;
        }

        .footer a {
            text-decoration: none;
            color: #4CAF50;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>Update Product Details</h1>
        <form action="updateProduct.jsp?pid=<%= pid %>" method="POST">
            <label for="pname">Product Name:</label>
            <input type="text" id="pname" name="pname" value="<%= pname %>" required><br><br>

            <label for="qty">Quantity:</label>
            <input type="number" id="qty" name="qty" value="<%= qty %>" required><br><br>

            <label for="price">Price:</label>
            <input type="number" id="price" name="price" value="<%= price %>" required><br><br>

            <input type="submit" value="Update Product">
        </form>

        <div class="back-link">
            <form action="sellerdesk3.jsp" method="post">
                <input type="submit" value="Back to Product List">
            </form>
        </div>
    </div>

    <div class="footer">
        <a href="index.html">Return to Home Page</a>
    </div>

</body>
</html>
