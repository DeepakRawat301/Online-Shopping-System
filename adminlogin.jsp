<%@page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Shopping Portal</title>
</head>
<body>
    <%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    boolean isValidUser = false;

    try {

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        PreparedStatement prst = con.prepareStatement("SELECT * FROM admin WHERE username=? AND password=?");
        prst.setString(1, username);
        prst.setString(2, password);
        
        ResultSet rs = prst.executeQuery();

        if (rs.next()) {
            isValidUser = true;
            String p1 = rs.getString(1);
            session.setAttribute("user" , p1);   
            response.sendRedirect("admindesk1.jsp");
            return; 
        }
    } catch (Exception e) {
        e.printStackTrace();
    } 

    if (isValidUser) {
        response.sendRedirect("dashboard.jsp");
    } else {
        out.println("Invalid username or password.");
        response.sendRedirect("login.html");
    }
    %>
</body>
</html>