window.addEventListener("load", () => {
    //Código desesperado para secciones del menú dinámicas
    activePage("sec_clientes");
    //función para obtener los clientes con ajax en segundo plano
    function updateTable(){
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "../getListClients");
        xhr.onload = ()=>{
            if(xhr.status === 200){
                const clientes = JSON.parse(xhr.responseText);
                showClientsDoom(clientes.content);
                
            }else{
                console.log("ERROR CON AJAX: " + xhr.status);
            }
        }
        xhr.send();
    }
    updateTable();
    

    const clientsTable = document.getElementById("clientsTable");
    //Función para actualizar la tabla y mostrar las entradas
    function showClientsDoom(clientes){
        //limpiamos la tabla
        clientsTable.innerHTML = "";

        const dataClient = new DocumentFragment();
        let i = 1;
        for(let cliente of clientes){
            const tr = document.createElement("tr");
            tr.innerHTML = `
                <th scope="row" id-db='${cliente.id}'>${i}</th>
                <td class="editable">${cliente.tipoDocumento}</td>
                <td class="editable">${cliente.documento}</td>
                <td class="editable">${cliente.nombre}</td>
                <td class="editable">${cliente.apell_paterno + " " + cliente.apell_materno}</td>
                <td class="editable">${cliente.correo}</td>
                <td>
                    <button class="btn btn-success">Activo</button>
                </td>
                <td>
                    <button class="btn btn-primary" rol="modify" id-reg="${i}"><i class="demo-psi-pen-5 icon-lg"></i></button>
                    <button class="btn btn-danger" rol="delete" id-reg="${i}"><i class="demo-psi-recycling icon-lg"></i></button>
                </td>`.trim();
            dataClient.appendChild(tr);
            i++;
        };
        clientsTable.append(dataClient);
    }


    //-----------------FUNCIONES DE LA TABLA-----------
    clientsTable.addEventListener("click", (ev)=>{
        //detectamos a los botones de las funciones
        if(ev.target.nodeName == "BUTTON" || ev.target.parentElement.nodeName == "BUTTON"){
            let button = ev.target;
            if(ev.target.parentElement.nodeName == "BUTTON"){
                button = ev.target.parentElement;
            }
            //obtenemos la fila seleccionado
            const fila = Array.from(clientsTable.children)[button.getAttribute("id-reg") - 1];
            const idCliente = fila.children[0].getAttribute("id-db");
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
                    for(let i = 0; i < fila.children.length; i++){
                        if(fila.children[i].classList.contains("editable")){
                            const field = fila.children[i];
                            datosArray[indexData] = field.textContent;
                            indexData++;
                        }
                    }
                    //datos con formato de objeto y además apellidos separados
                    let datosUsuario = {
                        "id": idCliente, //id de la base de datos
                        "tipoDocumento": datosArray[0],
                        "documento": datosArray[1],
                        "nombre": datosArray[2],
                        "apell_paterno": datosArray[3].split(" ")[0],
                        "apell_materno": datosArray[3].split(" ")[1],
                        "correo": datosArray[4]
                    }
                    
                    //setencia sql para actualización
                    const sql = `UPDATE clientes SET tipoDocumento= '${datosUsuario.tipoDocumento}',documento='${datosUsuario.documento}',nombre='${datosUsuario.nombre}',apell_paterno='${datosUsuario.apell_paterno}',apell_materno='${datosUsuario.apell_paterno}',correo='${datosUsuario.correo}' WHERE idCliente = '${datosUsuario.id}'`;
                    //hacemos la actualización
                    updateReg(sql).then((res)=>{
                        if(res.status == "success"){
                            Toast.fire({
                                icon: 'success',
                                title: '<big>Cliente actualizado con éxito<big>'
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
                    const sql2 = "DELETE FROM `clientes` WHERE idCliente = " + idCliente;
                    updateReg(sql2).then((res)=>{
                        if(res.status == "success"){
                            updateTable();
                        }else{
                            Toast.fire({
                                icon: 'error',
                                title: '<big><b>No es posible eliminar a este usuario<b><big>',
                                html: "<big>Al parecer el usuario ya tiene asignada una habitación<big>",
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


});//fin de función main (por darle un nombre)


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
const regClient_Form = document.getElementById("regClient_Form");
const xhr = new XMLHttpRequest();
regClient_Form.addEventListener("submit", (ev)=>{
    ev.preventDefault();
    //damos formato de formulario a los datos
    const datosForm = new FormData(regClient_Form);
    //realizamos una conexión ajax
    xhr.open("POST", "/HotelRoma/registrarCliente");
    xhr.onload = ()=>{
        if(xhr.status == 200){
            //Le quita el chiste a AJAX, pero bueno
            if(JSON.parse(xhr.responseText).status == "success"){
                location.reload();
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
