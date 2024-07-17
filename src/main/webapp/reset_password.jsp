<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restablecimiento de Contraseña</title>
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
        <h1>Restablecimiento de Contraseña</h1>
        <%
            String correo = request.getParameter("email");
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");
            String message = "";
            boolean success = false;
            Connection con = null;
            PreparedStatement ps = null;

            if (!newPassword.equals(confirmPassword)) {
                message = "Las contraseñas no coinciden.";
            } else {
                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");

                    try {
                        con = DriverManager.getConnection(
                                "jdbc:oracle:thin:@localhost:1521:xe", "usuarioDB", "contrasenaDB");

                        // Actualizar la contraseña en la tabla correspondiente
                        ps = con.prepareStatement("UPDATE usuarios SET contrasena = ? WHERE correo = ?");
                        ps.setString(1, newPassword);
                        ps.setString(2, correo);
                        int rowsUpdated = ps.executeUpdate();
                        ps.close();

                        if (rowsUpdated == 0) {
                            ps = con.prepareStatement("UPDATE colaboradores SET contrasena = ? WHERE correo = ?");
                            ps.setString(1, newPassword);
                            ps.setString(2, correo);
                            rowsUpdated = ps.executeUpdate();
                            ps.close();
                        }

                        if (rowsUpdated > 0) {
                            message = "Contraseña restablecida exitosamente.";
                            success = true;
                        } else {
                            message = "Error al restablecer la contraseña.";
                        }

                    } catch (SQLException e) {
                        e.printStackTrace();
                        message = "Error al conectar con la base de datos.";
                    } finally {
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
        <p class="<%= message.equals("Contraseña restablecida exitosamente.") ? "success" : "error" %>"><%= message %>
        </p>
        <script>
            setTimeout(function () {
                window.location.href = 'Login.html';
            }, 4000);
        </script>
    </div>
</div>
</body>
</html>
