<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="modelo.conexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet" %>
    <!DOCTYPE html>
    <html lang="en">

    <!--HEAD-->
    <%@include file= "../../components/head.jsp"%> 
    <head>
        <link rel="stylesheet" href="./recepStyle.css">
    </head>
    <!--HEAD-->
    
    <!--TIPS-->
    <!--You may remove all ID or Class names which contain "demo-", they are only used for demonstration. -->

    <body>
        <%
            conexion cc = new conexion();
            Connection con = cc.conectar();
        %>
        <div id="container" class="effect aside-float aside-bright mainnav-lg">

            <!--NAVBAR-->
            <!--===================================================-->
            <%@include file="../../components/navbar.jsp" %>
            <!--===================================================-->
            <!--END NAVBAR-->

            <div class="boxed">

                <!--CONTENT CONTAINER-->
                <!--===================================================-->
                <div id="content-container">
                    <!-- <div id="page-head">

                        <div class="pad-all text-center">
                            <h3>Welcome back to the Dashboard.</h3>
                            <p1>Scroll down to see quick links and overviews of your Server, To do list, Order status or
                                get
                                some Help using Nifty.<p>
                            </p1>
                        </div>
                    </div>  -->


                    <!--Page content-->
                    <!--===================================================-->
                    <div id="page-content">    
                        <div class="rooms-cont">
                            <!--
                                Básicamente las variables aquí son los íconos:
                                campana = fa fa-bell
                                cama = fa fa-bed
                                
                            -->
                            <!--EJEMPLO DE TARJETA DE HABITACIÓN
                            <div class="target-room">
                                <div class="info-cont">
                                    <div class="info-text">
                                        <p class="target-principal">NRO: 001</p>
                                        <p class="target-secundary">CATEGORIA: INDIVIDUAL</p>
                                    </div>
                                    <div class="icon-cont">
                                        <i class="fa fa-bell"></i>
                                    </div>
                                </div>
                                <a href="#">
                                <div class="status-cont disponible">
                                    <p>DISPONIBLE</p>
                                    <i class="fa fa-caret-right"></i>
                                </div>
                                </a>
                            </div>
                            -->
                            
                            <%
                                String sql = "SELECT h.IdHabitacion, h.Numero as 'numero', ctg.Descripcion as 'categoria' FROM habitaciones h INNER JOIN categoria ctg ON h.IdCategoria = ctg.IdCategoria WHERE h.IdEstadoHabitacion = 2";
                                Statement st = con.createStatement();
                                ResultSet habitaciones = st.executeQuery(sql);
                                
                                while(habitaciones.next()){
                            %>
                            <!--INSERTADO DINAMICAMENTE-->
                            <div class="target-room">
                                <div class="info-cont">
                                    <div class="info-text">
                                        <p class="target-principal">NRO: <%=habitaciones.getString("numero") %></p>
                                        <p class="target-secundary">CATEGORIA: <%=habitaciones.getString("categoria")%></p>
                                    </div>
                                    <div class="icon-cont">
                                        <i class="fa fa-bed"></i>
                                    </div>
                                </div>
                                <a href=<%="./venta.jsp?idhabitacion=" + habitaciones.getString("idHabitacion")%>>
                                    <div class="status-cont ventaBg">
                                        <p>Vender</p>
                                        <i class="fa fa-caret-right"></i>
                                    </div>
                                </a>
                            </div>
                            <%}%>


                        </div>
                    </div>
                    <!--===================================================-->
                    <!--End page content-->

                </div>
                <!--===================================================-->
                <!--END CONTENT CONTAINER-->

                <!--MAIN NAVIGATION (MENÚ)-->
                <%@include file="../../components/menu.jsp" %>
                <!--===================================================-->
                <!--END MAIN NAVIGATION-->
               

            </div>



            <!-- FOOTER -->
            <!--===================================================-->
            <%@include file="../../components/footer.jsp" %>
            <!--===================================================-->
            <!-- END FOOTER -->

        </div>
        <!--===================================================-->
        <!-- END OF CONTAINER -->


        <script>
            //Código desesperado para secciones del menú dinámicas
            activePage("sec_tienda", "subsec_vender");
        </script>

    </body>

    </html>