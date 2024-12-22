<%@page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

    <%

    String s1 = (String) session.getAttribute("user");
    if (s1 != null) {
       out.println("Welcome " + s1);
    }

    String pid = request.getParameter("pid");
    String pname = request.getParameter("pname");
    String qty = request.getParameter("qty");
    String price = request.getParameter("price");
    String username=s1;

    Connection con = null;
    PreparedStatement prst = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/online_shopping", "root", "12345");

        String query = "INSERT INTO  product (username,pid, pname, qty, price) VALUES (?, ?, ?, ?, ?)";
        prst = con.prepareStatement(query);
        prst.setString(1, username);
        prst.setString(2, pid);
        prst.setString(3, pname);
        prst.setString(4, qty);
        prst.setString(5, price);
    
        int n = prst.executeUpdate();
        if (n > 0) {
            // Close resources before redirecting
            prst.close();
            con.close();
            out.println("Product Added Successfully");
            response.sendRedirect("sellerdesk1.jsp");
            return; // Stop further execution of JSP
        } else {
            out.println("Failed to add product");
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