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
            String idhabitacion = request.getParameter("idhabitacion");
            
            String sql = "SELECT IdHabitacion, Precio, Numero as 'numero', Detalle, c.Descripcion as 'categoria', e.Descripcion as 'estado' FROM `habitaciones` h INNER JOIN `categoria` c ON h.IdCategoria = c.IdCategoria INNER JOIN `estado_habitacion` e ON h.IdEstadoHabitacion = e.IdEstadoHabitacion WHERE idhabitacion = '" + idhabitacion + "'";
            
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
            sql = "SELECT * FROM recepcion r INNER JOIN clientes c ON r.IdCliente = c.idCliente WHERE r.IdHabitacion = " + idhabitacion;
            st = con.createStatement();
            ResultSet recep_client = st.executeQuery(sql);
            
            String clientName = null, documento = null, correo = null, fechaEntrada = null;
            String precioInicial = null, adelanto = null, precioRestante = null, fechaSalida = null;
            String idRecepcion = null;
            
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
            }
            
            //damos formato legible a las fechas
            SetFormat setFormat = new SetFormat();
            fechaEntrada = setFormat.formatDate(fechaEntrada);
            fechaSalida = setFormat.formatDate(fechaSalida);
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
                        <!--DETALLES DE VENTAS-->
                        <div class="row">
                            <div class="col-sm-12">
                                <!--Panel with Header-->
                                <!--===================================================-->
                                <div class="panel">
                                    <div class="panel-heading">
                                        <h3 class="panel-title">Detalles de la venta</h3>
                                    </div>
                                    <div class="panel-body">
                                        <div class="block-rows">
                                            <!--Detalles VENTA-->
                                            <div class="row-element">
                                                <div class="col-sm-3" style="align-self:auto;">
                                                    <p class="text-bold">Producto: </p>
                                                    <div class="btn-group btn-block  btn-group-lg">
                                                        <div class="dropdown" style="align-self: top;">
                                                            <button class="btn btn-default btn-block dropdown-toggle" data-toggle="dropdown" type="button" aria-expanded="false" id="btn_selectProduct"> Productos <i class="dropdown-caret"></i>
                                                            </button>
                                                            <ul class="dropdown-menu dropdown-menu-lg" id="drop_products">
                                                                <!-- <li class="active"><a href="#">Semen</a></li> -->
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-3">
                                                    <p class="text-bold">Precio: </p>
                                                    <div class="well well-xs" id="precio_input"><%=adelanto%></div>
                                                </div>
                                                <div class="col-sm-3">
                                                    <p class="text-bold">Cantidad: </p>
                                                    <input type="text" placeholder="Cantidad..." class="form-control" id="cantidad_input">
                                                </div>
                                                <div class="col-sm-3" style="align-self: center;">
                                                    <button class="btn btn-block btn-success" id="btn_addReg">Agregar</button>
                                                </div>
                                            </div>
                                        </div>
                                        <!--TABLA DE VENTAS-->
                                        <table class="table table-hover table-bordered">
                                            <thead class="thead-dark">
                                              <tr>
                                                <th scope="col"></th>
                                                <th scope="col">Producto</th>
                                                <th scope="col">Cantidad</th>
                                                <th scope="col">Precio Unitario</th>
                                                <th scope="col">Sub Total</th>
                                              </tr>
                                            </thead>
                                            <tbody class="table-group-divider" id="registerTable">
                                            </tbody>
                                        </table>
                                        <!--Bloque de total a pagar-->
                                        <div class="block-rows">
                                            <div class="row-element" style="justify-content: flex-end;">
                                                <div class="col-sm-3">
                                                    <p class="text-bold">Total pagar: </p>
                                                    <div class="well well-xs" id="totalPagar_out">0</div>
                                                </div>
                                            </div>
                                        </div>


                                        <!--DROPBOX PARA SELECCIONAR ESTADOs-->
                                        <div class="block-rows">
                                            <!--Detalles VENTA-->
                                            <div class="rowGroup-right">
                                                <div class="btn-group dropdown dropup">
                                                    <button class="btn btn-default btn-active-purple">Estado venta</button>
                                                    <button class="btn btn-default btn-active-purple dropdown-toggle dropdown-toggle-icon" data-toggle="dropdown" type="button" id="btn_selectStatus">
                                                        Pendiente
                                                        <i class="dropdown-caret caret-up"></i>
                                                    </button>
                                                    <ul class="dropdown-menu" id="drop_status">
                                                        <li id-status="cancelado"><a href="#" >Cancelado</a></li>
                                                        <li id-status="pendiente"><a href="#" >Pendiente</a></li>
                                                    </ul>
                                                </div>
                                                <div class="col-sm-3" style="align-self: center;">
                                                    <button class="btn btn-block btn-purple" id="btn_regVenta">Finalizar venta</button>
                                                </div>
                                            </div>
                                        </div>

                                    </div><!--End panel body-->
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
            activePage("sec_tienda", "subsec_vender");
            const idRecepcion = "<%=idRecepcion%>"; //forma sucia de obtener el id de la recepción, pero funciona ._.
        </script>
        <script src="./script.js"></script>

    </body>
    
    </html>