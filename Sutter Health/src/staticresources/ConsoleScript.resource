		/** @Description: function called onkeyup and onkeydown for subject field. It fetches the value of subject field 
		*	and assign it to the search field 
		**/
		function getSubject()
        {
			/** @Description: get the value of subject field in variable sub **/
            var sub = document.getElementById(subId).value;
			
			/** @Description: assign the sub's value to search field **/
			document.getElementById(stringId).value = sub;
			/** @Description: call the getTimer method **/
			getTimer();
		};
        
        var interval = 750;
        var lastKeypress = null;

		/** @Description: function called from getSubject function, this function calls getSub function if there is an interval in keypress **/
        function getTimer()
        {
			/** @Description: get current time in milliseconds **/
		    this.lastKeypress = new Date().getTime();
			/** @Description: assign this object to variable that **/
		    var that = this;
			/** @Description: function to call getSub if the interval between key press is greater than 750 millisec **/
		    setTimeout(function() {
				/** @Description: get current time in millisec **/
				var currentTime = new Date().getTime();
				/** @Description: if interval between keypress is greater than 750 **/
				if(currentTime - that.lastKeypress > that.interval) {
					/** @Description: call getSub function **/
					that.getSub();
				}
				/** @Description: increase the interval by 100 **/
		    }, that.interval + 100);
        }
        
		/** @Description: function getSub fetches the value of subject field, if the value's length is greater than 2, it calls the actionfunction
		*	to refresh the article search results and pass the search String value
		**/
        function getSub()
        {
			/** @Description: fetch the value of subject field **/
            var sub = document.getElementById(subId).value;
			
				if(sub.length>2)
				{
					/** @Description: call to actionfunction **/
					getSubjectFunc(sub);
				}
				else
				{
					getSubjectFunc('');
				}
        }
	        
	/** @Description: function called onkeypress for search fields for S3 searches, on press of enter it invokes the appropriate
	*	action function that in turn calls the search method in the controller
	**/
	function noenter(event, search)  {
			/** @Description: if event is 'Enter' **/
            if (window.event && window.event.keyCode == 13 || event.which == 13) {
                /** @Description: switch statement to invoke the appropriate search **/
				switch(search) {
                    case 1:
						/** @Description: invoke Employee search **/
                        doEmployeeSearch();
                        break;
                    case 2:
                        /** @Description: invoke Provider search **/
						doProviderSearch();
                        break;
                    case 3:
						/** @Description: invoke Vendor search **/
                        doVendorSearch();
                        break;
                    case 4:
						/** @Description: invoke Patient search **/
                        doPatientSearch();
                        break;
                    case 5:
						/** @Description: invoke Guarantor search **/
                        doGuarantorSearch();
                        break;
                    case 6:
						/** @Description: invoke Patient Account search **/
                        doPatientAccountSearch();
                        break;
                    default: 
                }
                return false;
            } else {
                return true; 
            }   
        } 
        /** @Description: function called onkeypress for search fields for SHP searches, on press of enter it invokes the appropriate
		*	action function that in turn calls the search method in the controller
		**/
        function noenter1(event, search)  {
            /** @Description: if event is 'Enter' **/
			if (window.event && window.event.keyCode == 13 || event.which == 13) {
                /** @Description: switch statement to invoke the appropriate search **/
				switch(search) {
                    case 1:
						/** @Description: invoke Member search **/
                        doMemberSearch();
                        break;
                    case 2:
						/** @Description: invoke Provider search **/
                        doProviderSearch();
                        break;
                    case 3:
						/** @Description: invoke Broker search **/
                        doBrokerSearch();
                        break;   
                    case 4:
						/** @Description: invoke Employer search **/
                        doEmployerSearch();
                        break; 
                    case 5:
						/** @Description: invoke Claim search **/
                        doClaimSearch();
                        break;
                    default:
                }
                return false;
            } else {
                return true;        
            }
        }
        /** @Description: function called on change of field Claim start date, if Claim end date value is blank, it assign
		*	Claim start date value to end date value
		**/
        function dateAssignStart() {
			/** @Description: fetch value of Search start date **/
            var startSearch = document.getElementById('{!$Component.SearchStart}');
			/** @Description: fetch value of Search end date **/
            var endSearch = document.getElementById('{!$Component.SearchEnd}');
			/** @Description: check if the value of end date is null or empty **/
            if(endSearch.value == null || endSearch.value == "") {
				/** @Description: assign value of start date to end date **/
                endSearch.value = startSearch.value;
            } 
        }
        /** @Description: function called on change of field Claim end date, if Claim start date value is blank, it assign
		*	Claim end date value to start date value
		**/
        function dateAssignEnd() {
			/** @Description: fetch value of Search start date **/
            var startSearch = document.getElementById('{!$Component.SearchStart}');
			/** @Description: fetch value of Search end date **/
            var endSearch = document.getElementById('{!$Component.SearchEnd}');
			/** @Description: check if the value of start date is null or empty **/
            if(startSearch.value == null || startSearch.value == "") {
				/** @Description: assign value of end date to start date **/
                startSearch.value = endSearch.value;
            } 
        }
        /** @Description: function called on click of Attach to Customer Interaction button, it passes the article id to the controller method
		*	attach which attaches the article selected to the case 
		**/
        function selectedValue(){
			/** @Description: empty variable declared **/
            var checkeditem ='';
			/** @Description: fetch checkbox elementss **/
            var checkboxes = document.getElementsByName("check");
            for (var i = 0; i < checkboxes.length; i++) {
                /** @Description: if checkbox is checked **/
				if (checkboxes[i].checked) {
					/** @Description: concatenate all the article id for which checkboxes have been checked **/
                    checkeditem = checkeditem + (checkeditem ='' ? '' : ',' ) + checkboxes[i].value;
                }
            }
			/** @Description: call the actionfunction passArticle and pass the article ids **/
            passArticle(checkeditem);
        }
        
        /** @Description: function called on check of article checkbox, it activates the Attach to Customer Interaction button on 
		*	check of a checkbox
		**/
        function selectedValueCheck(){
			/** @Description: disable the attach button on page load and change its css **/
            document.getElementById(attachBtn).disabled=true;
            document.getElementById(attachBtn).style.borderColor='#C4C4C4';
            document.getElementById(attachBtn).style.color='#909090';
			/** @Description: fetch all the article checkboxes **/
			var checkboxes = document.getElementsByName("check");
			/** @Description: declare an empty variable **/
            var checkeditem = '';
			/** @Description: declare count and initialize it to 0 **/
			var count = 0;
            for (var i = 0; i < checkboxes.length; i++) {
				/** @Description: if checkbox is checked **/
                if (checkboxes[i].checked) {
					/** @Description: increment count by 1 **/
                    count++;
					/** @Description: if count is greater than 0 **/
                    if (count>0){ 
						/** @Description: activate the attach and change its css **/
                        document.getElementById(attachBtn).disabled=false;
                        document.getElementById(attachBtn).style.borderColor="#7F7F7F";
                        document.getElementById(attachBtn).style.color="#333333";
                    }else{
						/** @Description: disable the attach button and change its css **/
                        document.getElementById(attachBtn).disabled=true;
                        document.getElementById(attachBtn).style.borderColor='#C4C4C4';
                        document.getElementById(attachBtn).style.color='#909090';
                    }
                }
            }
        }
		
        /** @Description: function called on check of checkboxes of fields in verification panel, also the function is called on 
		*	verification panel load
		**/
        function fn_count(){
		/** @Description: fetch the value of validation no. hidden field **/
        var valno = document.getElementById(validationId).value;
		/** @Description: fetch panel element by id **/
	    var panel = document.getElementById("pg:theform:pgBlock:verificationPanel");
			/** @Description: disable the verify button and change its css on verification panel load **/
            document.getElementById(verifyBtn).disabled=true;
            document.getElementById(verifyBtn).style.borderColor='#C4C4C4';
            document.getElementById(verifyBtn).style.color='#909090';
			/** @Description: fetch all the input elements in panel **/
            var checkboxes = panel.getElementsByTagName("input"); 
			/** @Description: declare an empty variable **/
            var selectedLabel = '';
			/** @Description: declare count variable and intialize it to 0 **/
            var count = 0;
			/** @Description: loop on all the checkboxes **/
			for (var i = 0; i < checkboxes.length; i++) { 
				/** @Description: if the input element type is checkbox and is checked **/
				if(checkboxes[i].type == 'checkbox' && checkboxes[i].checked == true){
					/** @Description: concatenate the value of label of checkboxes checked  **/
					selectedLabel = selectedLabel + (selectedLabel ='' ? '' : ',' ) + checkboxes[i].getAttribute('label');
					/** @Description: increment count by 1 **/
					count++;
					/** @Description: if checkboxes checked is greater than validation no. **/
					if (count>=valno){
						/** @Description: enable the verify button and change its css **/
						document.getElementById(verifyBtn).disabled=false;
						document.getElementById(verifyBtn).style.borderColor="#7F7F7F";
						document.getElementById(verifyBtn).style.color="#333333";
					}else{
						/** @Description: disable the verify button and change its css **/
						document.getElementById(verifyBtn).disabled=true;
						document.getElementById(verifyBtn).style.borderColor='#C4C4C4';
						document.getElementById(verifyBtn).style.color='#909090';
					}
				}
			}
        }
        /** @Description: function called on click of Verified button on verification panel, it passes the article ids to the controller method
		*	contactverification
		**/
        function fn_countVerify(){
		/** @Description: fetch the panel by id **/
	    var panel = document.getElementById("pg:theform:pgBlock:verificationPanel");
			/** @Description: all the input elements in the panel **/
            var checkboxes = panel.getElementsByTagName("input");
			/** @Description: declare an empty variable **/
            var selectedLabel = '';
			/** @Description: loop on all the checkboxes **/
			for (var i = 0; i < checkboxes.length; i++) { 
				/** @Description: if the input element type is checkbox and is checked **/
				if(checkboxes[i].type == 'checkbox' && checkboxes[i].checked == true){
					/** @Description: concatenate the value of label of checkboxes checked  **/
					selectedLabel = selectedLabel + (selectedLabel ='' ? '' : ',' ) + checkboxes[i].getAttribute('label');
				}
			}
			passValues(selectedLabel); 
        }
		/** @Description: function to hide show more link **/
		function hideShowMore() {
			/** @Description: fetch all anchore tag elements on page **/
			var linkArr = document.getElementsByTagName("a");
			/** @Description: iterate over all the anchor elements **/
			for(var i = 0; i < linkArr.length; i++) {
				/** @Description: if href of anchor tag contains showMoreList string **/
				if(linkArr[i].href.indexOf("showMoreList") != -1) {
					/** @Description: change the anchor tag's display to none **/
					linkArr[i].style.display = 'none';
				}
			}
		}
        
        /** @Description: function called on render of interaction log detail page to hide the inline visualforce page **/
        function hideInlineVF(){
			/** @Description: fetch the ids of the iframes on page **/
        	var iframeVar = document.getElementsByTagName('iframe');
        	for(var i=0; i<iframeVar.length; i++){
				/** @Description: if iframe 'title' == VFP03_Inline_ClaimSearch_Link, hide the iframe **/
        		if(iframeVar[i].title == 'VFP03_Inline_ClaimSearch_Link'){
        			iframeVar[i].style.display = 'none';
        		}
        	}
        }
	
	/** @Description: function to check all the checkboxes at once **/
	function checkAll(cb)
        {
            var inputElem = document.getElementsByTagName("input");
            for(var i=0; i<inputElem.length; i++)
            {
                if(inputElem[i].id.indexOf("checkedone")!=-1){
                	inputElem[i].checked = cb.checked;
		}
            }
        }
		
	/** @Description: function to open a new Interaction Log when 'Save & New' button is clicked **/
	function openNewIL(){
			
		var callid_Id = 'pg:theform:callId_Id';
		var callid = document.getElementById(callid_Id).value;
		var dnisId = 'pg:theform:dnisId';
		var DNIS = document.getElementById(dnisId).value;
		var calldtId = 'pg:theform:calldtId';
		var CALLDT = document.getElementById(calldtId).value;
		var relatedLinkId = 'pg:theform:relatedLinkId';
		var devId = 'pg:theform:devId';
		var DEV = document.getElementById(devId).value;
		var aniId = 'pg:theform:aniId';
		var ANI = document.getElementById(aniId).value;
		var exitPathId = 'pg:theform:exitPathId';
		var EXITPATH = document.getElementById(exitPathId).value;
		var dnistcId = 'pg:theform:dnisTypeCodeId';
		var DNISTC = document.getElementById(dnistcId).value;
		var TRANF = 'NO';
		
		var errorBool = 'pg:theform:saveError';
		var erroBoolStr = document.getElementById(errorBool).value;
		var callidText = "callid";
		var DNISText = "DNIS";

		var CALLDTText = "CALLDT";
		var DEVText = "DEV";
		var ANIText = "ANI";
		var TRANFText = "TRANF";
		var EXITPATHText = "EXITPATH";
		var equals = "=";
		var and = "&";
		var DNISTCText = "DNISTC";
		
		var parameters = callidText + equals + callid + and + DNISText + equals + DNIS + and;
		parameters += CALLDTText + equals + CALLDT + and;
		parameters += DEVText + equals + DEV + and + ANIText + equals + ANI + and;
		parameters += TRANFText + equals + TRANF + and + EXITPATHText + equals + EXITPATH + and;
		parameters += DNISTCText + equals + DNISTC; 
		
		if(erroBoolStr == 'false')
		{
			sforce.console.openPrimaryTab(null, '/apex/VFP01_CustomConsole?' + parameters, true, 'Console');
		}
	}