@isTest
private class show_Tests {
    static testMethod void show_Helper_UnitTest(){
        Location__c testLocation = new Location__c(Name='LA');
        insert testLocation;

        Show__c testShow = testDataFactory.constructShow();
        Rate__c testRate = testDataFactory.constructRate();
        testRate.Location__c = testLocation.Id;
        insert testRate;
        testShow.Location__c = testLocation.Id;
        insert testShow;
        Contact testContact = testDataFactory.constructContact();
        insert testContact;
        Show_Contact__c testShowContact = testDataFactory.constructShowContact(testShow.Id, testContact.Id);

        insert testShowContact;



        List<show_Controller.Restriction> restrictions = new List<show_Controller.Restriction>();
        Show_Controller.Restriction r = new Show_Controller.Restriction();
        r.episode = 1;
        r.useOfName = true;
        r.Photo_Actual_Likeness = true;
        r.Excerpt_of_Performance_Digital = true;
        r.Excerpt_of_Performance_On_Air = true;
        r.BTS_Footage = true;
        r.Bloopers = true;
        r.info = 'adsfa';
        r.notes = 'dsaf';

        restrictions.add(r);

        Deal_Summary__c ds = new Deal_Summary__c(Type__c='Contract', Show_Contact__c = testShowContact.Id);
        ds.Talent_Restrictions__c = JSON.serialize(restrictions);
        insert ds;

        Show_Rate__c sr = new Show_Rate__c();
        sr.Show__c = testShow.Id;
        sr.Rate__c = testRate.Id;
        insert sr;

        test.startTest();
            testShow.ProductionIncentive__c = 'No';
            testShow.CentralProductions__c = 'Third Party';
            testShow.ProductionType__c = 'Comedy';
            testShow.Stunts__c = 'No';
            testShow.Minors__c = 'No';
        	testShow.Accountant_Needed__c = 'No';
        	update testShow;

            testShow.ProductionIncentive__c = 'Yes';
            testShow.CentralProductions__c = 'Central Productions';
            testShow.ProductionType__c = 'Drama';
            testShow.Stunts__c = 'Yes';
            testShow.Minors__c = 'Yes';
        	testShow.Accountant_Needed__c = 'Yes';
        	update testShow;

            Timecard__c testTimeCard = new TimeCard__c();
            testTimecard.show__c = testShow.Id;
            testTimecard.Employee_Name__c = testContact.FirstName+' '+testContact.LastName;
            insert testTimeCard;

            //testTimeCard = [SELECT Id, Show_Contact__c FROM TimeCard__c WHERE Id = :testTimecard.Id LIMIT 1];
            //system.assert(testTimeCard.Show_Contact__c == testShowContact.Id);

            //testTimeCard.Show_Contact__c = null;




            update testTimeCard;

            Show_Controller contr = new Show_Controller();
            contr.formName = 'dga';
            contr.showId = testShow.Id;

            Show_Controller contr1 = new Show_Controller();
            contr1.formName = 'sagaftra';
            contr1.showId = testShow.Id;

            Show_Controller contr2 = new Show_Controller();
            contr2.formName = 'talent list';
            contr2.showId = testShow.Id;


        test.stopTest();
    }
}