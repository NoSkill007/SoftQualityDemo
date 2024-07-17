<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Olvidé mi Contraseña</title>
    <link rel="stylesheet" href="forgot_password.css">
</head>
<body>
<div class="container">
    <div class="logo-container">
        <a href="Index.html">
            <img src="img/Logo2.png" alt="Supply Solutions">
        </a>
    </div>
    <div class="login-box">
        <h1>Olvidé mi Contraseña</h1>
        <%
            String correo = request.getParameter("email");
            String message = "";
            boolean userExists = false;
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            if (correo != null && !correo.isEmpty()) {
                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");

                    try {
                        con = DriverManager.getConnection(
                                "jdbc:oracle:thin:@localhost:1521:xe", "usuarioDB", "contrasenaDB");

                        // Verificar si el correo existe en las tablas de usuarios y colaboradores
                        ps = con.prepareStatement("SELECT COUNT(*) FROM usuarios WHERE correo = ?");
                        ps.setString(1, correo);
                        rs = ps.executeQuery();
                        if (rs.next() && rs.getInt(1) > 0) {
                            userExists = true;
                        }
                        rs.close();
                        ps.close();

                        if (!userExists) {
                            ps = con.prepareStatement("SELECT COUNT(*) FROM colaboradores WHERE correo = ?");
                            ps.setString(1, correo);
                            rs = ps.executeQuery();
                            if (rs.next() && rs.getInt(1) > 0) {
                                userExists = true;
                            }
                            rs.close();
                            ps.close();
                        }

                    } catch (SQLException e) {
                        e.printStackTrace();
                        message = "Error al conectar con la base de datos.";
                    } finally {
                        if (rs != null) {
                            try {
                                rs.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                        if (ps != null) {
                            try {
                                ps.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                        if (con != null) {
                            try {
                                con.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                                message = "Error al cerrar la conexión de la base de datos.";
                            }
                        }
                    }
                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                    message = "Driver JDBC no encontrado.";
                }
            }
        %>

        <% if (correo == null || correo.isEmpty()) { %>
        <form action="forgot_password.jsp" method="post">
            <input type="email" name="email" placeholder="Ingrese su correo electrónico" class="input-field" required>
            <input type="submit" value="Verificar Correo" class="sign-in-btn">
        </form>
        <p class="register-link">¿Recordaste tu contraseña? <a href="Login.html">Iniciar Sesión</a></p>
        <% } else if (userExists) { %>
        <form action="reset_password.jsp" method="post">
            <input type="hidden" name="email" value="<%= correo %>">
            <input type="password" name="new_password" placeholder="Ingrese la nueva contraseña" class="input-field"
                   required>
            <input type="password" name="confirm_password" placeholder="Confirme la nueva contraseña"
                   class="input-field" required>
            <input type="submit" value="Restablecer Contraseña" class="sign-in-btn">
        </form>
        <% } else { %>
        <p class="error">El correo electrónico no está registrado.</p>
        <script>
            setTimeout(function () {
                window.location.href = 'forgot_password.jsp';
            }, 4000);
        </script>
        <% } %>
        <p class="<%= userExists ? "success" : "error" %>"><%= message %>
        </p>
    </div>
</div>
</body>
</html>
