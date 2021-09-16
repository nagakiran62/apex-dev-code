@isTest
private class lightning_Tests {

    @testSetup
    static void setupTestData(){

        Account a = new Account(Name = 'Test');
        insert a;

        insert new Contact(FirstName = 'test', LastName = 't', AccountId = a.Id, email = 'test@example.com');

        Show__c testShow = testDataFactory.constructShow();
        insert testShow;

        Event testEvent = testDataFactory.constructEvent(testShow.Id,null);
        insert testEvent;

        Task testTask = testDataFactory.constructTask(testShow.Id,null);
        insert testTask;

        Budget_Item__c testBudgetItem = new Budget_Item__c();
        testBudgetItem.Show__c = testShow.Id;
        testBudgetItem.Amount__c = 1;
        testBudgetItem.Type__c = 'Budget';
        insert testBudgetItem;

        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'test.jpg',
            VersionData = Blob.valueOf('Test Content')
        );
        insert testContentVersion;
    }

    static testMethod void createEventForContent_UnitTest(){
        Show__c testShow = [SELECT Id FROM Show__c LIMIT 1];
        ContentVersion testContentVersion = [SELECT Id, Title, ContentDocumentId FROM ContentVersion LIMIT 1];

        List<lightning_Controller.contentWrapper> contentList = new List<lightning_Controller.contentWrapper>{
            new lightning_Controller.contentWrapper()
        };
        contentList[0].ContentDocumentId = testContentVersion.ContentDocumentId;
        contentList[0].title='test';

        contentList[0].versionId = testContentVersion.Id;
        test.startTest();
            lightning_Controller.createEventForContent(testShow.Id, system.now(), 'Test', JSON.serialize(contentList), null);
        test.stopTest();
    }

            
    static testMethod void saveTasks_UnitTest(){
        test.startTest();
            lightning_Controller.saveTasks(new List<Task>{ testDataFactory.constructTask(null,null)});
        test.stopTest();
    }

    static testMethod void saveShowFile_UnitTest(){
        Show__c testShow = [SELECT Id FROM Show__c LIMIT 1];
        test.startTest();
            lightning_Controller.saveShowFile(testShow.Id, 'fileName', EncodingUtil.base64Encode(blob.valueOf('base64Data')), 'text', '2017-08-08', 'Test');
        test.stopTest();
    }


    static testMethod void sendMailMethod_UnitTest(){
        test.startTest();
            lightning_Controller.sendMailMethod('test@mkpartners.com','test','test');
        test.stopTest();
    }

    static testMethod void deleteRecord_UnitTest(){
        Task testTask = [SELECT Id FROM Task LIMIT 1];
        test.startTest();
            lightning_Controller.deleteRecord(testTask.Id);
        test.stopTest();
    }


    static testMethod void queryTaskAndShow_UnitTest(){
        Task testTask = [SELECT Id FROM Task LIMIT 1];
        test.startTest();
            lightning_Controller.queryTaskAndShow(testTask.Id);
        test.stopTest();
    }


    static testMethod void queryGanttChart_UnitTest(){
        Show__c testShow = [SELECT Id FROM Show__c LIMIT 1];
        test.startTest();
            lightning_Controller.queryGanttChart(testShow.Id);
        test.stopTest();
    }

    static testMethod void queryActiveShows_UnitTest(){
        test.startTest();
            lightning_Controller.queryActiveShows();
        test.stopTest();
    }

    static testMethod void queryFiles_UnitTest(){
        Show__c testShow = [SELECT Id FROM Show__c LIMIT 1];
        test.startTest();
            lightning_Controller.queryFiles(testShow.Id);
        test.stopTest();
    }

    static testMethod void queryBudgetItems_UnitTest(){
        Show__c testShow = [SELECT Id FROM Show__c LIMIT 1];
        test.startTest();
            lightning_Controller.queryBudgetItems(testShow.Id);
        test.stopTest();
    }

    static testMethod void upsertBudgetItems_UnitTest(){
        List<Budget_Item__c> budgetItems = [SELECT Id, Name, AMount__c FROM Budget_Item__c];
        test.startTest();
            lightning_Controller.upsertBudgetItems(budgetItems);
        test.stopTest();
    }

    static testMethod void queryTasks_UnitTest(){
        Show__c testShow = [SELECT Id FROM Show__c LIMIT 1];
        test.startTest();
            lightning_Controller.queryTasks(testShow.Id, true, null, null);
        test.stopTest();
    }

    static testMethod void showContact_UnitTest(){
        Show__c testShow = [SELECT Id FROM Show__c LIMIT 1];
        Contact c = [SELECT Id FROM Contact LIMIT 1];

        test.startTest();
            List<Show_Contact__c> cs = new List<Show_Contact__c>();
            cs.add(new Show_Contact__c(Show__c = testShow.Id, Contact__c = c.Id, Type__c = 'BALA'));
            cs.add(new Show_Contact__c(Show__c = testShow.Id, Contact__c = c.Id, Type__c = 'IP Lit'));
            cs.add(new Show_Contact__c(Show__c = testShow.Id, Contact__c = c.Id, Type__c = 'MML'));
            cs.add(new Show_Contact__c(Show__c = testShow.Id, Contact__c = c.Id, Type__c = 'Production Executive'));

            insert cs;

            update cs;
        test.stopTest();

    }

    static testMethod void mergeTemplateTest(){
        //EmailTemplate template = [SELECT Id, FROM EmailTemplate];
        //Account a = 
        //id folderId = [SELECT Id FROM Folder WHERE Name = 'Shared Documents'].Id;

        //EmailTemplate e = new EmailTemplate (developerName = 'test', TemplateType= 'Text', Name = 'test', FOlderId = folderId); // plus any other fields that you want to set
        //insert e;
        EmailTemplate e = [SELECT Id FROM EmailTemplate LIMIT 1];

        lightning_Controller.getMergeEmailTemplate(e.Id, null);
        //EmailTemplate validEmailTemplate = new EmailTemplate();
        //validEmailTemplate.isActive = true;
        //validEmailTemplate.Name = 'name';
        //validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
        //validEmailTemplate.TemplateType = 'text';
        //validEmailTemplate.FolderId = UserInfo.getUserId();

        //insert validEmailTemplate;
    }
      static testMethod void queryPaymentDetails_Test(){
       Show__c testShow = [SELECT Id FROM Show__c LIMIT 1];
       List<Payment_Details__c> pd = new List<Payment_Details__c>();  
          pd.add(new Payment_Details__c(Show__c = testShow.Id ));
          //Budget_Person__c budgetPerson = [SELECT Id ,Show__c FROM Budget_Person__c LIMIT 1]; 
          List<Budget_Person__c> pd1 = new List<Budget_Person__c>();  
          pd1.add(new Budget_Person__c(Show__c = testShow.Id ));
          
          List<Budget_rental__c> br = new List<Budget_rental__c>();  
          br.add(new Budget_rental__c(Show__c = testShow.Id ));      
        test.startTest();
        lightning_Controller.queryPaymentDetails(testShow.Id,'Budget');
        lightning_Controller.queryBudgetPeople(testShow.Id); 
        lightning_Controller.queryBudgetRentals(testShow.Id);
        lightning_Controller.upsertPaymentDetails(pd);
        lightning_Controller.upsertBudgetRentals(br);
        lightning_Controller.upsertBudgetPeople(pd1);
        test.stopTest();  
      }
    
    static testMethod void saveShow_Test(){
        Show__c testShow1 = testDataFactory.constructShow();
        insert testShow1;
        
        Event testEvent = testDataFactory.constructEvent(testShow1.Id,null);
        insert testEvent;
        
        Task testTask = testDataFactory.constructTask(testShow1.Id,null);
        insert testTask;
        
        Budget_Item__c testBudgetItem = new Budget_Item__c();
        testBudgetItem.Show__c = testShow1.Id;
        testBudgetItem.Amount__c = 1;
        testBudgetItem.Type__c = 'Budget';
        insert testBudgetItem;
        
    Show__c testShow = [SELECT Id FROM Show__c LIMIT 1];
    lightning_Controller.saveShow(testShow);
     lightning_Controller.temptaskMethod(testShow.Id);
   // List<Contact> cont = new List<Contact>();
    //cont.add(new Contact());
      //  insert cont;
    ContentVersion cv=new Contentversion();
    cv.title='ABC';
    cv.PathOnClient ='test';
    Blob b=Blob.valueOf('Unit Test Attachment Body');
    cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
    cv.Type__c    = 'test';
    //cv.parentId = testShow.Id;
    //cv.ContentDocumentId = '069m0000000Bc89AAC';
    insert cv;
        
        FeedItem fi = new FeedItem();
        fi.Type = 'ContentPost';
        fi.RelatedRecordId = cv.Id;
        fi.parentId = testShow.Id;
        insert fi;
         lightning_Controller.insertFileAndLink(testShow.Id ,'Unit Test Attachment Body' ,'test','ABC','test');
         //lightning_Controller.getDocumentData(cv.ContentDocumentId);
         //lightning_Controller.upsertbudgetOverage(testBudgetItem ,testShow1.Id);
        }
  /*   static testMethod void generateCashflow_Test(){
      Show__c testShow = [SELECT Id FROM Show__c LIMIT 1];
      String content = '';
      content =  EncodingUtil.base64Encode( new PageReference('/apex/cashflowExport?&showId='+ testShow.Id ).getContent() );
       lightning_Controller.generateCashflow(testShow.Id);
     }   */
     static testMethod void insertContacts_Test(){
       List<Contact> con = new List<Contact>();  
          con.add(new Contact());
     lightning_Controller.insertContacts(con);
     }    
     static testMethod void insertAttachments_Test(){
      Show__c testShow = [SELECT Id FROM Show__c LIMIT 1];       
        Attachment a = new Attachment();
        a.Body = EncodingUtil.base64Decode('base64HtmlString');
        a.ParentId = testShow.Id;
        a.ContentType = 'text/plain';
        a.Name = 'htmlBody';
        insert a;
         lightning_Controller.insertAttachment(testShow.Id ,'base64HtmlString'); 
     }   
        static testMethod void booster(){
    test.startTest();
    lightning_Controller.boosterMethod();
    test.stopTest();
    }
    
}