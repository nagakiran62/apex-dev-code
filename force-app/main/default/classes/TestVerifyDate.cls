@isTest
public class TestVerifyDate {
   
    @isTest static void testCheckDates() {
        
        Date d1 = Date.newInstance(2018, 1, 1);
        Date d2 = Date.newInstance(2018, 1, 18);
        
        VerifyDate.CheckDates(D1,D2);
        
        Date d3 = Date.newInstance(2018, 3, 1);
         VerifyDate.CheckDates(D1,D3);
    }
}