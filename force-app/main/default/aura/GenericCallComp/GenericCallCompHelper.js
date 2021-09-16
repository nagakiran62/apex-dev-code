({
	callserver : function(component,methodname,attributeName,params) {
		 // step 1:get reference server side method
		 //alert("inside");
           var methodref =component.get(methodname);
        // step :2 set the parameters,if any
        if(params){
            methodref.setParams(params);
        }
        
        // step 3: register a call back function which will be invoked when the server returns a response
        methodref.setCallback(this, function(response){
             
        // step 4: check the response state and process it
            var respstate = response.getState();
            
            
            if(respstate== "SUCCESS"){
                var result = response.getReturnValue();
                //alert('the stateresponse' +result);
                component.set(attributeName,result);
            }
            else{
                alert("problem getting value");
            }
            
        });
         
		// step 5:put this call in queue so that framework can send this call request to server
		   $A.enqueueAction(methodref);
		
	}
	
})