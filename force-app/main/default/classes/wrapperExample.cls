public class wrapperExample{

 //Wrapper collection declared to hold both object values
  public List<innerWrapper> wrapAccountList = new list<innerWrapper> ();

 public list<innerWrapper> getvalues(){
  
  list<account> lstacc = new list<account> ();
  list<contact> lstrcon = new list<contact> ();
  lstacc= [select Id, Name,BillingState, Website, Phone from Account limit 10];
  
  lstrcon = [select Id, Name from Contact limit 10 ];

 for(integer i=0;i<10;i++){
 
 wrapAccountList.add(new innerWrapper(lstacc[i].name, lstrcon[i].name));
 }
 
 return wrapAccountList;
 
 }



 // This wrapper class contains both the salesforce standard object Account and contact
  public class innerWrapper{

 public string nameacc {get; set;}
  public string namecon{get; set;}

 public innerWrapper(string nam1, string nam2) {
  nameacc = nam1;
  namecon = nam2;

 }// end of constructor
  }// end of wrapper class
 }// end of class