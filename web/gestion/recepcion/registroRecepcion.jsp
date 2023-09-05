<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="modelo.conexion"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.ResultSet" %>
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
                            <div class="detalles_habitacion row">
                                <div class="col-sm-12">
                                    <!--Panel with Header-->
                                    <!--===================================================-->
                                    <div class="panel">
                                        <div class="panel-heading">
                                            <h3 class="panel-title">Detalles de la Habitación</h3>
                                        </div>
                                        <div class="panel-body">
                                            <div class="block-rows">
                                                <div class="col-sm-6">
                                                    <div class="row-element">
                                                        <p class="text-bold">Número: </p>
                                                        <p><%=numero%></p>
                                                    </div>
                                                    <div class="row-element">
                                                        <p class="text-bold">Detalle: </p>
                                                        <p><%=detalle%></p>
                                                    </div>
                                                </div>
                                                <div class="col-sm-6">
                                                    <div class="row-element">
                                                        <p class="text-bold">Categoría: </p>
                                                        <p><%=categoria%></p>
                                                    </div>
                                                    <div class="row-element">
                                                        <p class="text-bold">Piso: </p>
                                                        <p>1</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!--===================================================-->
                                    <!--End Panel with Header-->
                                </div>
                            </div>
                            <div class="forms_register">
                                <div class="detalle_cliente">
                                    <div class="col-sm-6">
                                        <div class="panel">
                                            <div class="panel-heading">
                                                <h3 class="panel-title">Detalle cliente</h3>
                                            </div>

                                            <!--Horizontal Form-->
                                            <!--===================================================-->
                                            <form class="form-horizontal" id="client_form">
                                                <div class="panel-body">
                                                    <div class="form-group">
                                                        <label class="col-sm-3 control-label" for="nroDocumento">Nro
                                                            Documento:</label>
                                                        <div class="input-group mar-btm">
                                                            <input type="email" class="form-control"
                                                                id="nroDocumento" name="documento">
                                                            <span class="input-group-btn">
                                                                <button class="btn btn-mint" data-target="#selectClient" data-toggle="modal" type="button">Buscar</button>
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-3 control-label" for="typeDoc">Tipo
                                                            Documento:</label>
                                                        <div class="col-sm-4">
                                                            <select id="typeDoc" class="form-control" name="tipo_documento">
                                                                <option selected>DNI</option>
                                                                <option>PASAPORTE</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-3 control-label"
                                                            for="clientName">Nombre</label>
                                                        <div class="col-sm-9">
                                                            <input type="text" id="clientName" class="form-control" name="nombre">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-3 control-label" for="apell_p">Apellido
                                                            paterno</label>
                                                        <div class="col-sm-9">
                                                            <input type="text" id="apell_p" class="form-control" name="apell_paterno">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-3 control-label" for="apell_m">Apellido
                                                            materno</label>
                                                        <div class="col-sm-9">
                                                            <input type="text" id="apell_m" class="form-control" name="apell_materno">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label class="col-sm-3 control-label"
                                                            for="email">Correo</label>
                                                        <div class="col-sm-9">
                                                            <input type="email" id="email" class="form-control" name="correo">
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>
                                            <!--===================================================-->
                                            <!--End Horizontal Form-->

                                        </div>
                                    </div>
                                </div>
                                <div class="detalle_reservacion">
                                    <div class="col-sm-6">
                                        <div class="panel">
                                            <div class="panel-heading">
                                                <h3 class="panel-title">Detalles de reservación</h3>
                                            </div>

                                            <!--Block Styled Form -->
                                            <!--===================================================-->
                                            <form action="#">
                                                <div class="panel-body" style="padding-bottom: 10px;">
                                                    <div class="row">
                                                        <div class="col-sm-6">
                                                            <div class="form-group">
                                                                <label class="control-label">Fecha de
                                                                    entrada</label>
                                                                <input type="date" disabled="" class="form-control" id="fecha_entrada">
                                                            </div>
                                                        </div>
                                                        <div class="col-sm-6">
                                                            <div class="form-group">
                                                                <label class="control-label">Fecha de salida</label>
                                                                <input type="date" class="form-control" id="fecha_salida">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-sm-6">
                                                            <div class="form-group">
                                                                <label class="control-label">Precio</label>
                                                                <input type="text" disabled="" class="form-control" value="<%=precio%>" id="precio_input">
                                                            </div>
                                                        </div>
                                                        <div class="col-sm-6">
                                                            <div class="form-group">
                                                                <label class="control-label">Adelanto</label>
                                                                <input type="text" value="0" placeholder="0" class="form-control" id="adelanto_input">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-sm-12">
                                                            <div class="form-group">
                                                                <label class="control-label">Observaciones:</label>
                                                                <textarea placeholder="observaciones" rows="2"
                                                                    class="form-control" id="observaciones_input"></textarea>
                                                            </div>
                                                        </div>
                                                    </div>  
                                                </div>
                                        </form>
                                                <div class="panel-footer text-right">
                                                    <button class="btn btn-success" id="regRecep_btn">Submit</button>
                                                </div>
                                            
                                            <!--===================================================-->
                                            <!--End Block Styled Form -->

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
        
        <!---MODAL PARA MOSTRAR CLIENTES (NO APARECE POR DEFECTO) --->
        <div class="modal fade" id="selectClient" role="dialog" tabindex="-1" aria-labelledby="demo-default-modal" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">

                    <!--Modal header-->
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><i class="pci-cross pci-circle"></i></button>
                        <h4 class="modal-title">Lista de clientes</h4>
                    </div>

                    <!--Modal body-->
                    <div class="modal-body">
                        <table class="table table-hover table-bordered">
                            <thead class="thead-dark">
                              <tr>
                                <th scope="col">Documento</th>
                                <th scope="col">Nombre</th>
                                <th scope="col">Apellido</th>
                                <th scope="col">Correo</th>
                              </tr>
                            </thead>
                            <tbody class="table-group-divider" id="clientsTable"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>


        <script>
            //Código desesperado para secciones del menú dinámicas
            activePage("sec_gestion", "subsec_recepcion");
            
            const fecha_salida = document.getElementById("fecha_salida");
            const fecha_entrada = document.getElementById("fecha_entrada");
            const precio_input = document.getElementById("precio_input");
            
            let d = new Date();
            let formatDate = moment(d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate(), "YYYY-MM-DD").format("YYYY-MM-DD");
            
            fecha_salida.value = formatDate;
            fecha_entrada.value = formatDate;
            
            fecha_salida.addEventListener("change", ()=>{
                
                let fechaSalida = moment(fecha_salida.value, "YYYY-MM-DD");
                let fechaEntrada = moment(fecha_entrada.value, "YYYY-MM-DD");
                
                if(fechaSalida.isBefore(fechaEntrada)){
                    alert("La fecha seleccionada no puede ser menor a la fecha actual!");
                    fecha_salida.value = formatDate;
                }else{
                    let diasDiferencia = fechaSalida.diff(fechaEntrada, 'days');
                    precio_input.value = (diasDiferencia + 1) * <%=precio%>
                }
                
            })
            
        </script>
        <script src="./script_regRec.js"></script>

    </body>
    
    </html>