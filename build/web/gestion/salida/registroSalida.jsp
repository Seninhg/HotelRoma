<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="modelo.conexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="ownUtils.SetFormat"%>
    <!DOCTYPE html>
    <html lang="en">
    
    <!--HEAD-->
    <%@include file="../../components/head.jsp" %>
        <!--HEAD-->
    
        <!--TIPS-->
        <!--You may remove all ID or Class names which contain "demo-", they are only used for demonstration. -->
    
    <body>
        <% 
            conexion cc=new conexion(); 
            Connection con=cc.conectar(); 
            
            //SE OBTIENE LA HABITACION ACTUAL
            String idHabitacion = request.getParameter("idhabitacion");
            
            String sql = "SELECT IdHabitacion, Precio, Numero as 'numero', Detalle, c.Descripcion as 'categoria', e.Descripcion as 'estado' FROM `habitaciones` h INNER JOIN `categoria` c ON h.IdCategoria = c.IdCategoria INNER JOIN `estado_habitacion` e ON h.IdEstadoHabitacion = e.IdEstadoHabitacion WHERE idhabitacion = '" + idHabitacion + "'";
            
            Statement st = con.createStatement();
            ResultSet habitaciones = st.executeQuery(sql);
            
            String numero = null, detalle = null, categoria = null, precio = null;
            while(habitaciones.next()){
                numero = habitaciones.getString("numero");
                detalle = habitaciones.getString("detalle");
                categoria = habitaciones.getString("categoria");
                precio = habitaciones.getString("Precio");
            }
            
            //SE OBTIENE LA RECEPCION REGISTRADA Y EL CLIENTE DE ONE (CON ID DE HABITACION)
            //mientras más peticiones evitemos mejor será ;)
            sql = "SELECT * FROM recepcion r INNER JOIN clientes c ON r.IdCliente = c.idCliente WHERE r.IdHabitacion = " + idHabitacion;
            st = con.createStatement();
            ResultSet recep_client = st.executeQuery(sql);
            
            String clientName = null, documento = null, correo = null, fechaEntrada = null;
            String precioInicial = null, adelanto = null, precioRestante = null, fechaSalida = null;
            String idRecepcion = null, idCliente = null;
            while(recep_client.next()){
                idRecepcion = recep_client.getString("idRecepcion");
                clientName = recep_client.getString("nombre");
                documento = recep_client.getString("documento");
                correo = recep_client.getString("correo");
                fechaEntrada = recep_client.getString("fechaEntrada");
                precioInicial = recep_client.getString("precioInicial");
                adelanto = recep_client.getString("adelanto");
                precioRestante = recep_client.getString("precioRestante");
                fechaSalida = recep_client.getString("fechaSalida");
                idCliente = recep_client.getString("idCliente");
            }
            
            //damos formato legible a las fechas
            SetFormat setFormat = new SetFormat();
            fechaEntrada = setFormat.formatDate(fechaEntrada);
            fechaSalida = setFormat.formatDate(fechaSalida);
            
            
            float totalPagar = Float.parseFloat(precioRestante);
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
                        <!--Page content-->
                        <!--===================================================-->
                        <div id="page-content">
                            <!--DETALLES HABITACION Y CLIENTE-->
                            <div class="row">
                                <div class="col-sm-12">
                                    <!--Panel with Header-->
                                    <!--===================================================-->
                                    <div class="panel">
                                        <div class="panel-heading">
                                            <h3 class="panel-title">Detalles de la Habitación</h3>
                                        </div>
                                        <div class="panel-body">
                                            <div class="block-rows">
                                                <!--Detalles habitación-->
                                                <div class="row-element">
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Número: </p>
                                                        <p><%=numero%></p>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Detalles: </p>
                                                        <p><%=detalle%></p>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Categoría: </p>
                                                        <p><%=categoria%></p>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Piso: </p>
                                                        <p>1</p>
                                                    </div>
                                                </div>
                                                <!--Detalles cliente-->
                                                <div class="row-element">
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Cliente: </p>
                                                        <p><%=clientName%></p>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Nro. Documento: </p>
                                                        <p><%=documento%></p>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Correo: </p>
                                                        <p><%=correo%></p>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Fecha entrada: </p>
                                                        <p><%=fechaEntrada%></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--===================================================-->
                                    <!--End Panel with Header-->
                                </div>
                            </div>
                            <!--DETALLES DE RECEPCION-->
                            <div class="row">
                                <div class="col-sm-12">
                                    <!--Panel with Header-->
                                    <!--===================================================-->
                                    <div class="panel">
                                        <div class="panel-heading">
                                            <h3 class="panel-title">Detalles de la Recepción</h3>
                                        </div>
                                        <div class="panel-body">
                                            <div class="block-rows">
                                                <!--Detalles habitación-->
                                                <div class="row-element">
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Costo Habitación: </p>
                                                        <div class="well well-xs"><%=precioInicial%></div>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Cantidad Adelanto: </p>
                                                        <div class="well well-xs"><%=adelanto%></div>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Cantidad Restante: </p>
                                                        <div class="well well-xs"><%=precioRestante%></div>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <p class="text-bold">Costo por penalidad: </p>
                                                        <input type="text" class="form-control" id="costoPenalidad_input" value="0">
                                                    </div>
                                                </div>
                                            </div>                                        
                                        </div>
                                    </div>
                                    <!--===================================================-->
                                    <!--End Panel with Header-->
                                </div>
                            </div>
                            <!--TABLA DE PRODUCTOS VENDIDOS-->
                            <div class="row">
                                <div class="col-sm-12">
                                    <!--Panel with Header-->
                                    <!--===================================================-->
                                    <div class="panel">
                                        <div class="panel-heading">
                                            <h3 class="panel-title">Servicio a la habitación</h3>
                                        </div>
                                        <div class="panel-body">
                                            <!--TABLA DE VENTAS-->
                                            <table class="table table-hover table-bordered">
                                                <thead class="thead-dark" >
                                                <tr>
                                                    <th scope="col">Producto</th>
                                                    <th scope="col">Cantidad</th>
                                                    <th scope="col">Precio Unitario</th>
                                                    <th scope="col">Estado de venta</th>
                                                    <th scope="col">Sub Total</th>
                                                </tr>
                                                </thead>
                                                <%
                                                    sql = "SELECT p.nombre, d_v.cantidad, p.precio, v.estado, d_v.subTotal FROM `detalle_venta` d_v INNER JOIN productos p ON d_v.idProducto = p.idProducto INNER JOIN ventas v ON v.idVenta = d_v.idVenta WHERE v.idRecepcion = " + idRecepcion;
                                                    st = con.createStatement();
                                                    ResultSet registros_ventas = st.executeQuery(sql);    
                                                %>
                                                <tbody class="table-group-divider">
                                                    <%while(registros_ventas.next()){%>
                                                        <tr>
                                                            <td><%=registros_ventas.getString("nombre")%></td>
                                                            <td><%=registros_ventas.getString("cantidad")%></td>
                                                            <td><%=registros_ventas.getString("precio")%></td>
                                                            <td>
                                                                <%
                                                                    String estado = registros_ventas.getString("estado");
                                                                    String classBtn = null;
                                                                    if(estado.equals("pendiente")){
                                                                        classBtn = "success";
                                                                        //importante: Ahora se le suma el subTotal de las ventas de cada producto al total a pagar
                                                                        totalPagar += Float.parseFloat(registros_ventas.getString("subTotal"));
                                                                    }else if(estado.equals("cancelado")){
                                                                        classBtn = "danger";
                                                                    }
                                                                %>
                                                                <button class="btn btn-<%=classBtn%>"><%=estado%></button>
                                                            </td>
                                                            <td><%=registros_ventas.getString("subTotal")%></td>
                                                        </tr>
                                                    <%}%>
                                                </tbody>
                                            </table>

                                            
                                            <!--DROPBOX PARA SELECCIONAR ESTADOs-->
                                            <div class="block-rows">
                                                <div class="rowGroup-right">
                                                    <!--Bloque de total a pagar-->
                                                    <div class="block-rows col-sm-6">
                                                        <div class="row-element" style="justify-content: flex-end;">
                                                            <div class="col-sm-3">
                                                                <p class="text-bold">Total pagar: </p>
                                                                <div class="well well-xs" id="totalPagar_out"><%=totalPagar%></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-3" style="align-self: center;">
                                                        <button class="btn btn-block btn-purple" id="btn_regSalida">Registrar salida</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--===================================================-->
                                    <!--End Panel with Header-->
                                </div>
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

            const idRecepcion = "<%=idRecepcion%>";
            const idCliente = "<%=idCliente%>";
            const idHabitacion = "<%=idHabitacion%>";

            let totalPagar = parseFloat("<%=totalPagar%>");

            const totalPagar_out = document.getElementById("totalPagar_out");
            function updateTotalPagar(monto){
                totalPagar_out.textContent = parseFloat(monto);
            }
            updateTotalPagar(totalPagar);            

        </script>
        <script src="./script.js"></script>

    </body>
    
    </html>