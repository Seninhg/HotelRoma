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
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import modelo.conexion;

/*DEPENDENCIA PARA MANEJAR JSON*/
import org.json.*;


@WebServlet(name = "GetSetRooms", urlPatterns = {"/getListRooms"})
public class GetSetRooms extends HttpServlet {
    conexion cc = new conexion();
    Connection con = cc.conectar();

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
            response.setContentType("application/json");
            
            JSONObject msg = new JSONObject();
            try {
                String sql = "SELECT h.IdHabitacion as 'id', h.numero as 'numero', h.detalle as 'detalle', h.precio as 'precio', h.idCategoria as 'idCategoria', ca.Descripcion 'categoria', es.Descripcion as 'estadoHabitacion', h.Estado as 'estado' FROM `habitaciones` h INNER JOIN categoria ca ON ca.IdCategoria = h.IdCategoria INNER JOIN estado_habitacion es WHERE es.IdEstadoHabitacion = h.IdEstadoHabitacion; ";
                Statement st = con.createStatement();
                ResultSet habitaciones = st.executeQuery(sql);
                //arreglo que almacenará los objetos
                JSONArray listaHabitaciones = new JSONArray();
                
                while(habitaciones.next()){
                    //creamos un objeto habitación con sus propiedades
                    JSONObject habitacion = new JSONObject();
                    habitacion.put("id", habitaciones.getString("id"));
                    habitacion.put("numero", habitaciones.getString("numero"));
                    habitacion.put("detalle", habitaciones.getString("detalle"));
                    habitacion.put("precio", habitaciones.getString("precio"));
                    habitacion.put("categoria", habitaciones.getString("categoria"));
                    habitacion.put("idCategoria", habitaciones.getString("idCategoria"));
                    habitacion.put("estadoHabitacion", habitaciones.getString("estadoHabitacion"));
                    habitacion.put("estado", habitaciones.getString("estado"));
                    
                    //ingresamos la habitación al array
                    listaHabitaciones.put(habitacion);
                }
                msg.put("status", "success");
                msg.put("content", listaHabitaciones);

            } catch (Exception e) {
                msg.put("statuts", "fail");
                msg.put("msg", e.getMessage());
            }
            
            PrintWriter out = response.getWriter();
            out.print(msg);
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
        JSONObject msg = new JSONObject();

        String numero = request.getParameter("numero");
        String detalle = request.getParameter("detalle");
        String precio = request.getParameter("precio");
        String idCategoria = request.getParameter("categoria");
        String estado = request.getParameter("estado");

        try{
            String sql = "INSERT INTO `habitaciones`(`Numero`, `Detalle`, `Precio`, `IdCategoria`, `Estado`) VALUES (?,?,?,?,?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, numero);
            pst.setString(2, detalle);
            pst.setString(3, precio);
            pst.setString(4, idCategoria);
            pst.setByte(5, Byte.parseByte(estado));
            
            pst.execute();
            msg.put("status", "success");
        }catch(Exception e){
            msg.put("status", "fail");
            msg.put("msg", e.getMessage());
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
