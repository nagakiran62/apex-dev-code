@Istest
public class LeadProcessorTest {
    
    @testSetup 
    static void setup(){
        
        List<Lead> lstleadtoInsert = new list<lead> ();
        
        for(integer i=0;i<200;i++){
            lstleadtoInsert.add(new Lead(Company='test',LastName='test' +i));
                                                 
        }
           insert lstleadtoInsert;
    }
    
    static testmethod void test() {  
        
        Test.startTest();
        LeadProcessor l1 = new LeadProcessor();
        Id batchId = Database.executeBatch(l1);
        Test.stopTest();
        
       // System.assertEquals(10, [select count() from Lead where LeadSource = 'Dreamforce']);
        
    }

}