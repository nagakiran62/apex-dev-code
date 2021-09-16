public class RandomContactFactory {

    Public static List<contact> generateRandomContacts(Integer num, string s){
        
        List<contact> lstcontacts = new List<contact> ();
        
        for(integer i =0;i<num;i++){
            
            Contact c = new contact();
            c.firstname ='Test' + i;
            c.LastName= s;
            lstcontacts.add(c);
        }
        
        return lstcontacts;
        
    }
}