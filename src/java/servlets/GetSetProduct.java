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

@WebServlet(name = "GetSetProduct", urlPatterns = {"/GetSetProduct"})
public class GetSetProduct extends HttpServlet {

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
            
            //conexión a sql
            conexion cc = new conexion();
            Connection con = cc.conectar();
            //JsonArray
            JSONArray productsList = new JSONArray();
            JSONObject msg = new JSONObject();
            response.setContentType("application/json");
            
            try{
                String sql = "SELECT * FROM productos";
                Statement st = con.createStatement(); 
                ResultSet productos = st.executeQuery(sql);
                
                while (productos.next()){
                    JSONObject producto = new JSONObject();
                    producto.put("id", productos.getString("idProducto"));
                    producto.put("nombre", productos.getString("nombre"));
                    producto.put("detalle", productos.getString("detalle"));
                    producto.put("precio", productos.getString("precio"));
                    producto.put("cantidad", productos.getString("cantidad"));
                    producto.put("estado", productos.getString("estado"));
                    producto.put("fechaCreacion", productos.getString("fechaCreacion"));
                    
                    productsList.put(producto);
                }
                msg.put("status", "success");
                msg.put("content", productsList);
                
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
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            conexion cc = new conexion();
            Connection con = cc.conectar();
        
            JSONObject msg = new JSONObject();
            
            String nombre = request.getParameter("nombre");
            String detalle = request.getParameter("detalle");
            String precio = request.getParameter("precio");
            String cantidad = request.getParameter("cantidad");
            
            try{
            String sql = "INSERT INTO `productos`(`nombre`, `detalle`, `precio`, `cantidad`) VALUES (?,?,?,?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, nombre);
            pst.setString(2, detalle);
            pst.setString(3, precio);
            pst.setString(4, cantidad);

            pst.execute();
            msg.put("status", "success");
            
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
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
