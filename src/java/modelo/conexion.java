
package modelo;

import com.mysql.jdbc.Connection; //importado de la librería externa
import java.sql.DriverManager; //Driver para conectar 
import javax.swing.JOptionPane; //esto es solo para mostrar alertas o mensajes

public class conexion {
    private final String database = "hotel_roma";
    private final String server = "jdbc:mysql://localhost/" + database;
    private final String user = "root";
    private final String password = "";
    
    public Connection conectar(){
        Connection conectar = null;
        try{
            Class.forName("com.mysql.jdbc.Driver");
            conectar = (Connection) DriverManager.getConnection(server, user, password); //se realiza la conexión apuntando al localhost con usuario root
            
        }catch(Exception e){ //en caso no hay una conexión, entonces se muestra este error por ventana con JOptionPane
            JOptionPane.showMessageDialog(null, "Error de conexión" + e.getMessage());
        }
        
        return conectar;
        
    
    }
    
}
