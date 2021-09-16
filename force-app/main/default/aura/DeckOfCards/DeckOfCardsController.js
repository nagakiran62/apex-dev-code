({
	handleclick : function(component, event, helper) {
        
       for(var i=1; i<=2;i++){
            var btn = component.find(i);
            btn.set("v.variant","neutral");
        }
       
		//for standard attribute get refrencing and access like below
        var btnClicked = event.getSource();
        //var btnClickedLabel = btnClicked.get("v.label");
        btnClicked.set("v.variant","brand");
        
        var ajithdiv = component.find("ajithdiv");
        var vijaydiv = component.find("vijaydiv");
        var btnClickedLabel = btnClicked.get("v.label");
        
            if(btnClickedLabel=="Ajith")
            {
              
              $A.util.removeClass(ajithdiv,"slds-hide");
              $A.util.addClass(vijaydiv,"slds-hide"); 
            }else{
              $A.util.removeClass(vijaydiv,"slds-hide");
              $A.util.addClass(ajithdiv,"slds-hide");
            }
        
        
        //alert('u clicked' +btnClickedLabel)
		
	}
})