<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Guardar Información</title>
    <link rel="stylesheet" href="shared_styles.css">
</head>
<body>
<div class="container">
    <div class="logo-container">
        <img src="img/Logo2.png" alt="eSupply Solutions">
    </div>
    <h1>Resultado del Registro</h1>
    <%
        String remitenteNombre = request.getParameter("remitente-nombre");
        String remitenteCedula = request.getParameter("remitente-cedula");
        String remitenteEmail = request.getParameter("remitente-email");
        String remitenteTelefono = request.getParameter("remitente-telefono");

        String destinatarioNombre = request.getParameter("destinatario-nombre");
        String destinatarioCedula = request.getParameter("destinatario-cedula");
        String destinatarioEmail = request.getParameter("destinatario-email");
        String destinatarioTelefono = request.getParameter("destinatario-telefono");
        String destinatarioHoraRetiro = request.getParameter("destinatario-hora-retiro");

        String paqueteDescripcion = request.getParameter("paquete-descripcion");
        String paqueteEspecificaciones = request.getParameter("paquete-especificaciones");
        String paqueteDireccionRetiro = request.getParameter("paquete-direccion-retiro");
        String paqueteDireccionEntrega = request.getParameter("paquete-direccion-entrega");

        Connection con = null;
        CallableStatement csRemitente = null;
        CallableStatement csDestinatario = null;
        CallableStatement csPaquete = null;

        String message = "";
        boolean success = false;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "usuarioDB", "contrasenaDB");

            // Insertar remitente
            String sqlRemitente = "{call insertar_remitente(?, ?, ?, ?, ?)}";
            csRemitente = con.prepareCall(sqlRemitente);
            csRemitente.setString(1, remitenteNombre);
            csRemitente.setString(2, remitenteCedula);
            csRemitente.setString(3, remitenteEmail);
            csRemitente.setString(4, remitenteTelefono);
            csRemitente.registerOutParameter(5, Types.INTEGER);
            csRemitente.executeUpdate();
            int remitenteId = csRemitente.getInt(5);

            // Insertar destinatario
            String sqlDestinatario = "{call insertar_destinatario(?, ?, ?, ?, ?, ?)}";
            csDestinatario = con.prepareCall(sqlDestinatario);
            csDestinatario.setString(1, destinatarioNombre);
            csDestinatario.setString(2, destinatarioCedula);
            csDestinatario.setString(3, destinatarioEmail);
            csDestinatario.setString(4, destinatarioTelefono);
            csDestinatario.setString(5, destinatarioHoraRetiro);
            csDestinatario.registerOutParameter(6, Types.INTEGER);
            csDestinatario.executeUpdate();
            int destinatarioId = csDestinatario.getInt(6);

            // Insertar paquete
            String sqlPaquete = "{call insertar_paquete(?, ?, ?, ?, ?, ?, ?)}";
            csPaquete = con.prepareCall(sqlPaquete);
            csPaquete.setString(1, paqueteDescripcion);
            csPaquete.setString(2, paqueteEspecificaciones);
            csPaquete.setString(3, paqueteDireccionRetiro);
            csPaquete.setString(4, paqueteDireccionEntrega);
            csPaquete.setInt(5, remitenteId);
            csPaquete.setInt(6, destinatarioId);
            csPaquete.registerOutParameter(7, Types.INTEGER);
            csPaquete.executeUpdate();
            int paqueteId = csPaquete.getInt(7);

            message = "¡Información guardada exitosamente!";
            success = true;
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            message = "Error: Driver JDBC no encontrado.";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Error al guardar la información en la base de datos: " + e.getMessage();
        } finally {
            if (csRemitente != null) try {
                csRemitente.close();
            } catch (SQLException ignore) {
            }
            if (csDestinatario != null) try {
                csDestinatario.close();
            } catch (SQLException ignore) {
            }
            if (csPaquete != null) try {
                csPaquete.close();
            } catch (SQLException ignore) {
            }
            if (con != null) try {
                con.close();
            } catch (SQLException ignore) {
            }
        }
    %>
    <p class="<%= success ? "success" : "error" %>"><%= message %>
    </p>
    <script>
        setTimeout(function () {
            window.location.href = 'Pantalla_Cliente.html';
        }, 2000);
    </script>
</div>
</body>
</html>
