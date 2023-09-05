<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<header id="navbar">
    <div id="navbar-container" class="boxed navbar-ourself">

        <!--Brand logo & name-->
        <!--================================-->
        <div class="navbar-header">
            <a href="index.html" class="navbar-brand">
                <img src="/HotelRoma/src/images/hotel.png" alt="HotelRoma Logo" class="brand-icon">
                <div class="brand-title">
                    <span class="brand-text">Hotel Roma</span>
                </div>
            </a>
        </div>
        <!--================================-->
        <!--End brand logo & name-->


        <!--Navbar Dropdown-->
        <!--================================-->
        <div class="navbar-content">
            <ul class="nav navbar-top-links">

                <!--Navigation toogle button-->
                <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
                <li class="tgl-menu-btn">
                    <a class="mainnav-toggle" href="#">
                        <i class="demo-pli-list-view"></i>
                    </a>
                </li>
                <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
                <!--End Navigation toogle button-->

            </ul>
            <ul class="nav navbar-top-links">


                <!--Notification dropdown-->
                <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
                <li class="dropdown">
                    <a href="#" data-toggle="dropdown" class="dropdown-toggle">
                        <i class="demo-pli-bell"></i>
                        <span class="badge badge-header badge-danger"></span>
                    </a>


                    <!--Notification dropdown menu-->
                    <div class="dropdown-menu dropdown-menu-md dropdown-menu-right">
                        <div class="nano scrollable">
                            <div class="nano-content">
                                <ul class="head-list">
                                    <li>
                                        <a class="media" href="#">
                                            <div class="media-left">
                                                <i class="demo-pli-file-edit icon-2x"></i>
                                            </div>
                                            <div class="media-body">
                                                <p class="mar-no text-nowrap text-main text-semibold">Write
                                                    a
                                                    news article</p>
                                                <small>Last Update 8 hours ago</small>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a class="media" href="#">
                                            <div class="media-left">
                                                <i class="demo-pli-add-user-star icon-2x"></i>
                                            </div>
                                            <div class="media-body">
                                                <p class="mar-no text-nowrap text-main text-semibold">New
                                                    User
                                                    Registered</p>
                                                <small>4 minutes ago</small>
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a class="media" href="#">
                                            <div class="media-left">
                                                <img class="img-circle img-sm" alt="Profile Picture"
                                                    src="/HotelRoma/src/images/profile-photos/3.png">
                                            </div>
                                            <div class="media-body">
                                                <p class="mar-no text-nowrap text-main text-semibold">
                                                    Jackson
                                                    sent you a message</p>
                                                <small>40 minutes ago</small>
                                            </div>
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <!--Dropdown footer-->
                        <div class="pad-all bord-top">
                            <a href="#" class="btn-link text-main box-block">
                                <i class="pci-chevron chevron-right pull-right"></i>Show All Notifications
                            </a>
                        </div>
                    </div>
                </li>
                <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
                <!--End notifications dropdown-->

                <!--User dropdown-->
                <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
                <li id="dropdown-user" class="dropdown">
                    <a href="#" data-toggle="dropdown" class="dropdown-toggle text-right">
                        <span class="ic-user pull-right">
                            <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
                            <!--You can use an image instead of an icon.-->
                            <!--<img class="img-circle img-user media-object" src="img/profile-photos/1.png" alt="Profile Picture">-->
                            <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
                            <i class="demo-pli-male"></i>
                        </span>
                        <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
                        <!--You can also display a user name in the navbar.-->
                        <!--<div class="username hidden-xs">Aaron Chavez</div>-->
                        <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
                    </a>


                    <div class="dropdown-menu dropdown-menu-sm dropdown-menu-right panel-default">
                        <ul class="head-list">
                            <li>
                                <a href="#"><i class="demo-pli-male icon-lg icon-fw"></i> Profile</a>
                            </li>
                            <li>
                                <a href="#"><span class="label label-success pull-right">New</span><i
                                        class="demo-pli-gear icon-lg icon-fw"></i> Settings</a>
                            </li>
                            <li>
                                <a href="#" id="btn_logout"><i class="demo-pli-unlock icon-lg icon-fw"></i>
                                    Logout</a>
                            </li>
                        </ul>
                    </div>
                </li>
                <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
                <!--End user dropdown-->

            </ul>
        </div>
        <!--================================-->
        <!--End Navbar Dropdown-->

    </div>
</header>
<script>
    const btn_logout = document.getElementById("btn_logout");
    console.log(btn_logout);
    btn_logout.addEventListener("click", async ()=>{
        //código sucio para eliminar la sessión
        const response = await deleteSession();
        if(response.status == "success"){
            alert("Cerrando sesión...");
            location.href = "/HotelRoma/";
        }
    })
    
    async function deleteSession(){
        return await fetch("/HotelRoma/controlSession", {
            method: "DELETE",
        }).then(async (response)=>{
            if(response.ok){
                return await response.json();
            }
        })
    }
</script>