public class show_Helper {
    static Boolean hasRun = util.hasSyncedEvents;
    static List<String> EVENT_SUBJECTS = new List<String>{
        'Writing','Pre-Production','Production','Post-Production','Delivery','Premiere'
    };
    static List<Show_Task__mdt> DEFAULT_TASKS = [
        SELECT Id, Label, Type__c, Stage__c, Field_Name__c, Email_Template_Id__c, File_Type__c
        FROM Show_Task__mdt
    ];

    static List<String> GUILDS = new List<String>{
        'AFTRA', 'DGA', 'WGA', 'IATSE', 'TEAMSTER'
    };

    static List<Rate__c> DEFAULT_RATES = [
        SELECT Id, Name, CameraUsageType__c, DGA_Agreement__c, IATSE_Agreement__c, LengthofShow__c,
        Location__c, Production_Company__c, ProductionType__c, Project_Type__c, SAGAFTRA_Agreement__c, WGA_Agreement__c
        FROM Rate__c
    ];

    static Map<String,String> PRODUCTION_COMPANY_MAP = new Map<String,String>{
        'Central Productions'=>'1361',
        'Third Party'=>'1360',
        'Third Party - Hands Off'=>'1360'
    };

    public static void beforeInsert(List<Show__c> newList){
        for(Show__c show : newList){
            if(String.isNotBlank(show.CentralProductions__c) && PRODUCTION_COMPANY_MAP.containsKey(show.CentralProductions__c) ){
                show.CompanyCode__c = PRODUCTION_COMPANY_MAP.get(show.CentralProductions__c);
            }

            if(String.isNotBlank(show.ProductionType__c) ){
                if(show.ProductionType__c == 'Drama' || show.ProductionType__c == 'Series'){
                    show.CameraUsageType__c = 'Single Camera';
                }else if(show.ProductionType__c != 'Animation'){
                    show.CameraUsageType__c = 'Multi Camera';
                }
            }
        }
    }

    public static void afterInsert(List<Show__c> newList){  
        Detailed_Budget_Info_and_Assumptions__c obj = new Detailed_Budget_Info_and_Assumptions__c();
        obj.Show_Budget__c = newList[0].Id;
        insert obj;

        Show_Data__c obj2 = new Show_Data__c();
        obj2.Show__c = newList[0].Id;
        insert obj2;
        
        //Unique_Budget_Id
        Map<Id,Show__c> showMap = new Map<Id,Show__c>(newList);
        
        List<Contact> clist = new List<Contact>([SELECT Id FROM Contact WHERE Is_Global__c = TRUE]);
        for ( Integer i=0; i<newList.size(); i++ ){
            for(Contact sc : clist )
            {
                Show_Contact__c c2 = new Show_Contact__c();
                c2.Show__c = newList[i].Id;
                c2.Contact__c = sc.Id;
                c2.Type__c = 'Global Contact';
                insert c2;
            }
        }
        Map<Id,Map<String,Event>> showEventMap = new Map<Id,Map<String,Event>>();
        for ( Integer i=0; i<newList.size(); i++ ){
            showEventMap.put(newList[i].Id, new Map<String,Event>());
        }
        showEventMap = compileShowEventMap(showEventMap);
        List<Event> toDelete = new List<Event>();
        List<Event> toUpsert = new List<Event>();
        List<Show_Rate__c> rates = new List<Show_Rate__c>();


        Show_Task__mdt Greenlight_Memo_Task = [
            SELECT Id, Label, Type__c, Field_Name__c, Email_Template_Id__c, File_Type__c
            FROM Show_Task__mdt
            WHERE DeveloperName = 'Greenlight_Memo'
            LIMIT 1
        ];

        List<Task> tasksUpsert = new List<Task>();

        for ( Integer i=0; i<newList.size(); i++ ){
            Map<String,Event> eventMap = showEventMap.get(newList[i].Id);
            Event writing = updateEvent(newList[i].Id, 'Writing', newList[i].Writing_Period_Start_Date__c, newList[i].Writing_Period_Complete_Date__c, eventMap);
            if ( writing.StartDateTime == null && writing.Id != null ){
                toDelete.add(writing);
            }
            else if ( writing.StartDateTime != null ){
                toUpsert.add(writing);
            }

            Event preProduction = updateEvent(newList[i].Id, 'Pre-Production', newList[i].Pre_Production_Start_Date__c  , newList[i].PreProductioncompletedate__c , eventMap);
            if ( preProduction.StartDateTime == null && preProduction.Id != null ){
                toDelete.add(preProduction);
            }
            else if ( preProduction.StartDateTime != null ){
                toUpsert.add(preProduction);
            }

            Event production = updateEvent(newList[i].Id, 'Production', newList[i].Production_Start_Date__c, newList[i].Production_Complete_Date__c, eventMap);
            if ( production.StartDateTime == null && production.Id != null ){
                toDelete.add(production);
            }
            else if ( production.StartDateTime != null ){
                toUpsert.add(production);
            }

            Event postProduction = updateEvent(newList[i].Id, 'Post-Production', newList[i].Post_Production_Start_Date__c , newList[i].PostProductionCompleteDate__c , eventMap);
            if ( postProduction.StartDateTime == null && postProduction.Id != null ){
                toDelete.add(postProduction);
            }
            else if ( postProduction.StartDateTime != null ){
                toUpsert.add(postProduction);
            }

            if( newList[i].ProductionIncentive__c == 'Yes'){
                Task t = new Task(WhatId = newList[i].Id);
                t.Subject = 'Production Incentive';
                t.Type = Greenlight_Memo_Task.Type__c;
                t.Email_Template_Id__c = Greenlight_Memo_Task.Email_Template_Id__c;
                t.Field_To_Update__c = Greenlight_Memo_Task.Field_Name__c;
                t.File_Type__c = Greenlight_Memo_Task.File_Type__c;

                tasksUpsert.add(t);
            }

            if( newList[i].Stunts__c == 'Yes'){
                Task t = new Task(WhatId = newList[i].Id);
                t.Subject = 'Stunts';
                t.Type = Greenlight_Memo_Task.Type__c;
                t.Email_Template_Id__c = Greenlight_Memo_Task.Email_Template_Id__c;
                t.Field_To_Update__c = Greenlight_Memo_Task.Field_Name__c;
                t.File_Type__c = Greenlight_Memo_Task.File_Type__c;

                tasksUpsert.add(t);
            }

            if( newList[i].Minors__c == 'Yes'){
                Task t = new Task(WhatId = newList[i].Id);
                t.Subject = 'Minors';
                t.Type = Greenlight_Memo_Task.Type__c;
                t.Email_Template_Id__c = Greenlight_Memo_Task.Email_Template_Id__c;
                t.Field_To_Update__c = Greenlight_Memo_Task.Field_Name__c;
                t.File_Type__c = Greenlight_Memo_Task.File_Type__c;

                tasksUpsert.add(t);
            }

            if( newList[i].Minors__c == 'Accountant Needed'){
                Task t = new Task(WhatId = newList[i].Id);
                t.Subject = 'Accountant Needed';
                t.Type = Greenlight_Memo_Task.Type__c;
                t.Email_Template_Id__c = Greenlight_Memo_Task.Email_Template_Id__c;
                t.Field_To_Update__c = Greenlight_Memo_Task.Field_Name__c;
                t.File_Type__c = Greenlight_Memo_Task.File_Type__c;

                tasksUpsert.add(t);
            }
            rates.addAll(compileShowRates(newList[i]));
        }

        if ( !hasRun ){
            hasRun = true;
            delete toDelete;
            upsert toUpsert;
            insert rates;
            compileShowTasks(showMap);

            if(tasksUpsert.size() > 0){
                insert tasksUpsert;
            }

        }
    }

    public static void compileShowTasks(Map<Id,Show__c> showMap){
        Map<String,Task> showTaskMap = new Map<String,Task>();
        for ( Task t : [
            SELECT Id, Subject, WhatId
            FROM Task
            WHERE WhatId IN :showMap.keySet()
        ]){
            showTaskMap.put(t.WhatId+'|'+t.Subject, t);
        }
        for ( Show__c s : showMap.values() ){
            system.debug('how many show records');
            for ( Show_Task__mdt m : DEFAULT_TASKS ){
                Task t = new Task();
                t.Subject = m.Label;
                t.Type = m.Type__c;
                t.Stage__c = m.Stage__c;
                t.Email_Template_Id__c = m.Email_Template_Id__c;
                t.Field_To_Update__c = m.Field_Name__c;
                t.WhatId = s.Id;
                t.File_Type__c = m.File_Type__c;
                //                t.ActivityDate = system.today();
                if ( showTaskMap.containsKey(t.WhatId+'|'+t.Subject) ){
                    t = showTaskMap.get(t.WhatId+'|'+t.Subject);
                }
                showTaskMap.put(t.WhatId+'|'+t.Subject,t);
            }
        }
        upsert showTaskMap.values();
    }

    public static List<Show_Rate__c> compileShowRates(Show__c s){
        Map<String,Show_Rate__c> resMap = new Map<String,Show_Rate__c>();
        for ( Rate__c r : DEFAULT_RATES ){
            if (
                r.LengthofShow__c == s.LengthofShow__c &&
                r.Production_Company__c == s.CentralProductions__c &&
                r.ProductionType__c == s.ProductionType__c &&
                r.Project_Type__c == s.Content_Types__c &&
                r.Location__c == s.Location_Lookup__c
            ){
                if ( String.isNotBlank(r.DGA_Agreement__c) ){
                    resMap.put('DGA - '+r.DGA_Agreement__c,new Show_Rate__c(Name = r.DGA_Agreement__c, Rate__c=r.id, Show__c = s.Id, Guild__c='DGA'));
                }
                if ( String.isNotBlank(r.IATSE_Agreement__c) ){
                    resMap.put('IATSE - '+r.IATSE_Agreement__c,new Show_Rate__c(Name = r.IATSE_Agreement__c, Rate__c=r.id, Show__c = s.Id, Guild__c='IATSE'));
                }
                if ( String.isNotBlank(r.SAGAFTRA_Agreement__c) ){
                    resMap.put('SAG/AFTRA - '+r.SAGAFTRA_Agreement__c, new Show_Rate__c(Name = r.SAGAFTRA_Agreement__c, Rate__c=r.id, Show__c = s.Id, Guild__c='SAG/AFTRA'));
                }
                if ( String.isNotBlank(r.WGA_Agreement__c) ){
                    resMap.put('WGA - '+r.WGA_Agreement__c, new Show_Rate__c(Name = r.WGA_Agreement__c, Rate__c=r.id, Show__c = s.Id, Guild__c='WGA'));
                }
            }
        }
        return resMap.values();
    }

    public static void beforeUpdate(List<Show__c> newList, List<Show__c> oldList){
        List<Show_Contact__c> showContacts = new List<Show_Contact__c>();

        for(Integer i = 0; i < newList.size(); i++){

            if(newList[i].Name != oldList[i].Name){
                newList[i].FKA__c = newList[i].FKA__c == null ? oldList[i].Name : (oldList[i].Name + '<br/>' + newList[i].FKA__c);
            }

            if(newList[i].Title_Clearance__c != oldList[i].Title_Clearance__c && newList[i].Title_Clearance__c == 'Yes'){
                newList[i].FKA__c = newList[i].FKA__c == null ? newList[i].Name : (newList[i].Name + '<br/>' + newList[i].FKA__c);

                newList[i].Name = newList[i].Proposed_Title__c;
            }

            if(
                String.isNotBlank(newList[i].CentralProductions__c) &&
                newList[i].CentralProductions__c != oldList[i].CentralProductions__c &&
                PRODUCTION_COMPANY_MAP.containsKey(newList[i].CentralProductions__c)
            ){
                newList[i].CompanyCode__c = PRODUCTION_COMPANY_MAP.get(newList[i].CentralProductions__c);
            }

            if(String.isNotBlank(newList[i].ProductionType__c) && newList[i].ProductionType__c != oldList[i].ProductionType__c){
                if(newList[i].ProductionType__c == 'Drama' || newList[i].ProductionType__c == 'Series'){
                    newList[i].CameraUsageType__c = 'Single Camera';
                }else if(newList[i].ProductionType__c != 'Animation'){
                    newList[i].CameraUsageType__c = 'Multi Camera';
                }else{
                    newList[i].CameraUsageType__c = null;
                }
            }

        }


    }

    public static void afterUpdate(List<Show__c> newList, List<Show__c> oldList){
        Map<Id,Show__c> showMap = new Map<Id,Show__c>(newList);
        Map<Id,Map<String,Event>> showEventMap = new Map<Id,Map<String,Event>>();
        for ( Integer i=0; i<newList.size(); i++ ){
            showEventMap.put(newList[i].Id, new Map<String,Event>());
        }

        List<Show_Contact__c> showContacts = new List<Show_Contact__c>();

        showEventMap = compileShowEventMap(showEventMap);
        List<Event> toDelete = new List<Event>();
        List<Event> toUpsert = new List<Event>();
        List<Show_Rate__c> rates = new List<Show_Rate__c>();

        Show_Task__mdt Greenlight_Memo_Task = [
            SELECT Id, Label, Type__c, Field_Name__c, Email_Template_Id__c, File_Type__c
            FROM Show_Task__mdt WHERE DeveloperName = 'Greenlight_Memo'
            LIMIT 1
        ];

        List<Task> tasksUpsert = new List<Task>();
        system.debug('inside show after update');
        for ( Integer i=0; i<newList.size(); i++ ){
            rates.addAll(compileShowRates(newList[i]));
            Map<String,Event> eventMap = showEventMap.get(newList[i].Id);
            if (
                newList[i].Writing_Period_Start_Date__c != oldList[i].Writing_Period_Start_Date__c ||
                newList[i].Writing_Period_Complete_Date__c != oldList[i].Writing_Period_Complete_Date__c
            ){
                Event writing = updateEvent(newList[i].Id, 'Writing', newList[i].Writing_Period_Start_Date__c, newList[i].Writing_Period_Complete_Date__c, eventMap);
                if ( writing.StartDateTime == null && writing.Id != null ){
                    toDelete.add(writing);
                }
                else if ( writing.StartDateTime != null ){
                    toUpsert.add(writing);
                }
            }
            if (
                newList[i].Pre_Production_Start_Date__c != oldList[i].Pre_Production_Start_Date__c ||
                newList[i].PreProductioncompletedate__c != oldList[i].PreProductioncompletedate__c
            ){
                Event preProduction = updateEvent(newList[i].Id, 'Pre-Production', newList[i].Pre_Production_Start_Date__c  , newList[i].PreProductioncompletedate__c , eventMap);
                if ( preProduction.StartDateTime == null && preProduction.Id != null ){
                    toDelete.add(preProduction);
                }
                else if ( preProduction.StartDateTime != null ){
                    toUpsert.add(preProduction);
                }
            }
            if (
                newList[i].Production_Start_Date__c != oldList[i].Production_Start_Date__c ||
                newList[i].Production_Complete_Date__c != oldList[i].Production_Complete_Date__c
            ){
                Event production = updateEvent(newList[i].Id, 'Production', newList[i].Production_Start_Date__c, newList[i].Production_Complete_Date__c, eventMap);
                if ( production.StartDateTime == null && production.Id != null ){
                    toDelete.add(production);
                }
                else if ( production.StartDateTime != null ){
                    toUpsert.add(production);
                }
            }
            if (
                newList[i].Post_Production_Start_Date__c != oldList[i].Post_Production_Start_Date__c ||
                newList[i].PostProductionCompleteDate__c != oldList[i].PostProductionCompleteDate__c
            ){
                Event postProduction = updateEvent(newList[i].Id, 'Post-Production', newList[i].Post_Production_Start_Date__c , newList[i].PostProductionCompleteDate__c , eventMap);
                postProduction.WhatId = newList[i].Id;
                if ( postProduction.StartDateTime == null && postProduction.Id != null ){
                    toDelete.add(postProduction);
                }
                else if ( postProduction.StartDateTime != null ){
                    toUpsert.add(postProduction);
                }
            }

            if(newList[i].IP_LIT_Contact__c != null && newList[i].IP_Lit_Contact__c != oldList[i].IP_Lit_Contact__c){
                showContacts.add(new Show_Contact__c(Show__c = newList[i].Id, Type__c = 'IP Lit', Contact__c = newList[i].IP_Lit_Contact__c));
                //newList[i].IP_Lit_Contact__c = null;
            }
            if(newList[i].MML_Contact__c != null && newList[i].MML_Contact__c != oldList[i].MML_Contact__c){
                showContacts.add(new Show_Contact__c(Show__c = newList[i].Id, Type__c = 'MML', Contact__c = newList[i].MML_Contact__c));
            }
            if(newList[i].Multiplatform_Contact__c != null && newList[i].Multiplatform_Contact__c != oldList[i].Multiplatform_Contact__c){
                showContacts.add(new Show_Contact__c(Show__c = newList[i].Id, Type__c = 'Multiplatform', Contact__c = newList[i].Multiplatform_Contact__c));
            }


            if( newList[i].ProductionIncentive__c != oldList[i].ProductionIncentive__c && newList[i].ProductionIncentive__c == 'Yes'){
                Task t = new Task(WhatId = newList[i].Id);
                t.Subject = 'Production Incentive';
                t.Type = Greenlight_Memo_Task.Type__c;
                t.Email_Template_Id__c = Greenlight_Memo_Task.Email_Template_Id__c;
                t.Field_To_Update__c = Greenlight_Memo_Task.Field_Name__c;
                t.File_Type__c = Greenlight_Memo_Task.File_Type__c;

                tasksUpsert.add(t);
            }

            if(newList[i].Stunts__c != oldList[i].Stunts__c && newList[i].Stunts__c == 'Yes'){
                Task t = new Task(WhatId = newList[i].Id);
                t.Subject = 'Stunts';
                t.Type = Greenlight_Memo_Task.Type__c;
                t.Email_Template_Id__c = Greenlight_Memo_Task.Email_Template_Id__c;
                t.Field_To_Update__c = Greenlight_Memo_Task.Field_Name__c;
                t.File_Type__c = Greenlight_Memo_Task.File_Type__c;

                tasksUpsert.add(t);
            }

            if(newList[i].Minors__c != oldList[i].Minors__c && newList[i].Minors__c == 'Yes'){
                Task t = new Task(WhatId = newList[i].Id);
                t.Subject = 'Minors';
                t.Type = Greenlight_Memo_Task.Type__c;
                t.Email_Template_Id__c = Greenlight_Memo_Task.Email_Template_Id__c;
                t.Field_To_Update__c = Greenlight_Memo_Task.Field_Name__c;
                t.File_Type__c = Greenlight_Memo_Task.File_Type__c;

                tasksUpsert.add(t);
            }

            if(newList[i].Accountant_Needed__c != oldList[i].Accountant_Needed__c && newList[i].Accountant_Needed__c == 'Yes'){
                Task t = new Task(WhatId = newList[i].Id);
                t.Subject = 'Accountant Needed';
                t.Type = Greenlight_Memo_Task.Type__c;
                t.Email_Template_Id__c = Greenlight_Memo_Task.Email_Template_Id__c;
                t.Field_To_Update__c = Greenlight_Memo_Task.Field_Name__c;
                t.File_Type__c = Greenlight_Memo_Task.File_Type__c;

                tasksUpsert.add(t);
            }


        }
        if ( !hasRun ){
            hasRun = true;
            delete toDelete;
            upsert toUpsert;

            if(showContacts.size() > 0){
                insert showContacts;
            }
            compileShowTasks(showMap);

            if(tasksUpsert.size() > 0){
                upsert tasksUpsert;
            }

            delete [SELECT Id FROM Show_Rate__c WHERE Show__c IN :showMap.keySet()];
            insert rates;
        }
    }

    public static Event updateEvent(Id showId, String phaseName, DateTime startDateTime, DateTime endDateTime, Map<String,Event> eventMap){
        Event e = new Event();
        e.Subject = phaseName;
        e.Phase__c = phaseName;
        e.WhatId = showId;
        e.Show__c = showId;
        
        if ( eventMap.containsKey(phaseName) ){
            e = eventMap.get(phaseName);
        }
        e.StartDateTime = null;
        e.EndDateTime = null;
        
        if ( startDateTime != null ){
            e.StartDateTime = startDateTime;
        }
        
        if ( endDateTime != null ){
            e.End_DateTime__c = endDateTime;
        } else {
            e.End_DateTime__c = startDateTime;
        }
        return e;
    }

    static Map<Id,Map<String,Event>> compileShowEventMap(Map<Id,Map<String,Event>> showEventMap){
        for ( Event e : [
            SELECT Id, StartDateTime, EndDateTime, End_DateTime__c, Subject, Phase__c, WhatId
            FROM Event
            WHERE Phase__c IN :EVENT_SUBJECTS
            AND WhatId IN :showEventMap.keySet()
        ]){
            Map<String,Event> eventMap = showEventMap.get(e.WhatId);
            eventMap.put(e.Phase__c, e);
            showEventMap.put(e.WhatId,eventMap);
        }
        return showEventMap;
    }
/*
    static List<Task> constructShowTasks(Id showId){
        return null;
    }
*/


}