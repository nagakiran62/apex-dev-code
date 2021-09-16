public class AccountCreate {

    public PageReference save() {
    
   partnerSoapSforceCom.Soap myconnec = new partnerSoapSforceCom.Soap();

partnerSoapSforceCom.LoginResult logindetails=
myconnec.login('nagakiran62@accenture.com','Wakeup@123hMx8Agm2MjpKFt4LV1mcNkaP');
system.debug('## the details'+logindetails.sessionid);

String Sessionid =  logindetails.sessionid;

soapSforceComSchemasClassAccountcre.SessionHeader_element headerinfo = new  soapSforceComSchemasClassAccountcre.SessionHeader_element();

headerinfo.sessionId =Sessionid ;

soapSforceComSchemasClassAccountcre.AccountCreate newacc = new  soapSforceComSchemasClassAccountcre.AccountCreate();

newacc.SessionHeader = headerinfo;

string result = newacc.CreateAccount(acc.name,acc.phone,acc.billingcity);

if(result == 'success'){
 insert acc;
 }
if(acc.id != null){
message='the record is been inserted in both applications';
 
 }
    
    
        return null;
    }


   Public Account acc{get; set;}
   
   Public string message{get; set;}
   
  

   public AccountCreate (){
   
   acc = new account();
    message = '';
   }
    

}