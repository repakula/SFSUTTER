/**********************************************************************************  
*     Class Name  : CorrespondencePreview                                         *
*     Author      : IDC Offshore                                                  *
*     Date        : 09-Sept-2014                                                  *
*     Project Name: CRM - SFT - Sutter Health                                     *          
*     Description : contoller for VisualForce page Broker_Correspondence_Preview
*     History
       -------
    VERSION  AUTHOR        DATE           DETAIL                 Description
    1.0      IDC Offshore  09-Sept-2014  Initial creation   Intial Creation
    1.1      IDC Offshore  12-Dec-2015   Updated            Commented unused variables
***********************************************************************************/

public class CorrespondencePreview {
    //public String test {get;set;}    
    //public EmailTemplate lstEmailTemplate{get;set;}  
    //public BrandTemplate lstBrandTemplate{get;set;}  
    //public string bvalue{get;set;}  
   // public string dummyStr{get;set;}  
    public string currentRecordId{get;set;}  
    public Correspondence_Letter__c objCorrespLetter{get;set;}  
    public string objLetterContent {get;set;}
    
    /***********************************************************************************  
    *     @Author      : IDC Offshore                                                  *
    *     @Date        : 09-Sept-2014                                                  *
    *     @Project Name: CRM - SFT - Sutter Health                                     *          
    *     @Description : Contructor of the CorrespondencePreview class                 *
    *     @param       : ApexPages.StandardController, Corresspondence Letter ID       *
    *     @return      : Letter Content                                               *  
    ************************************************************************************/
        public CorrespondencePreview(ApexPages.StandardController controller) {

        currentRecordId = ApexPages.CurrentPage().getparameters().get('id');
        objCorrespLetter = [select Letterbody__c, Letter_Content__c from Correspondence_Letter__c where id = : currentRecordId];
        try {
            objLetterContent  = objCorrespLetter.Letter_Content__c;
            Integer i = objLetterContent .indexOf('http');
            Integer j = objLetterContent .indexOf(']', i);
            if (j == -1) {
                j = objLetterContent .indexOf('<', i);
            }
            objLetterContent  = objLetterContent .substring(i, j);
            objLetterContent  = objLetterContent.replace('amp;', '');
           
        } catch (Exception e) {
            objLetterContent  = objCorrespLetter.Letter_Content__c;
        }
        

    }

}