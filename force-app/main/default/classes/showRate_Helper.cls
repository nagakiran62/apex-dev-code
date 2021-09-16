public class showRate_Helper {
    public static void afterInsert(List<Show_Rate__c> newList){
        Map<Id,List<String>> showMap = new Map<Id,List<String>>();
        for ( Integer i=0; i<newList.size(); i++ ){
            List<String> tempList = new List<String>();
            if ( showMap.containsKey(newList[i].Show__c) ){
                tempList = showMap.get(newList[i].Show__c);
            }
            if ( String.isNotBlank(newList[i].Guild__c) ){
                tempList.add(newList[i].Guild__c);
            }
            showMap.put( newList[i].Show__c, tempList);
        }
        List<Show__c> showUpdates = new List<Show__c>();
        for ( Id i : showMap.keySet() ){
            if ( showMap.get(i) != null ){
                Show__c s = new Show__c(Id=i);
                s.Guilds__c = String.join(showMap.get(i),', ');
                showUpdates.add(s);
            }
        }
        update showUpdates;
    }
}