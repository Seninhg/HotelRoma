
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<!--===================================================-->
<nav id="mainnav-container">
    <div id="mainnav">


        <!--OPTIONAL : ADD YOUR LOGO TO THE NAVIGATION-->
        <!--It will only appear on small screen devices.-->
        <!--================================
    <div class="mainnav-brand">
        <a href="index.html" class="brand">
            <img src="img/logo.png" alt="Nifty Logo" class="brand-icon">
            <span class="brand-text">Nifty</span>
        </a>
        <a href="#" class="mainnav-toggle"><i class="pci-cross pci-circle icon-lg"></i></a>
    </div>
    -->

        <!--Menu-->
        <!--================================-->
        <div id="mainnav-menu-wrap">
            <div class="nano">
                <div class="nano-content">

                    <!--Profile Widget-->
                    <!--================================-->
                    <div id="mainnav-profile" class="mainnav-profile">
                        <div class="profile-wrap text-center">
                            <div class="pad-btm">
                                <img class="img-circle img-md" src="/HotelRoma/src/images\profile-photos\1.png"
                                    alt="Profile Picture">
                            </div>
                            <a href="#profile-nav" class="box-block" data-toggle="collapse"
                                aria-expanded="false">
                                <span class="pull-right dropdown-toggle">
                                    <i class="dropdown-caret"></i>
                                </span>
                                <p class="mnp-name"><%=(String)session.getAttribute("nombre")%></p>
                                <span class="mnp-desc"><%=(String)session.getAttribute("correo")%></span>
                            </a>
                        </div>
                        <div id="profile-nav" class="collapse list-group bg-trans">
                            <a href="#" class="list-group-item">
                                <i class="demo-pli-male icon-lg icon-fw"></i> View Profile
                            </a>
                            <a href="#" class="list-group-item">
                                <i class="demo-pli-gear icon-lg icon-fw"></i> Settings
                            </a>
                            <a href="#" class="list-group-item">
                                <i class="demo-pli-information icon-lg icon-fw"></i> Help
                            </a>
                            <a href="#" class="list-group-item">
                                <i class="demo-pli-unlock icon-lg icon-fw"></i> Logout
                            </a>
                        </div>
                    </div>


                    <!--Shortcut buttons-->
                    <!--================================-->
                    <div id="mainnav-shortcut" class="hidden">
                        <ul class="list-unstyled shortcut-wrap">
                            <li class="col-xs-3" data-content="My Profile">
                                <a class="shortcut-grid" href="#">
                                    <div class="icon-wrap icon-wrap-sm icon-circle bg-mint">
                                        <i class="demo-pli-male"></i>
                                    </div>
                                </a>
                            </li>
                            <li class="col-xs-3" data-content="Messages">
                                <a class="shortcut-grid" href="#">
                                    <div class="icon-wrap icon-wrap-sm icon-circle bg-warning">
                                        <i class="demo-pli-speech-bubble-3"></i>
                                    </div>
                                </a>
                            </li>
                            <li class="col-xs-3" data-content="Activity">
                                <a class="shortcut-grid" href="#">
                                    <div class="icon-wrap icon-wrap-sm icon-circle bg-success">
                                        <i class="demo-pli-thunder"></i>
                                    </div>
                                </a>
                            </li>
                            <li class="col-xs-3" data-content="Lock Screen">
                                <a class="shortcut-grid" href="#">
                                    <div class="icon-wrap icon-wrap-sm icon-circle bg-purple">
                                        <i class="demo-pli-lock-2"></i>
                                    </div>
                                </a>
                            </li>
                        </ul>
                    </div>
                    <!--================================-->
                    <!--End shortcut buttons-->


                    <!---MENU DE OPCIONES REAL-->
                    <ul id="mainnav-menu" class="list-group">

                        <!-----------Navegación----------->
                        <li class="list-header">Manejo de Hotel</li>

                        <!--Dashboard-->
                        <li id="sec_dashboard">
                            <a href="/HotelRoma/dashboard">
                                <i class="fa fa-dashboard"></i>
                                <span class="menu-title">
                                    Dashboard
                                </span>
                            </a>
                        </li>

                        <!--Gestión-->
                        <li id="sec_gestion">
                            <a href="#">
                                <i class="fa fa-bell"></i>
                                <span class="menu-title">Gestión</span>
                                <i class="arrow"></i>
                            </a>

                            <!--Submenu-->
                            <ul class="collapse">
                                <li id="subsec_recepcion"><a href="/HotelRoma/gestion/recepcion/">Recepción</a></li>
                                <li id="subsec_salida"><a href="/HotelRoma/gestion/salida/">Salida</a></li>
                            </ul>
                        </li>

                        <!--TIENDA-->
                        <li id="sec_tienda">
                            <a href="#">
                                <i class="fa fa-shopping-cart"></i>
                                <span class="menu-title">Tienda</span>
                                <i class="arrow"></i>
                            </a>

                            <!--Submenu-->
                            <ul class="collapse">
                                <li id="subsec_vender"><a href="/HotelRoma/tienda/vender/">Vender</a></li>
                                <small style="text-align: center">registrar:</small>
                                <li id="subsec_productos"><a href="/HotelRoma/tienda/productos/">Productos</a></li>
                            </ul>
                        </li>

                        <!--CLIENTES-->
                        <li id="sec_clientes">
                            <a href="/HotelRoma/clientes">
                                <i class="fa fa-users"></i>
                                <span class="menu-title">
                                    Clientes
                                </span>
                            </a>
                        </li>

                        
                        <%
                            if(session.getAttribute("idTipoPersona").equals("1")){
                        %>
                        <!---------SECCION DE MANTENIMIENTO Y CONFIGURACION (SOLO DISPONIBLE PARA ROL ADMINISTRADOR)------->
                        <li class="list-divider"></li>
                        <li class="list-header">Configuración</li>

                        <!--Mantenimiento-->
                        <li id="sec_mantenimiento">
                            <a href="#">
                                <i class="ion-wrench"></i>
                                <span class="menu-title">Mantenimiento</span>
                                <i class="arrow"></i>
                            </a>

                            <!--Submenu-->
                            <ul class="collapse">
                                <li  id="subsec_habitaciones"><a href="/HotelRoma/mantenimiento/habitaciones/">Habitaciones</a></li>
                                <li id="subsec_categorias"><a href="/HotelRoma/mantenimiento/categorias/">Categorías</a></li>
                            </ul>
                        </li>

                        <!--USUARIOS-->
                        <li id="sec_usuarios">
                            <a href="/HotelRoma/usuarios/">
                                <i class="fa fa-user"></i>
                                <span class="menu-title">
                                    Usuarios
                                </span>
                            </a>
                        </li>
                        <%}%>
                    </ul>

                </div>
            </div>
        </div>
        <!--================================-->
        <!--End menu-->

    </div>
</nav>

<script>
    const rutas = [
        {
            name: "sec_dashboard",
            submenu: null
        },
        {
            name: "sec_gestion",
            submenu: ["subsec_recepcion", "subsec_salida"]
        },
        {
            name: "sec_tienda",
            submenu: ["subsec_vender", "subsec_productos"]
        },
        {
            name: "sec_clientes",
            submenu: null,
        },
        {
           name: "sec_mantenimiento" ,
           submenu: ["subsec_habitaciones", "subsec_categorias"]
        },
        {
            name: "sec_usuarios",
            submenu: null,
        },
    ]

    function activePage(name, submenuActive = null){
        //se busca el objeto que contiene a dicha ruta
        const rutaOwn = rutas.find((ruta)=>{
            return ruta.name == name;
        });

        let section_menu = document.getElementById(name);
        section_menu.classList.add("active-sub");

        if(submenuActive != null){
            section_submenu = document.getElementById(submenuActive);
            section_submenu.classList.add("active-link");
        }

        //si la sección contiene un submenú, entonces este se desplega luego de 2 segundos
        if(rutaOwn.submenu != null){
            setTimeout(()=>{
                const element = section_menu.getElementsByTagName("a")[0];
                element.click()
            }, 1000);
        }
        
        
    }
</script>
