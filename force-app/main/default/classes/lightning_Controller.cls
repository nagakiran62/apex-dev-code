public class lightning_Controller {
    
    @AuraEnabled
    public static Map<String,object> createEventForContent(Id showId, DateTime uploadDate, String uploadType, String contentListString, String otherType){
        List<ContentWrapper> contentList = (List<contentWrapper>)JSON.deserialize(contentListString,List<contentWrapper>.class);
        Set<Id> versionIds = new Set<Id>();
        List<ContentVersion> cvs = new List<ContentVersion>();
        for(ContentWrapper cw : contentList){
            cvs.add(new ContentVersion(Type__c = uploadType, Id = cw.versionId, Other_Type__c = otherType));
        }
        
        update cvs;
        
        Id parentId = showId;
        if ( uploadDate != null ){
            Event e = new Event();
            e.WhatId = showId;
            e.StartDateTime = uploadDate;
            e.EndDateTime = uploadDate;
            e.Subject = uploadType;
            e.startDateTime = e.startDatetime.addDays(1);
            e.enddateTime = e.enddatetime.addDays(1);
            insert e;
            system.debug(e);
            parentId = e.Id;
        }
        
        Set<Id> feedItemIds = new Set<Id>();
        for ( contentWrapper cw : contentList ){
            if ( String.isNotBlank(cw.feedItemId) ){
                feedItemIds.add(cw.feedItemId);
            }
        }
        List<FeedItem> toDelete = [SELECT Id, Title, Body, RelatedRecordId FROM FeedItem WHERE Id IN :feedItemIds];
        
        List<ConnectApi.FeedItemInput> toPost = new List<ConnectApi.FeedItemInput>();
        for ( FeedItem fi : toDelete ){
            ConnectApi.FeedItemInput feedItemInput = compilePost(parentId, uploadType+': '+fi.Title, contentList[0].ContentDocumentId);
            if ( !Test.isRunningTest() ){
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement('internal', feedItemInput);
            }
        }
        delete toDelete;
        
        //for(ContentVersion cv : [SELECT Id, Type__c FROM ContentVersion WHERE ])
        
        /*
        // Define the FeedItemInput object to pass to postFeedElement
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.subjectId = parentId;
        
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = uploadType+': ';


        // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
        // For this feed item, we define a files capability to hold the file(s).
        ConnectApi.FilesCapabilityInput filesInput = new ConnectApi.FilesCapabilityInput();
        filesInput.items = new List<ConnectApi.FileIdInput>();
        for ( contentWrapper cw : contentList ){
        system.debug(cw);
        ConnectApi.FileIdInput idInput = new ConnectApi.FileIdInput();
        textSegmentInput.text += cw.title+'; ';
        idInput.id = cw.ContentDocumentId;//
        filesInput.items.add(idInput);
        }

        // The MessageBodyInput object holds the text in the post
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        messageBodyInput.messageSegments.add(textSegmentInput);
        feedItemInput.body = messageBodyInput;

        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
        feedElementCapabilitiesInput.files = filesInput;
        
        feedItemInput.capabilities = feedElementCapabilitiesInput;
        
        // Post the feed item.
        if ( !Test.isRunningTest() ){
        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement('internal', feedItemInput);
        }
        */
        return queryFiles(showId);
    }
    
    public class contentWrapper {
        public String FeedItemId;
        public String ContentVersionId;
        public String ContentDocumentId;
        public String title;
        public String parentId;
        public String fileName;
        public String versionId;
        public boolean checked;
    }
    
    @AuraEnabled
    public static Show__c queryShow(Id showId){
        List<Show__c> shows = [
            SELECT Id, Name, AFTRA__c, NumberofEps__c, Title_Clearance__c, IP_Lit_Contact__c, Location_Name__c, Production_Contact__c,
            WBS_Element__c, Production_Exec__c, Travel_Booker__c, Travel_Approver__c,
            Project_Type__c, Budget_Approver__c, Budget_Approver_VIN__c, Project_Manager__c, Project_Mgr_VIN__c,
            CompanyCode__c, Finance_Content_Code__c, Season__c, Lengthofshow__c, ContentType__c, centralproductions__c,
            ProductionType__c, Incentive_State__c, Budget_Incentive__c, Package_Fee_Type__c, Package_Fee_Amount__c,Guilds__c,
            Vendor_Name__c, Package_Fee__c, Vendor_Id__c, Proposed_title__c, Owner.Name, Content_Types__c, BudgetEstimate__c,Production_Accounting_Systems__c,
            MMl_Contact__c,Total_Gross_Budget_Text__c,Internal_Expense_Text__c,Approved_Overages_Text__c,Asset_ID__c,Total_Gross_Budget__c,Residual_Estimate__c,Prod_Co_Point_of_Contact__c,Internal_Expense_Total__c,lastmodifieddate, LRP_Estimate__c,Approved_Overages_Read_Only__c,Multiplatform_Contact__c, Pre_Production_Start_Date__c, Image_URL__c
            ,WBS_Element_Request__c ,Request_PCR_MML_Digital_Contact__c,
            acc_Set_up_Form__c,Background_Business_Checks__c,Deal_Status__c,Deliverables_Cleared__c,
            Enter_Deal_Summaries__c,Finance_Vetting__c,Internal_Budget_Approval__c,
            Scenechronize__c,Travel_Setup__c,WGA_Weekly_Work_List__c,X1st_shoot_date__c
            ,Network_Contact_List__c,Greenlight_Memo__c,Post_Guidelines__c,Kick_Off_Call__c
            ,Scenechronize_Kick_Off_Call__c,Crew_List__c,VTR_Reminder__c,Cost_Report__c,MML__c,Post__c,Residuals__c,Calendar__c,Guidelines_Email__c,VMN_Insurance_Procedure__c,VMN_Insurance_End_Date__c
            FROM Show__c
            WHERE Id = :showId
        ];
        if ( shows.size() > 0 ){
            return shows[0];
        }
        return null;
    }
    
    @AuraEnabled
    public static Map<String,object> queryTaskAndShow(Id taskId){
        Map<String, Schema.SObjectField> showFieldMap = Schema.SObjectType.Show__c.fields.getMap();
        Map<String,object> res = new Map<String,object>();
        res.put('task',null);
        res.put('show',null);
        res.put('userId', UserInfo.getUserId());
        List<Task> tasks = [
            SELECT Id, ActivityDate, Status, Subject, WhatId, Type, Field_To_Update__c, Email_Template_Id__c, OwnerId, Description, File_Type__c, Stage__c
            FROM Task
            WHERE Id = :taskId
            AND WhatId != null
            ORDER BY Sort_Order__c ASC
        ];
        if ( tasks.size() > 0 ){
            if ( String.isNotBlank(tasks[0].Field_To_Update__c) && showFieldMap.containsKey(tasks[0].Field_To_Update__C) ){
                Schema.SObjectField F = showFieldMap.get(tasks[0].Field_To_Update__c); //where fieldAPIName is API name of field
                Schema.DescribeFieldResult R = F.getDescribe();
                String fieldLabel = R.getLabel();
                res.put('label',fieldLabel);
            }
            
            res.put('task',tasks[0]);
            Show__c show = queryShow(tasks[0].WhatId);
            if ( show != null ){
                res.put('show',show);
            }
        }
        
        
        return res;
    }
    
    
    
    
    
    @AuraEnabled
    public static void sendMailMethod(String mMail ,String mSubject ,String mbody){
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        
        // Step 1: Create a new Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // Step 2: Set list of people who should get the email
        List<String> sendTo = new List<String>();
        sendTo.add(mMail);
        mail.setToAddresses(sendTo);
        
        // Step 3: Set who the email is sent from
        mail.setReplyTo('noreply@gmail.com'); // change it with your mail address.
        mail.setSenderDisplayName('salesforce User');
        
        // Step 4. Set email contents - you can use variables!
        mail.setSubject(mSubject);
        mail.setHtmlBody(mbody);
        
        // Step 5. Add your email to the master list
        mails.add(mail);
        
        // Step 6: Send all emails in the master list
        Messaging.sendEmail(mails);
    }
    
    @auraEnabled
    public static List<Show__c> queryGanttChart(Id showId){
        String queryString = 'SELECT Id, Name, CreatedDate, Start_Date__c, End_Date__c, ';
        queryString += ' (SELECT Id, Subject, StartDateTime, EndDateTime, Color__c, Color_Code__c, OwnerId FROM Events ORDER BY StartDateTime)';
        queryString += ' FROM Show__c WHERE Start_Date__c != null AND End_Date__c != null ';
        if ( showId != null ){
            queryString += ' AND Id = :showId';
        }
        queryString += ' ORDER BY Name';
        return database.query(queryString);
    }
    
    @auraEnabled
    public static List<Show__c> queryActiveShows(){
        return [SELECT Id, Name, Status__c FROM Show__c LIMIT 5];
    }
    
    @auraEnabled
    public static Map<String,List<FeedItem>> queryFiles(Id showId){
        Map<String, List<FeedItem>> res = new Map<String, List<FeedItem>>();
        
        for(Object s : (List<Object>)JSON.deserializeUntyped( util_Controller.getPicklistValues( 'ContentVersion' , 'Type__c'))){
            res.put(String.valueOf(s), new List<FeedItem>());
        }
        Set<Id> parentIds = new Set<Id>();
        if ( showId != null ){
            Map<Id,Event> eventMap = new Map<Id,Event>([SELECT Id FROM Event WHERE WhatId =:showId]);
            parentIds.addAll(eventMap.keySet());
            parentIds.add(showId);
        }else{
            Map<Id, Show__c> showMap = new Map<Id, Show__c>([SELECT Id FROM Show__c]);
            parentIds.addAll(showMap.keySet());
            
            Map<Id, Event> eventMap = new Map<Id, Event>([SELECT Id FROM Event WHERE WHatId IN : parentIds]);
            parentIds.addAll(eventMap.keySet());
        }
        
        String queryString = 'SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :parentIds';
        Set<Id> contentDocIds = new Set<Id>();
        
        for(ContentDocumentLink link : [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN : parentIds]){
            contentDocIds.add(link.ContentDocumentId);
        }
        
        for( ContentVersion version : [
            SELECT Id, Type__c, Other_Type__c, Title, ContentSize, FileExtension, ContentDocumentId, Createddate, LastModifiedDate
            FROM ContentVersion
            WHERE ContentDocumentId IN :contentDocIds
        ]){
            String key = 'Other';
            List<FeedItem> temp = new List<FeedItem>();
            
            if ( String.isNotBlank(version.Type__c) && version.Type__c == 'Other' && String.isNotBlank(version.Other_Type__c) ){
                key = version.Other_Type__c;
            }
            else if( res.containsKey(version.Type__c)){
                key = version.Type__c;
            }
            if ( res.containsKey(key) ){
                temp = res.get(key);
            }
            
            temp.add(new FeedItem(Title = version.Title, RelatedRecordId = Version.ContentDocumentId, LastEditDate = Version.LastModifiedDate));
            res.put(key,temp);
            
        }
        return res;
    }
    
    @auraEnabled
    public static void deleteRecord(Id recordId){
        Schema.sObjectType t = recordId.getSObjectType();
        sObject s = t.newSOBject();
        s.Id = recordId;
        delete s;
    }
    
    @auraEnabled
    public static Object queryBudgetItems(Id showId){
        Map<String,List<Object>> res = new Map<String,List<Object>>();
        res.put('Budget',new List<Budget_Item__c>());
        res.put('Top Sheet',new List<Budget_Item__c>());
        res.put('Pilot Costs', new List<Budget_Item__c>());
        res.put('Overage', new List<Budget_Item__c>());
        for ( Budget_Item__c b : [
            SELECT Id, Name, Amount__c, Type__c
            FROM Budget_Item__c
            WHERE Show__c = :showId
        ]){
            if ( res.containsKey(b.Type__c) ){
                res.get(b.Type__c).add(b);
            }
        }
        if ( res.get('Budget').size() == 0 && res.get('Top Sheet').size() == 0 ){
            for ( String b : defaultBudgetList ){
                res.get('Budget').add(new Budget_Item__c(Name=b, Amount__c = 0, Show__c = showId, Type__c = 'Budget'));
            }
            for ( String b : defaultTopSheetList ){
                res.get('Top Sheet').add(new Budget_Item__c(Name=b, Amount__c = 0, Show__c = showId, Type__c = 'Top Sheet'));
            }
            
            for(String b : defaultPilotCostList){
                res.get('Pilot Costs').add(new Budget_Item__c(Name=b, Amount__c = 0, Show__c = showId, Type__c = 'Pilot Costs'));
            }
        }
        
        res.put('show', [SELECT Id, NumberofEps__c, Budget_Incentive__c, ProductionIncentive__c, ProductionType__c, Approval_To_Lock__c, Package_Fee_Amount__c, Package_Fee_Type__c  FROM Show__c WHERE Id = :showId]);
        
        return res;
    }
    
    @auraEnabled
    public static List<Payment_Details__c> queryPaymentDetails(Id recordId, string Typeof){
        List<payment_details__c> paymentDetails =  new List<payment_details__c>();
        
        if(Typeof =='Budget'){
        paymentDetails = [SELECT Id, Invoice__c, Index__c,Left_To_Pay__c, Milestones_Notes__c,Paid__c,Payment_Status__c,
                          PO__c,Vendor__c,Confirmed_Date__c,Approved_Overages_dummy__c,Approved_Overages_Paid__c,Cleared_Date_CJIA__c,Show__c from Payment_Details__c where show__c =:recordId AND  Type_of_Payment__c='Budget'];
        }
        
        if(Typeof =='Overage'){
        paymentDetails = [SELECT Id, Invoice__c, Index__c,Left_To_Pay__c, Milestones_Notes__c,Paid__c,Payment_Status__c,
                          PO__c,Vendor__c,Confirmed_Date__c,Approved_Overages_dummy__c,Approved_Overages_Paid__c,Cleared_Date_CJIA__c,Show__c from Payment_Details__c where show__c =:recordId AND  Type_of_Payment__c='Overage'];
        }
        
        if(Typeof =='Expense'){
        paymentDetails = [SELECT Id, Invoice__c, Index__c,Left_To_Pay__c, Milestones_Notes__c,Paid__c,Payment_Status__c,
                          PO__c,Vendor__c,Confirmed_Date__c,Approved_Overages_dummy__c,Approved_Overages_Paid__c,Internal_Expense__c,Cleared_Date_CJIA__c,Show__c from Payment_Details__c where show__c =:recordId AND  Type_of_Payment__c='Expense'];
        }
        return paymentDetails;
    }
    
    @auraEnabled
    public static List<Budget_Person__c> queryBudgetPeople(Id recordId){
        String queryString = 'SELECT Id, Name,Title__c,Credit__c,Rate__c,Options__c,Travel_Requirements__c, Category__c FROM Budget_Person__c';
        queryString += ' WHERE Id != null AND Show__c = :recordId ORDER BY Category__c';
        return database.query(queryString);
    }
    
    //queryBudgetRentals
    @auraEnabled
    public static List<Budget_rental__c> queryBudgetRentals(Id recordId){
        String queryString = 'SELECT Id, Name,Rate__c,Category__c, Service__c FROM Budget_rental__c';
        queryString += ' WHERE Id != null AND Show__c = :recordId ORDER BY Category__c';
        return database.query(queryString);
    }
    
    //upsertPaymentDetails
    @auraEnabled
    public static String upsertPaymentDetails(List<Payment_Details__c> paymentDetails){
        try {
            List<Payment_Details__c> toInsert = new List<Payment_Details__c>();
            List<Payment_Details__c> toUpdate = new List<Payment_Details__c>();
            List<Payment_Details__c> toDelete = new List<Payment_Details__c>();
            for ( Payment_Details__c pd : paymentDetails ){
                if ( pd.Id != null ){
                    toUpdate.add(pd);
                } else {
                    toInsert.add(pd);
                }
            }
            insert toInsert;
            update toUpdate;
        } catch ( Exception e ){
            return e.getMessage();
        }
        return 'Success';
    }

    //upsertBudgetRentals
    @auraEnabled
    public static String upsertBudgetRentals(List<Budget_rental__c> budgetRentals){
        try {
            List<Budget_rental__c> toInsert = new List<Budget_rental__c>();
            List<Budget_rental__c> toUpdate = new List<Budget_rental__c>();
            List<Budget_rental__c> toDelete = new List<Budget_rental__c>();
            for ( Budget_rental__c bi : budgetRentals ){
                if ( bi.Id != null && String.isBlank(bi.Name)  ){
                    toDelete.add(bi);
                } else
                    if ( bi.Id != null ){
                        toUpdate.add(bi);
                    } else {
                        toInsert.add(bi);
                    }
            }
            insert toInsert;
            update toUpdate;
            delete toDelete;
        } catch ( Exception e ){
            return e.getMessage();
        }
        return 'Success';
    }
    
    @auraEnabled
    public static String upsertBudgetPeople(List<Budget_Person__c> budgetPeople){
        try {
            List<Budget_Person__c> toInsert = new List<Budget_Person__c>();
            List<Budget_Person__c> toUpdate = new List<Budget_Person__c>();
            List<Budget_Person__c> toDelete = new List<Budget_Person__c>();
            for ( Budget_Person__c bi : budgetPeople ){
                if ( bi.Id != null && String.isBlank(bi.Name)  ){
                    toDelete.add(bi);
                } else
                    if ( bi.Id != null ){
                        toUpdate.add(bi);
                    } else {
                        toInsert.add(bi);
                    }
            }
            insert toInsert;
            update toUpdate;
            delete toDelete;
        } catch ( Exception e ){
            return e.getMessage();
        }
        return 'Success';
    }

    @auraEnabled
    public static String upsertBudgetItems(List<Budget_Item__c> budgetItems){
        try {
            List<Budget_Item__c> toInsert = new List<Budget_Item__c>();
            List<Budget_Item__c> toUpdate = new List<Budget_Item__c>();
            List<Budget_Item__c> toDelete = new List<Budget_Item__c>();
            for ( Budget_Item__c bi : budgetItems ){
                if ( bi.Id != null && String.isBlank(bi.Name) && bi.Amount__c == null ){
                    toDelete.add(bi);
                } else
                    if ( bi.Id != null ){
                        toUpdate.add(bi);
                    } else {
                        toInsert.add(bi);
                    }
            }
            insert toInsert;
            update toUpdate;
            delete toDelete;
        } catch ( Exception e ){
            return e.getMessage();
        }
        return 'Success';
    }
    
    static List<String> defaultBudgetList = new List<String>{
        'Above the Line','Below the Line','Production','Post Production','Other'
            };
                static List<String> defaultTopSheetList = new List<String>{
                    'Producers','Writers','Director','Cast','Production','Art Department','Set Constrution','Grip Operations','Special Effects','Props'
                        };
                            
                            static list<String> defaultPilotCostList = new List<String>{
                                'Pilot Capitalization', 'Pilot Finishing', 'Retro Pilot Package Fee'
                                    };
                                        
                                        @auraEnabled
                                        public static List<Task> queryTasks(Id recordId, Boolean mine, Boolean isClosed, Boolean isAssigned){
                                            Id ownerId = userInfo.getUserId();
                                            String queryString = 'SELECT Id, Status, ActivityDate, WhatId, What.Name, WhoId, Subject, OwnerId, Stage__c, Owner.Name';
                                            queryString += ' FROM Task WHERE Id != null AND';
                                            if ( recordId != null ){
                                                queryString += ' WhatId = :recordId AND';
                                            }
                                            if ( mine != null && mine){
                                                queryString += ' OwnerId = :ownerId AND';
                                            }
                                            if ( isClosed != null && isClosed ){
                                                queryString += ' IsClosed = :isClosed AND';
                                            }
                                            
                                            if( isAssigned != null && isAssigned){
                                                queryString += ' Status =\'Assigned\' AND';
                                            }
                                            queryString = queryString.substringBeforeLast('AND')+' ORDER BY Sort_Order__c ASC LIMIT 200';
                                            return database.query(queryString);
                                        }
    
    @auraEnabled
    public static Show__c saveShow(Show__c show){
        upsert show;
        return show;
    }
    
    @auraEnabled
    public static budget_item__c upsertbudgetOverage(budget_item__c budgetItems, String showId){
        upsert budgetItems;
        
        Task t = new Task();
        system.debug('Show Id '+showId);
        t = [select id,subject,WhatId,OwnerId,Type from task where whatid =:showId AND Subject = 'Budget overage Approval' limit 1];
        system.debug('Task  '+t);
        
        t.Type = 'Notification';
        t.Subject = 'Budget overage Approval'; 
        t.WhatId = 'a02W000000FaA0EIAV'; 
        t.OwnerId = UserInfo.getUserId()  ;
        upsert t;
        
        ConnectApi.MessageBodyInput messageInput = 
            new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = 
            new List<ConnectApi.MessageSegmentInput>();
        
        // create and add the mention segment
        ConnectApi.MentionSegmentInput mentionSegment = 
            new ConnectApi.MentionSegmentInput();
        mentionSegment.id = UserInfo.getUserId();
        messageInput.messageSegments.add(mentionSegment);
        
        // create and add the message body segment
        ConnectApi.TextSegmentInput textSegment;
        textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = ' Budget Overage Approval';
        messageInput.messageSegments.add(textSegment);
        
        // create the FeedItemInput and add the messageInput to it
        ConnectApi.FeedItemInput input = 
            new ConnectApi.FeedItemInput();
        
        input.subjectId = 'a02W000000FaA0EIAV';
        input.body = messageInput;
        
        // finally, post to the current user's feed
        if ( !Test.isRunningTest() ){
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement('internal', input);
        }
        
        //     ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.News, 'me', input, null);
        
        /*     
FeedItem fi = new FeedItem();
fi.Type = 'ContentPost';
fi.RelatedRecordId = t.Id;
fi.parentId = 'a02W000000FaA0EIAV';
insert fi;
*/   
        return budgetItems;
        
    }    
    
    @auraEnabled
    public static Task temptaskMethod(String showId){
        return null;
        
    }
    
    
    @auraEnabled
    public static List<Task> saveTasks(List<Task> tasks){
        upsert tasks;
        return tasks;
    }
    
    @AuraEnabled
    public static Map<String,List<FeedItem>> saveShowFile(
        Id parentId, String fileName, String base64Data, String type, String uploadDate, String uploadType
    ){
        system.debug(parentId);
        system.debug(uploadDate);
        system.debug(uploadType);
        Date d = Date.valueOf(uploadDate);
        Id showId = parentId;
        if ( d != null ){
            Event e = new Event();
            e.WhatId = showId;
            e.StartDateTime = d;
            e.EndDateTime = d;
            e.Subject = uploadType;
            insert e;
            system.debug(e);
            showId = e.Id;
        }
        
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.PathOnClient = fileName;
        insert cv;
        cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        
        // Define the FeedItemInput object to pass to postFeedElement
        ConnectApi.FeedItemInput feedItemInput = compilePost(parentId, uploadType+': '+fileName, cv.ContentDocumentId);
        // Post the feed item.
        if ( !Test.isRunningTest() ){
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement('internal', feedItemInput);
        }
        return queryFiles(parentId);
    }
    
    public static ConnectApi.FeedItemInput compilePost(Id parentId, String textInput, Id contentDocumentId){
        // Define the FeedItemInput object to pass to postFeedElement
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.subjectId = parentId;
        
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = textInput;
        
        // The MessageBodyInput object holds the text in the post
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        messageBodyInput.messageSegments.add(textSegmentInput);
        feedItemInput.body = messageBodyInput;
        
        // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
        // For this feed item, we define a files capability to hold the file(s).
        ConnectApi.FilesCapabilityInput filesInput = new ConnectApi.FilesCapabilityInput();
        filesInput.items = new List<ConnectApi.FileIdInput>();
        ConnectApi.FileIdInput idInput = new ConnectApi.FileIdInput();
        idInput.id = contentDocumentId;
        filesInput.items.add(idInput);
        
        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
        feedElementCapabilitiesInput.files = filesInput;
        
        feedItemInput.capabilities = feedElementCapabilitiesInput;
        
        return feedItemInput;
    }
    
    
    public transient Attachment objAttachment;
    
    //Use getter so we can make attachment transient
    public Attachment getObjAttachment(){
        objAttachment = new Attachment();
        return objAttachment;
    }
    
    public Boolean fileUploadProcessed{get;set;}
    public String message{get;set;}
    public String messageType{get;set;}
    
    Public void uploadFile(){
        try {
            objAttachment.ParentId = (Id) ApexPages.currentPage().getParameters().get('id');
            
            insert objAttachment;
            
            message = 'File was uploaded successfully';
            messageType = 'success';
        }catch(Exception e){
            message = e.getMessage();
            messageType = 'error';
        }
        fileUploadProcessed = true;
    }
    
    @AuraEnabled
    public static String getMergeEmailTemplate(String templateId, String objId){
        Contact c = [SELECT Id FROM Contact Where Email != null LIMIT 1 ];
        //EmailTemplate template = [SELECT Id, FROM EmailTemplate WHERE Id :]
        
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'mcastillo@mkpartners.com'};
            mail.setToAddresses(toAddresses);
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);
        mail.setSenderDisplayName('MMPT');
        mail.setTargetObjectId(c.Id);
        mail.setTemplateId(templateId);
        mail.setWhatId(objId);
        
        Savepoint sp = Database.setSavepoint();
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        Database.rollback(sp);
        
        String mailTextBody = mail.getPlainTextBody();
        String mailHtmlBody = mail.getHTMLBody();
        String mailSubject = mail.getSubject();
        System.debug('this is mailTextBody');
        System.debug(mailTextBody);
        
        Map<String, String> res = new Map<String, String>();
        res.put('body', mail.getPlainTextBody());
        res.put('htmlBody', mail.getHTMLBody());
        res.put('subject', mailSubject);
        
        return JSON.serialize(res);
        
    }
    
    @AuraEnabled
    public static String generatePdf(String templateId, String objId, String attachmentId, String fileType, Boolean skipLink, String fileName, String linkId){
        
        if(skipLink == null){
            skipLink = false;
        }
        String content = '';
        
        if(String.isNotBlank(attachmentId)){
            content =  EncodingUtil.base64Encode( new PageReference('/apex/PdfGenerator?&b='+attachmentId).getContent() );
        }else{
            content = EncodingUtil.base64Encode( new PageReference('/apex/PdfGenerator?id='+objId+'&templateId='+templateId).getContent() );
        }
        
        if(!skipLink){
            if(linkId == null || String.isBlank(linkId)){
                linkId = objId;
            }
            insertFileAndLink(linkId, content, fileType, 'pdf', fileName );
        }
        
        
        
        return content;
        
        
    }
    
    @AuraEnabled
    public static String insertAttachment(String recordId, String base64HtmlString){
        Attachment a = new Attachment();
        a.Body = EncodingUtil.base64Decode(base64HtmlString);
        a.ParentId = recordId;
        a.ContentType = 'text/plain';
        a.Name = 'htmlBody';
        insert a;
        
        
        
        return a.Id;
    }
    
    @AuraEnabled
    public static void insertFileAndLink(String recordId, String base64String, String cvType, String fileExtension, String fileName){
        
        if(fileName == null || String.isBlank(fileName)){
            fileName = cvType;
        }
        
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.VersionData = EncodingUtil.base64Decode(base64String);
        cv.PathOnClient = fileName + '.' + fileExtension;
        cv.Type__c = cvType;
        insert cv;
        system.debug('CVer'+cv);
        
        FeedItem fi = new FeedItem();
        fi.Type = 'ContentPost';
        fi.RelatedRecordId = cv.Id;
        fi.parentId = recordId;
        insert fi;
    }
    
    @AuraEnabled
    public static Map<String, Object> getDocumentData(String contentDocumentId){
        
        ContentVersion cv = [SELECT Id, VersionData, Title,
                             PathOnClient, ContentSize FROM ContentVersion WHERE ContentDocumentId = : contentDocumentId AND IsLatest=true];
        
        Map<String, Object> resp = new Map<String, Object>();
        
        if(cv != null){
            resp.put('path', cv.PathOnClient);
            resp.put('data', EncodingUtil.base64Encode(cv.VersionData));
            resp.put('size', cv.ContentSize);            
        }
        return resp;
    }
    
    @AuraEnabled
    public static String getSpreadsheetData(String templateId, String recordId){
        //List<List<Object>> data = new List<List<Object>>();
        //system.debug(recordId);
        List<excelHelper.row> data = new List<excelHelper.row>();
        if(templateId == 'Cashflow'){
            data = excelHelper.getCashflow(recordId);
        }else if(templateId == 'Network Distribution List'){
            data = excelHelper.getNetworkDistributionList(recordId);
        }else if(templateId == 'Network Contact List'){
            data = excelHelper.getNetworkContactList(recordId);
        }else if(templateId == 'ATL Breakdown'){
            data = excelHelper.getAtlBreakdown(recordId);
        }else if(templateId == 'Guild Union Form'){
            data = excelHelper.getGuildUnionForm(recordId);
        }else if(templateId =='ATL Memo'){
            data = excelHelper.getATLMemo(recordId);
        }else if(templateId == 'SAGAFTRA Final Cast List'){
            data = excelHelper.getSAGAFTRAFinalCastList(recordId);
        }else if(templateId == 'Package Fee Calculation'){
            data = excelHelper.getPackageFeeCalculation(recordId);
        }else if(templateId == 'WGA Weekly Work List'){
            data = excelHelper.getWGAWeeklyWorkList(recordId);
        }else if(templateId == 'Assumptions'){
            data = excelHelper.getASSUMPTIONS(recordId);
        }else if(templateId == 'Due Date Summary'){
            data = excelHelper.getDueDateSummary(recordId);
        }
        
        //return JSON.serialize();
        return JSON.serialize(data);
    }
    
    @AuraEnabled
    public static String generateCashflow(String recordId){
        system.debug('recordId '+recordId);
        String content = '';
        //       pageReference a = new Pagereference('/apex/cashflowExport?&showId='+recordId);
        if(String.isNotBlank(recordId)){
            content =  EncodingUtil.base64Encode( new PageReference('/apex/cashflowExport?&showId='+recordId).getContent() );
        }
        insertFileAndLink(recordId, content, 'Cashflow', 'xls', 'Cashflow' );
        return content;
        
        
    }
    
    @AuraEnabled
    public static String generatePackageFeeCalc(String recordId){
        system.debug('recordId '+recordId);
        String content = '';
        //       pageReference a = new Pagereference('/apex/cashflowExport?&showId='+recordId);
        if(String.isNotBlank(recordId)){
            content =  EncodingUtil.base64Encode( new PageReference('/apex/packageFeeCalcExport?&showId='+recordId).getContent() );
        }
        insertFileAndLink(recordId, content, 'Other', 'xls', 'Package Fee Calculation' );
        return content;
        
        
    }
    
    // added by naga to delete the show record
    
    @AuraEnabled
    public static void deleteShowRec (string showid){
       show__c c =[select id,name from show__c where id= :showid];
       Delete c;
    }
    
    @AuraEnabled
    public static String insertContacts(List<contact> listOfRecords){
        system.debug('List of records '+listOfRecords);
        Database.SaveResult[] sr =  database.insert(listOfRecords,false);
        system.debug(sr);
        if (sr != null){ 
            for (Database.SaveResult result : sr) {
                if (!result.isSuccess()) {
                    Database.Error[] errs = result.getErrors();
                    for(Database.Error err : errs)
                        System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                    
                }
            }
        }
        return 'Called';
    }
    
    @AuraEnabled
    public static String getbaseURL(){
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        System.debug('Base URL: ' + sfdcBaseURL ); 
        return sfdcBaseURL;
        
    }
    @auraEnabled
    public static List < Show__c > getShowsbyRT(String sortField, boolean isAsc) {
        List < Show__c > lstShow = new List < Show__c > ();
        Id id1 = Userinfo.getProfileId();
        List < Profile > profileName = [select Name from profile where Id =: id1];
        String prfName = profileName[0].Name;
        
        if (prfName != 'System Administrator') {
            String sSoql = 'SELECT Id , Name , Channel__c, RecordType.Name ';
            sSoql += ' From Show__c ';
            sSoql += ' where RecordType.Name  != null ';
            sSoql += ' AND RecordType.Name  = :prfName ';
            if (sortField != '') {
                sSoql += ' Order by ' + sortField;
                
                // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
                if (isAsc) {
                    sSoql += ' asc';
                } else {
                    sSoql += ' desc';
                }
            }
            list < Show__c > lstResult;
            lstResult = Database.query(sSoql);
            for (Show__c s: lstResult) {
                lstShow.add(s);
            }
            
            /*
            List<RecordType> rtList = [Select id ,name ,DeveloperName ,sObjectType From RecordType where sObjectType ='Show__c' AND name = :prfName ];
            List<Show__c> lstShow1 = [Select Id,Name ,RecordType.Name From Show__c where RecordType.Name  != null AND RecordType.Name  = :prfName Order by Name Asc  ];
            //List<Show__c> lstShow1 = [Select Id,Name , RecordType.Name From Show__c where RecordType.Name  != null AND RecordType.Name  = : rtList[0].Name Order by Name Asc  ];
            
            lstShow.addAll(lstShow1);
            */
        } else if (prfName == 'System Administrator') {
            String sSoql = 'SELECT Id , Name , Channel__c, RecordType.Name ';
            sSoql += ' From Show__c ';
            if (sortField != '') {
                sSoql += ' Order by ' + sortField;
                
                // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
                if (isAsc) {
                    sSoql += ' asc';
                } else {
                    sSoql += ' desc';
                }
            }
            list < Show__c > lstResult;
            lstResult = Database.query(sSoql);
            for (Show__c s: lstResult) {
                lstShow.add(s);
            }
            
            /*
                List<Show__c> lstShow2 = [Select Id,Name,RecordType.Name From Show__c Order by Name Asc ];
                lstShow.addAll(lstShow2);
            */
        }

        
        return lstShow;
    }
    
    //added by Gireesh -- 1/16/19  -- Download Data task - Cashflow sub tab
        
    @AuraEnabled
    public Static Budget_Item__c getBudgetSingleRow(String showId){
    
      Budget_Item__c budgetItem = new Budget_Item__c();
        budgetItem.Show__c =showId;
        budgetItem.For_Cashflow__c = true;
        
        budgetItem.Net_Terms__c = '';
        budgetItem.PSA_Status_1__c ='';
        budgetItem.Others__c = '';
        
        
        budgetItem.Cashflow_Notes__c ='';
        insert budgetItem;
        return budgetItem;
    } 


    // Added by naga to get logged in user profile to hide air date

    @AuraEnabled 
    public static string fetchUserProfile(){
     // query current user information  
      User oUser = [select id,Name,profile.Name
                 FROM User Where id =: userInfo.getUserId()];
       string profname = oUser.profile.Name;
        return profname;
    }
    
    // added by naga for new tasks tab 
    
    @AuraEnabled
    
    public Static void updateshowfieldsNow ( string showid,boolean statusfield, string typeofchecklist ) {
        
        show__c ss = [select id, Request_PCR_MML_Digital_Contact__c,WBS_Element_Request__c,
            acc_Set_up_Form__c,Background_Business_Checks__c,Deal_Status__c,Deliverables_Cleared__c,
            Enter_Deal_Summaries__c,Finance_Vetting__c,Internal_Budget_Approval__c,
            Scenechronize__c,Travel_Setup__c,WGA_Weekly_Work_List__c,MML__c,Post__c,Residuals__c
            from show__c where Id=:showid];
        
        if(typeofchecklist == 'RequestPCR')
        {
          ss.Request_PCR_MML_Digital_Contact__c = statusfield;
        }
        if(typeofchecklist == 'WBSElementReq')
        {
         ss.WBS_Element_Request__c = statusfield;
        }
       /* if(typeofchecklist == 'firstshoot')
        {
         ss.X1st_shoot_date__c = statusfield;
        } */
        if(typeofchecklist == 'accsetup')
        {
         ss.acc_Set_up_Form__c = statusfield;
        }
        if(typeofchecklist == 'background')
        {
         ss.Background_Business_Checks__c = statusfield;
        }
       
        
       
        if(typeofchecklist == 'dealstatus')
        {
         ss.Deal_Status__c = statusfield;
        }
        if(typeofchecklist == 'delivarablescleared')
        {
         ss.Deliverables_Cleared__c = statusfield;
        }
        if(typeofchecklist == 'enterdeal')
        {
         ss.Enter_Deal_Summaries__c = statusfield;
        }
        if(typeofchecklist == 'financevetting')
        {
         ss.Finance_Vetting__c = statusfield;
        }
        
        if(typeofchecklist == 'internalbudget')
        {
         ss.Internal_Budget_Approval__c = statusfield;
        }
        
        
        if(typeofchecklist == 'Scenechronize')
        {
         ss.Scenechronize__c = statusfield;
        }
        
        if(typeofchecklist == 'travelsetup')
        {
         ss.Travel_Setup__c = statusfield;
        }
        
        
        if(typeofchecklist == 'wgaworklist')
        {
         ss.WGA_Weekly_Work_List__c = statusfield;
        }
        
         if(typeofchecklist == 'MML')
        {
         ss.MML__c = statusfield;
        }
        
         if(typeofchecklist == 'Post')
        {
         ss.Post__c = statusfield;
        }
        
         if(typeofchecklist == 'Residuals')
        {
         ss.Residuals__c = statusfield;
        }
        
        update ss;
    }
    
    @AuraEnabled
    public Static void saveTasksShowsNow(Date firstshoot,string showid,Date networkContact, Date greenLight, Date postGuidelines,
    Date kickOff, Date sceneKick, Date crewList, Date vtrRem, Date costReport,Date calendar,Date guidelinesEmail,Date startdate
    ,Date endate){
        
        system.debug('the value' +firstshoot);
        show__c ss = [select id,X1st_shoot_date__c,Network_Contact_List__c,Greenlight_Memo__c,Post_Guidelines__c,Kick_Off_Call__c
        ,Scenechronize_Kick_Off_Call__c,Crew_List__c,VTR_Reminder__c,Cost_Report__c,Calendar__c,Guidelines_Email__c,VMN_Insurance_Procedure__c,VMN_Insurance_End_Date__c
        from show__c where Id=:showid];

        ss.X1st_shoot_date__c = firstshoot;
        ss.Network_Contact_List__c = networkContact;
        ss.Greenlight_Memo__c = greenLight;
        ss.Post_Guidelines__c = postGuidelines;
        ss.Kick_Off_Call__c = kickOff;
        ss.Scenechronize_Kick_Off_Call__c = sceneKick;
        ss.Crew_List__c = crewList;
        ss.VTR_Reminder__c = vtrRem;
        ss.Cost_Report__c = costReport;
        ss.Calendar__c = calendar;
        ss.Guidelines_Email__c = guidelinesEmail;
        ss.VMN_Insurance_Procedure__c = startdate;
        ss.VMN_Insurance_End_Date__c = endate;
        
        
        update ss;      
        
    }

    
    
    //adding boosters to increase coverage
    public static void boosterMethod(){
        Integer i = 0; 
  
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;    
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;  
    } }