@isTest
private class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
   
    static testmethod void testScheduledJob() {
         List<lead> Leads = new list<lead> ();
       for (Integer i = 0; i < 200; i++) {
            Leads.add(new lead(
                lastname='Dream force'+i,
                company='test'
            ));
        }
        insert Leads;
        
         String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new DailyLeadProcessor());
        
        
    }       
         
       
         
}