({
    doInit : function(component, event, helper) {
        var recString = '/'+component.get("v.recordId");
        component.set("v.recString",recString);
        var formatter = new Intl.NumberFormat('en-US',{
            style : 'currency',
            currency : 'USD',
            minimumFractionDigits : 2
        });
        var data = Object;
        var action = component.get('c.queryShow');
        action.setParams({
            showId : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                console.log('success');
                data = response.getReturnValue();
                component.set("v.show",data);
                console.log('Show details ' ,component.get("v.show"));
            }else if(state === 'ERROR'){
                console.log('Error');
            }
            
        }); 
        $A.enqueueAction(action);

        var totalFunded = ''; 
        var totalFund = 0;
        var queryString = 'SELECT Cashflow_Notes__c,total_fund_test_text__c,Funded_to_date_formula_Text__c,Tax_Credit_Text__c,Approved_Overages_Text__c,Difference_in_total_and_funded_date_text__c, Amount__c,Cashflow_A_o__c,CHECK_ACH__c,CreatedById,CreatedDate,Digital_Allocation__c,';
        queryString += 'For_Cashflow__c,Funded_To_Date__c,Funded_To_Date2__c,Graphics_Allocation__c,Id,Internal_Charge_1__c,Internal_Charge_2__c,';
        queryString += 'Locked_External_Production_Budget__c,Name,Total_To_Be_Funded__c,Net_Terms__c,Others__c,Other_text__c,PSA_Status_1__c,PSA_Status_2__c,';
        queryString += 'Show__c,Type__c FROM Budget_Item__c where show__c=\''+component.get("v.recordId") +'\' LIMIT 1';
       
        component.find('util').query(queryString, function(response){
            if(response.length ==1){
                component.set('v.cashflowBudget',response[0]);
                component.set('v.cashflowid', response[0].Id);                
            }
            else if(response.length == 0){
                      var recId = component.get("v.recordId");
                      var action = component.get('c.getBudgetSingleRow');
        action.setParams({
            showId : recId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                console.log('success-create new row');
                var data = response.getReturnValue();
                component.set('v.cashflowBudget',data);
                var cashflowId = data.Id;
                component.set('v.cashflowid', cashflowId);
            }else if(state === 'ERROR'){
                console.log('Error');
            }
            
        }); 
        $A.enqueueAction(action);  
                
            }
            
            helper.queryPaymentDetails(component,helper);
            helper.queryPaymentOverageDetails(component,helper); 
            helper.queryInternalExpenses(component,helper);			
        })
        
        var tempList = [];
        queryString = 'SELECT Id, Invoice__c,Confirmed_Date__c,Cleared_Date_CJIA__c,Vendor__c, Index__c,Left_To_Pay__c, Milestones_Notes__c,Paid__c,';
        queryString += 'Payment_Status__c,PO__c,Show__c from Payment_Details__c where show__c = \''+component.get("v.recordId")+'\'';

        component.find('util').query(queryString, function(response){
            if(response.length <=10 && response.length > 0){
                for(var i=0;i<response.length;i++){
                    tempList.push(response[i]);
                }
                var check = false;
                for(var i=response.length;i<10;i++){
                    var r ={sobjectType : 'Payment_Details__c',Index__c : i}
                    tempList.push(r);
                }
            }else{
                for(var i=1;i<=10;i++){
                    var r ={sobjectType : 'Payment_Details__c',Index__c : i}
                    tempList.push(r);
                }
            }
            component.set("v.paymentDetails",tempList);
        })
    },
    scriptsLoaded : function(cmp,evt, hlp){
        $(function() {
            console.log("ready func called, jualter.");
        });        
        
    },

    addPaymentItem : function(cmp,evt,hlp){
        var recordId = cmp.get("v.recordId");
        var l = cmp.get("v.paymentDetail");
        l.push( hlp.addRow(recordId) );
        cmp.set("v.paymentDetail",l);
        hlp.addRow(recordId);
    },
	
	addOveragePayment : function(cmp,evt,hlp){
	
	  var recordId = cmp.get("v.recordId");
        var l = cmp.get("v.paymentDetailoverages");
        l.push( hlp.addOverageRow(recordId) );
        cmp.set("v.paymentDetailoverages",l);
        hlp.addOverageRow(recordId);
	
	},
	
	addInternalExpense : function(cmp,evt,hlp){
	
	  var recordId = cmp.get("v.recordId");
        var l = cmp.get("v.InternalExpenses");
        l.push( hlp.addExpenseRow(recordId) );
        cmp.set("v.InternalExpenses",l);
        hlp.addExpenseRow(recordId);
	
	},

   saveCashFlow  : function(component, event, helper) {
        var records = new Object();
        records = component.get("v.show");
		var cashflowid = component.get("v.cashflowBudget.Id");
	
        console.log("cashflowid -> ", cashflowid);
        component.find('util').upsert(records, function(response){
            console.log('Show Saved ',response);
        })
        var record ={
            sobjectType : 'Budget_item__c',
            Name : 'Cashflow Details',
            Show__c : component.get("v.show.Id"),
            For_Cashflow__c: true,
            Funded_To_Date2__c: component.get("v.cashflowBudget.Funded_To_Date__c2"),
            Net_Terms__c: component.get("v.cashflowBudget.Net_Terms__c"),
            PSA_Status_1__c: component.get("v.cashflowBudget.PSA_Status_1__c"),
            Others__c: component.get("v.cashflowBudget.Others__c"),
            Other_text__c: component.get("v.cashflowBudget.Other_text__c"),
            Total_To_Be_Funded__c : component.get("v.cashflowBudget.Total_To_Be_Funded__c"),
            Vendor_Id__c : component.get("v.Vendor_Id__c"),
            Vendor_Name__c: component.get("v.Vendor_Name__c"),
            Cashflow_Notes__c: component.get("v.cashflowBudget.Cashflow_Notes__c"),
        }
        
        if(cashflowid){
            record.Id = cashflowid;
        }
        component.find('util').upsert(record, function(response){
            console.log("upserty sert ", response);
            var cashflowid = response[0].Id;
            component.set("v.cashflowid", cashflowid);
			 $A.get('e.force:refreshView').fire();
        })
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Cash Flow was successfully saved.",
            "type": 'success'
        });
        toastEvent.fire();
    },
    savePaymentDetail : function(cmp,evt,hlp){
		var record = new Object();
		record = cmp.get("v.paymentDetail");

        cmp.find('util').upsert(record, function(response){
			$A.get('e.force:refreshView').fire();
		})
        
        var paymentDetails = cmp.get("v.savePaymentDetail");
        var toSave = [];

        for ( var x in paymentDetails ){
            paymentDetails[x].sobjectType = 'Payment_Details__c';
          //  paymentDetails[x].Budget_Item__c = cashflowid;
            toSave.push(paymentDetails[x]);
        }
        var action = cmp.get("c.upsertPaymentDetails");
        action.setParams({paymentDetails:toSave});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if ( state === "SUCCESS" ){
                var res = response.getReturnValue();
                hlp.queryPaymentDetails(cmp, hlp);
            }else if(state === 'ERROR'){
                console.log(response.getError());
            }
        })
		$A.enqueueAction(action);
		hlp.queryPaymentDetails(cmp, hlp);
        // added by naga
        var a = cmp.get('c.doInit');
        $A.enqueueAction(a);         
    },
	
	savePaymentOverageDetail : function(cmp,evt,hlp){
		var record = new Object();
		record = cmp.get("v.paymentDetailoverages");

        cmp.find('util').upsert(record, function(response){
			$A.get('e.force:refreshView').fire();
		})
        
        var paymentDetails = cmp.get("v.savePaymentDetail");
        var toSave = [];

        for ( var x in paymentDetails ){
            paymentDetails[x].sobjectType = 'Payment_Details__c';
          //  paymentDetails[x].Budget_Item__c = cashflowid;
            toSave.push(paymentDetails[x]);
        }
        var action = cmp.get("c.upsertPaymentDetails");
        action.setParams({paymentDetails:toSave});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if ( state === "SUCCESS" ){
                var res = response.getReturnValue();
                hlp.queryPaymentOverageDetails(cmp, hlp);
            }else if(state === 'ERROR'){
                console.log(response.getError());
            }
        })
		$A.enqueueAction(action);
		hlp.queryPaymentOverageDetails(cmp, hlp);
        // added by naga
        var a = cmp.get('c.doInit');
        $A.enqueueAction(a);         
    },
	
	saveInternalExpense : function(cmp,evt,hlp){
		var record = new Object();
		record = cmp.get("v.InternalExpenses");

        cmp.find('util').upsert(record, function(response){
			$A.get('e.force:refreshView').fire();
		})
        
        var paymentDetails = cmp.get("v.savePaymentDetail");
        var toSave = [];

        for ( var x in paymentDetails ){
            paymentDetails[x].sobjectType = 'Payment_Details__c';
          //  paymentDetails[x].Budget_Item__c = cashflowid;
            toSave.push(paymentDetails[x]);
        }
        var action = cmp.get("c.upsertPaymentDetails");
        action.setParams({paymentDetails:toSave});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if ( state === "SUCCESS" ){
                var res = response.getReturnValue();
                hlp.queryPaymentOverageDetails(cmp, hlp);
            }else if(state === 'ERROR'){
                console.log(response.getError());
            }
        })
		$A.enqueueAction(action);
		hlp.queryPaymentOverageDetails(cmp, hlp);
        // added by naga
        var a = cmp.get('c.doInit');
        $A.enqueueAction(a);         
    },
	
	deletePayment : function(component, event, helper) {
		var recordId = event.srcElement.dataset.id;
		var action = component.get("c.deleteRecord");
		action.setParams({recordId:recordId});
		action.setCallback(this,function(response) {
	        var state = response.getState();
	        if ( state === "SUCCESS" ){
	        	helper.queryPaymentDetails(component,helper);
	        }
	    });
		$A.enqueueAction(action);
        // added by naga for refresh after deleted in budget item fields
        var a = component.get('c.doInit');
        $A.enqueueAction(a);  
	},
	
 
    
    export :  function(component, event, helper) {
        console.log('Exporting Cashflow');
        var url = '/apex/cashflowExport?showId=' + component.get("v.recordId");
        window.open(url, '_self');
        var action = component.get('c.generateCashflow');
        action.setParams({
            recordId : component.get("v.recordId"),
        });
        $A.enqueueAction(action);
    },
    
    calculate :  function(component, event, helper) {
        component.set('v.modalOpen', true);
        helper.applyCSS(component);
        
    },
    closeModal : function(component, event, helper){
        helper.revertCssChange(component);
        component.set('v.modalOpen', false);
    },
    onCheck : function(component, event, helper){
        
        var label = event.getSource().get("v.name");
        var checkCmp = component.find(label);
        if(label == 'Digital Allocation'){
            component.set("v.digitalAllocationCheckbox",checkCmp.get("v.value"));
        }
        if(label == 'Graphics Allocation'){
            component.set("v.graphicsAllocationCheckbox",checkCmp.get("v.value"));
        }
        if(label == 'Internal charges #1'){
            component.set("v.internalCharges1Checkbox",checkCmp.get("v.value"));
        }
        if(label == 'Internal Charges #2'){
            component.set("v.internalCharges2Checkbox",checkCmp.get("v.value"));
        }
        if(label == 'Approved Production Overages'){
            component.set("v.approvedProductionOverageCheckbox",checkCmp.get("v.value"));
        }
    },
    CalculateTotal : function(component, event, helper){
        var total = 0;
        if(component.get("v.cashflowBudget.Other_text__c") !=null){
            total = total +  parseInt(component.get("v.cashflowBudget.Other_text__c"));
        }
        
        component.set('v.totalToBeFunded', total);
        component.set('v.modalOpen', false);
    },
    
    onBudgetChange : function(component, event, helper){
        component.set('v.cashflowBudget.Other_text__c','');
    },
        clickXLS : function(component, event, helper){
      var urlEvent = $A.get("e.force:navigateToURL");
	  var cmpId = component.get("v.recordId");
	  var redURL = '/apex/cashFlowDetailsXLS'+'?recid='+cmpId;
        urlEvent.setParams({           
            "url" :  redURL                
        });
        	urlEvent.fire();
          
    }
})