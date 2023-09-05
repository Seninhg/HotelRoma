<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="modelo.conexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet" %>
    <!DOCTYPE html>
    <html lang="en">

    <!--HEAD-->
    <%@include file= "../../components/head.jsp"%> 
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
                                String sql = "SELECT IdHabitacion, Numero as 'numero', c.Descripcion as 'categoria', e.Descripcion as 'estado' FROM `habitaciones` h INNER JOIN `categoria` c ON h.IdCategoria = c.IdCategoria INNER JOIN `estado_habitacion` e ON h.IdEstadoHabitacion = e.IdEstadoHabitacion";
                                Statement st = con.createStatement();
                                ResultSet habitaciones = st.executeQuery(sql);
                                
                                while(habitaciones.next()){
                            %>
                            <!--INSERTADO DINAMICAMENTE-->
                            <div class="target-room">
                                <div class="info-cont">
                                    <div class="info-text">
                                        <p class="target-principal"><%=habitaciones.getString("numero") %></p>
                                        <p class="target-secundary">CATEGORIA: <%=habitaciones.getString("categoria")%></p>
                                    </div>
                                    <div class="icon-cont">
                                        <%
                                            String pageRedirect = "#";
                                            if(habitaciones.getString("estado").equals("DISPONIBLE")){
                                                pageRedirect = "./registroRecepcion.jsp";
                                         %>
                                                <i class="fa fa-bell"></i>
                                           <%
                                                }else if(habitaciones.getString("estado").equals("OCUPADO")){
                                                pageRedirect = "./detalleRecepcion.jsp";
                                           %>
                                                    <i class="fa fa-bed"></i>
                                            <%
                                            }else if(habitaciones.getString("estado") .equals("LIMPIEZA")){
                                                pageRedirect = "#targetCleaned";
                                            %>
                                                <img src="/HotelRoma/src/images/icons/escoba.png" width="40px"/>
                                            <%}%>
                                    </div>
                                </div>
                                <a href=<%=pageRedirect + "?idhabitacion=" + habitaciones.getString("idHabitacion")%>>
                                    <div class="<%="status-cont " +  (habitaciones.getString("estado").toLowerCase())%>">
                                        <p><%=habitaciones.getString("estado") %></p>
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
            activePage("sec_gestion", "subsec_recepcion");

            window.onhashchange = ()=>{
                const url = window.location.hash;
                if(url.includes("#targetCleaned")){
                    const queryParam = url.split("?")[1];
                    let idHabitacion = new URLSearchParams(queryParam).get("idhabitacion");
                    
                    Swal.fire({
                        title: '¿Deseas confirmar como concluida la limpieza  de la habitación?',
                        showCancelButton: true,
                        confirmButtonText: 'Aceptar',
                        denyButtonText: `Cancelar`,
                        width: "30%",                        
                        }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.isConfirmed) {
                            const sql = `UPDATE habitaciones SET IdEstadoHabitacion = 1 WHERE IdHabitacion = ` + idHabitacion;
                            const formData = new FormData();
                            formData.append("sqlQuery", sql);


                            fetch("/HotelRoma/updateReg", {
                                method: "POST",
                                body: (new URLSearchParams(formData))
                            }).then(async (response)=>{
                                let res = JSON.parse(await response.text());
                                
                                if(res.status == "success"){
                                    Swal.fire('Estado de habitación actualizado!', '', 'success').then(()=>{
                                        window.location.reload();
                                    })
                                }else{
                                    Swal.fire("Hubo un error", '', 'error').then(()=>{
                                        window.location.hash = "#";
                                    })
                                }
                                
                            })
                            
                        } else{
                            window.location.hash = "#";
                        }
                    })
                }
            }
        </script>

    </body>

    </html>
