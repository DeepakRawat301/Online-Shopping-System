<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("user");

    if (username == null) {
        response.sendRedirect("login.html");
        return;
    }

    String productName = request.getParameter("pname");
    String quantityToDelete = request.getParameter("quantity");

    try {
        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        // Update the product table to add the deleted quantity back
        PreparedStatement updateProductStmt = con.prepareStatement(
            "UPDATE product SET qty = qty + ? WHERE pname = ?"
        );
        updateProductStmt.setInt(1, Integer.parseInt(quantityToDelete));
        updateProductStmt.setString(2, productName);
        updateProductStmt.executeUpdate();

        // Delete the product from the cart
        PreparedStatement deleteCartStmt = con.prepareStatement(
            "DELETE FROM cart WHERE username = ? AND pname = ?"
        );
        deleteCartStmt.setString(1, username);
        deleteCartStmt.setString(2, productName);
        deleteCartStmt.executeUpdate();

        con.close();

        // Redirect back to the cart page
        response.sendRedirect("userdesk2.jsp");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        out.println("JDBC Driver not found: " + e.getMessage());
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("Database error: " + e.getMessage());
    } catch (Exception e) {
        e.printStackTrace();
        out.println("An unexpected error occurred: " + e.getMessage());
    }
%>
