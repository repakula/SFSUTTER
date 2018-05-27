/**  
 *     Class Name  : VFC_Manager_Feedback_Comment_Ext_Test
 *     Author      : IDC Offshore
 *     Date        : 22-Aug-2014
 *     Project Name: CRM - SFT - Sutter Health
 *     Description : Test Class for VFC_Manager_Feedback_Comment_Ext Class.tests scenerios creating a new record , saving that record and canceling that record.
**/
@isTest
private class VFC_Manager_Feedback_Comment_Ext_Test
{ 

    /*******************************************************************
    Purpose: Create test data used by all tests  
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    @testsetup
    Static void createTestData()
    {
        Managers_Feedback__c mfeedbackRecord = new Managers_Feedback__c();
        mfeedbackRecord.Service_Area__c= 'Benefits & Retirement';
        insert mfeedbackRecord; 
        //Assert to check if managerfeedbackRecord record has been created successfully 
        system.assert(mfeedbackRecord.id!= null);
        
    }
    
    /*******************************************************************
    Purpose: Create a new Manager feedback comment record and save
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: [NA]
    ********************************************************************/
    static testmethod void saveMFComments(){
        Managers_Feedback__c mfeedbackRecord = [select id from Managers_Feedback__c where Service_Area__c= 'Benefits & Retirement' limit 1 ];
        //Assert to check manager feedback has been fetched  successfully 
        system.assert(mfeedbackRecord != null);
    
        Test.startTest();
        Manager_Feedback_Comment__c comment = new Manager_Feedback_Comment__c();      
        ApexPages.StandardController apptController = new ApexPages.StandardController(comment );
        PageReference pageRef = Page.VFP_Manager_Feedback_Comment;
        Test.setCurrentPage(pageRef);  

        String mfeedbackId = String.valueOf(mfeedbackRecord.id);                
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('feedbackid', mfeedbackId );
        
        VFC_Manager_Feedback_Comment_Ext  mfComment = new VFC_Manager_Feedback_Comment_Ext(apptController);
        mfComment.commentRecord.comments__c = 'Tested';
           
        mfComment.save();       
        Test.stopTest();
        
        List<Manager_Feedback_Comment__c> mFCommentRecords = [select id from Manager_Feedback_Comment__c where id =: mfeedbackRecord.id limit 1];
        //Assert to check if managerfeedback comment  record has been created successfully 
        system.assert(mFCommentRecords != null);         
    }
    
    /*******************************************************************
    Purpose: To Test negative scenario (Error :Manager feedback record id not matched.)
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]: Inavlid id
    ********************************************************************/
    static testmethod void saveMFCommentsException(){
        Test.startTest();
        try{
            Manager_Feedback_Comment__c comment = new Manager_Feedback_Comment__c();      
            ApexPages.StandardController apptController = new ApexPages.StandardController(comment );
            PageReference pageRef = Page.VFP_Manager_Feedback_Comment;
            Test.setCurrentPage(pageRef); 
            String mfeedbackId = 'Test';
            
            // Add parameters to page URL
            ApexPages.currentPage().getParameters().put('feedbackid', mfeedbackId );
            
            VFC_Manager_Feedback_Comment_Ext  mfComment = new VFC_Manager_Feedback_Comment_Ext(apptController);
            comment.Comments__c='Testing';
            comment.Managers_Feedback__c = mfeedbackId ;
            
            insert comment ;
            mfComment.save();    
        }Catch(Exception ex){ 
            system.assert(ex.getMessage()!=null);
        }  
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: Create a new Manager feedback comment record without providing manager feedback record id and save. 
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]:  [NA]
    ********************************************************************/
    static testmethod void savewithoutMFrecordId(){
        Test.startTest();
        Manager_Feedback_Comment__c comment = new Manager_Feedback_Comment__c();      
        ApexPages.StandardController apptController = new ApexPages.StandardController(comment );
        PageReference pageRef = Page.VFP_Manager_Feedback_Comment;
        Test.setCurrentPage(pageRef);  
        VFC_Manager_Feedback_Comment_Ext  mfComment = new VFC_Manager_Feedback_Comment_Ext(apptController);
        //Assert to check manager feedback comment record 
        system.assert(mfComment.commentRecord == null); 
                  
        mfComment.save();  
        mfComment.cancel();     
        
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: Create a new Manager feedback comment record and cancel. 
    Parameters: [NA]
    Returns: [NA]
    Throws [Exceptions]:  [NA]
    ********************************************************************/
    static testmethod void cancelMFComments(){
    
        Managers_Feedback__c mfeedbackRecord = [select id from Managers_Feedback__c where Service_Area__c= 'Benefits & Retirement' limit 1 ];
        //Assert to check manager feedback has been fetched  successfully 
        system.assert(mfeedbackRecord != null);
        
        Test.startTest();
        Manager_Feedback_Comment__c comment = new Manager_Feedback_Comment__c();      
        ApexPages.StandardController apptController = new ApexPages.StandardController(comment );
        PageReference pageRef = Page.VFP_Manager_Feedback_Comment;
        Test.setCurrentPage(pageRef); 
          
        String mfeedbackId = String.valueOf(mfeedbackRecord.id);                
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('feedbackid', mfeedbackId );
        
        VFC_Manager_Feedback_Comment_Ext  mfComment = new VFC_Manager_Feedback_Comment_Ext(apptController);
        mfComment.commentRecord.comments__c = 'Tested';
           
        mfComment.cancel();       
        Test.stopTest();              
    }

}