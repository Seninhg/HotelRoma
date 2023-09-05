
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.conexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login-Admin</title>

    <!--CSS-->
    <link rel="stylesheet" href="./css/login.css">
    <!-- BOOSTRAP -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">

</head>
<body>
    <%
        conexion cc = new conexion();
        Connection con = cc.conectar();
    %>
    <div class="app">
        <div class="cont_principal">
            <div class="logo">
                <img src="./src/images/hotel_logo.jpg" alt="MiHotel_logo">
            </div>
            <div class="login_main">
                <!--Código de boostrap-->
                <h1>Bienvenido</h1>
                <div class="cont_form">
                    <form action="index.jsp" method="post">
                        <div class="mb-4">
                        <label for="exampleInputEmail1" class="form-label">Correo:</label>
                        <input type="email" class="form-control"  name="email" required>
                        </div>
                        <div class="mb-4">
                        <label for="exampleInputPassword1" class="form-label">Contraseña:</label>
                        <input type="password" class="form-control" name="password" required>
                        </div>
                        <div class="mb-4 form-check">
                        <input type="checkbox" class="form-check-input" id="exampleCheck1">
                        <label class="form-check-label" for="exampleCheck1">Guardar sesión</label> <!--No funcional hasta que aprendamos a manejar sesiones--->
                        </div>
                        <div class="text-center btn_cont">
                            <button type="submit" class="btn btn-primary" name="enviar">Login</button>
                        </div>
                    </form>
                    
                    <!--VALIDACIÓN DE DATOS-->
                    <%
                        String userName = null, password = null;
                        int resultado = 0;
                        if(request.getParameter("enviar")!= null){
                            userName = request.getParameter("email");
                            password = request.getParameter("password");
                            
                            
                            String sql = "SELECT * FROM usuarios WHERE Correo = '" + userName + "' AND Clave = '" + password + "'";
                            
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(sql);
                            
                            if(rs.next()){ //si la consulta retorna filas, entonces al menos un usuario cumplió con los datos
                                resultado = 1;
                                session.setAttribute("id", rs.getString("idUsuario"));
                                session.setAttribute("nombre", rs.getString("nombre"));
                                session.setAttribute("apellido_paterno", rs.getString("apell_paterno"));
                                session.setAttribute("apellido_materno", rs.getString("apell_materno"));
                                session.setAttribute("correo", rs.getString("correo"));
                                session.setAttribute("idTipoPersona", rs.getString("idTipoPersona"));
                            }
                            
                            if(resultado != 1){
                               %>
                               <p>El usuario ingresado no es válido</p>
                                <%
                            }
                        }
                        %>
                    
                    <%if(resultado == 1){%>
                    <p>Usuario permitido</p>
                        <script>
                            location.href = "./dashboard/";
                        </script>
                    <%}%>
                </div>
            </div>
        </div>
    </div>
</body>
</html>