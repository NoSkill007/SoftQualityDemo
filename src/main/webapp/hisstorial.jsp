<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=K2D:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <title>Inicio Recepcionista</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            font-family: 'K2D', sans-serif;
            margin: 0;
        }

        main {
            flex: 1;
        }

        .table-container {
            width: 80%;
            margin: 0 auto;
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        #solicitud_envio {
            padding: 10px;
        }

        .opciones {
            background-color: #E4A92F;
            padding: 10px;
            color: white;
            height: 25px;
            border-radius: 25px;
            text-align: center;
            cursor: pointer;
            width: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .opciones:hover {
            background-color: #9fc4e6;
            color: rgb(255, 255, 255);
        }

        #encabezado {
            background-color: #002D54;
            color: white;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            position: relative;
            justify-content: flex-start;
        }

        #logo img {
            width: 200px;
            height: auto;
        }

        .iconos {
            margin-left: auto;
            display: flex;
            gap: 15px;
        }

        .iconos i {
            color: white;
            font-size: 24px;
            cursor: pointer;
        }

        .iconos i:hover {
            color: #E4A92F;
        }

        .footer-container {
            background-color: #002d54;
            color: white;
            padding: 20px 20px;
            display: flex;
            justify-content: space-around;
        }

        .footer-section {
            margin: 0 50px;
        }

        .footer-heading {
            border-bottom: 1px solid #aaa;
            padding-bottom: 5px;
        }

        .branch-schedule,
        .contact-info {
            list-style-type: none;
            padding: 0;
        }

        .schedule-item,
        .contact-item {
            margin-bottom: 5px;
        }

        .social-icon {
            text-align: left;
            margin: 0 5px;
        }

        .social-icon img {
            width: 25px;
            height: 25px;
        }

    </style>
</head>
<body>
<header id="encabezado">
    <div id="logo">
        <img src="img/Logo.png" alt="Logo">
    </div>
    <div class="iconos">
        <i class="fas fa-bell"></i>
        <i class="fas fa-user"></i>
        <i class="fas fa-cog"></i>
    </div>
</header>

<main>
    <section>
        <div id="solicitud_envio">
            <h2>Solicitudes de envio</h2>
        </div>

        <div id="solicitud_envio" class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Numero de solicitud</th>
                    <th>Fecha de envio</th>
                    <th>Destino</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>

                <%
                    Connection conexionBD = null;
                    Statement instruccion = null;
                    ResultSet resultado = null;

                    try {
                        // Cargar el controlador
                        Class.forName("oracle.jdbc.driver.OracleDriver");

                        // Conexión a la base de datos
                        conexionBD = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "usuarioDB", "contrasenaDB");

                        // Consulta que trae todos los registros de la tabla paquete y formatea la fecha
                        String query = "SELECT ID, TO_CHAR(fecha, 'YYYY-MM-DD') AS fecha, DIRECCION_ENTREGA FROM paquete";
                        instruccion = conexionBD.createStatement();
                        resultado = instruccion.executeQuery(query);

                        // Si existen registros se ejecutan
                        while (resultado.next()) {
                            String numeroSolicitud = resultado.getString("ID");
                            String fechaEnvio = resultado.getString("fecha");
                            String direccion = resultado.getString("DIRECCION_ENTREGA");
                %>
                <tr>
                    <td><%= numeroSolicitud %></td>
                    <td><%= fechaEnvio %></td>
                    <td><%= direccion %></td>
                    <td><a href="detalles.jsp?id=<%= numeroSolicitud %>">Ver detalles</a></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (resultado != null) resultado.close();
                            if (instruccion != null) instruccion.close();
                            if (conexionBD != null) conexionBD.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
                </tbody>
            </table>
        </div>


    </section>
</main>

<!-- Footer con la información de la empresa -->
<footer class="footer-container">
    <div class="footer-section">
        <h2 class="footer-heading">SUCURSALES</h2>
        <ul class="branch-schedule">
            <li class="schedule-item">El dorado: lunes a viernes: 8:00 am - 8:00 pm</li>
            <li class="schedule-item">sábado: 8:00 am - 6:00 pm</li>
            <li class="schedule-item">Nuevo tocumen: lunes a viernes: 9:30 am - 5:00 pm</li>
            <li class="schedule-item">sábado: 10:00 am - 4:00 pm</li>
            <li class="schedule-item">Arraiján: lunes a viernes: 9:30 am - 6:00 pm</li>
            <li class="schedule-item">sábado: 9:30 am - 4:00 pm</li>
        </ul>
    </div>
    <div class="footer-section">
        <h2 class="footer-heading">CONTACTO</h2>
        <ul class="contact-info">
            <li class="contact-item">El dorado: XXXX-XXXX</li>
            <li class="contact-item">Arraijan: XXXX-XXXX</li>
            <li class="contact-item">Nuevo tocumen: XXXX-XXXX</li>
        </ul>
        <div class="social-icons">
            <a href="#" class="social-icon"><img src="img/tik_tok@512px.png" alt="TikTok"></a>
            <a href="#" class="social-icon"><img src="img/linkedin@512px.png" alt="Linkedin"></a>
            <a href="#" class="social-icon"><img src="img/instagram@512px.png" alt="Instagram"></a>
            <a href="#" class="social-icon"><img src="img/facebook@512px.png" alt="Facebook"></a>
        </div>
    </div>
</footer>
</body>
</html>
