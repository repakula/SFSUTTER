({
    getArts: function(cmp){
       console.log(cmp);
        console.log(222);
      var action = cmp.get("c.getArticlesList");
        console.log(43768);
        console.log(action);
        action.setCallback(this, function(response){
            var state = response.getState();
             console.log(response);
            if (state === "SUCCESS") {
                console.log(response);
                console.log(response.getReturnValue());
                cmp.set("v.iam", response.getReturnValue());
                
            }
        });
     $A.enqueueAction(action);
    },
    getString : function(component, event) {
    var action = component.get("c.getString");
     action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();
                component.set("v.favoriteColors", stringItems);
            }
        });
        $A.enqueueAction(action);
    }
})