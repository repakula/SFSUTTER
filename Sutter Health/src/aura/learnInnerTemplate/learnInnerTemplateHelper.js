({
	helperMethod : function() {
        
		var headRight = document.getElementsByClassName("headerRight")[0];
        
 var topicImg=headRight.getElementsByClassName("data-category-image")[0].backgroundImage;

 var topicImgUrl=topicImg.replace('url(','').replace(')','');

 document.getElementById('learn_topicImg').style.backgroundImage=topicImg;
 document.getElementById('learn_topicImg').html('<img src="'+topicImgUrl+'"');
	}
})