<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>

<%
    String id = request.getParameter("id");
    String nombreRemitente = "", apellidoRemitente = "", cedulaRemitente = "", correoRemitente = "", telefonoRemitente = "";
    String nombreDestinatario = "", apellidoDestinatario = "", cedulaDestinatario = "", correoDestinatario = "", telefonoDestinatario = "";
    String descripcionPaquete = "", especificacionPaquete = "", direccionRetiro = "", direccionEntrega = "", horaRetiro = "";

    if (id != null && !id.isEmpty()) {
        Connection conexionBD = null;
        Statement instruccion = null;
        ResultSet resultado = null;
        try {
            // Cargar el controlador
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Conexión a la base de datos
            conexionBD = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "usuarioDB", "contrasenaDB");

            // Consultar datos del remitente
            String queryRemitente = "SELECT Nombre, Cedula, Correo_electronico, Telefono FROM remitente WHERE ID = " + id;
            instruccion = conexionBD.createStatement();
            resultado = instruccion.executeQuery(queryRemitente);

            if (resultado.next()) {
                nombreRemitente = resultado.getString("Nombre");
                cedulaRemitente = resultado.getString("Cedula");
                correoRemitente = resultado.getString("Correo_electronico");
                telefonoRemitente = resultado.getString("Telefono");
            }

            // Consultar datos del destinatario
            String queryDestinatario = "SELECT Nombre, Cedula, Correo_electronico, Telefono, Hora_Retiro FROM destinatario WHERE ID = " + id;
            resultado = instruccion.executeQuery(queryDestinatario);

            if (resultado.next()) {
                nombreDestinatario = resultado.getString("Nombre");
                cedulaDestinatario = resultado.getString("Cedula");
                correoDestinatario = resultado.getString("Correo_electronico");
                telefonoDestinatario = resultado.getString("Telefono");
                horaRetiro = resultado.getString("Hora_Retiro");
            }

            // Consultar datos del paquete
            String queryPaquete = "SELECT Descripcion, Especificaciones, Direccion_Retiro, Direccion_Entrega FROM paquete WHERE ID = " + id;
            resultado = instruccion.executeQuery(queryPaquete);

            if (resultado.next()) {
                descripcionPaquete = resultado.getString("Descripcion");
                especificacionPaquete = resultado.getString("Especificaciones");
                direccionRetiro = resultado.getString("Direccion_Retiro");
                direccionEntrega = resultado.getString("Direccion_Entrega");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Cerrar los recursos
            try {
                if (resultado != null) resultado.close();
                if (instruccion != null) instruccion.close();
                if (conexionBD != null) conexionBD.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=K2D:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <title>Tables</title>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow-x: hidden;
        }

        body {
            font-family: 'K2D', sans-serif;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            box-sizing: border-box;
            align-items: center;
        }

        #encabezado, .footer-container {
            width: 100%;
        }

        #encabezado {
            background-color: #002D54;
            color: white;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            justify-content: space-between;
            box-sizing: border-box;
        }

        #logo {
            display: block;
        }

        .iconos {
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

        .content {
            width: 100%;
            max-width: 1200px;
            padding: 20px;
            box-sizing: border-box;
        }

        .table-container {
            width: 100%;
            margin-bottom: 20px;
        }

        h2 {
            margin: 0 0 10px 0;
            padding: 0;
            text-align: left;
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
        }

        table {
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
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

        .footer-container {
            background-color: #002d54;
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-around;
            box-sizing: border-box;
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

        /* Estilos de los botones */
        .boton {
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
            margin-right: 10px;
        }

        /* Estilos específicos para el botón "Rechazar" */
        .boton-rechazar {
            background-color: #FF5733; /* Color rojo */
            color: white;
        }

        /* Estilos específicos para el botón "Aceptar" */
        .boton-aceptar {
            background-color: #4CAF50; /* Color verde */
            color: white;
        }

        /* Estilos para centrar los botones y agregar padding */
        #botones-container {
            display: flex;
            justify-content: center;
            padding: 20px;
        }

        /* Estilos para el cuadro de diálogo */
        .dialogo {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            padding: 20px;
            border: 1px solid #ddd;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }

        .dialogo textarea {
            width: 400px;
            height: 350px;
            margin-bottom: 10px;
        }

        .dialogo select {
            width: 100%;
            margin-bottom: 10px;
        }

        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }

        #logo img{
            width: 200px;
            height: auto;
        }
    </style>
</head>
<body>
<section id="encabezado">
    <div id="logo">
        <img src="img/Logo.png" >
    </div>
    <div class="iconos">
        <i class="fas fa-bell"></i>
        <i class="fas fa-user"></i>
        <i class="fas fa-cog"></i>
    </div>
</section>

<div class="content">
    <!-- Table: Informacion del remitente -->
    <div class="table-container">
        <h2>Información del Remitente</h2>
        <table>
            <thead>
            <tr>
                <th>Nombre Completo</th>
                <th>Cédula</th>
                <th>Correo</th>
                <th>Teléfono</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td><%= nombreRemitente %> <%= apellidoRemitente %></td>
                <td><%= cedulaRemitente %></td>
                <td><%= correoRemitente %></td>
                <td><%= telefonoRemitente %></td>
            </tr>
            </tbody>
        </table>
    </div>

    <!-- Table: Informacion del destinatario -->
    <div class="table-container">
        <h2>Información del Destinatario</h2>
        <table>
            <thead>
            <tr>
                <th>Nombre Completo</th>
                <th>Cédula</th>
                <th>Correo</th>
                <th>Teléfono</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td><%= nombreDestinatario %> <%= apellidoDestinatario %></td>
                <td><%= cedulaDestinatario %></td>
                <td><%= correoDestinatario %></td>
                <td><%= telefonoDestinatario %></td>
            </tr>
            </tbody>
        </table>
    </div>

    <!-- Table: Informacion del envio -->
    <div class="table-container">
        <h2>Información del Envío</h2>
        <table>
            <thead>
            <tr>
                <th>Descripción del Paquete</th>
                <th>Especificaciones</th>
                <th>Dirección de Retiro</th>
                <th>Dirección de Entrega</th>
                <th>Hora de Retiro</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td><%= descripcionPaquete %></td>
                <td><%= especificacionPaquete %></td>
                <td><%= direccionRetiro %></td>
                <td><%= direccionEntrega %></td>
                <td><%= horaRetiro %></td>
            </tr>
            </tbody>
        </table>
    </div>
</div>

<section id="botones-container">
    <!-- Botón Rechazar -->
    <button class="boton boton-rechazar" onclick="mostrarDialogo('rechazo')">Rechazar</button>

    <!-- Botón Aceptar -->
    <button class="boton boton-aceptar" onclick="mostrarDialogo('aceptar')">Aceptar</button>
</section>

<!-- Cuadro de diálogo para rechazo -->
<div id="dialogo-rechazo" class="dialogo">
    <h3>Motivo del Rechazo</h3>
    <textarea id="motivo-rechazo" placeholder="Escribe el motivo del rechazo..."></textarea>
    <button class="boton boton-rechazar" onclick="enviarRechazo()">Enviar</button>
    <button class="boton" onclick="cerrarDialogo()">Cancelar</button>
</div>

<!-- Cuadro de diálogo para aceptación -->
<div id="dialogo-aceptar" class="dialogo">
    <h3>Asignar Repartidor</h3>
    <select id="repartidor-select">
        <option value="repartidor1">Repartidor 1</option>
        <option value="repartidor2">Repartidor 2</option>
        <option value="repartidor3">Repartidor 3</option>
        <!-- Agrega más opciones según sea necesario -->
    </select>
    <button class="boton boton-aceptar" onclick="asignarRepartidor()">Asignar</button>
    <button class="boton" onclick="cerrarDialogo()">Cancelar</button>
</div>

<!-- Overlay para el fondo oscuro -->
<div id="overlay" class="overlay"></div>

<script>
    function mostrarDialogo(tipo) {
        document.getElementById('overlay').style.display = 'block';
        if (tipo === 'rechazo') {
            document.getElementById('dialogo-rechazo').style.display = 'block';
        } else if (tipo === 'aceptar') {
            document.getElementById('dialogo-aceptar').style.display = 'block';
        }
    }

    function cerrarDialogo() {
        document.getElementById('overlay').style.display = 'none';
        document.getElementById('dialogo-rechazo').style.display = 'none';
        document.getElementById('dialogo-aceptar').style.display = 'none';
    }

    function enviarRechazo() {
        const motivo = document.getElementById('motivo-rechazo').value;
        if (motivo) {
            alert('Motivo de rechazo enviado: ' + motivo);
            // Aquí puedes agregar la lógica para enviar el motivo de rechazo al servidor
            cerrarDialogo();
        } else {
            alert('Por favor, escribe un motivo de rechazo.');
        }
    }

    function asignarRepartidor() {
        const repartidor = document.getElementById('repartidor-select').value;
        alert('Repartidor asignado: ' + repartidor);
        // Aquí puedes agregar la lógica para asignar el repartidor al servidor
        cerrarDialogo();
    }
</script>

</body>
<footer class="footer-container">
    <div class="footer-section">
        <h2 class="footer-heading">SUCURSALES</h2>
        <ul class="branch-schedule">
            <li class="schedule-item">El Dorado: lunes a viernes: 8:00 am - 8:00 pm</li>
            <li class="schedule-item">Sábado: 8:00 am - 6:00 pm</li>
            <li class="schedule-item">Nuevo Tocumen: lunes a viernes: 9:30 am - 5:00 pm</li>
            <li class="schedule-item">Sábado: 10:00 am - 4:00 pm</li>
            <li class="schedule-item">Arraiján: lunes a viernes: 9:30 am - 6:00 pm</li>
            <li class="schedule-item">Sábado: 9:30 am - 4:00 pm</li>
        </ul>
    </div>
    <div class="footer-section">
        <h2 class="footer-heading">CONTACTO</h2>
        <ul class="contact-info">
            <li class="contact-item">El Dorado: XXXX-XXXX</li>
            <li class="contact-item">Arraiján: XXXX-XXXX</li>
            <li class="contact-item">Nuevo Tocumen: XXXX-XXXX</li>
        </ul>
        <div class="social-icons">
            <a href="#" class="social-icon"><img src="img/tik_tok@512px.png" alt="TikTok"></a>
            <a href="#" class="social-icon"><img src="img/linkedin@512px.png" alt="Linkedin"></a>
            <a href="#" class="social-icon"><img src="img/instagram@512px.png" alt="Instagram"></a>
            <a href="#" class="social-icon"><img src="img/facebook@512px.png" alt="Facebook"></a>
        </div>
    </div>
</footer>
</html>
