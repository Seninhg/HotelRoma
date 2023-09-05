
package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/*DEPENDECIAS PARA LA BASE DE DATOS*/
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import modelo.conexion;
import org.json.*;

/**
 *
 * @author Lenovo
 */
@WebServlet(name = "RegVenta", urlPatterns = {"/RegVenta"})
public class RegVenta extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            try(PrintWriter out = response.getWriter()){
                out.print("GET METHOD NOT ALLOWED");
            }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
            conexion cc = new conexion();
            Connection con = cc.conectar();
            
            //respuesta
            JSONObject respuesta = new JSONObject();
            //nuestro objeto que contiene todo el cuerpo de nuestra consulta desde el fronted en formato JSON
            String JsonData = request.getParameter("data");
            JSONObject requestMsg = new JSONObject(JsonData);
            
            
            float totalCosto = requestMsg.getFloat("total");
            String idRecepcion = requestMsg.getString("idRecepcion");
            String estado = requestMsg.getString("status");
            
            try{
               
                //Ingresamos en la tabla ventas nuestro registro general
                String sql_insertRow = "INSERT INTO `ventas`(`idRecepcion`, `total`, `estado`) VALUES (?,?,?)";
            
                PreparedStatement pst = con.prepareStatement(sql_insertRow);
                pst.setString(1, idRecepcion);
                pst.setFloat(2, totalCosto);
                pst.setString(3, estado);

                pst.execute();
                //ahora intentamos conseguir el id del registro anterior, pero...... cómo???
                String sql_getIdRow = "SELECT idVenta FROM ventas WHERE idRecepcion = " + idRecepcion;
                Statement st = con.createStatement();
                ResultSet idRow = st.executeQuery(sql_getIdRow);
                //el resultset podría retornar varias filas, por lo que debemos obtener la última registrada
                if(idRow.last()){
                    String idVenta = idRow.getString("idVenta");
                    //AHORA PODEMOS INSERTAR EN LA TABLA DETALLE_VENTAS
                    String sql_insertDetail = "INSERT INTO `detalle_venta`(`idVenta`, `idProducto`, `cantidad`, `subTotal`) VALUES (?,?,?,?)";
                    
                    JSONArray habitaciones = requestMsg.getJSONArray("ventas_reg"); //obtenemos el array de habitaciones
                    //ahora lo recorremos e insertamos en la base de datos
                    for (Object myObject : habitaciones) {
                        JSONObject habitacion = (JSONObject) myObject;
                        //reemplazamos los ? con los datos de la habitacion
                        pst = con.prepareStatement(sql_insertDetail);
                        pst.setString(1, idVenta); //esto es constante
                        pst.setString(2, habitacion.getString("idDb"));
                        pst.setInt(3, habitacion.getInt("cantidad"));
                        pst.setFloat(4, habitacion.getFloat("subTotal"));
                        //ejecutamos la declaración
                        pst.execute();
                    }
                    
                    respuesta.put("status", "success");
                    respuesta.put("content", "Se ingresó correctamente el registro :)");
                }
                
            }catch(Exception e){
                respuesta.put("status", "fail");
                respuesta.put("content", e.getMessage());
            }
            
            response.setContentType("application/json");
            try(PrintWriter out = response.getWriter()){
                out.println(respuesta);
            }
            
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
