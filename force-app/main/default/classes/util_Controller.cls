public class util_Controller {

	@AuraEnabled
	public static List<sObject> upsertRecords(List<sObject> records){
		List<sObject> toInsert = new List<sObject>();
        List<sObject> toUpdate = new List<sObject>();

        for( sObject s : records){
            if(s.Id != null){
                toUpdate.add(s);
            }else{
                toInsert.add(s);
            }
        }

        List<Database.SaveResult> resUpd = Database.update(toUpdate, false);
        List<Database.SaveResult> resInsert = Database.insert(toInsert, false);

        for( Database.SaveResult r : resUpd ){
            if( !r.isSuccess() ){
                system.debug(r.getErrors()[0].getMessage() );
                throw new AuraHandledException(r.getErrors()[0].getMessage());

            }
        }

        for( Database.SaveResult r : resInsert ){
            if( !r.isSuccess() ){
                system.debug(r.getErrors()[0].getMessage());
                throw new AuraHandledException(r.getErrors()[0].getMessage());
            }
        }

        return records;
	}

	@AuraEnabled
	public static void deleteRecords(List<sObject> records){
		system.debug(records);

		try{
			delete records;
		}catch(DmlException e){
			throw new AuraHandledException(e.getDmlMessage(0));
		}

		return;
	}

	@AuraEnabled
	public static List<sObject> query(String queryString){
		system.debug('the value in' +database.query(queryString));
		return database.query(queryString);
	}

	@AuraEnabled
	public static List<sObject> queryRecords(String sobjectType, String whereClause, String orderBy, String lim, List<String> fields){
		String queryString = 'SELECT ';
		for(String field : fields){
			queryString += field + ', ';
		}

		queryString = queryString.subStringBeforeLast(',');
		queryString += ' FROM ' + sobjectType;

		if(String.isNotBlank(whereClause)){
			queryString += ' ' + whereClause;
		}

		if(String.isNotBlank(orderBy)){
			queryString += ' ' + orderBy;
		}

		if(String.isNotBlank(lim)){
			queryString += ' ' + lim;
		}
		system.debug(queryString);

		return database.query(queryString);
	}

	@AuraEnabled
    public static String getPicklistValues(String sobjectType , String fieldName){ 
        
        List<String> lstPickvals= new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectType);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
          lstPickvals.add(a.getValue());//add the value  to our final list
        }

        return JSON.serialize(lstPickvals);
        
    }



	

}