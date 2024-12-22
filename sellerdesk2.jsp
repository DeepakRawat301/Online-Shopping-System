<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product</title>
    <style>
        /* General Page Styles */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: #333;
        }

        /* Container for the Form */
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            text-align: center;
        }

        h1 {
            color: #4CAF50;
            margin-bottom: 20px;
        }

        /* Form Styling */
        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        label {
            margin: 10px 0 5px;
            font-weight: bold;
        }

        input[type="text"] {
            width: 80%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1em;
        }

        input[type="text"]:focus {
            border-color: #4CAF50;
            outline: none;
        }

        button {
            padding: 12px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 1.2em;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #45a049;
        }

        /* Logout Button */
        .logout-form {
            margin-top: 20px;
        }

        .logout-form input[type="submit"] {
            padding: 12px;
            background-color: #f44336;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 1.2em;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .logout-form input[type="submit"]:hover {
            background-color: #e53935;
        }

        /* Return Link */
        .return-link {
            margin-top: 20px;
            font-size: 1.1em;
        }

        .return-link a {
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
        <h1>Add Product</h1>

        <% 
            String s1 = (String) session.getAttribute("user");
            if (s1 != null) {
                out.println("<p>Welcome, " + s1 + "</p>");
            }
        %>

        <form action="sellerdeskp.jsp" method="post">
            <label for="pid">Enter Product ID</label>
            <input type="text" id="pid" name="pid" placeholder="Product ID" required>
            
            <label for="pname">Enter Product Name</label>
            <input type="text" id="pname" name="pname" placeholder="Product Name" required>

            <label for="qty">Enter Quantity</label>
            <input type="text" id="qty" name="qty" placeholder="Quantity" required>

            <label for="price">Enter Price</label>
            <input type="text" id="price" name="price" placeholder="Price" required>

            <button type="submit">Add Product</button>
        </form>

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
