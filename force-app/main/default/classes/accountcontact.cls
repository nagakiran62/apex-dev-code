public class accountcontact {
    
    @auraenabled
    public static account displayaccount(string searchvalue){
        
        account a =[select id,name,phone from account where name= :searchvalue limit 1];
        
        system.debug('the value of s' +a);
        
        return a;
        
    }

    @AuraEnabled (cacheable=true)
    public static list<accwrapper> displayacccontact(){

        list<accwrapper> lstaccwrapper = new list<accwrapper>();
        for(account a :[select id,name, (select id,name from contacts) from account limit 50]){
            accwrapper acc = new accwrapper(a.name,a.contacts);
            lstaccwrapper.add(acc);
        }
        return lstaccwrapper;
    }// end of methiod

    public class accwrapper{
        public list<Contact> con {get;set;}
        public string name {get;set;}

        public accwrapper(string name,list<Contact> con){
           this.name = name;
           this.con=con;
        }
    }

}