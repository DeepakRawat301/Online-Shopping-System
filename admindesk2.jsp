<%@ page import="java.sql.*" %>
<%
    // Database connection constants
    final String DB_URL = "jdbc:mysql://localhost:3306/online_shopping";
    final String DB_USER = "root";
    final String DB_PASSWORD = "12345";

    String action = request.getParameter("action");
    String username = request.getParameter("username");

    if (action != null && username != null) {
        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String query;
            if ("block".equals(action)) {
                query = "UPDATE user SET is_blocked = 1 WHERE username = ?";
            } else if ("unblock".equals(action)) {
                query = "UPDATE user SET is_blocked = 0 WHERE username = ?";
            } else {
                throw new IllegalArgumentException("Invalid action: " + action);
            }

            try (PreparedStatement prst = con.prepareStatement(query)) {
                prst.setString(1, username);
                prst.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div style='color: red;'>Error: " + e.getMessage() + "</div>");
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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
            background-color: #f2f2f2;
        }
        a {
            color: #0077cc;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        .logout-form, .home-link {
            text-align: center;
            margin: 20px 0;
        }
        .logout-form input[type="submit"] {
            background-color: #0077cc;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .logout-form input[type="submit"]:hover {
            background-color: #005bb5;
        }
    </style>
</head>
<body>
    <h1>Admin - Manage Users</h1>

    <table>
        <tr>
            <th>Username</th>
            <th>Password</th>
            <th>Name</th>
            <th>Email</th>
            <th>City</th>
            <th>Account Status</th>
            <th>Action</th>
        </tr>
        <%
            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String query = "SELECT * FROM user";
                try (PreparedStatement prst = con.prepareStatement(query); ResultSet rs = prst.executeQuery()) {
                    while (rs.next()) {
                        String sellerUsername = rs.getString("username");
                        String password = rs.getString("password");
                        String name = rs.getString("name");
                        String email = rs.getString("email");
                        String city = rs.getString("city");
                        boolean isBlocked = rs.getBoolean("is_blocked");
        %>
        <tr>
            <td><%= sellerUsername %></td>
            <td><%= password %></td>
            <td><%= name %></td>
            <td><%= email %></td>
            <td><%= city %></td>
            <td><%= isBlocked ? "Blocked" : "Active" %></td>
            <td>
                <% if (isBlocked) { %>
                    <a href="admindesk2.jsp?action=unblock&username=<%= sellerUsername %>">Unblock</a>
                <% } else { %>
                    <a href="admindesk2.jsp?action=block&username=<%= sellerUsername %>">Block</a>
                <% } %>
            </td>
        </tr>
        <%
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div style='color: red;'>Error: " + e.getMessage() + "</div>");
            }
        %>
    </table>

    <div class="logout-form">
        <form action="sellerlogout.jsp" method="post">
            <input type="submit" value="Logout">
        </form>
    </div>

    <div class="home-link">
        <a href="index.html">Return to Home Page</a>
    </div>

    <div class="home-link">
        <a href="admindesk1.jsp">Back to Dashboard</a>
    </div>
</body>
</html>
