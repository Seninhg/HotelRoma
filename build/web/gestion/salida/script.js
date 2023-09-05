window.addEventListener("load", ()=>{
    const costoPenalidad_input = document.getElementById("costoPenalidad_input");
    let costoPenalidad = 0;
    costoPenalidad_input.addEventListener("keyup",()=>{

        costoPenalidad = costoPenalidad_input.value;
        if(!isNaN(costoPenalidad)){
            if(costoPenalidad == ""){
                costoPenalidad = 0;
            }
            //debe convertirse todo en decimales pues me salta un **** de errores
            const newTotal = parseFloat(totalPagar) + parseFloat(costoPenalidad);
            updateTotalPagar(newTotal);
        }
        
    })

    //FUNCIÓN PARA ENVIAR EL FORMULARIO AL SERVLET DE RegSalida
    const btn_regSalida = document.getElementById("btn_regSalida");

    btn_regSalida.addEventListener("click", regSalida);
    function regSalida(){
        const formData = new FormData();
        //datos para la tabla recepcion
        formData.append("idRecepcion", idRecepcion);
        formData.append("idCliente", idCliente);
        formData.append("idHabitacion", idHabitacion);
        formData.append("totalPagado", totalPagar);
        formData.append("costoPenalidad", costoPenalidad);
        const d = new Date();
        const fechaActual = moment(d.getFullYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate(), "YYYY-MM-DD").format("YYYY-MM-DD");
        formData.append("fecha", fechaActual);
        
        

        console.log(formData);

        fetch("/HotelRoma/regSalida", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: (new URLSearchParams(formData)).toString()
        }).then(async (res)=>{
            const response = JSON.parse(await res.text());
            if(response.status == "success"){
                Swal.fire('Salida registrada!', 'será redireccionado a vista recepción', 'success').then((r)=>{
                    window.location.href = "/HotelRoma/gestion/recepcion";
                })
            }
        })
    }
        
})