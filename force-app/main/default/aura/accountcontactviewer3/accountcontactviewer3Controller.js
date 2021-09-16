({
      doInit: function(component, event, helper) {
        // Fetch the account list from the Apex controller
        helper.getAccountList(component);
      },
      /*getContacts: function(component, event, helper) {
        // Prevent the form from getting submitted
        //event.preventDefault();
        // Get the value from the field that's in the form
        //var accountName = event.target.getElementsByClassName('account-name')[0].value;
        //confirm('Delete the ' + accountName + ' account? (don’t worry, this won’t actually work!)');
        helper.getContacts(component, event);
      }*/
        getContacts: function(component, event) {
        alert('accoutn helper');
       //var viewContactEvnt = component.getEvent('contactDetail');
       // var accountId = component.get('v.recordId'); 
       var viewContactEvnt = $A.get("e.c:ViewContactEvent");
        var accountId = '0017F00000MbpxQQAR';
        //event.target.getElementsByClassName('account-Id')[0].value;
       //2. Set params in JSON format
       viewContactEvnt.setParams(
                           {
                            "accountId":'0017F00000MbpxQQAR'
                           }
                           );
       
       //3. fire the event
       viewContactEvnt.fire();
        //alert('event fired' + viewContactEvnt + 'with account id' + accountId);
      }
    })