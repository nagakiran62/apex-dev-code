({
 
  jsLoaded : function(component, event, helper) {
         
      jQuery("document").ready(function(){
          
          alert('inside the jquery');
          $('#cmp-nav').onePageNav({
              scrollSpeed: 750,
				scrollThreshold: 0.5,
				filter: '',
				easing: 'swing',   
          });
          
      });
        
 }
})