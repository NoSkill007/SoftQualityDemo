<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultado del Registro</title>
    <link rel="stylesheet" href="shared_styles.css">
</head>
<body>
<div class="container">
    <div class="login-box">
        <div class="logo-container">
            <img src="img/Logo2.png" alt="Logo">
        </div>
        <h1>Resultado del Registro</h1>
        <%
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String correo = request.getParameter("correo");
            String contrasena = request.getParameter("contrasena");
            String confirmarContrasena = request.getParameter("confirmarContrasena");
            String message = "";
            boolean success = false;
            Connection con = null;

            if (!contrasena.equals(confirmarContrasena)) {
                message = "Las contraseñas no coinciden.";
            } else {
                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");

                    try {
                        con = DriverManager.getConnection(
                                "jdbc:oracle:thin:@localhost:1521:xe", "usuarioDB", "contrasenaDB");

                        // Verificar si el correo ya está registrado
                        PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM usuarios WHERE correo = ?");
                        ps.setString(1, correo);
                        ResultSet rs = ps.executeQuery();
                        rs.next();
                        int count = rs.getInt(1);
                        rs.close();
                        ps.close();

                        if (count > 0) {
                            message = "El correo ya está registrado.";
                        } else {
                            CallableStatement cs = con.prepareCall("{call registrar_usuario(?, ?, ?, ?)}");
                            cs.setString(1, nombre);
                            cs.setString(2, apellido);
                            cs.setString(3, correo);
                            cs.setString(4, contrasena);  // Guardar la contraseña tal cual

                            cs.execute();
                            cs.close();

                            message = "Registro exitoso!";
                            success = true;
                        }
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
            }
        %>
        <p class="<%= success ? "success" : "error" %>"><%= message %>
        </p>
        <script>
            setTimeout(function () {
                window.location.href = '<%= success ? "Login.html" : "Register.html" %>';
            }, 2000);
        </script>
    </div>
</div>
</body>
</html>