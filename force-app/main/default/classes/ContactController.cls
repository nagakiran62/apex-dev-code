public class ContactController {

    @AuraEnabled
     public static String createContact(Contact con){
        try{
            insert con;
            return 'success';
        }catch (DmlException ex){
            return 'Unable to create contact' +ex.getMessage();
        }
    }
}