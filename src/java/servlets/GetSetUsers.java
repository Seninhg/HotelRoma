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


@WebServlet(name = "GetSetUsers", urlPatterns = {"/GetSetUsers"})
public class GetSetUsers extends HttpServlet {

    

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
        
            conexion cc = new conexion();
            Connection con = cc.conectar();
        
            JSONArray users = new JSONArray();
            JSONObject msg = new JSONObject();
            response.setContentType("application/json");
            
            try{
                String sql = "SELECT *, tp.Descripcion as 'tipoPersona' FROM usuarios as u INNER JOIN tipo_persona tp ON u.idTipoPersona = tp.idTipoPersona";
                Statement st = con.createStatement(); 
                ResultSet usuarios = st.executeQuery(sql);
                
                while (usuarios.next()){
                    JSONObject user = new JSONObject();
                    user.put("id", usuarios.getString("idUsuario"));
                    user.put("tipoDocumento", usuarios.getString("tipoDocumento"));
                    user.put("documento", usuarios.getString("documento"));
                    user.put("nombre", usuarios.getString("nombre"));
                    user.put("apell_paterno", usuarios.getString("apell_paterno"));
                    user.put("apell_materno", usuarios.getString("apell_materno"));
                    user.put("correo", usuarios.getString("correo"));
                    user.put("clave", usuarios.getString("clave"));
                    user.put("idTipo", usuarios.getString("idTipoPersona"));
                    user.put("tipo", usuarios.getString("tipoPersona"));
                    user.put("estado", usuarios.getString("estado"));
                    
                    users.put(user);
                }
                msg.put("status", "success");
                msg.put("content", users);
                
            }catch(Exception e){
                msg.put("status", "fail");
                msg.put("content", e.getMessage());
            }
            
            try(PrintWriter out = response.getWriter()){
                out.println(msg);
            }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * Para poder registrar a un usuario desde la propia plataforma
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
             conexion cc = new conexion();
             Connection con = cc.conectar();
            
            JSONObject msg = new JSONObject();
        
            String tipoDocumento = request.getParameter("tipoDocumento");
            String documento = request.getParameter("documento");
            String nombre = request.getParameter("nombre");
            String apell_paterno = request.getParameter("apell_paterno");
            String apell_materno = request.getParameter("apell_materno");
            String correo = request.getParameter("correo");
            String clave = request.getParameter("password");
            String idTipoPersona = request.getParameter("idTipoPersona");
            String estado = request.getParameter("estado");
            
            
            try {
                String SQL = "INSERT INTO  USUARIOS(tipoDocumento, documento, nombre, apell_paterno, apell_materno, correo, clave, idTipoPersona, estado) values (?,?,?,?,?,?,?,?, ?);";

                PreparedStatement pst = con.prepareStatement(SQL);
                pst.setString(1, tipoDocumento);
                pst.setString(2, documento);
                pst.setString(3, nombre);
                pst.setString(4, apell_paterno);
                pst.setString(5, apell_materno);
                pst.setString(6, correo);
                pst.setString(7, clave);
                pst.setString(8, idTipoPersona);
                pst.setByte(9, Byte.parseByte(estado));

                pst.execute();
                msg.put("status", "success");

            } catch (Exception e) {
                msg.put("status", "fail");
                msg.put("msg", e.getMessage());
            }
            
            response.setContentType("application/json");
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
