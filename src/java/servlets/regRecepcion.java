/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import modelo.conexion;
import org.json.*;


/**
 *
 * @author Lenovo
 */
@WebServlet(name = "regRecepcion", urlPatterns = {"/regRecepcion"})
public class regRecepcion extends HttpServlet {

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
            /**
             * Se debe hacer un registro en la base de datos recepcion
             * El estado de la habitación en la base de datos debe modificarse a ocupado
             */
            JSONObject msg = new JSONObject();
        
            //Conexión a base de datos
            conexion cc = new conexion();
            Connection con = cc.conectar();
        
            String fecha_entrada = request.getParameter("fecha_entrada");
            String fecha_salida = request.getParameter("fecha_salida");
            String precio_input = request.getParameter("precio_input");
            String adelanto_input = request.getParameter("adelanto_input");
            String observaciones_input = request.getParameter("observaciones_input");
            String idCliente = request.getParameter("idCliente");
            String idHabitacion = request.getParameter("idHabitacion");
            
            
            try{
                String sql = "INSERT INTO `recepcion`(`IdCliente`, `IdHabitacion`, `FechaEntrada`, `FechaSalida`, `FechaSalidaConfirmacion`, `PrecioInicial`, `Adelanto`, `PrecioRestante`, `TotalPagado`, `Observacion`) VALUES (?,?,?,?,?,?,?,?,?,?)";
                PreparedStatement pst = con.prepareStatement(sql);
                
                
                pst.setString(1, idCliente);
                pst.setString(2, idHabitacion);
                pst.setString(3, fecha_entrada);
                pst.setString(4, fecha_salida);
                pst.setString(5, null);
                pst.setString(6, precio_input);
                pst.setString(7, adelanto_input);
                //se calcula el monto restante a pagar restando el precio inicial - el adelanto
                String precioRestante = Float.toString(Float.parseFloat(precio_input) - Float.parseFloat(adelanto_input));
                
                pst.setString(8, precioRestante);
                //el totalPagado en este caso sería solo lo que el cliente adelantó, por defecto es 0 en db
                pst.setString(9, adelanto_input);
                if(observaciones_input == ""){
                    observaciones_input = "ninguno";
                }
                pst.setString(10, observaciones_input);
                
                pst.execute();
                
                //Actualización del estado de dicha habitación
                sql = "UPDATE `habitaciones` SET `IdEstadoHabitacion`= 2 WHERE IdHabitacion = " + idHabitacion;
                System.out.println(sql);
                Statement st = con.createStatement();
                int rowAfected = st.executeUpdate(sql);
                if(rowAfected == 1){
                    msg.put("status", "success");
                }
                
            } catch (Exception e){
                msg.put("status", "fail");
                msg.put("content", e.getMessage());
            }
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
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
