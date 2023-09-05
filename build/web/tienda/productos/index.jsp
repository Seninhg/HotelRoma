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
                        <button data-target="#crearProducto" data-toggle="modal" class="btn btn-primary">Crear nuevo</button>
                        <table class="table table-hover table-bordered">
                            <thead class="thead-dark">
                              <tr>
                                <th scope="col">#</th>
                                <th scope="col">Nombre</th>
                                <th scope="col">Detalle</th>
                                <th scope="col">Precio</th>
                                <th scope="col">Cantidad</th>
                                <th scope="col">Estado</th>
                                <th scope="col">tools</th>
                              </tr>
                            </thead>
                            <tbody class="table-group-divider" id="productsTable">
                            </tbody>
                        </table>

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


            <!-- SCROLL PAGE BUTTON -->
            <!--===================================================-->
            <button class="scroll-top btn">
                <i class="pci-chevron chevron-up"></i>
            </button>
            <!--===================================================-->
        </div>
        <!--===================================================-->
        <!-- END OF CONTAINER -->


        <!---MODAL PARA CREAR CLIENTES (NO APARECE POR DEFECTO) --->
        <div class="modal fade" id="crearProducto" role="dialog" tabindex="-1" aria-labelledby="demo-default-modal" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">

                    <!--Modal header-->
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><i class="pci-cross pci-circle" id="close_modal"></i></button>
                        <h4 class="modal-title">Registrar Producto</h4>
                    </div>

                    <!--Modal body-->
                    <div class="modal-body">
                        <!--Block Styled Form -->
                        <!--===================================================-->
                        <form id="regProduct_Form" method="POST" action="/HotelRoma/setProducts">
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label class="control-label">Nombre:</label>
                                            <input type="text" class="form-control" name="nombre">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label class="control-label">Detalle:</label>
                                            <input type="text" class="form-control" name="detalle">
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label class="control-label">Precio:</label>
                                            <input type="text" class="form-control" name="precio">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label class="control-label">Cantidad:</label>
                                            <input type="text" class="form-control" name="cantidad">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-footer text-right">
                                <button class="btn btn-success" type="submit">Registrar</button>
                            </div>
                        </form>
                        <!--===================================================-->
                        <!--End Block Styled Form -->
                    </div>
                </div>
            </div>
        </div>


        <!--Sistema ajax para petición de datos-->
        <script src="./script.js">
            
        </script>

    </body>

    </html>