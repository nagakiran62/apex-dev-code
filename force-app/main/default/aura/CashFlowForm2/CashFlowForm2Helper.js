({
    addRow : function(recordId){
        var r = new Object;
        r.sobjectType = "Payment_Details__c";
        r.Paid__c = "";
        r.Left_To_Pay__c = "";
        r.Milestones_Notes__c = "";
        r.PO__c = "";
        r.Invoice__c = "";
        r.Payment_Status__c = "";
		r.Type_of_Payment__c ="Budget";
        r.Show__c = recordId;
        return r;
    },
	addOverageRow : function(recordId){
        var r = new Object;
        r.sobjectType = "Payment_Details__c";
        r.Approved_Overages_Paid__c = "";
        r.Approved_Overages_dummy__c = "";
        r.Milestones_Notes__c = "";
        r.PO__c = "";
        r.Invoice__c = "";
        r.Payment_Status__c = "";
		r.Type_of_Payment__c ="Overage";
        r.Show__c = recordId;
        return r;
    },
    addExpenseRow : function(recordId){
        var r = new Object;
        r.sobjectType = "Payment_Details__c";
        r.Internal_Expense__c = "";
        r.Approved_Overages_dummy__c = "";
        r.Milestones_Notes__c = "";
        r.PO__c = "";
        r.Invoice__c = "";
        r.Payment_Status__c = "";
		r.Type_of_Payment__c ="Expense";
        r.Show__c = recordId;
        return r;
    },
    queryPaymentDetails : function(cmp,hlp){
        var action = cmp.get("c.queryPaymentDetails");
        var recordId = cmp.get("v.recordId");
        
        action.setParams({recordId:recordId,
		                   Typeof :'Budget'});
        action.setCallback(this,function(response) {
            var state = response.getState();
            var res = response.getReturnValue();
            if ( state === "SUCCESS" ){
                console.log("res from paymentDetail", res);
                cmp.set("v.paymentDetail",res);
            }
        })
        $A.enqueueAction(action);                
    },
	
	queryPaymentOverageDetails : function(cmp,hlp){
        var action = cmp.get("c.queryPaymentDetails");
        var recordId = cmp.get("v.recordId");
        
        action.setParams({recordId:recordId,
		                  Typeof :"Overage"});
        action.setCallback(this,function(response) {
            var state = response.getState();
            var res = response.getReturnValue();
            if ( state === "SUCCESS" ){
                console.log("res from paymentDetail", res);
                cmp.set("v.paymentDetailoverages",res);
            }
        })
        $A.enqueueAction(action);                
    },
	
	queryInternalExpenses : function(cmp,hlp){
        var action = cmp.get("c.queryPaymentDetails");
        var recordId = cmp.get("v.recordId");
        
        action.setParams({recordId:recordId,
		                  Typeof :"Expense"});
        action.setCallback(this,function(response) {
            var state = response.getState();
            var res = response.getReturnValue();
            if ( state === "SUCCESS" ){
                console.log("res from paymentDetail", res);
                cmp.set("v.InternalExpenses",res);
            }
        })
        $A.enqueueAction(action);                
    }
  
})