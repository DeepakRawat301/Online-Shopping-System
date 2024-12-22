<%@page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration</title>
</head>
<body>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String city = request.getParameter("city");

    Connection con = null;
    PreparedStatement prst = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        String query = "INSERT INTO admin (username, password, name, email, city) VALUES (?, ?, ?, ?, ?)";
        prst = con.prepareStatement(query);
        prst.setString(1, username);
        prst.setString(2, password);
        prst.setString(3, name);
        prst.setString(4, email);
        prst.setString(5, city);


        int n = prst.executeUpdate();
        if (n > 0) {
            // Close resources before redirecting
            prst.close();
            con.close();
            response.sendRedirect("adminlogin.html");
            return; // Stop further execution of JSP
        } else {
            out.println("Failed to register doctor");
        }
    } catch (ClassNotFoundException | SQLException e) {
        // Handle exceptions properly (log or display error message)
        out.println("Exception occurred: " + e.getMessage());
    } finally {
        // Close resources in finally block to ensure they are always closed
        try {
            if (prst != null) {
                prst.close();
            }
            if (con != null) {
                con.close();
            }
        } catch (SQLException e) {
            out.println("Error closing resources: " + e.getMessage());
        }
    }

    
%>
</body>
</html>
