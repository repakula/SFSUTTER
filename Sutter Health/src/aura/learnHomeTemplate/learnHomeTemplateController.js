({
	  getMegaMenuItems: function(cmp){
       

          var action = cmp.get("c.getMegaMenuArticles");
 
        action.setCallback(this, function(response){
            var state = response.getState();
             
            if (state === "SUCCESS") {
               
                cmp.set("v.menuItems", response.getReturnValue());
                setTimeout(function(){
                    addMenu();
                },800); 
            }
        });
     $A.enqueueAction(action);
         
    }
    
})