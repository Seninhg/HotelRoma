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


@WebServlet(name = "GetSetCategoria", urlPatterns = {"/GetSetCategoria"})
public class GetSetCategoria extends HttpServlet {
        conexion cc = new conexion();
        Connection con = cc.conectar();
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
        JSONObject msg = new JSONObject();
        JSONArray categorias = new JSONArray();
        try{
            String sql =  "SELECT * FROM categoria";
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(sql);
            
            while(rs.next()){
                JSONObject categoria = new JSONObject();
                categoria.put("id", rs.getString("idCategoria"));
                categoria.put("descripcion", rs.getString("descripcion"));
                categoria.put("estado", rs.getString("estado"));

                categorias.put(categoria);
            }
            msg.put("status","success");
            msg.put("content", categorias);
        }catch(Exception e){
            msg.put("status", "fail");
            msg.put("msg", e.getMessage());
        }
        
        response.setContentType("application/json");
        try(PrintWriter out = response.getWriter()){
            out.print(msg);
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
        JSONObject msg = new JSONObject();
        
        String descripcion = request.getParameter("descripcion");
        String sql = "INSERT INTO `categoria`(`Descripcion`) VALUES (?)";
        try{
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, descripcion);
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
