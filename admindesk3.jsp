<%@ page import="java.sql.*" %>
<%
    String action = request.getParameter("action");
    String username = request.getParameter("username");

    if (action != null && username != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

            PreparedStatement prst;
            if (action.equals("block")) {
                prst = con.prepareStatement("UPDATE seller SET is_blocked = 1 WHERE username = ?");
            } else if (action.equals("unblock")) {
                prst = con.prepareStatement("UPDATE seller SET is_blocked = 0 WHERE username = ?");
            } else {
                throw new IllegalArgumentException("Invalid action: " + action);
            }
            prst.setString(1, username);
            prst.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Sellers</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        h1 {
            text-align: center;
            color: #333;
            margin-top: 20px;
        }
        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            background-color: #fff;
        }
        table th, table td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }
        table th {
            background-color: #0077cc;
            color: white;
        }
        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        table tr:hover {
            background-color: #f1f1f1;
        }
        a {
            color: #0077cc;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
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
    </style>
</head>
<body>
    <h1>Admin - Manage Sellers</h1>

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
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

                PreparedStatement prst = con.prepareStatement("SELECT * FROM seller");
                ResultSet rs = prst.executeQuery();

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
                    <a href="admindesk3.jsp?action=unblock&username=<%= sellerUsername %>">Unblock</a>
                <% } else { %>
                    <a href="admindesk3.jsp?action=block&username=<%= sellerUsername %>">Block</a>
                <% } %>
            </td>
        </tr>
        <%
                }
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("Error: " + e.getMessage());
            }
        %>
    </table>

    <div class="form-container">
        <form action="sellerlogout.jsp" method="post">
            <input type="submit" value="Logout">
        </form>
    </div>

    <div style="text-align: center;">
        <a href="admindesk1.jsp" class="button">Back to Dashboard</a>
    </div>

    <div style="text-align: center;">
        <a href="index.html" class="button">Return to Home Page</a>
    </div>
</body>
</html>
