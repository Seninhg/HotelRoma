
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>Sistema-HotelRoma</title>


    <!--STYLESHEET-->
    <!--=================================================-->

    <!--Open Sans Font [ OPTIONAL ]-->
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,300,600,700' rel='stylesheet' type='text/css'>


    <!--Bootstrap Stylesheet [ REQUIRED ]-->
    <link href="/HotelRoma/css/bootstrap.min.css" rel="stylesheet">


    <!--Nifty Stylesheet [ REQUIRED ]-->
    <link href="/HotelRoma/css/nifty.min.css" rel="stylesheet">

    <!--Nifty Premium Icon [ DEMONSTRATION ]-->
    <link href="/HotelRoma/css\demo\nifty-demo-icons.min.css" rel="stylesheet">

    <!--Estilos css propios-->
    <link rel="stylesheet" href="/HotelRoma/css/style.css">

    <!--Font Awesome [ OPTIONAL ]-->
    <link href="/HotelRoma/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet">

    <!--iON ICONS -->
    <link rel="stylesheet" href="/HotelRoma/plugins/ionicons/css/ionicons.min.css">
    
    <!--ALERTAS CON MEJOR DISEÑO (Sweetalert2)-->
    <script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>


    <!--=================================================

REQUIRED
You must include this in your project.


RECOMMENDED
This category must be included but you may modify which plugins or components which should be included in your project.


OPTIONAL
Optional plugins. You may choose whether to include it in your project or not.


DEMONSTRATION
This is to be removed, used forÂ demonstration purposes only.Â This category must not be included in your project.


SAMPLE
Some script samples which explain how to initialize plugins or components. This category should not be included in your project.


Detailed information and more samples can be found in the document.

=================================================-->

</head>


<%
    if(session.getAttribute("nombre") == null){ %>
    <script>
        alert("Sesión no iniciada, se redirigirá a inicio");
        location.href = "/HotelRoma/";
    </script>
<%        
    }
%>