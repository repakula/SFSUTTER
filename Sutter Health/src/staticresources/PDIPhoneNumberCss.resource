#MainDiv {
    Width:95%;
    height:100%;
    /*border:1px solid red;*/
    margin : 0px auto;
    }
    #LeftContent {
    overflow-x: auto;
    height: auto;
    border:1px solid lightgray; 
    float:left;
    -webkit-box-shadow: inset -2px 3px 17px -1px rgba(0,0,0,0.75);
    -moz-box-shadow: inset -2px 3px 17px -1px rgba(0,0,0,0.75); 
    box-shadow: inset -2px 3px 17px -1px rgba(0,0,0,0.75);
    }
    .leftwidthFfull { 
        Width:100% !important;
    }
    .leftwidth {
        Width:50% !important;
    }
    .rightContentDisplay {
        display:block;
    }
    .rightContentDisplayHide {
        display:none;
    }
    .validateBtnDisplay {
        display:block;
    }
    .validateBtnDisplayHide {
        display:none;
    }
    .Display {
        display:block;
    }
    .DisplayHide {
        display:none;
    }
    #RightContent {
    Width:49%;
    border:1px solid lightgray;
    float:right;
    -webkit-box-shadow: inset -2px 3px 17px -1px rgba(0,0,0,0.75);
    -moz-box-shadow: inset -2px 3px 17px -1px rgba(0,0,0,0.75);
    box-shadow: inset -2px 3px 17px -1px rgba(0,0,0,0.75);
    min-height:600px;
    }
    
    .pbSubsection1 {
        max-height:350px;
        min-height:350px;
        overflow-y: auto;
    }
    .pbBody .pbSubheader {
        text-align:left;
    }
    .leftTd {
        text-align: right;
        padding: 5px;
        font-size: 12px;
        font-weight: bold;
    }
    .rightTd {
        text-align: light;
        padding: 5px;
        font-size: 12px;
        /*font-weight: bold;*/
    }
    .pbButton {
        display: none;
    }
    .pbButtonb {
        display: none;
    }
    .pbSubsection {
        overflow-y: hidden;
    }
    .DivAddress .pbSubsection {
        overflow-y: auto;
        max-height: 310px;
        min-height: 245px;
        height: 483px;
    }
    .bPageBlock .pbBody .pbSubheader {
        background-color: #c0be72 !important;
    }
    .overlay {
        opacity: 0.9;
        position: absolute;
        background: black;
        top: 0px;
        left: 0px;
        z-index: 99999;
        height: 100%;
    }
    .OverlayContainer {
        width: 80%;
        z-index: 99999;
        position: relative;
        margin: 0px auto;
        margin-top: -300px;
        top:-640px;
        background: white;
        height: 600px;
        border-radius: 10px 10px 10px 10px;
        overflow-y:scroll;
    }
    fieldset legend {
        font-weight: bold;
        color: black;
        text-align: left;
    }
    fieldset {
        border:2px solid #166699;
        border-radius:5px;
        
    }
    #addressValidate{
    font-weight: bold;
    color: black;
    text-align: left;
    width:95%
    }
    #providerDetails{
    font-weight: bold;
    color: black;
    text-align: left;
    width:95%
    }
    #AdminAssistant{
    font-weight: bold;
    color: black;
    text-align: left;
    width:95%
    }
    .addressUpdateDiv{
        width: 100%;
        margin: 0px auto;
        padding-top: 25px;
    }
    
    span#saveMsgCustInqId {
    display: block;
    text-align: center;
    color: green;
    font-weight: bold;
    }
    span#saveMsgProvider {
    display: block;
    text-align: center;
    color: green;
    font-weight: bold;
    -webkit-animation: fade 120s;
    -webkit-animation-fill-mode: both;
    }
    
    @-webkit-keyframes fade {
        0% {
            opacity: 0;
        }
        
        10% {
            opacity: 1;
        }
        
        90% {
            opacity: 1;
        }
        
        100% {
            opacity: 0;
        }
    }
    
    span#saveMsgCustInqId {
    
    margin: 0 auto;
    text-align: center;
    -webkit-animation: fade 60s;
    -webkit-animation-fill-mode: both;
    }
    .requiredInput {
        position: relative;
        height: 100%;
    }
    .requiredInput .requiredBlock {
        background-color: #c00;
        position: absolute;
        left: -4px;
        width: 3px;
        top: 1px;
        bottom: 1px;
    }
    #contentLoading {
    position: fixed;
    top: 0; right: 0; bottom: 0; left: 0;
    opacity: 0.5;
    -moz-opacity:0.5;
    z-index: 999999;
    }
    .label{
        font-weight:bold;
        text-align:left;
        font-size:11px;
    }