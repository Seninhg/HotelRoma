window.addEventListener("load",async ()=>{
    //-----------------Función para hacer petición al servlet GetSetProducts
    async function getProducts(){
        return fetch("/HotelRoma/getProducts", {
            method: "GET",
        }).then(async (productos)=>{
            const products = await productos.json()
            return products.content;
        })
    }


    let productos = await getProducts();


    //VARIABLES IMPRESCINDIBLES PARA LA PETICIÓN
    let requestMsg = {status: "pendiente", idRecepcion: idRecepcion};
    let ventas_reg = []; //almacenará todos los registros que hagamos (ES ESTO LO QUE SE ENVIARÁ AL SERVIDOR)
    
    //entradas y no entradas de registro de productos
    const drop_products = document.getElementById("drop_products"); //dropdown para selección de productos
    const cantidad_input = document.getElementById("cantidad_input");
    const precio_input = document.getElementById("precio_input");
    const totalPagar_out = document.getElementById("totalPagar_out");

    function showIndropDown(){
        //<li class="active"><a href="#">Semen</a></li>
        const listaProductos = new DocumentFragment();

        productos.forEach((producto)=>{
            const li = document.createElement("li");
            li.innerHTML = `<a href="#">${producto.nombre}</a>`;
            li.setAttribute("id-product", producto.id);
            listaProductos.appendChild(li);
        })
        
        drop_products.appendChild(listaProductos);
    }

    showIndropDown();

    let currentRegister = {}; //almacena al producto actual seleccionado (ESTO ES SOLO PARA EL FRONTED, NO SE DEBERÍA ENVIAR)
    //evento: cuando hago click en algun producto del dropdown
    drop_products.addEventListener("click", (ev)=>{
        const li = ev.target.parentElement; //esto es suponiendo que siempre se haga click en el elemento a, pero podría no darse el caso
        const idProductSelected = li.getAttribute("id-product");

        const productSelected = productos.filter((producto)=>{
            return producto.id == idProductSelected;
        })[0];

        //MODIFICADORES DE LOS CAMPOS
        precio_input.innerText = productSelected.precio;

        //almacena nuestra selección de forma temporal para poder ser usada más adelante
        currentRegister = productSelected;
        //estatregia sucia para no crear otra constante para acceder al elemento botón
        const btn_selectProduct = document.getElementById("btn_selectProduct");
        btn_selectProduct.innerHTML = productSelected.nombre + `<i class="dropdown-caret" name="botonsito"></i>`;
    })

    //-----------función para añadir a la tabla un registro de venta (sin consulta sql) //ESTO ES PARA LA TABLA NADAMAS
    const btn_addReg = document.getElementById("btn_addReg");
    let idVariable = 1;
    btn_addReg.addEventListener("click", ()=>{
        const cantidad = cantidad_input.value;
        if(currentRegister.id != undefined && currentRegister.precio != undefined && cantidad != ""){
            currentRegister.idReg = idVariable;
            saveRowProduct(currentRegister, cantidad);
            idVariable++;
        }else{
            Swal.fire({
                icon: 'error',
                title: 'Oops...',
                text: 'Se te olvidó rellenar algo talvez?'
            })
        }
    })
    //almacena en un objeto al registro insertado, para poder hacer operaciones básicas luego
    function saveRowProduct(currentRegister, cantidad){
        ventas_reg.push({
            idReg: (currentRegister.idReg).toString(), //este identificador es para poder manipularlo en el DOM
            idDb: (currentRegister.id).toString(), //este identificador es el real, el de la base de datos
            nombreProducto: currentRegister.nombre,
            cantidad: parseInt(cantidad),
            precio: parseFloat(currentRegister.precio),
            subTotal: parseFloat(currentRegister.precio * cantidad),
        })

        //actualizar la tabla
        updateTable(ventas_reg);
    }
    //función que modifica la tabla añadiendo entradas
    const registerTable = document.getElementById("registerTable");
    function updateTable(ventas_reg){
        //almacena en nuestro mensaje de petición las ventas registradas actuales
        requestMsg.ventas_reg = ventas_reg;
        //modificación de la tabla
        registerTable.innerHTML = "";
        const row = new DocumentFragment();
        let total = 0;
        ventas_reg.forEach((registro)=>{
            const tr = document.createElement("tr");
            tr.innerHTML = `
                <td class="text-center"><button class="btn btn-danger" id-register="${registro.idReg}"><i class="fa fa-trash icon-sm"></i></button></td>
                <td>${registro.nombreProducto}</td>
                <td>${registro.cantidad}</td>
                <td>${registro.precio}</td>
                <td>${registro.subTotal}</td>
            `;
            row.append(tr);

            //para encontrar el total?
            total += registro.subTotal;
        })
        //añade el total a nuestro objeto de respuesta
        requestMsg.total = parseFloat(total);
        registerTable.append(row);
        //modificar el campo de suma total
        totalPagar_out.innerText = total;
    }
    //función para detectar el click en botón de eliminar fila
    registerTable.addEventListener("click", (ev)=>{
        if(ev.target.parentElement.nodeName == "BUTTON" || ev.target.nodeName == "BUTTON"){
            let button;
            if(ev.target.parentElement.nodeName == "BUTTON"){
                button = ev.target.parentElement;
            }
            if(ev.target.nodeName == "BUTTON"){
                button = ev.target;
            }

            const filaId = button.getAttribute("id-register");
            ventas_reg = ventas_reg.filter((registro)=>{
                return registro.idReg != filaId;
            })
            updateTable(ventas_reg);
        }
    })


    /*FUNCION PARA EL DROPDOWN DE ESTADO*/
    const drop_status = document.getElementById("drop_status");
    drop_status.addEventListener("click", (ev)=>{
        const li = ev.target.parentElement; //esto es suponiendo que siempre se haga click en el elemento a, pero podría no darse el caso
        const idStatusSelected = li.getAttribute("id-status");
        requestMsg.status = idStatusSelected;
        
        //estatregia sucia para no crear otra constante(xd) para acceder al elemento botón
        const btn_selectStatus = document.getElementById("btn_selectStatus");
        btn_selectStatus.innerHTML = ev.target.textContent + `<i class="dropdown-caret caret-up"></i>`;
    })


    //Finalmente, la función para hacer el envío de los datos
    const btn_regVenta = document.getElementById("btn_regVenta");
    btn_regVenta.addEventListener("click", ()=>{
        if(requestMsg.ventas_reg != undefined){

            console.log(requestMsg);
            const jsonData = JSON.stringify(requestMsg);
            const formData = new FormData();
            formData.append("data", jsonData); //truquito para subirlo al servlet

            fetch("/HotelRoma/regVenta", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                },
                body: (new URLSearchParams(formData)).toString() //recordemos que JSON como se hace el especial requiere formato de formulario
            }).then(async (res)=>{
                const response = JSON.parse(await res.text());
                console.log(response);
                if(response.status == "success"){
                    Swal.fire('Venta registrada!', '', 'success').then((r)=>{
                        ventas_reg = [];
                        requestMsg.ventas_reg = [];
                        updateTable(ventas_reg);
                    })
                }
            })

        }else{
            Swal.fire({
                icon: 'error',
                title: 'Uhm...',
                text: 'No tienes registros :('
            })
        }
    })
})






