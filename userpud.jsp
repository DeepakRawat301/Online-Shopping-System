<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration</title>
</head>
<body>

<%
    // Check if a session attribute exists for the user
    String s1 = (String) session.getAttribute("user");
    if (s1 != null) {
        out.println("Welcome " + s1);
    }

    // Get form data
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String city = request.getParameter("city");

    // Check if the values are null or empty
    if (username == null || password == null || name == null || email == null || city == null) {
        out.println("<p>Error: Missing data.</p>");
        return;
    }

    Connection con = null;
    PreparedStatement prst = null;

    try {
        // Register MySQL driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        // Prepare SQL query to update user data
        String query = "UPDATE user SET password=?, name=?, email=?, city=? WHERE username=?";
        prst = con.prepareStatement(query);
        prst.setString(1, password);
        prst.setString(2, name);
        prst.setString(3, email);
        prst.setString(4, city);
        prst.setString(5, username);

        // Debug: Print query parameters to verify
        out.println("<p>Updating user: " + username + "</p>");

        // Execute the query
        int n = prst.executeUpdate();
        if (n > 0) {
            out.println("<p>Profile Updated successfully</p>");
            response.sendRedirect("userdesk1.jsp");  // Redirect after successful update
        } else {
            out.println("<p>Failed to update user: No such user found.</p>");
        }
    } catch (ClassNotFoundException | SQLException e) {
        out.println("<p>Exception occurred: " + e.getMessage() + "</p>");
        e.printStackTrace();  // Print stack trace for debugging
    } finally {
        // Ensure resources are closed in the finally block
        try {
            if (prst != null) {
                prst.close();
            }
            if (con != null) {
                con.close();
            }
        } catch (SQLException e) {
            out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
%>

</body>
</html>
