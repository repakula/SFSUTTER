setTimeout( function(){
 addMenu();
} ,1000);
var prevNowPlaying = null;
prevNowPlaying=setInterval(function(){ addMenu(); }, 20000);

 setTimeout( function(){
clearInterval(prevNowPlaying);
} ,20000*200);
var addMenu=function(){
console.log('Menu Debug__log');
 var htmlDynamic=$('#dynamicMenu').html();
           // console.log(htmlDynamic);
          if($('#dynamicMenu').length >0 ){
             $( ".menuItem a:contains('I  AM..')" ).find('.subMenu').remove();
             $( ".menuItem a:contains('I  AM..')" ).after(htmlDynamic);
             $( ".menuItem a:contains('I AM..')" ).after(htmlDynamic);
             $('#dynamicMenu').hide();
          }
            
            //$('.subMenu').hide();
         //    $('.leftNavContent:first').show();
         //    $('.leftSubNav li').hover(function(){
              
         //  $('.leftNavContent').hide();
         //  $(this).find('.leftNavContent').show(); 
         //  var offtop= $(this).find('.leftNavContent').offset().top;
         // // console.log(offtop);
         //  offtop=-Math.abs(offtop);
         //  console.log(offtop);
         //    $(this).find('.leftNavContent').css('top',offtop);
           
         //   });
          $('.leftSubNav li a,.menuRightContent a').bind( 'click' ,function(){
            window.location="under-construction";
          });
          $('.leftSubNav li').removeClass('hover');
            $('.leftSubNav li').hover(function(){
			
			var index = $( ".leftSubNav li" ).index( this );
		 	$('.menuRightContent').hide();
		 	$( ".menuRightContent:eq( "+index+" )" ).show();
		 });
                 } 