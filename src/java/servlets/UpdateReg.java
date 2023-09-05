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
import java.sql.ResultSet;
import modelo.conexion;
import org.json.JSONObject;

/**
 *
 * @author Lenovo
 */
@WebServlet(name = "UpdateReg", urlPatterns = {"/UpdateReg"})
public class UpdateReg extends HttpServlet {

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
                out.print("<h1>GET METHOD NOT ALLOWED FOR THIS SERVLET</h1>");
            }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * Esta función permite hacer todo tipo de actualizaciones pasando como petición el sql a ejecutar
     * No retorna ningún tipo de dato, solo success o fail según sea el caso
     * Solo permite hacer una actualización por registro
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
            conexion cc = new conexion();
            Connection con = cc.conectar();
            
            JSONObject msg = new JSONObject();
            PrintWriter out = response.getWriter();
            

           if(request.getParameter("sqlQuery") != null){
               String sql = request.getParameter("sqlQuery");
               
                try{
                    Statement st = con.createStatement();
                    if(st.executeUpdate(sql) >= 1){
                        msg.put("status", "success");
                        msg.put("msg", "Actualización hecha con éxito");;
                    }
                }catch(Exception e){
                    msg.put("status", "fail");
                    msg.put("msg", e.getMessage());
                }
                
           }else{
               msg.put("status", "fail");
               msg.put("msg", "No  existe un parámetro sqlQuery!");
           }
           
           response.setContentType("application/json");
           out.print(msg);
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
