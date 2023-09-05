
package ownUtils;

public class SetFormat {    
    
    public  String formatDate(String date){
        String date2 = (date.split("\\s"))[0];
        String[] partsDate = date2.split("-");
        String formatDate = partsDate[2] + "/" + partsDate[1] + "/" + partsDate[0];
        return formatDate;
    }
    
}


