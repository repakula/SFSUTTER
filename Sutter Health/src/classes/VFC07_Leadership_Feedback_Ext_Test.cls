/**  
 *     Class Name  : VFC07_Leadership_Feedback_Ext_Test
 *     Author      : IDC Offshore
 *     Date        : 11-June-2014
 *     Project Name: CRM - SFT - Sutter Health
 *     Description : Test Class for VFC07_Leadership_Feedback_Ext Class. This class tests creating a new record and saving that record scenario.
 **/
@isTest(seeAllData = true)
private class VFC07_Leadership_Feedback_Ext_Test {

    /**    
    * @author IDC Team    
    * @date 31/07/2014    
    * @description create a new Managers feedback record and save.    
    * @return void    
    */
    static testMethod void testSave() 
    {
        Managers_Feedback__c MFInfo = new Managers_Feedback__c();
        MFInfo.Service_Area__c= 'Benefits  & Retirement';
    
        // insert MFInfo;
    
        ApexPages.StandardController ApptController = new ApexPages.StandardController(MFInfo);
    
        VFC07_Leadership_Feedback_Ext  vlf = new VFC07_Leadership_Feedback_Ext(ApptController);
        
        vlf.saveAndSend(); 
        vlf.showMsg=true; 
        vlf.saveAndSend();
        
        //added on 05-Oct-2015 to cover SH_VFC07_Leadership_Feedback_Ext class by SaasFocus
        SH_VFC07_Leadership_Feedback_Ext sh_Vlf = new SH_VFC07_Leadership_Feedback_Ext(ApptController);
        sh_Vlf.saveAndSend(); 
        sh_Vlf.showMsg=true; 
        sh_Vlf.saveAndSend();
        
        // Assert to check SH_VFC07_Leadership_Feedback_Ext
        system.assertnotequals(vlf,null);
        
     }

}