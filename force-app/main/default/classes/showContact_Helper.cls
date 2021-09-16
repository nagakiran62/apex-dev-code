public class showContact_Helper {

    public static Map<String, Schema.SObjectField> FIELD_MAP = Schema.SObjectType.Show_Contact__c.fields.getMap();

    /**
    * @name beforeInsert
    * @description
    * @param
    **/

    /**
    * @name afterInsert
    * @description
    * @param
    **/
    public static void afterInsert(List<Show_Contact__c> newList){
        Set<Id> showIds = new Set<Id>();
        for ( Integer i=0;i<newList.size();i++ ){
            showIds.add(newList[i].Show__c);
        }

        system.debug(showIds);
        if(showIds.size() > 0){
            compileContactTextFields(showIds);
        }
    }

    public static void afterUpdate(List<Show_Contact__c> newList, List<Show_Contact__c> oldList){
        Set<Id> showIds = new Set<Id>();
        for ( Integer i=0;i<newList.size();i++ ){
            showIds.add(newList[i].Show__c);
        }
        system.debug(showIds);
        if(showIds.size() > 0){
            compileContactTextFields(showIds);
        }
    }

    public static void compileContactTextFields(Set<Id> showIds){
        Map<Id, Show__c> showMap = new Map<Id, Show__c>();

        for(Id i : showIds){
            Show__c show = new Show__c(Id = i);
            show.Production_Contact_Text__c = '';
            show.Executive_Producer_Contact_Text__c = '';
            show.BALA_Text__c = '';
            show.IP_Lit_Contact_Text__c = '';
            show.MML_Contact_Text__c = '';
            show.Development_Executive_Text__c = '';

            showMap.put(i, show);
        }


        for(Show_Contact__c c : [SELECT Id, Show__c, Type__c, Contact_Info__c FROM Show_Contact__c WHERE Show__c IN : showIds AND Contact__c != NULL]){
            system.debug(c);
            if(c.Type__c == 'Production'){
                showMap.get(c.Show__c).Production_Contact_Text__c += c.Contact_Info__c + ', ';
            }
            if(c.Type__c == 'Executive Producer'){
                showMap.get(c.Show__c).Executive_Producer_Contact_Text__c += c.Contact_Info__c + ', ';
            }
            if(c.Type__c == 'BALA'){
                showMap.get(c.Show__c).Bala_Text__c +=  c.Contact_Info__c + ', ';
            }
            if(c.Type__c == 'IP Lit'){
                showMap.get(c.Show__c).IP_Lit_Contact_Text__c += c.Contact_Info__c + ', ';   
            }
            if(c.Type__c == 'MML'){
                showMap.get(c.Show__c).MML_Contact_Text__c += c.Contact_Info__c + ', ';
            }
            if(c.Type__c == 'Development Executive'){
                showMap.get(c.Show__c).Development_Executive_Text__c += c.Contact_Info__c + ', ';
            }
        }


        for(Id i : showMap.keySet()){
            showMap.get(i).Production_Contact_Text__c = showMap.get(i).Production_Contact_Text__c.substringBeforeLast(',');
            showMap.get(i).Executive_Producer_Contact_Text__c = showMap.get(i).Executive_Producer_Contact_Text__c.substringBeforeLast(',');
            showMap.get(i).BALA_Text__c = showMap.get(i).BALA_Text__c.substringBeforeLast(',');
            showMap.get(i).IP_Lit_Contact_Text__c = showMap.get(i).IP_Lit_Contact_Text__c.substringBeforeLast(',');
            showMap.get(i).MML_Contact_Text__c = showMap.get(i).MML_Contact_Text__c.substringBeforeLast(',');
        }

        if(showMap.values().size() > 0){
            update showMap.values();
        }


    }

}