<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="modelo.conexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet" %>
    <!DOCTYPE html>
    <html lang="en">

    <!--HEAD-->
    <%@include file="../components/head.jsp" %> 
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
            <%@include file="../components/navbar.jsp" %>
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
                        <div class="row">
                            <div class="col-md-3">
                                <div class="panel panel-warning panel-colorful media middle pad-all">
                                    <div class="media-left">
                                        <div class="pad-hor">
                                            <i class="fa fa-file-text"></i>
                                        </div>
                                    </div>
                                    <div class="media-body">
                                        <% 
                                            
                                            String sql = "SELECT COUNT(*) as 'total_habitaciones' FROM habitaciones";
                                            Statement st = con.createStatement(); 
                                            ResultSet rs = st.executeQuery(sql);
                                            String n_habiTotales;
                                            while (rs.next()){
                                                n_habiTotales = rs.getString("total_habitaciones");
                                                
                                        %>
                                        <p class="text-2x mar-no text-semibold"><%=n_habiTotales %></p>
                                        <%}%>
                                        <p class="mar-no">Habitaciones totales</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="panel panel-info panel-colorful media middle pad-all">
                                    <div class="media-left">
                                        <div class="pad-hor">
                                            <i class="fa fa-laptop"></i>
                                        </div>
                                    </div>
                                    <div class="media-body">
                                        <% 
                                            sql = "SELECT COUNT(*) as 'totalDisponibles' FROM `habitaciones` WHERE IdEstadoHabitacion = 1"; 
                                            rs = st.executeQuery(sql);
                                            String n_habiDisponibles;
                                            while(rs.next()){
                                                n_habiDisponibles = rs.getString("totalDisponibles");
                                        %>
                                        <p class="text-2x mar-no text-semibold"><%=n_habiDisponibles%></p>
                                        <%}%>
                                        <p class="mar-no">Habitaciones disponibles</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="panel panel-mint panel-colorful media middle pad-all">
                                    <div class="media-left">
                                        <div class="pad-hor">
                                            <i class="fa fa-hotel"></i>
                                        </div>
                                    </div>
                                    <div class="media-body">
                                        <% 
                                            sql = "SELECT COUNT(*) as 'totalOcupadas' FROM `habitaciones` WHERE IdEstadoHabitacion = 2"; 
                                            rs = st.executeQuery(sql);
                                            String n_habiOcupadas;
                                            while(rs.next()){
                                                n_habiOcupadas = rs.getString("totalOcupadas");
                                        %>
                                        <p class="text-2x mar-no text-semibold"><%=n_habiOcupadas%></p>
                                        <%}%>
                                        <p class="mar-no">Habitaciones ocupadas</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="panel panel-purple panel-colorful media middle pad-all">
                                    <div class="media-left">
                                        <div class="pad-hor">
                                            <i class="fa fa-shower"></i>
                                        </div>
                                    </div>
                                    <div class="media-body">
                                        <% 
                                            sql = "SELECT COUNT(*) as 'totalLimpieza' FROM `habitaciones` WHERE IdEstadoHabitacion = 3"; 
                                            rs = st.executeQuery(sql);
                                            String n_habiLimpieza;
                                            while(rs.next()){
                                                n_habiLimpieza = rs.getString("totalLimpieza");
                                        %>
                                        <p class="text-2x mar-no text-semibold"><%= n_habiLimpieza %></p>
                                        <%}%>
                                        <p class="mar-no">Habitaciones en limpieza</p>
                                    </div>
                                </div>
                            </div>
            
                        </div>
            
                    </div>
                    <!--===================================================-->
                    <!--End page content-->

                </div>
                <!--===================================================-->
                <!--END CONTENT CONTAINER-->

                <!--MAIN NAVIGATION (MENÚ)-->
                <%@include file="../components/menu.jsp" %>
                <!--===================================================-->
                <!--END MAIN NAVIGATION-->
               

            </div>



            <!-- FOOTER -->
            <!--===================================================-->
            <%@include file="../components/footer.jsp" %>
            <!--===================================================-->
            <!-- END FOOTER -->


            <!-- SCROLL PAGE BUTTON -->
            <!--===================================================-->
            <button class="scroll-top btn">
                <i class="pci-chevron chevron-up"></i>
            </button>
            <!--===================================================-->
        </div>
        <!--===================================================-->
        <!-- END OF CONTAINER -->
        
        <script>
            activePage("sec_dashboard");
        </script>

    </body>

    </html>