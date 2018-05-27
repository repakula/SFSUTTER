@font-face {
    font-family: 'helvetica_ce_55_romanbold';
    src: url('../learn_fonts/helvetica_neue_ce_75_bold-webfont.woff2') format('woff2'),
         url('../learn_fonts/helvetica_neue_ce_75_bold-webfont.woff') format('woff');
    font-weight: normal;
    font-style: normal;
}

@font-face {
    font-family: 'ubunturegular';
    src: url('../learn_fonts/ubuntu-r_0-webfont.woff2') format('woff2'),
         url('../learn_fonts/ubuntu-r_0-webfont.woff') format('woff');
    font-weight: normal;
    font-style: normal;

}

@font-face {
    font-family: 'ubuntumedium';
    src: url('../learn_fonts/ubuntu-m_0-webfont.woff2') format('woff2'),
         url('../learn_fonts/ubuntu-m_0-webfont.woff') format('woff');
    font-weight: normal;
    font-style: normal;

}

@font-face {
	font-family: 'Conv_MinionPro-BoldIt';
	src: url('../learn_fonts/MinionPro-BoldIt.eot');
	src: local('☺'), url('../learn_fonts/MinionPro-BoldIt.woff') format('woff'), 
	url('../learn_fonts/MinionPro-BoldIt.ttf') format('truetype'), 
	url('../learn_fonts/MinionPro-BoldIt.svg') format('svg');
	font-weight: normal;
	font-style: normal;
}

@font-face {
	font-family: 'Conv_HelveticaLTStd-Roman_1';
	src: url('../learn_fonts/HelveticaLTStd-Roman_1.eot');
	src: local('☺'), url('../learn_fonts/HelveticaLTStd-Roman_1.woff') format('woff'), 
	url('../learn_fonts/HelveticaLTStd-Roman_1.ttf') format('truetype'), 
	url('../learn_fonts/HelveticaLTStd-Roman_1.svg') format('svg');
	font-weight: normal;
	font-style: normal;
}

@font-face {
	font-family: 'Conv_HelveticaNeueLTStd-Md_2';
	src: url('../learn_fonts/HelveticaNeueLTStd-Md_2.eot');
	src: local('☺'), url('learn_fonts/HelveticaNeueLTStd-Md_2.woff') format('woff'), 
	url('../learn_fonts/HelveticaNeueLTStd-Md_2.ttf') format('truetype'), 
	url('../learn_fonts/HelveticaNeueLTStd-Md_2.svg') format('svg');
	font-weight: normal;
	font-style: normal;
}




html, body {
	margin: 0px;
	padding: 0px;
	width: 100%;
	min-height: 100%;
}

body {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
 }
#body{
	background: #7a7a7a ;
}

a, a:link, a:visited {
    outline: none;
	text-decoration: none;	
}

img {
	border: none;
	margin: 0px;
}


h1 {
	font-size: 2em;
	font-weight: bold;
	margin: 0px;
	padding: 0px;	
}

h2 {
	font-size: 1.2em;
	font-weight: bold;
	margin: 0px;
	padding: 0px;
}

h3, h4, h5, h6 {
	font-size: .9em;
	font-weight: bold;
	margin: 0px;
	padding: 0px;	
}

form, input, select, textarea, p {
	margin: 0px;
	padding: 0;
}

textarea {
	resize: none;
}

input:focus, textarea:focus {
	outline: none;
}

input::-moz-focus-inner { 
    border: 0;
    padding: 0;
}

article, aside, details, figcaption, figure,  
footer, header, hgroup, menu, nav, section, time {  
	display: block; 
	margin: 0px;
	padding: 0; 
} 

.customClear {
	clear: both;
	font-size: 0em;
	line-height: 0px;
	height: 0px;
	margin: 0px;
	padding: 0px;
}

.overlay {
	width: 100%;
	height: 100%;
	background: #000;
	position: fixed;
	top: 0;
	left: 0;
	z-index: 1000;
	display: none;
}

.modal_wrapper {
	width: 100%;
	position: absolute;
	padding-top: 50px;
	top: 0;
	left: 0;
	z-index: 1001;
	display: none;
}


/*IE below 9*/
#ieWrapper {
	background: #000;
	position: fixed;
	z-index: 100;
	top: 0;	left: 0;
	width: 100%;
	height: 100%;
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
}

.ieHolder {
	position: relative; 
	width: 555px;
	padding: 20px;
	margin: 200px auto 0 auto;
	background: #FFF;
	border: 7px solid #2b2927;
}

.btnIeUpdate {
	background: url(../learn_images/btnIeUpdate.jpg) 0 0 no-repeat;
	width: 144px;
	height: 37px;
	position: absolute;
	right: 20px;
	bottom: 20px;
	color: #fff;
	line-height: 37px;
	text-align: center;
	text-decoration: none;
	text-transform: uppercase;
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size: 13px;
}

.ieLogo {
	float: left;
	width: 134px;
	height: 139px;
	background: url(../learn_images/ieLogo.jpg) no-repeat 0 0;
}

.ieContent {
	float: right;
	margin: 0;
	padding: 0;
	width: 400px;
	color: #666;
	font-size: 15px;
	line-height: 18px;
}

.ieContent strong {
	margin: 0 0 15px 0;
	padding: 0 0 10px 0;
	border-bottom: 1px dashed #cccccc;
	display: block;
	font-size: 18px;
	color: #333;
	font-weight: normal;
}
/*End IE below 9*/

.layoutWrapper {
	position: relative;
	overflow-x: hidden;
}

.leftAnimo {
	-webkit-transform: translate3d(270px, 0px, 0px);
 	-moz-transform: translate3d(270px, 0px, 0px);
 	transform: translate3d(270px, 0px, 0px);
 	-webkit-transition: all 300ms cubic-bezier(0.42, 0, 0.58, 1) 0s;
    -moz-transition: all 300ms cubic-bezier(0.42, 0, 0.58, 1) 0s;
     transition: all 300ms cubic-bezier(0.42, 0, 0.58, 1) 0s;
}

.mobileNav {
	background: #222629;
	width: 300px;
	height: 100% !important;
	height: auto;
	text-transform: uppercase;
	position: absolute;
	left: 0;
	top: 0;
	z-index: 0;
	display: none;
}

.mobileNav ul {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	display: block;
}

.mobileNav li {
	font-family: 'ubunturegular';
	font-size: 16px;
	color: #c1c1c1;
	list-style: none;
	float: none;
	position: relative;
	background: url(../learn_images/bgMenuDivider.jpg) repeat-x 0 0;
}

.mobileNav li a {
	padding: 10px 15px 8px;
	color: #bcbdbd;
	-webkit-transition: background-color ease-out 0.6s;
    -moz-transition: background-color ease-out 0.6s;
    -o-transition: background-color ease-out 0.6s;
    transition: background-color ease-out 0.6s;
   display: block;
}

.mobileNav li a:hover, .mobileNav li.selected a, .mobileNav li li.selected a {
	color: #FFF !important;
	background: #00a4a2;
}

.mobileNav li.selected li a {
	background: none;
}

.mobileNav li:last-child {
	border: none;
}

.mobileNav li ul {
	margin: 0;
	padding: 0;
	position: relative;
	top: 0;
	left: 0;
	padding: 0;
	width: 100%;
	display: block;
	z-index: 100;
}

.mobileNav li li {
	font-size: 15px;
	float: none;
}

.mobileNav li li a {
	color: #bcbdbd !important;
	padding: 10px 30px;
	box-sizing: border-box;
	display: block;
}

.mobileNav li li a {
	padding-left: 50px;
}

.mobileNav li li a:hover {
	color: #FFF !important;
	background: #fdb813;
}

.mobileNav ul ul {
	background: #303437;
}

.mobileNav .btnRequestQuote a {
	 font-family: 'source_sans_prosemibold';
	 color: #FFF;
	 font-size:16px;
	  padding: 10px 15px;
	  box-sizing: border-box;
	background: #005dab;
	  -webkit-transition: all ease-out 0.3s;
	-moz-transition: all ease-out 0.3s;
	-o-transition: all ease-out 0.3s;
	transition: all ease-out 0.3s;
	display: block;
}

.mobileNav .btnRequestQuote a:hover {
	color: #FFF;
	background: #fdb813;
	
}

.mobNav {
	position: absolute;
	bottom: 4px;
	left: 10px;
	display: none;
}

.iconMobNav {
  width: 35px;
  height: 21px;
  position: relative;
  margin: 7px 0 0;
  -webkit-transform: rotate(0deg);
  -moz-transform: rotate(0deg);
  -o-transform: rotate(0deg);
  transform: rotate(0deg);
  -webkit-transition: .5s linear;
  -moz-transition: .5s linear;
  -o-transition: .5s linear;
  transition: .5s linear;
  cursor: pointer;
   opacity: 1;
   display: block;
}

.iconMobNav span {
  display: block;
  position: absolute;
  height: 3px;
  width: 100%;
  background: #FFF;
  border-radius: 9px;
  opacity: 1;
  left: 0;
  -webkit-transform: rotate(0deg);
  -moz-transform: rotate(0deg);
  -o-transform: rotate(0deg);
  transform: rotate(0deg);
  -webkit-transition: .25s linear;
  -moz-transition: .25s linear;
  -o-transition: .25s linear;
  transition: .25s linear;
}

.iconMobNav  span:nth-child(1) {
  top: 0px;
}

.iconMobNav span:nth-child(2), .iconMobNav  span:nth-child(3) {
  top: 8px;
}

.iconMobNav span:nth-child(4) {
  top: 16px;
}

.iconMobNav.open span:nth-child(1) {
  top: 18px;
  width: 0%;
  left: 50%;
}

.iconMobNav.open span:nth-child(2) {
  -webkit-transform: rotate(45deg);
  -moz-transform: rotate(45deg);
  -o-transform: rotate(45deg);
  transform: rotate(45deg);
}

.iconMobNav.open span:nth-child(3) {
  -webkit-transform: rotate(-45deg);
  -moz-transform: rotate(-45deg);
  -o-transform: rotate(-45deg);
  transform: rotate(-45deg);
}

.iconMobNav.open span:nth-child(4) {
  top: 18px;
  width: 0%;
  left: 50%;
}

#container {
	background: #FFF;
	 -webkit-box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, 0.75);
	-moz-box-shadow:    0px 0px 10px 0px rgba(0, 0, 0, 0.75);
	box-shadow:         0px 0px 10px 0px rgba(0, 0, 0, 0.75);
	position: relative;
	z-index: 1;
}

.pageHeader {
	width: 100%;
	min-height: 118px;
}

.pageLogo {
	max-width: 358px;
	height: 52px;
	float: left;
	margin: 41px 0 0;
}

.headerRight {
	float: right;
	padding: 80px 0 0;
	box-sizing: border-box;
}

.headerRight ul {
	margin: 0;
	padding: 0;
	font-size: 0;
	list-style: none;
	display: block;
}

.headerRight li  {
	font-family: 'helvetica_ce_55_romanbold'!important;
	font-size: 14px !important;
	font-weight: bold!important;
	text-transform: uppercase;
	display: inline-block;
	position: relative;
}
.selfServiceSearchWrapper .search-button.uiButton{
background: rgba(0, 0, 0, 0) url("../learn_images/iconSearch.png") no-repeat scroll 0 7px !important;

}
.headerRight li a {
	color: #00a4a3;
}
.headerRight li a:hover{
    color:#007d7c;
}
.headerRight li:first-child {
	margin-right: 60px;
	box-sizing: border-box;
}

.headerRight li:first-child:before  {
	content: "";
	background: url(../learn_images/iconLogin.png) no-repeat 0 0;
	width: 15px;
	height: 14px;
	position: absolute;
	left: -20px;
	top: 3px;
}

.headerRight li:first-child:after {
	content: "";
	background: url(../learn_images/iconDropArrow.jpg) no-repeat 0 0;
	width: 9px;
	height: 5px;
	position: absolute;
	right: -15px;
	top: 6px;
}

.headerRight li:last-child:before {
	content: "";
	background: url(../learn_images/iconSearch.png) no-repeat 0 0;
	width: 14px;
	height: 15px;
	position: absolute;
	left: -17px;
	top: 2px;

}

.pageNav {
	background: #007d7c;
	width: 100%;
 	position: relative;
 	min-height: 40px;
}

.pageNav ul {
	font-size: 0;
	margin: 0;
	padding: 0;
	list-style: none;
	display: block;
 }
.pageNav li {
	font-family: 'helvetica_ce_55_romanbold';
	font-size: 14px;
	font-weight: bold;
	text-transform: uppercase;
	box-sizing: border-box;
	position: relative;
	display: inline-block;
}

.pageNav li:last-child {
	padding-right: 0;
}

.pageNav li a {
	color: #FFF;
	padding: 9px 14px 10px;
	box-sizing: border-box;
	-webkit-transition: background-color ease-out 0.6s;
    -moz-transition: background-color ease-out 0.6s;
    -o-transition: background-color ease-out 0.6s;
    transition: background-color ease-out 0.6s;
	display: block;
}
.forceCommunityNavigationMenu .menuItemLink{
	font-weight: bold !important;
}
.forceCommunityNavigationMenu .menuItemLink, .forceCommunityNavigationMenu .menuItemLink.triggerLink, .forceCommunityNavigationMenu .subMenuItem a[aria-disabled="false"]{
		font-family:"helvetica_ce_55_romanbold" !important;
		min-height: 40px;
		max-width:inherit !important; 
}



.pageNav > li.selected > a, .pageNav > li > a:hover ,
.forceCommunityNavigationMenu .menuItemLink:hover,
 .forceCommunityNavigationMenu .menuItemLink:focus,
  .forceCommunityNavigationMenu .menuItemLink.triggerLink:hover,
   .forceCommunityNavigationMenu .menuItemLink.triggerLink:focus, 
   .forceCommunityNavigationMenu .menuItem.current .menuItemLink, 
   .forceCommunityNavigationMenu .menuItem.current .menuItemLink.triggerLink
    {
	background: #00a4a2  !important;;
	color: #FFF  !important;
	min-height: 40px;
	font-family:"helvetica_ce_55_romanbold" !important;
	padding-top: 10px;
}

.selfServiceProfileMenuTrigger .trigger-link:focus{
	border: none !important;
	box-shadow:none !important;
}
.pageNav li .subMenu {
	background: #ffffff !important;
	position: absolute;
	top: 40px;
	left: -72px;
	border-top: 5px solid #005695;
	padding: 20px 20px;
	box-sizing: border-box;
	min-width: 750px;
	min-height: 320px;
	display: none;
	z-index: 100;
	overflow: hidden;
	border-left: 1px solid #e4e4de;
	border-right: 1px solid #e4e4de;
	border-bottom: 1px solid #e4e4de;
}

.pageNav li:hover .subMenu {
	display: block !important;
}

.leftSubNav {
	border-right: 1px solid #dcdcdc;
	float: left;
	min-width: 300px;
	padding-right: 15px;
	box-sizing: border-box;
}

.leftSubNav li {
	font-family: 'ubunturegular';
	font-weight: normal;
	font-size: 13px;
	text-transform: inherit!important;
	display: block;
	padding-right: 0;
	margin-bottom: 5px;
}

.leftSubNav li a {
	color: #005695;
	background: url(../learn_images/iconSubNav.png) no-repeat 10px 13px;
	padding: 6px 22px;
	box-sizing: border-box;
	display: block;
}

.leftSubNav li.selected a {
	background-position:10px 13px; 
}

.leftSubNav li a:hover, .leftSubNav li.selected {
	color: #222;
	background: #e8e8e8 url(../learn_images/iconSubNav.png) no-repeat 10px 13px;
}

.menuRightContent {
	font-family: 'ubunturegular';
	display: none;
}

.menuRightContent:first-child {
	display: block;
}

.menuRightContent span, .menuRightContent span a {
	font-size: 13px;
	color: #025595;
	padding: 5px 0;
	display: inline-block;
}

.titleSubnav {
	font-size: 13px;
	text-transform: uppercase;
	font-weight: bold;
}

.titleSubnav span {
	color: #00a4a3!important;
}


.menuRightContent p {
	font-weight: normal;
	color: #474746;
	display: block;
	white-space: normal;

}
.menuRightContent figure {
    margin: 0 !important;
}
.profileIcon{
display: none;
}
.titleSubnav {
	color: #025595;
}

.menuRightContent p a {
	color: #025595 !important;
	position: relative;
	display: inline-block;
}

.menuRightContent p em {
	background: url(../learn_images/iconNavMore.png) no-repeat center center;
	font-size: 14px;
	font-style: normal;
	width: 7px;
	height: 7px;
	-webkit-transition: all ease-out .5s;
    -moz-transition: all  ease-out .5s;
    -o-transition: all  ease-out .5s;
    transition: all  ease-out .5s;
    position: absolute;
    right: -10px;
    top: 4px;
}

.menuRightContent p a:hover em {
	-webkit-transform: rotate(360deg);
	-moz-transform: rotate(360deg);
	-ms-transform: rotate(360deg);
	-o-transform: rotate(360deg);
	transform: rotate(360deg);
}

.leftNavContent {
	font-size: 13px;
	font-weight: normal;
	text-transform: capitalize;
	max-width: 408px;
	width: 100%;
	float: left;
	padding: 5px 0 20px 20px;
	 box-sizing: border-box;
	 overflow: hidden;
}

.leftNavContent figure {
	padding-bottom: 8px;
}

.leftNavContent span {
	font-weight: bold;
}

.leftNavContent a {
	display: inline!important;
	padding: 0!important;
	color: #222!important;
}
.uiMenuItem:hover .subMenu{
	display: block;
}

.pageBanner {
	width: 100%;
	position: relative;
	border-bottom: 14px solid #005695;
	padding-bottom: 98px;
	box-sizing:border-box;
}

.bannercontentWapper {
	width: 100%;
	height: 100%;
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 100%;
	margin: 0;
}

.bannerContent {
	max-width: 1008px;
	margin: 0 auto;
	padding-top: 45px;
	box-sizing:  border-box;
}

.bannerContent p {
	font-family: 'Conv_HelveticaLTStd-Roman_1';
	font-size: 30px;
	color: #4a4a4a;
}

.bannerContent p span {
	font-family: 'Conv_HelveticaNeueLTStd-Md_2';
	font-size: 45px;
	color: #00a5a4;
}
.menuItemLink {
    padding: 9px 14px 10px !important;
}
.pageNav .slds-icon--xx-small.slds-icon{
	display: none !important;
}
.bx-caption {
	font-family: 'Conv_HelveticaNeueLTStd-Md_2';
	font-size: 25px;
	font-style: italic;
	font-weight: normal;
	color: #FFF;
	width: 100%;
	background: #00a4a2;
	padding: 30px 0;
	box-sizing: border-box;
	position: absolute;
	bottom: 0;
	left: 0;
	text-align: center;
}

.pageBanner ul {
	margin: 0;
	padding: 0;
}

#body .homeContent {
	margin: -36px auto 0 auto;
	padding: 50px 0 60px;
	box-sizing: border-box;
}

.homeVideo {
	background: #e7e7e8;
	max-width: 433px;
	width: 100%;
	margin-bottom: 50px;
}

.homeLeft {
	padding-right: 25px;
	box-sizing: border-box;
}

.homeRight {
	padding-left: 25px;
	box-sizing: border-box;
	float: right;
}

.homeContent h2 {
	font-family: 'Conv_MinionPro-BoldIt';
	font-size: 25px;
	color: #4a4a4a;
	padding-bottom: 10px;
	display: block;
        font-weight: normal !important;
}

.homeContent p {
	font-size: 14px;
	color: #6d6e71;
	padding-bottom: 30px;
}

.buttonBlue  {
	font-family: 'Conv_HelveticaNeueLTStd-Md_2';
	font-size: 17px;
	text-transform: capitalize;
	background: #025595 url(../learn_images/bgButtonArrow.png) no-repeat 30px center / 3% 30%;
	color: #FFF;
	padding: 9px 18px 6px 45px;
	box-sizing: border-box;
	-moz-border-radius: 50px;
	-webkit-border-radius: 50px;
	border-radius: 25px;
	display: inline-block;
}
 .buttonBlue:hover{
 	color: #FFF;
 	background-color: #02396b;
 	text-decoration: none !important;
 }
 .home_col_link{ color: #4a4a4a !important; }
 .home_col_link:hover{
 	 	text-decoration: none !important;
 }
.pageFooter {
	 background: #7a7a7a ;
    box-sizing: border-box;
    padding: 25px 0 130px;
    width: 100%;
}
 /*height:115px  !important; 
    display:block  !important; 
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;*/
 .textContent{
   max-height:115px  !important; 
    display:block  !important; 
     overflow: hidden;
    text-overflow: ellipsis;
}
.pageFooter p {
	font-size: 13px;
	color: #efefef;
}
.profileName111{
	background:transparent url("../learn_images/iconLogin.png") no-repeat scroll 0 4px !important;
    padding-left:  20px !important;
}
.pageFooter figure {
	float: left;
	padding: 40px 0 0;
	margin: 0px;
	box-sizing: border-box;
}

.pageFooter figure:last-child {
	float: right;
}
.pageBanner .carousel-switcher-container {
    display: none !important;
}
.acsliderBR_Carousel.carousel-container > .carousel-control{
	    height: 73px !important;
	    width: 45px !important;
}
.slds-button.menuItemLink.homeButton.slds-button--icon-border {
    display: none;
}
.homeContent.row{
	background: #fff !important;
}
.slds-col--padded{
	padding:0;
}
.headerRight .menuList li{
	display:none!important;
}
.headerRight .menuList li:first-child{
	display:block!important;
}
.headerRight .menuList li:last-child{
	display:block!important;
}
span.zero-state-panel-label{
	display:none!important;
}
.forceCommunityNavigationMenu{
	text-align:right;
}
.navigationMenuWrapper{
	text-align:left;
}
.toggleNav {
    	font-size: 30px !important;
	z-index:1000;
}
.navigationMenu li .homeLink{
	display:none;
}
.pageNav .navigationMenuWrapper.showElement > ul.navigationMenu{
	display:block !important;
}
.headerRight .selfServiceProfileMenu .login .profileIcon{
	display:none!important;
}
.headerRight .selfServiceProfileMenu .login .linkLabel{
	padding:0!important;
}

@media screen and (max-width:1060px) {
	.row {
		padding-right: 15px;
		padding-left: 15px;
		box-sizing: border-box;
	}
}

@media screen and (max-width:1024px) {
	.bannerContent{
		padding:45px 20px 0;
	}
	.homeContent iframe{
		width:100% !important;
	}
		
	
}

@media screen and (max-width:900px) {
	.pageBanner .bx-caption{
		padding-left:15px;
		padding-right:15px;
		font-size: 18px;
	}
	.bannerContent p{
		font-size: 25px;
	}
	.bannerContent p span{
	 	font-size: 35px;
	}
	.pageBanner{
		padding-bottom:80px;
	}

}

@media screen and (max-width:767px) {
	
	.pageNav li a{
		padding: 14px 14px 13px;
	}
	.leftNavContent{
		display:none  !important;
	}
	.bannerContent{
		padding-top: 35px;
		padding-left: 15px;
	}
	.bannerContent p{
	 	font-size: 20px;
	 }
	.bannerContent p span{
	 	font-size: 30px;
	}
	.bx-caption{
		font-size: 16px;
	}
	.pageHeader{
		text-align:center;
	}
	.pageLogo {
		float: none;
		height: 52px;
		margin: 20px 0 ;
		max-width: 300px;
		display:inline-block;
	}
	.headerRight,.cLearnHomeTemplate .headerRight{
		max-width:100% !important;
		width:100%;
		padding:0 0 20px;
		float:none;
		text-align:center;
		
	}
	.headerRight li{
		display:inline-block;
		float:none;
                background-color:#fff!important;
		/*max-width:170px;
		width:100%;*/
		position:relative;
		
	}
	.headerRight li:last-child{
		max-width:170px;
		width:100%;
	}
	.headerRight li input{
	 	border-radius:0 !important;	
	}
	.cLearnHomeTemplate .selfServiceProfileMenuTrigger .profileName,.selfServiceProfileMenuTrigger .profileName{
		display:block;
		width:300px;
	}
	
	.headerRight .selfServiceProfileMenu	{
		margin:0;

	}
	.headerRight li:first-child .loginWrapper.selfServiceProfileMenu{
		width:90px !important;
	}
	.headerRight .selfServiceProfileMenuTrigger{
		padding:0;
	}

	.headerRight .selfServiceProfileMenu .selfServiceProfileMenuTrigger,.headerRight .selfServiceProfileMenu .login {
	        position: relative;
	        right: 0;
	        top: 5px;
	}
	/*.headerRight .selfServiceProfileMenu .login .profileIcon{
		position: absolute;
	    	left:-60px;
	    	top: 4px;
		

	}*/
	.headerRight .selfServiceProfileMenu .login .linkLabel{
		display:inline-block;
		position:absolute;
		top:2px;
		left:8px;
		z-index:10;
	}
	
	.cLearnHomeTemplate .headerRight .uiPopupTrigger.selfServiceProfileMenuTrigger,.headerRight .uiPopupTrigger.selfServiceProfileMenuTrigger{
		display:block;
		max-width:170px!important ;
		width:100% !important ;
	}
	 .headerRight .selfServiceProfileMenuTrigger .profileName{
		max-width:95% ;
		position:relative;
		top:2px;
	}
	.headerRight li:first-child::after{
		right:10px;
	}
	.headerRight li:first-child{
		margin-right:20px;
	}
	.headerRight li .close-button{
		height:30px !important;
	}
	.search-wrapper{
		background:#fff;
	}
	.forceCommunityOmniBox.selfServiceSearchWrapper.focused .search-container{
		width:100%;
	}
	.cLearnHomeTemplate .selfServiceProfileMenuTrigger .trigger-link,.selfServiceProfileMenuTrigger .trigger-link{
		display:block;
	}

	.selfServiceSearchWrapper .search-button.uiButton{
		background-position:4px 7px !important;
	}
	.headerRight li:first-child::before{
		left:-13px;
		top:10px;
	}
	.headerRight li:first-child::after{
		top:15px;
	}
	.slds-icon-utility-search{
		position:absolute;
		left:10px;
		top:3px;
	}
	
	.subMenu,.leftSubNav{
		float:none;
		width:auto;
		min-width:auto;
		box-sizing:border-box;
		margin:0; 
	}
	.leftSubNav{
		padding:0;
		border-right:0;
	}
	
	.leftSubNav li a,.leftSubNav li a:hover, .leftSubNav li.selected a{
		background:url("../learn_images/iconSubNav.png") no-repeat scroll 3px 10px
	}
	.leftSubNav li a{ 
		padding:3px 14px;
	}
	.pageNav li .subMenu{ 
		min-height:auto; 
		min-width:auto;
		top:0;
		left:0;
	}
	.contentSection{
		padding-left:15px;
		padding-right:15px;
	}
	.pageBanner{
		padding-bottom:100px;
	}
	.headerRight .selfServiceProfileMenu .login .linkLabel,.headerRight .selfServiceProfileMenu .login .login-link{
		padding:0!important;
	}
}

@media screen and (max-width:640px) {
	.pageLogo, .headerRight {
		margin:0 auto;
		float: none;
		padding-top:15px;
	}
	
	#container {
		-moz-transition: all 500ms cubic-bezier(0.19, 1, 0.22, 1);
     -webkit-transition: all 500ms cubic-bezier(0.19, 1, 0.22, 1);
     transition: all 500ms cubic-bezier(0.19, 1, 0.22, 1);
	}
	
	 
	 
	 .pageLogo {
	 	height: inherit;
	 	text-align: center;
	 	padding-top: 15px;
	 }
	 
	 .pageLogo img {
	 	max-width: 80%;
	 }
	 
	.mobileNav {
		display: none;
	}
	
	.mobNav, .mobileNav {
		display: block;
	}
	
	.pageNav ul {
		display: none;
	}
	 
	 .pageBanner span {
	 	font-size: 13px;
	 	padding: 5px;
	 }
	
	 
	 .homeVideo {
	 	margin-bottom: 25px;
	 }
	 
	
	 
	 .homeContent h2 {
	 	font-size: 16px;
	 }
	 
	 .homeContent p {
	 	font-size: 13px;
	 	padding-bottom: 10px;
	 }
	 
	 .homeContent a {
	 	font-size: 15px;
	 	padding: 12px 55px;
	 }
	 
	.cLearnHomeTemplate .homeLeft,.homeLeft,.cLearnHomeTemplate .headerRight,.headerRight {
	 	padding: 15px 0 ;
	 	text-align: center;
	 
	 }
	 
	 .homeLeft {
	 	padding-bottom: 15px;
	 }
	 
	 .pageNav li:hover > .subMenu {
		display: none;
	}
	 
	 .pageFooter figure,.pageFooter figure:last-child {
	 	float: none;
	 	text-align: center;
	 	padding-top: 14px;
	 }
	.pageFooter{
		padding-bottom: 60px;
	}
	 .pageFooter figure:last-child img {
	 	max-width: 50%;
	 }
	 
	 .pageBanner li {
	 	height: 151px;
	 }
	 
	 .bx-caption {
	 	font-size: 12px;
	 	padding: 10px 0;
	 }
	 .bannerContent{
		padding-top: 15px;
	}
	.bannerContent p{
		font-size: 16px;
	}
	.bannerContent p span{
		font-size: 20px;
	}
	.pageBanner {
	    padding-bottom: 47px ;
	   
	}

}
@media screen and (max-width:600px) {
	
	.headerRight li:first-child,.cLearnHomeTemplate .headerRight li:first-child{
		padding-bottom:10px;
	}
	.headerRight,.cLearnHomeTemplate .headerRight{
		max-width:150px !important;
		width:100%;
		margin:0 auto !important;
	}
	.pageBanner {
		 min-height: 142px;
	)

}@media screen and (max-width:350px) {
	.pageLogo {
		padding:5px 0;
	}
	.cLearnHomeTemplate .homeLeft,.homeLeft,.cLearnHomeTemplate .headerRight,.headerRight {
	 	padding: 10px 0 ;
	 	text-align: center;
	 
	 }
}
