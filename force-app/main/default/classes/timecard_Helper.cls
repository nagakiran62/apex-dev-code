public class timecard_Helper {

    public static void beforeInsert(List<Timecard__c> newList) {
        Map<Id,Map<String,Show_Contact__c>> showMap = new Map<Id,Map<String,Show_Contact__c>>();
        for ( Timecard__c t : newList ){
            showMap.put( t.Show__c, null );
        }
        showMap = compileShowMap(showMap.keySet());
        for ( Timecard__c t : newList ){
            if (
                t.Show_Contact__c == null &&
                showMap.containsKey(t.Show__c) &&
                String.isNotBlank(t.Employee_Name__c) &&
                showMap.get(t.Show__c).containsKey(t.Employee_Name__c.toLowerCase())
            ){
                t.Show_Contact__c = showMap.get(t.Show__c).get(t.Employee_Name__c.toLowerCase()).Id;
            }
        }
    }

    public static void beforeUpdate(List<Timecard__c> newList, List<Timecard__c> oldList) {
        Map<Id,Map<String,Show_Contact__c>> showMap = new Map<Id,Map<String,Show_Contact__c>>();
        for ( Timecard__c t : newList ){
            showMap.put( t.Show__c, null );
        }
        showMap = compileShowMap(showMap.keySet());
        for ( Timecard__c t : newList ){
            if (
                t.Show_Contact__c == null &&
                showMap.containsKey(t.Show__c) &&
                String.isNotBlank(t.Employee_Name__c) &&
                showMap.get(t.Show__c).containsKey(t.Employee_Name__c.toLowerCase())
            ){
                t.Show_Contact__c = showMap.get(t.Show__c).get(t.Employee_Name__c.toLowerCase()).Id;
            }
        }
    }

    public static Map<Id,Map<String,Show_Contact__c>> compileShowMap(Set<Id> showIds){
        Map<Id,Map<String,Show_Contact__c>> res = new Map<Id,Map<String,Show_Contact__c>>();
        for ( Show__c s : [
            SELECT Id,
            (
                SELECT Id, Contact__c, Contact__r.Name, Contact__r.FirstName, Contact__r.LastName
                FROM Show_Contacts__r
            )
            FROM Show__c
            WHERE Id IN : showIds
        ]){
            Map<String,Show_Contact__c> tempMap = new Map<String,Show_Contact__c>();
            for ( Show_Contact__c sc : s.Show_Contacts__r ){
                String contactName = sc.Contact__r.LastName + ', ' + sc.Contact__r.FirstName;
                tempMap.put(contactName.toLowerCase(), sc);
                //tempMap.put( sc.Contact__r.Name, sc);
            }
            res.put( s.Id, tempMap );
        }
        return res;
    }

}