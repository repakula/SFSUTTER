/*
    This class is used to cover the SH_Help_Support class
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Prashant Kumar          05/10/2015                   1.0
    ==========================================================  
*/
@isTest(seeAllData=true)
private class SH_Help_SupportTest { 

    //this method is used to cover the testcoverage of SH_Help_Support class
    static testmethod void validateHelp_SupportTest()
    {
        
        string strRecID = SH_Common.GetRecordTypeId('Case', 'Employee Inquiry');
        Test.startTest();
        User objUser = SH_CommonTest.CreateCommunityUser();
        Contact userContact = [Select Employee_EEO_SubCode__c from contact where id = :objUser.ContactId];
        userContact.Employee_EEO_SubCode__c = 'AA';
        update userContact;
        Case objcase = SH_CommonTest.CreateCase(objUser.id, objUser.contactid, strRecID);
        Test.stopTest();
		SH_Menu_Item__c menuItem =  new SH_Menu_Item__c(
														SH_Employee_EEO_subcode__c = userContact.Employee_EEO_SubCode__c,
														Name = 'Benifits',
														SH_Function__c = 'Human Resource',
				    									SH_Sub_Function__c = 'HR Benefits',
				    									SH_Team__c = 'Benifit Team',
				    									SH_Customer_Intent__c = 'General Inquiry',
														SH_Is_Publish__c = true,
														SH_Icon__c = 'image',
														SH_Content_Image_Url__c = 'image1'
														);
		insert menuItem;
		SH_Sub_Menu_Item__c subMenu =  new SH_Sub_Menu_Item__c(
						    									Name = 'test subMenu',
						    									SH_Function__c = 'Human Resource',
						    									SH_Sub_Function__c = 'HR Benefits',
						    									SH_Team__c = 'Benifit Team',
						    									SH_Customer_Intent__c = 'General Inquiry',
						    									SH_Menu_Item__c = menuItem.id,
						    									SH_Is_Publish__c = true
						    									);
		insert subMenu;
        system.runAs(objUser)
        {
            Apexpages.currentpage().getparameters().put('Id',objcase.ID);
            Apexpages.currentPage().getParameters().put('L1','test');
            Apexpages.currentPage().getParameters().put('L1Id','test');
            Apexpages.currentPage().getParameters().put('L2','test');
            Apexpages.currentPage().getParameters().put('L2Id','test');
            Apexpages.currentPage().getParameters().put('isHelp','true');
            //Apexpages.currentPage().getParameters().put('M','true');
            //Apexpages.currentPage().getParameters().put('SM','test');
            Apexpages.currentPage().getParameters().put('M','');
            Apexpages.currentPage().getParameters().put('SM','');
            Apexpages.currentPage().getParameters().put('T','test');
            Apexpages.currentPage().getParameters().put('CI','test');
            Apexpages.currentPage().getParameters().put('C','test');
            Apexpages.currentPage().getParameters().put('IsCase','true');
            Apexpages.currentPage().getParameters().put('H','true');
            Apexpages.currentPage().getParameters().put('IsSearch','true');
            Apexpages.currentPage().getParameters().put('q','true');

            SH_Help_Support objHelp_support = new SH_Help_Support();
            list<SH_Help_Support.NVWrapper> currentMItem = SH_Help_Support.getMenuItems();
            String selectedId = currentMItem.isEmpty() ? '' : currentMItem[0].Id;
            objHelp_support.selectedMenuItem = selectedId;
            list<SH_Help_Support.NVWrapper> currentsMItem = SH_Help_Support.getSubMenuItems(objHelp_support.selectedMenuItem);
            String selectedSubId = currentsMItem.isEmpty() ? '' : currentsMItem[0].Id;
            objHelp_support.selectedSubMenuItem = selectedSubId;
            objHelp_support.strCategoryForHelp = null;
            objHelp_support.strSubCategoryForHelp = null;
            Attachment thisAttachment = objHelp_support.getAttachment();
            thisAttachment.name = 'test Attachment';
            thisAttachment.body = Blob.valueOf('Test file body!');
            objHelp_support.setAttachment(thisAttachment);
            objHelp_support.CreateCase();
            //3930 Using other unknown options
            objHelp_support.selectedMenuItem = SH_Help_Support.UNKNOWN_ID;
            objHelp_support.selectedSubMenuItem = SH_Help_Support.OTHER_NOT_SPECIFIED_ID;
            objHelp_support.strCategoryForHelp = null;
            objHelp_support.strSubCategoryForHelp = null;
            objHelp_support.CreateCase();
            //confirm routing
            Id caseID = Apexpages.currentPage().getParameters().get('Id');
            Case newCase = [Select Function__c, Sub_Function__c, Team__c, Customer_Intent__c from case where id = :caseID];
            //system.assert(newCase.Function__c == SH_Help_Support.UNKNOWN_ID_SUBMENU.SH_Function__c); *12/8* Removed, manually set by agent
			//system.assert(newCase.Sub_Function__c == SH_Help_Support.UNKNOWN_ID_SUBMENU.SH_Sub_Function__c); 
			system.assert(newCase.Team__c == SH_Help_Support.UNKNOWN_ID_SUBMENU.SH_Team__c);
			system.assert(newCase.Customer_Intent__c == SH_Help_Support.UNKNOWN_ID_SUBMENU.SH_Customer_Intent__c);

            //3930 Using unknown submenu options
            objHelp_support.initialize();
            objHelp_support.selectedMenuItem = selectedId;
            objHelp_support.selectedSubMenuItem = SH_Help_Support.OTHER_NOT_SPECIFIED_ID;
            objHelp_support.strCategoryForHelp = null;
            objHelp_support.strSubCategoryForHelp = null;
            objHelp_support.CreateCase();
            //confirm routing
            caseID = Apexpages.currentPage().getParameters().get('Id');
            newCase = [Select Function__c, Sub_Function__c, Team__c, Customer_Intent__c from case where id = :caseID];
            SH_Menu_Item__c mItem = [select SH_Function__c,SH_Sub_Function__c, SH_Team__c, SH_Customer_Intent__c from SH_Menu_Item__c where id = :selectedId];
            system.assert(newCase.Function__c == mItem.SH_Function__c);
			system.assert(newCase.Sub_Function__c == mItem.SH_Sub_Function__c); 
			system.assert(newCase.Team__c == mItem.SH_Team__c);
			system.assert(newCase.Customer_Intent__c == mItem.SH_Customer_Intent__c);
			 
        }
    }
}