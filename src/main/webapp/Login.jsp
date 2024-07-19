<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultado del Inicio de Sesión</title>
    <link rel="stylesheet" href="shared_styles.css">
</head>
<body>
<div class="container">
    <div class="login-box">
        <div class="logo-container">
            <img src="img/Logo2.png" alt="Logo">
        </div>
        <h1>Resultado del Inicio de Sesión</h1>
        <%
            String userType = request.getParameter("user-type");
            String correo = request.getParameter("email");
            String contrasena = request.getParameter("password");
            String message = "";
            boolean success = false;
            Connection con = null;

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");

                try {
                    con = DriverManager.getConnection(
                            "jdbc:oracle:thin:@localhost:1521:xe", "usuarioDB", "contrasenaDB");

                    String tableName = userType.equals("cliente") ? "usuarios" : "colaboradores";
                    PreparedStatement ps = con.prepareStatement("SELECT contrasena FROM " + tableName + " WHERE correo = ?");
                    ps.setString(1, correo);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        String dbContrasena = rs.getString("contrasena");

                        if (dbContrasena.equals(contrasena)) {
                            message = "Inicio de sesión exitoso!";
                            success = true;
                        } else {
                            message = "Contraseña incorrecta.";
                        }
                    } else {
                        message = "Correo no registrado.";
                    }

                    rs.close();
                    ps.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                    message = "Error al conectar con la base de datos.";
                } finally {
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
        %>
        <p class="<%= success ? "success" : "error" %>"><%= message %>
        </p>
        <script>

            setTimeout(function () {
                if (<%= success %>) {
                    window.location.href = '<%= userType.equals("cliente") ? "Pantalla_Cliente.html" : "inicio_recepcionista.html" %>';
                } else {
                    window.location.href = 'Login.html';
                }
            }, 2000);
        </script>
    </div>
</div>
</body>
</html>
