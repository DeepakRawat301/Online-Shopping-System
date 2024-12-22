<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        PreparedStatement prst = con.prepareStatement("SELECT * FROM user WHERE username = ? AND password = ?");
        prst.setString(1, username);
        prst.setString(2, password);

        ResultSet rs = prst.executeQuery();

        if (rs.next()) {
            boolean isBlocked = rs.getBoolean("is_blocked");

            if (isBlocked) {
                out.println("<h2>Your account is blocked. Please contact admin.</h2>");
            } else {
                session.setAttribute("user", username);
                response.sendRedirect("userdesk1.jsp");
            }
        } else {
            out.println("<h2>Invalid username or password</h2>");
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>
