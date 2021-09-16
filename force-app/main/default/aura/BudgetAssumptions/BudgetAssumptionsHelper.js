({
    addRow : function(recordId){
        var r = new Object;
        r.sobjectType = "Budget_Person__c";
        r.Title__c = "";
        r.Name = "";
        r.Credit__c = "";
        r.Rate__c = "";
        r.Options__c = "";
        r.Travel_Requirements__c = "";
        r.Category__c = "";
        r.Show__c = recordId;
        //added by naga for new field
        r.Notes_Guarantee__c= "";
        return r;
    },

    addRowRental : function(recordId){
        var r1 = new Object;
        r1.sobjectType = "Budget_rental__c";
        r1.Name = "";
        r1.Rate__c = "";
        r1.Service__c = "";
        r1.Category__c = "";
        r1.Show__c = recordId;
        return r1;
    },    

    queryGetBudgetNotes : function(cmp,hlp){
        var queryString = "SELECT Id, Budget_Notes__c from Show__c ";
        queryString +=    ' WHERE Id = \'' + cmp.get('v.recordId') + '\' ';		
        cmp.find('util').query(queryString, function(data){
           cmp.set('v.Budget_Notes__c', data[0].Budget_Notes__c);
        })

    },
    
    queryBudgetPeople : function(cmp,hlp){
		var queryString = 'SELECT Id,Notes_Guarantee__c, Name,Title__c,Credit__c,Rate__c,Options__c,Travel_Requirements__c, Category__c FROM Budget_Person__c';
        queryString +=    ' WHERE Id != null and Show__c = \'' + cmp.get('v.recordId') + '\' ';
        cmp.find('util').query(queryString, function(data){
           cmp.set('v.budgetPerson', data);
        })
        
		/* old way of getting budget people by using call
		 * to controller method. -WLK 02-28-2018
        var action = cmp.get("c.queryBudgetPeople");
        var recordId = cmp.get("v.recordId");
        
        action.setParams({recordId:recordId});
        action.setCallback(this,function(response) {
            var state = response.getState();
            var res = response.getReturnValue();
            if ( state === "SUCCESS" ){
                console.log("res from queryBudgetPeople", res);
                cmp.set("v.budgetPerson",res);
            }
        })
        $A.enqueueAction(action);        
        */
    },

    queryBudgetRentals : function(cmp,hlp){
		var queryString = 'SELECT Id, Name, Rate__c, Service__c, Category__c FROM Budget_rental__c ';
        queryString +=    ' WHERE Id != null and Show__c = \'' + cmp.get('v.recordId') + '\' ';
        cmp.find('util').query(queryString, function(data){
            cmp.set('v.budgetRental', data);
        })
    }
    
})