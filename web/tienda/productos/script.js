window.addEventListener("load", () => {
    //Código desesperado para secciones del menú dinámicas
    activePage("sec_tienda", "subsec_productos");
    //función para obtener los clientes con ajax en segundo plano
    function updateTable(){
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "/HotelRoma/getProducts");
        xhr.onload = ()=>{
            if(xhr.status === 200){
                const productos = JSON.parse(xhr.responseText);
                showProductsDoom(productos.content);
                
            }else{
                console.log("ERROR CON AJAX: " + xhr.status);
            }
        }
        xhr.send();
    }
    updateTable();
    

    const productsTable = document.getElementById("productsTable");
    //Función para actualizar la tabla y mostrar las entradas
    function showProductsDoom(productos){
        //limpiamos la tabla
        productsTable.innerHTML = "";

        const dataProduct = new DocumentFragment();
        let i = 1;
        for(let producto of productos){
            const tr = document.createElement("tr");
            tr.innerHTML = `
                <th scope="row" id-db='${producto.id}'>${i}</th>
                <td class="editable">${producto.nombre}</td>
                <td class="editable">${producto.detalle}</td>
                <td class="editable">${producto.precio}</td>
                <td class="editable">${producto.cantidad}</td>
                <td>
                    <button class="btn btn-success">Activo</button>
                </td>
                <td>
                    <button class="btn btn-primary" rol="modify" id-reg="${i}"><i class="demo-psi-pen-5 icon-lg"></i></button>
                    <button class="btn btn-danger" rol="delete" id-reg="${i}"><i class="demo-psi-recycling icon-lg"></i></button>
                </td>`.trim();
                dataProduct.appendChild(tr);
            i++;
        };
        productsTable.append(dataProduct);
    }


    //-----------------FUNCIONES DE LA TABLA-----------
    productsTable.addEventListener("click", (ev)=>{
        //detectamos a los botones de las funciones
        if(ev.target.nodeName == "BUTTON" || ev.target.parentElement.nodeName == "BUTTON"){
            let button = ev.target;
            if(ev.target.parentElement.nodeName == "BUTTON"){
                button = ev.target.parentElement;
            }
            //obtenemos la fila seleccionado
            const fila = Array.from(productsTable.children)[button.getAttribute("id-reg") - 1];
            const idProducto = fila.children[0].getAttribute("id-db");
            switch(button.getAttribute("rol")){
                case 'modify':
                    for(let i = 0; i < fila.children.length; i++){
                        if(fila.children[i].classList.contains("editable")){
                            fila.children[i].contentEditable = "true";
                        }
                    }
                    //cambiamos el ícono y el rol del botón
                    button.innerHTML = `<i class="fa fa-save icon-lg"></i>`;
                    button.setAttribute("rol", "saveReg");
                    Toast.fire({
                        icon: 'info',
                        title: '<big><b>Ahora puedes modificar la celdas<b><big>',
                        html: "<big>intenta haciendo click en cualquiera de las celdas de tu fila seleccionada<big>",
                    })
                break;
                case 'saveReg':
                    let datosArray = [];
                    let indexData = 0;
                    //reconocemos aquellos campos que pueden ser editados y pasamos sus valores a un array
                    for(let i = 0; i < fila.children.length; i++){
                        if(fila.children[i].classList.contains("editable")){
                            const field = fila.children[i];
                            datosArray[indexData] = field.textContent;
                            indexData++;
                        }
                    }
                    //datos con formato de objeto
                    let datosProducto = {
                        "id": idProducto, //id de la base de datos
                        "nombre": datosArray[0],
                        "detalle": datosArray[1],
                        "precio": datosArray[2],
                        "cantidad": datosArray[3]
                    }
                    
                    //setencia sql para actualización
                    const sql = `UPDATE productos SET nombre ='${datosProducto.nombre}',detalle='${datosProducto.detalle}',precio='${datosProducto.precio}',cantidad='${datosProducto.cantidad}' WHERE idProducto = ${datosProducto.id}`;
                    //hacemos la actualización
                    updateReg(sql).then((res)=>{
                        if(res.status == "success"){
                            Toast.fire({
                                icon: 'success',
                                title: '<big>Producto actualizado con éxito<big>'
                            })
                        }else{
                            Toast.fire({
                                icon: 'error',
                                title: 'Hubo un error inesperado :('
                            })
                            console.log("ERROR: " + res.msg);
                        }
                    })
                    //cambiamos el ícono y el rol del botón
                    button.innerHTML = `<i class="demo-psi-pen-5 icon-lg"></i>`;
                    button.setAttribute("rol", "modify");
                    //además quitamos la propiedad que permite modificar el texto de cada celda
                    for(let i = 0; i < fila.children.length; i++){
                        if(fila.children[i].classList.contains("editable")){
                            fila.children[i].contentEditable = "false";
                        }
                    }
                break;
                case 'delete':
                    const sql2 = "DELETE FROM `productos` WHERE idProducto = " + idProducto;
                    updateReg(sql2).then((res)=>{
                        if(res.status == "success"){
                            updateTable();
                        }else{
                            Toast.fire({
                                icon: 'error',
                                title: '<big><b>No es posible eliminar este producto<b><big>',
                                html: "<big>Al parecer este producto ya se encuentra registrado en alguna recepción, los identificadores son importantes para mantener la estructura del sistema<big>",
                            })
                        }
                    })
                break;
            }

            //función para actualizar la base de datos usando un servlet utilitario para consultas
            async function updateReg(sql){
                const formData = new FormData();
                formData.append("sqlQuery", sql);

                return fetch("/HotelRoma/updateReg", {
                    method: "POST",
                    body: (new URLSearchParams(formData))
                }).then(async (response)=>{
                    let res = JSON.parse(await response.text());
                    return res;
                }).catch((err)=>{
                    return err;
                })
            }
        }
    })    





    //función util que sirve como plantilla para pequeños modales o alertas
    const Toast = Swal.mixin({
        toast: true,
        position: 'bottom-end',
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
        toast.addEventListener('mouseenter', Swal.stopTimer)
        toast.addEventListener('mouseleave', Swal.resumeTimer)
        }
    })

    //sencilla consulta para registrar un cliente con el modal de registro
    const regProduct_Form = document.getElementById("regProduct_Form");
    const xhr = new XMLHttpRequest();
    regProduct_Form.addEventListener("submit", (ev)=>{
        ev.preventDefault();
        //damos formato de formulario a los datos
        const datosForm = new FormData(regProduct_Form);
        //realizamos una conexión ajax
        xhr.open("POST", "/HotelRoma/setProducts");
        xhr.onload = ()=>{
            if(xhr.status == 200){
                if(JSON.parse(xhr.responseText).status == "success"){
                    const close_modal = document.getElementById("close_modal");
                    close_modal.click();
                    Swal.fire({
                        icon: 'success',
                        title: 'Producto registrado!',
                    })
                    updateTable();
                }
            }else{
                console.log("ERROR CON AJAX: " + xhr.status);
            }
        }
        xhr.setRequestHeader("content-type", "application/x-www-form-urlencoded");

        /*no se puede enviar el objeto datosForm en sí, pues el especial de java requiere una cadena codificada, como si de un method: GET se tratase, por suerte no es tan complicado recrearlo*/
        const urlFormat = (new URLSearchParams(datosForm)).toString();
        xhr.send(urlFormat);

        
    })
});//fin de función main (por darle un nombre)