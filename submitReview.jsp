<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("user");
    String pname = request.getParameter("pname");
    String review = request.getParameter("review");

    if (username == null || pname == null || review == null) {
        response.sendRedirect("login.html");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        PreparedStatement reviewStmt = con.prepareStatement(
            "INSERT INTO reviews (username, pname, review) VALUES (?, ?, ?)"
        );
        reviewStmt.setString(1, username);
        reviewStmt.setString(2, pname);
        reviewStmt.setString(3, review);

        int rowsInserted = reviewStmt.executeUpdate();

        if (rowsInserted > 0) {
            response.sendRedirect("userdesk2.jsp"); 
            out.println("<p>Thank you for your review! <a href='userdesk2.jsp'>Return to Cart</a></p>");
        } else {
            out.println("<p>Failed to submit review. Please try again later.</p>");
        }

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>
