window.addEventListener("load", main);


let clientes;
async function main(){
    actualizarTabla();
}
    function actualizarTabla(){
        getClients().then((clients)=>{
            clientes = clients;
            showClientsDoom(clientes);
        })
    }

    
    async function getClients(){
        //petición ajax para obtener clientes del servlet
        return await fetch("../../getListClients", {
            method: "GET",
        }).then(async (response)=>{
            const clients = await response.json();
            return clients.content;
        })
    }
    

    const clientsTable = document.getElementById("clientsTable");
    
    //mostrar los datos extraidos en la tabla de clientes
    function showClientsDoom(clientes){
        clientsTable.innerHTML = ``;
        const dataClient = new DocumentFragment();
        let i = 1;
        for(let cliente of clientes){
            const tr = document.createElement("tr");
            tr.setAttribute("id-client", cliente.id);
            tr.classList.add("cursor-pointer")
            tr.innerHTML = `
                <td scope="row">${cliente.documento}</td>
                <td>${cliente.nombre}</td>
                <td>${cliente.apell_paterno + " " + cliente.apell_materno}</td>
                <td>${cliente.correo}</td>`.trim();
            dataClient.appendChild(tr);
            i++;
        };
        clientsTable.append(dataClient);
    }

    //obtener el id del cliente seleccionado en la tabla
    clientsTable.addEventListener("click", (ev)=>{
        const celda = ev.target;
        if(celda.nodeName == "TD"){
            const fila = celda.parentElement;
            console.log(fila);
            setDataToFields(fila.getAttribute("id-client"));
        }
    })


    //para pasar los datos de la fila seleccionada a los campos
    const nroDocumento = document.getElementById("nroDocumento");
    const typeDoc = document.getElementById("typeDoc");
    const clientName = document.getElementById("clientName");
    const apell_p = document.getElementById("apell_p");
    const apell_m = document.getElementById("apell_m");
    const email = document.getElementById("email");
    
    function setDataToFields(idClient){
        let clienteSelect = clientes.find((client)=>client.id == idClient);
        nroDocumento.value = clienteSelect.documento;
        typeDoc.value = clienteSelect.tipoDocumento;
        clientName.value = clienteSelect.nombre;
        apell_p.value = clienteSelect.apell_paterno;
        apell_m.value = clienteSelect.apell_materno;
        email.value = clienteSelect.correo;
    }


    const regRecep_btn = document.getElementById("regRecep_btn");

    regRecep_btn.addEventListener("click", async()=>{

        const params = new URLSearchParams(window.location.search);
        let idHabitacion = params.get("idhabitacion");

        let clientFind = await existeCliente();
        if(clientFind != undefined){ //cliente ya existe
            console.log("CLIENTE YA EXISTE")
            registrarRecepcion(clientFind.id, idHabitacion);
        }else{ //cliente no existe, es necesario crearlo
            registrarCliente().then(async ()=>{
                clientFind = await existeCliente();
                if(clientFind != undefined){ //cliente se creó con éxito
                    console.log("CLIENTE SE CREO CON EXITO");
                    registrarRecepcion(clientFind.id, idHabitacion);
                    actualizarTabla();
                }
            });   
        }
    })
    
    async function existeCliente(){

        clientes = await getClients();
        let clientFind = clientes.find((client)=>client.documento == nroDocumento.value && client.correo == email.value);

        return clientFind;
    }
    

//para poder registrar el cliente en caso no exista
async function registrarCliente(){
    /***
     * La función obtiene automáticamente los datos de las entradas del formulario usuarios
     * Parsea todo a FormData para luego enviarlo al servlet GetSetCliente
     */
    const client_form = document.getElementById("client_form");

    const datosForm = new FormData(client_form);
    const urlFormat = (new URLSearchParams(datosForm)).toString();
    
    const config = {
        method: "POST",
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: urlFormat
    }

    return await fetch("../../registrarCliente", config).then((response)=>{
        if(response.ok){
            response.text().then((res)=>{
                console.log(res);
            })
            return true;
        }
    });
    
}

//para poder registrar la recepción
async function registrarRecepcion(idCliente, idHabitacion){
    /**
     * Pendiente:
     * Crear un cuerpo de formulario para hacer una petición al servlet de registro
     * Debido a la propiedad disabled de algunos campos, obtenerlo como en registrar clientes no es posible
     * Además se deberán añadir el id del cliente y el id de la habitación
     * el servlet deberá encargarse de rellenar los otros campos
     *  */
    const datosForm = new FormData(); //formulario

    const fecha_entrada = document.getElementById("fecha_entrada").value;
    const fecha_salida = document.getElementById("fecha_salida").value;
    const precio_input = document.getElementById("precio_input").value;
    const adelanto_input = document.getElementById("adelanto_input").value;
    const observaciones_input = document.getElementById("observaciones_input").value;

    datosForm.append("fecha_entrada", fecha_entrada);
    datosForm.append("fecha_salida", fecha_salida);
    datosForm.append("precio_input", precio_input);
    datosForm.append("adelanto_input", adelanto_input == "" || adelanto_input == undefined?0:adelanto_input);
    datosForm.append("observaciones_input", observaciones_input);
    datosForm.append("idCliente", idCliente);
    datosForm.append("idHabitacion", idHabitacion);


    const urlFormat = (new URLSearchParams(datosForm)).toString();    
    const config = {
        method: "POST",
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: urlFormat
    }
    return await fetch("/HotelRoma/registrarRecepcion", config).then((response)=>{
        if(response.ok){
            response.text().then((res)=>{
                let response = JSON.parse(res);
                if(response.status == "success"){
                    Swal.fire('Recepción registrada!', 'Se lo redirigirá al menú de recepción', 'success').then((r)=>{
                        if(r.isConfirmed){
                            location.href = "/HotelRoma/gestion/recepcion/";
                        }
                    })
                }
                console.log(response);
            })
            return true;
        }
    });
}