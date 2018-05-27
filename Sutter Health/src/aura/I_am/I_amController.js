({
	  getIam: function(cmp){
       
      var action = cmp.get("c.getIamArticle");
 
        action.setCallback(this, function(response){
            var state = response.getState();
             
            if (state === "SUCCESS") {
                
                cmp.set("v.iam", response.getReturnValue());
                setTimeout(function(){
  					var imgFullURL = document.querySelector('#custom_image img').src;
     				document.getElementById('learn_topicImg').style.background = "url('"+imgFullURL+"')  no-repeat 0 0 /cover";
     				document.getElementById('learn_topicImg').innerHTML='<img src ="'+imgFullURL+'" class="innerHeader"> ';
                              /* starts */    
                var actionIn = cmp.get("c.getArticleByCategory");
        
        actionIn.setCallback(this, function(response){
            var state = response.getState();
              console.log(response.getReturnValue());
             console.log(state);
            if (state === "SUCCESS") {
               
           cmp.set("v.linkedArticles", response.getReturnValue());
  
            }
        });
     $A.enqueueAction(actionIn); 
                    /* end */
                
                },500);
            }
        });
     $A.enqueueAction(action);
         
    },
    
})