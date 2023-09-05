window.addEventListener("load", () => {
    //Código desesperado para secciones del menú dinámicas
    activePage("sec_mantenimiento", "subsec_habitaciones");
    //función para obtener los clientes con ajax en segundo plano
    function updateTable(){
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "/HotelRoma/getListRooms");
        xhr.onload = ()=>{
            if(xhr.status === 200){
                const habitaciones = JSON.parse(xhr.responseText);
                showUsersDoom(habitaciones.content);
            }else{
                console.log("ERROR CON AJAX: " + xhr.status);
            }
        }
        xhr.send();
    }
    updateTable();
    

    const roomsTable = document.getElementById("roomsTable");
    //Función para actualizar la tabla y mostrar las entradas
    function showUsersDoom(habitaciones){
        //limpiamos la tabla
        roomsTable.innerHTML = "";

        const dataUser = new DocumentFragment();
        let i = 1;
        for(let habitacion of habitaciones){
            const tr = document.createElement("tr");
            let status = {};
            if(habitacion.estado == 1){
                status.class = "btn-success";
                status.text = "Activo";
            }else{
                status.class = "btn-mint";
                status.text = "Inactivo";
            }
            tr.innerHTML = `
                <th scope="row" id-db='${habitacion.id}'>${i}</th>
                <td class="editable">${habitacion.numero}</td>
                <td class="editable">${habitacion.detalle}</td>
                <td class="editable">${habitacion.precio}</td>
                <td class="editable" id-categoria="${habitacion.idCategoria}">${habitacion.categoria}</td>
                <td>PRIMERO</td>
                <td>
                    <button class="btn ${status.class}" value="${habitacion.estado}" rol="modStatus" id-reg="${i}">${status.text}</button>
                </td>
                <td>
                    <button class="btn btn-primary" rol="modify" id-reg="${i}"><i class="demo-psi-pen-5 icon-lg"></i></button>
                    <button class="btn btn-danger" rol="delete" id-reg="${i}"><i class="demo-psi-recycling icon-lg"></i></button>
                </td>`.trim();
                dataUser.appendChild(tr);
            i++;
        };
        roomsTable.append(dataUser);
    }


    //-----------------FUNCIONES DE LA TABLA-----------
    roomsTable.addEventListener("click", (ev)=>{
        //detectamos a los botones de las funciones
        if(ev.target.nodeName == "BUTTON" || ev.target.parentElement.nodeName == "BUTTON"){
            let button = ev.target;
            if(ev.target.parentElement.nodeName == "BUTTON"){
                button = ev.target.parentElement;
            }
            //obtenemos la fila seleccionado
            const fila = Array.from(roomsTable.children)[button.getAttribute("id-reg") - 1];
            const idHabitacion = fila.children[0].getAttribute("id-db");

            //ROLES DE LOS BOTONES, ASÍ PODEMOS DETERMINAR FUNCIONES
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
                    let datosHabitacion = {
                        "id": idHabitacion, //id de la base de datos
                        "numero": datosArray[0],
                        "detalle": datosArray[1],
                        "precio": datosArray[2],
                        "categoria": datosArray[3],
                        "idCategoria": fila.children[4].getAttribute("id-categoria"), 
                    }
                    //setencia sql para actualización
                    const sql = `UPDATE habitaciones SET Numero ='${datosHabitacion.numero}', Detalle ='${datosHabitacion.detalle}',Precio ='${datosHabitacion.precio}', IdCategoria ='${datosHabitacion.idCategoria}' WHERE IdHabitacion = ${idHabitacion}`;
                    //hacemos la actualización
                    updateReg(sql).then((res)=>{
                        if(res.status == "success"){
                            Toast.fire({
                                icon: 'success',
                                title: '<big>Habitación actualizada con éxito<big>'
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
                    const sql2 = "DELETE FROM `habitaciones` WHERE IdHabitacion = " + idHabitacion;
                    updateReg(sql2).then((res)=>{
                        if(res.status == "success"){
                            updateTable();
                        }else{
                            Toast.fire({
                                icon: 'error',
                                title: '<big><b>No es posible eliminar esta habitación<b><big>',
                            })
                        }
                    })
                break;
                case 'modStatus':
                    const currentStatus = button.getAttribute("value");
                    let newStatus;
                    currentStatus == 1?newStatus = 0: newStatus = 1;
                    const sql3 = `UPDATE habitaciones SET Estado = ${newStatus} WHERE idHabitacion = ${idHabitacion}`;
                    updateReg(sql3).then((res)=>{
                        if(res.status == "success"){
                            updateTable();
                        }else{
                            Toast.fire({
                                icon: 'error',
                                title: '<big><b>Hubo un error intenando cambiar el estado<b><big>',
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


//sencilla consulta para registrar un usuario con el modal de registro
const regRoom_Form = document.getElementById("regRoom_Form");
const xhr = new XMLHttpRequest();
regRoom_Form.addEventListener("submit", (ev)=>{
    ev.preventDefault();
    //damos formato de formulario a los datos
    const datosForm = new FormData(regRoom_Form);
    console.log(datosForm);
    //realizamos una conexión ajax
    xhr.open("POST", "/HotelRoma/regRoom");
    xhr.onload = ()=>{
        if(xhr.status == 200){
            //Le quita el chiste a AJAX, pero bueno
            if(JSON.parse(xhr.responseText).status == "success"){
                location.reload();
            }else{
                const btn_closeModal = document.getElementById("btn_closeModal");
                btn_closeModal.click();
                Swal.fire({
                    icon: 'error',
                    title: 'Oops...',
                    text: 'Hubo un error intentado registrar la habitación!'
                });
                console.log(JSON.parse(xhr.responseText));
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
