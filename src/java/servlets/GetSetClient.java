
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
@WebServlet(name = "GetSetClient", urlPatterns = {"/GetSetClient"})
public class GetSetClient extends HttpServlet {

     /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
            conexion cc = new conexion();
            Connection con = cc.conectar();
        
            JSONArray clients = new JSONArray();
            JSONObject msg = new JSONObject();
            response.setContentType("application/json");
            
            try{
                String sql = "SELECT * FROM clientes";
                Statement st = con.createStatement(); 
                ResultSet clientes = st.executeQuery(sql);
                
                while (clientes.next()){
                    JSONObject client = new JSONObject();
                    client.put("id", clientes.getString("idCliente"));
                    client.put("tipoDocumento", clientes.getString("tipoDocumento"));
                    client.put("documento", clientes.getString("documento"));
                    client.put("nombre", clientes.getString("nombre"));
                    client.put("apell_paterno", clientes.getString("apell_paterno"));
                    client.put("apell_materno", clientes.getString("apell_materno"));
                    client.put("correo", clientes.getString("correo"));
                    client.put("estado", clientes.getString("estado"));
                    clients.put(client);
                }
                msg.put("status", "success");
                msg.put("content", clients);
                
            }catch(Exception e){
                msg.put("status", "fail");
                msg.put("content", e.getMessage());
            }
            
            try(PrintWriter out = response.getWriter()){
                out.println(msg);
            }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            JSONObject result = new JSONObject();
            String nombre = request.getParameter("nombre");
            String apell_paterno = request.getParameter("apell_paterno");
            String apell_materno = request.getParameter("apell_materno");
            String correo = request.getParameter("correo");
            String tipo_documento = request.getParameter("tipo_documento");
            String documento = request.getParameter("documento");
            
            conexion cc = new conexion();
            Connection con = cc.conectar();
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            try {
                String SQL = "INSERT INTO  CLIENTES(tipoDocumento, documento, nombre, apell_paterno, apell_materno, correo) values (?,?,?,?,?,?);";

                PreparedStatement pst = con.prepareStatement(SQL);
                pst.setString(1, tipo_documento);
                pst.setString(2, documento);
                pst.setString(3, nombre);
                pst.setString(4, apell_paterno);
                pst.setString(5, apell_materno);
                pst.setString(6, correo);

                pst.execute();
                result.put("status", "success");

            } catch (Exception e) {
                result.put("status", "fail");
                result.put("message", e.getMessage());
            }
            out.print(result);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "registrar clientes en la base de datos clientes";
    }// </editor-fold>

}