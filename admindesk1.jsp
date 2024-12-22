<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <!-- Include the font-awesome icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- Custom Stylesheet -->
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }
        header {
            background-color: #0077cc;
            color: #fff;
            padding: 1rem;
            text-align: center;
            font-size: 1.5rem;
        }
        .welcome-msg {
            margin: 1rem auto;
            text-align: center;
            font-size: 1.2rem;
        }
        .dashboard-container {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 1rem;
            padding: 2rem;
        }
        .dashboard-card {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            text-align: center;
            width: 200px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .dashboard-card a {
            text-decoration: none;
            color: #0077cc;
            font-weight: bold;
        }
        .logout-form, .home-link {
            text-align: center;
            margin: 2rem 0;
        }
        .logout-form input[type="submit"] {
            background-color: #0077cc;
            color: #fff;
            border: none;
            padding: 0.5rem 1.5rem;
            font-size: 1rem;
            border-radius: 5px;
            cursor: pointer;
        }
        .logout-form input[type="submit"]:hover {
            background-color: #005bb5;
        }
        .home-link a {
            color: #0077cc;
            text-decoration: none;
            font-weight: bold;
        }
        .home-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <!-- Header Section -->
    <header>Admin Dashboard</header>

    <!-- Welcome Message -->
    <div class="welcome-msg">
        <%
        String s1 = (String) session.getAttribute("user");
        if (s1 != null) {
        %>
            Welcome, <b><%= s1 %></b>
        <%
        }
        %>
    </div>

    <!-- Dashboard Links -->
    <div class="dashboard-container">
        <div class="dashboard-card">
            <a href="admindesk2.jsp">
                <i class="fa-solid fa-users"></i><br>
                See All Users
            </a>
        </div>
        <div class="dashboard-card">
            <a href="admindesk3.jsp">
                <i class="fa-solid fa-store"></i><br>
                See All Sellers
            </a>
        </div>
        <div class="dashboard-card">
            <a href="admindesk4.jsp">
                <i class="fa-solid fa-box"></i><br>
                See All Products
            </a>
        </div>
        <div class="dashboard-card">
            <a href="admindesk5.jsp">
                <i class="fa-solid fa-user-circle"></i><br>
                Profile
            </a>
        </div>
    </div>

    <!-- Logout Button -->
    <div class="logout-form">
        <form action="sellerlogout.jsp" method="post">
            <input type="submit" value="Logout">
        </form>
    </div>

    <!-- Return to Home Page -->
    <div class="home-link">
        <a href="index.html">Return to Home Page</a>
    </div>
</body>
</html>
