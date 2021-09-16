({
      // Fetch the accounts from the Apex controller
      getAccountList: function(component) {
        var action = component.get('c.getAccounts');
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
         component.set('v.accounts', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
      }/*,
    
   	getContacts: function(component, event) {
        alert('accoutn helper');
       var viewContactEvnt = component.getEvent('contactDetail');
       // var accountId = component.get('v.recordId'); 
        var accountId = '0012E00001oLJ81QAG';
        //event.target.getElementsByClassName('account-Id')[0].value;
       //2. Set params in JSON format
       viewContactEvnt.setParams(
                           {
                            "accountId":accountId
                           }
                           );
       
       //3. fire the event
       viewContactEvnt.fire();
        alert('event fired' + viewContactEvnt + 'with account id' + accountId);
      }*/
    })