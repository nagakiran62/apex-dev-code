public class selectCmp {
@Auraenabled
    public static list<string> firstname(){
        
        list<string> lstfstname = new list<string> ();
        
        for(contact c : [select firstname from contact limit 10]){
            lstfstname.add(c.firstname);
        }
        
        return lstfstname;
    }
    
    
@Auraenabled
    public static list<contact> getContactdetails(){
      
        
        return [SELECT Id, firstname,lastname FROM contact limit 10];
    }
}