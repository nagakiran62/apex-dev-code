public class testDataFactory {

    public static Account constructAccount(){
        Account a = new Account();
        a.Name = 'Test';
        return a;
    }

    public static Contact constructContact(){
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Test';
        return c;
    }

    public static ContentVersion constructContentVersion(){
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'test.jpg',
            VersionData = Blob.valueOf('Test Content')
        );
        return testContentVersion;
    }

    public static Show_Contact__c constructShowContact(Id showId, Id contactId){
        Show_Contact__c sc = new Show_Contact__c();
        sc.Show__c = showId;
        sc.Contact__c = contactId;
        return sc;
    }

    public static Event constructEvent(Id whatId, Id whoId){
        Event e = new Event();
        e.Subject = 'Writing';
        e.StartDateTime = System.Now();
        e.End_DateTime__c = e.StartDateTime.addDays(5);
        e.Phase__c = 'Writing';
        if ( whatId != null ){
            e.WhatId = whatId;
        }
        if ( whoId != null ){
            e.whoId = whoId;
        }
        return e;
    }

    public static Task constructTask(Id whatId, Id whoId){
        Task e = new Task();
        e.Subject = 'Writing';
        e.ActivityDate = System.Today();
        e.Phase__c = 'Writing';
        if ( whatId != null ){
            e.WhatId = whatId;
        }
        if ( whoId != null ){
            e.whoId = whoId;
        }
        e.Field_To_Update__c = 'Name';
        return e;
    }

    public static Rate__c constructRate(){
        Rate__c testRate = new Rate__c();
        testRate.LengthofShow__c = '60 min';
        //testRate.Location__c = system.today();
        testRate.ProductionType__c = 'Pilot';
        testRate.Project_Type__c = 'Drama';
        testRate.Production_Company__c = 'Third Party';
        testRate.DGA_Agreement__c = 'FLLTA - SIdeletter 6';
        return testRate;
    }

    public static Show__c constructShow(){
        Show__c testShow = new Show__c();
        testShow.Name = 'Test Show';
        testShow.Writing_Period_Start_Date__c = system.today();
        testShow.Writing_Period_Complete_Date__c = system.today();
        testShow.Pre_Production_Start_Date__c = system.today();
        testShow.PreProductioncompletedate__c = system.today();
        testShow.Production_Start_Date__c = system.today();
        testShow.Production_Start_Date__c = system.today();
        testShow.Post_Production_Start_Date__c = system.today();
        testShow.PostProductionCompleteDate__c = system.today();
        testShow.ProductionIncentive__c = 'Yes';
        testShow.CentralProductions__c = 'Central Productions';
        testShow.ProductionType__c = 'Drama';
        testShow.Stunts__c = 'Yes';
        testShow.Minors__c = 'Yes';
        return testShow;
    }

}