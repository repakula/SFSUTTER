/**  
*    Class  Name: ManageCorrespondenceHelper
*    Author: IDC Offshore
*    Date: 20-October-2015
*    Description: This helper class is using in ManageCorrespondence Trigger 
*                  In This Class   we are creating look up for Subscriber__c  so Dependent member correspondence will appear in related list.
*    History
*    --------
*    VERSION    AUTHOR           DATE        DETAIL 
*       1.0     IDC Offshore   20/10/2015   Helper class for ManageCorrespondence 
*       
**/

public class ManageCorrespondenceHelper {
    
    
    /**
    * @author       :   IDC Offshore 
    * @date         :   20-October-2015
    * @version      :   1.0
    * @description  :   Added for Correspondence member employer  Req no 3378 to check record type  and id for Sobject
    * @param        :   Map
    * @return       :   Map
    */ 
    public  static Map<string, string> checkRecordType(string objectType)
    {   Map<String,String> contactRecordTypes = new Map<String,String>();

         try {  
                List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType= :objectType and isActive=true];

             /** @Description: Iterate over the list of all record type and return record type value and ID**/
                for(RecordType rt: rtypes){

                    contactRecordTypes.put(rt.Name,rt.Id);

                }
                     } catch(Exception e) {
                     System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
                }
                
     return contactRecordTypes;
    } 
    
     /**
    * @author       :   IDC Offshore 
    * @date         :   20-October-2015
    * @version      :   1.0
    * @description  :   Assigning lookup id  in  Subscriber__C to make dependent related list
    * @param        :   List
    * @return       :   Void
    */
    public static void insertCorrespondenceSubscriber ( List < Correspondence_Letter__c > InsertedCorrespondenceList ){
          
    List<Account> accTempList = new List<Account>();
    List<Contact> conTempList = new List<Contact>();
    Map<string, account> accountMap = new Map<string, account>();  // create map of string(Subscriber_HCC_ID__c) and account object 
    Map<string, contact > contactMap = new Map<string, contact>(); // create map of string(Member_ID__c) and contact object 
    map <string ,string> recordtype = new map <string,string>();  
    string objectType= 'contact';
    recordtype = checkRecordType(objectType);
    String value = recordtype.get(system.label.CL08_Member);      
    try {
            if (!InsertedCorrespondenceList.isEmpty()){
                conTempList = [select id ,Accountid, Account.Subscriber_HCC_ID__c, Member_ID__c, MemberIdField__c from contact where RecordTypeid = :value  AND Member_ID__c != null  limit 50000 ];
                // inserting list of contact in contact map  Member_ID__c as a key and  contact object is value 
                for(  contact con : conTempList ) {
                    if(String.isNotBlank(con.Member_ID__c)) 
                    {
                        contactMap.put(con.Member_ID__c, con);
                    }
                }
            
                // inserting  list of account in map Subscriber_HCC_ID__c is key and account object is a value
                for(  account acc: [select id, SHP_Group_ID__c , Subscriber_HCC_ID__c from account where RecordType.Name = :system.label.CL174_SHP_Subscriber AND Subscriber_HCC_ID__c != null limit 50000 ]) {
                    if(String.isNotBlank(acc.Subscriber_HCC_ID__c)) 
                    {
                        accountMap.put(acc.Subscriber_HCC_ID__c, acc);
                    }
                }
                   
                    
                for(Correspondence_Letter__c corres  : InsertedCorrespondenceList)
                {
                    //  Checking in condition SHP_Correspondence_Entity_Recipient_HCC__c should not be equal to null and  SHP_Entity_Type__C type should be member to ensure that it should work only for member contact
                    if(corres.SHP_Correspondence_Entity_Recipient_HCC__c != null  && corres.SHP_Entity_Type__C ==system.label.CL08_Member) 
                    {   // Checking in Condition  map should not be null and  Value of SHP_Correspondence_Entity_Recipient_HCC__c should be exist in contact object
                        if ( !contactMap.isempty() && corres.SHP_Correspondence_Entity_Recipient_HCC__c == contactMap.get(corres.SHP_Correspondence_Entity_Recipient_HCC__c).Member_ID__c)
                        {
                            // Creating   lookup only for those record  whose SHP_Correspondence_Entity_Recipient_HCC__c is not equal to  Account.Subscriber_HCC_ID__c
                            // if both value are not equal , that means  correspondence are dependent correspondence 
                           
                           if(contactMap.get(corres.SHP_Correspondence_Entity_Recipient_HCC__c).Member_ID__c != contactMap.get(corres.SHP_Correspondence_Entity_Recipient_HCC__c ).Account.Subscriber_HCC_ID__c)
                               {
                                    String ParentContactFordependent = contactMap.get(corres.SHP_Correspondence_Entity_Recipient_HCC__c ).Account.Subscriber_HCC_ID__c;
                                    corres.Subscriber__c = contactMap.get(ParentContactFordependent).Id;
                                    corres.SHP_Employer_Group__c =accountMap.get(ParentContactFordependent).id; // inserting id SHP_Employer_Group__c look up field so dependent data can be pulled from custom console page  
                               }
                               // Checking in condition if both value are equal that means  correspondence are not  dependent correspondence 
                              
                           else if(contactMap.get(corres.SHP_Correspondence_Entity_Recipient_HCC__c).Member_ID__c == contactMap.get(corres.SHP_Correspondence_Entity_Recipient_HCC__c ).Account.Subscriber_HCC_ID__c)
                           {
                               // Assigning null  so dependent correspondence will not be created 
                               corres.Subscriber__c = null;
                               corres.SHP_Employer_Group__c = null;
                           }
                        }
                    }
                                 
                }
                
            }
        }
     
     catch(Exception e) {
            if(e.getMessage() != null) {
               /** @Description: Initiate a new instance of SystemException__c object **/
               SystemException__c systemException = new SystemException__c();
               /** @Description: Assign exception message passed to the method to ExceptionMessage__c field of SystemException__c object **/
               systemException.ExceptionMessage__c = e.getMessage();
                /** @Description: insert the systemException record **/
                insert systemException;
                
             
            } 
        }
    }
}