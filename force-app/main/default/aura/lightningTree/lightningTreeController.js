({  
   doInit: function (cmp, event, helper) {  
     helper.apexMethod(cmp);  
   },  
   handleSelect: function (cmp, event, helper) {  
     //return name of selected tree item  
     var myName = event.getParam('name');  
     alert("You selected: " + myName);  
   }  
 })