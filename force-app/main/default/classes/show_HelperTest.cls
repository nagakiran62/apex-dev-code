@isTest
private class show_HelperTest {
    public static testMethod void Testmethod1() {
    
     
     List<Show__c> newShowList = new List<show__c>();
        Show__c testShow = new Show__c();
        testShow.Name = 'Test Show';      
        testShow.CentralProductions__c = 'Central Productions';
        testShow.ProductionType__c = 'Drama';
        testShow.Minors__c ='Yes';
        testShow.CameraUsageType__c = 'Single Camera';
        testShow.Stunts__c ='Yes';
         newShowList.add(testShow);
         Show__c testShow1 = new Show__c();
        testShow1.Name = 'Test Show';      
        testShow1.CentralProductions__c = 'Central Productions';
        testShow1.ProductionType__c = 'Animation';        
        testShow1.CameraUsageType__c = 'Multi Camera';
        testShow1.Minors__c ='Accountant Needed';
        testShow1.Stunts__c ='Yes';
        newShowList.add(testShow1); 
               insert newShowList;

        Test.startTest();
        show_Helper.beforeInsert(newShowList);        
        Test.stopTest();
        
    
    }
      public static testMethod void Testmethod2() {
    
     
     List<Show__c> newShowList = new List<show__c>();
        Show__c testShow = new Show__c();
        testShow.Name = 'Test Show';      
        testShow.CentralProductions__c = 'Central Productions';
        testShow.ProductionType__c = 'Drama';
        testShow.ProductionIncentive__c = 'Yes';
        testShow.CameraUsageType__c = 'Single Camera';
        testShow.Minors__c ='Yes';
        testShow.Stunts__c ='Yes';
         newShowList.add(testShow);
         Show__c testShow1 = new Show__c();
        testShow1.Name = 'Test Show';      
        testShow1.CentralProductions__c = 'Central Productions';
        testShow1.ProductionType__c = 'Animation';        
        testShow1.CameraUsageType__c = 'Multi Camera';
        testShow1.Minors__c ='Accountant Needed';
        testShow1.Stunts__c ='Yes';
        newShowList.add(testShow1); 
               insert newShowList;

        List<Contact> clist = new List<Contact>();
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'TestL';
        c.Is_Global__c = TRUE;
        clist.add(c);
        Contact c1 = new Contact();
        c1.FirstName = 'Testw3';
        c1.LastName = 'TestL';
        c1.Is_Global__c = TRUE;
        clist.add(c1);
        insert clist;
        
        
        Show_Contact__c c2 = new Show_Contact__c();
                c2.Show__c = newShowList[0].Id;
                c2.Contact__c = clist[0].Id;
                insert c2;
                
  Location__c testLocation = new Location__c(Name='LA');
        insert testLocation;   
        List<Show__c> shwLstOld = new List<Show__c>();           
                Show__c sh = new Show__c ();
sh.Name = 'Anything';
sh.LengthofShow__c = '60 min';
sh.Location__c = testLocation.Id;
sh.ProductionType__c = 'Pilot';
sh.Project_Type__c = 'Drama';
//sh.Production_Company__c = 'Third Party';
insert sh;
shwLstOld.add(sh);

 Rate__c testRate = new Rate__c();
        testRate.LengthofShow__c = '60 min';
        testRate.Location__c = testLocation.Id ;
        testRate.ProductionType__c = 'Pilot';
        testRate.Project_Type__c = 'Drama';
        testRate.Production_Company__c = 'Third Party';
        testRate.DGA_Agreement__c = 'FLLTA - SIdeletter 6';
        insert testRate;
        
        Show_Rate__c shwRate = new Show_Rate__c();
        shwRate.Name = 'FLLTA - SIdeletter 6';
        shwRate.Rate__c = testRate.Id;
        shwRate.Show__c = sh.Id;
        insert shwRate;
        
        Show_Task__mdt shwmdt = new Show_Task__mdt ();
        //shwmdt.Label= 'sample';
        //insert shwmdt;
        Task t = new Task(WhatId = newShowList[0].Id);
                t.Subject = 'Production Incentive';
                t.Type = shwmdt.Type__c;
                t.Email_Template_Id__c = shwmdt.Email_Template_Id__c;
                t.Field_To_Update__c = shwmdt.Field_Name__c;
                t.File_Type__c = shwmdt.File_Type__c;
        insert t;
                Map<Id,Show__c> mapShw = new Map<Id,Show__c>();
        mapShw.put(testShow.Id,testShow);
        mapShw.put(testShow1.Id,testShow1);
        
        Test.startTest();
        show_Helper.afterInsert(newShowList);
        show_Helper.compileShowRates(sh);   
        show_Helper.compileShowTasks(mapShw);
        //show_Helper.afterUpdate(newShowList,shwLstOld);
        Test.stopTest();
        
    
    }
    
    
    }