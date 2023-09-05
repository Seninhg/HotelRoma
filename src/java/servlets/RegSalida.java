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


@WebServlet(name = "RegSalida", urlPatterns = {"/RegSalida"})
public class RegSalida extends HttpServlet {

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
        
            JSONObject msg = new JSONObject();
            response.setContentType("application/json");
        
            /**
             * Por ahora no cambiaremos el estado del cliente, pues este podría pedir más habitaciones
             */
        
            //Variables obtenidas del request
            String idRecepcion = request.getParameter("idRecepcion");
            String idHabitacion = request.getParameter("idHabitacion");
            String idCliente = request.getParameter("idCliente");
            String totalPagado = request.getParameter("totalPagado");
            String costoPenalidad = request.getParameter("costoPenalidad");
            String fecha = request.getParameter("fecha");
            
            
            try{
                /**
                 * Por ahora no modificaremos el estado del cliente, pues hay una gran encrucijada respecto a eso
                 */
                //Actualizamos el estado de la habitación a limpieza
                String sql  = "UPDATE `habitaciones` SET `IdEstadoHabitacion`= 3 WHERE IdHabitacion = " + idHabitacion;
                Statement st = con.createStatement();
                st.executeUpdate(sql);
                //Actualización de la tabla recepción
                sql = "UPDATE `recepcion` SET `fechaSalidaConfirmacion`= ?,`totalPagado`= ?,`costoPenalidad`= ?,`estado`= 0 WHERE idRecepcion = "  + idRecepcion;
                PreparedStatement pst = con.prepareStatement(sql);
                pst.setString(1, fecha);
                pst.setString(2, totalPagado);
                pst.setString(3, costoPenalidad);
                pst.executeUpdate();
                //Ahora modificamos la columna estado de la tabla ventas cuyas columnas idRecepción coincidan con la recepción anteriormente cerrada
                sql = "UPDATE ventas SET estado = 0 WHERE idRecepcion = " + idRecepcion;
                st = con.createStatement();
                st.executeUpdate(sql);
                //finalmente eliminamos(supongo) aquellos registros de la tabla detalle_venta cuyas columnas idVenta coincida con la anterior modificada
                //primero conseguimos el id de la venta (Pudimos hacerlo desde el fronted pero no era tan eficiente?1)
                sql = "SELECT * FROM ventas WHERE idRecepcion = " + idRecepcion;
                st = con.createStatement();
                ResultSet venta = st.executeQuery(sql);
                String idVenta = null;
                while(venta.next()){
                    idVenta = venta.getString("idVenta");
                }
                //ahora hacemos eso que dijismos al principio
                sql = "DELETE FROM detalle_venta WHERE idVenta = " + idVenta;
                st = con.createStatement();
                st.executeUpdate(sql);
                
                msg.put("status", "success");
                msg.put("idVentaporEliminar",idVenta);
                
            }catch(Exception e){
                msg.put("status", "fail");
                msg.put("content", e.getMessage());
            }
            
            
            try(PrintWriter out = response.getWriter()){
               out.print(msg);
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
