/**  
 *     Name  : VFC_OE_14
 *     Author      : Saket
 *     Date        : 10/06/2014
 *     Project Name: CRM - SFT - Sutter Health
 *     Description :This class shows articles as per user Union,Status,Affiliate to manger and employee.
 **/
public class VFC_OE_14 {

    


        public String numberDaysDue {
                get;
                set;
        }
        public String numberDays {
                get;
                set;
        }
        public String Closedstatustext {
                get;
                set;
        }

        public String numberdaysDueperiod {
                get;
                set;
        }

        public boolean isClosed {
                get;
                set;
        }
        public boolean isDaysShow {
                get;
                set;
        }
        public boolean isTimeShow {
                get;
                set;
        }

        public boolean showMsg {
                get;
                set;
        }

        Map < String, List < DataCategoryInfo >> categoryGroupToDataCategoryList_Map = new Map < String, List < DataCategoryInfo >> ();
      //  Map < String, string>  BenefittedStatus = null;

        public List < KnowledgeArticleVersion > articleList{get;set;}
        public List < KnowledgeArticleVersion > articleListcounter;
        public static Date endDate ;
        public static Date startDate ;
        public static Date today ;
        
        public String categoryType_BU;
      //  public boolean benefittedflag;

        
         /**
         * @author Saket
         * @date 10/06/2014
         * @description This method shows articles according to user Union,Status,Affiliate .
         * @param
         * @return
         */

        public PageReference gotoLink() {

                PageReference reference;

                
                if (articleList <> null && !articleList.isEmpty() && articleList.size() == 1) {

                                reference = new PageReference('/' + articleList[0].KnowledgeArticleId); 
                                reference.getParameters().put('popup', 'true');
                                reference.setRedirect(true);
                                system.debug('Testing 1234');
                     
                } else
                
                {
                       // reference = new PageReference('/home/home.jsp'); 
                        showMsg = true;
                        system.debug('Testing 12345');
                }
                return reference;


        }
        
        
        
        Public void OE_Recordcount() {
        
       // benefittedflag=false;        
       // PageReference reference;

                try {

                        //BenefittedStatus = new Map<String,String> { 'AA'=>'AA', 'AB'=>'AB' ,'AF', 'AG' ,'AJ', 'AK' ,'AN', 'AP' ,'AT', 'AV' ,'AX', 'AY' ,'LA', 'LB' ,'LD', 'LE' ,'LG', 'LH' ,'LJ', 'LK'};
                      //  BenefittedStatus = new Map<String,String> { 'AA'=>'AA', 'AB'=>'AB'};
                        DataCategoryGroupInfo[] categoryGroups = DataCategoryUtil.getInstance().getAllCategoryGroups();

                        if (categoryGroups <> null) {

                                for (DataCategoryGroupInfo categoryGroup: categoryGroups) {
                                        if (categoryGroup <> null) {
                                                categoryGroupToDataCategoryList_Map.put(categoryGroup.getName(), categoryGroup.getgroupStructure());
                                        }
                                }



                                User lstUser = [select u.Id, u.contact.Employee_Employment_Status__c, u.contact.Employee_Affiliate_Facility__c, u.contact.Employee_Union_Affiliate__c, u.contact.Employee_Region__c, u.contact.Employee_Bargaining_Union__c from User u where u.id = : UserInfo.getUserId() limit 1];

                                String categoryFilter = '';

                                if (lstUser <> null) {
                                        for (List < DataCategoryInfo > infoList: categoryGroupToDataCategoryList_Map.values()) {
                                                for (DataCategoryInfo info: infoList) {

                                                        if (lstUser.contact.Employee_Affiliate_Facility__c <> null && lstUser.contact.Employee_Affiliate_Facility__c == info.getLabel()) {
                                                                String categoryType = info.getName();

                                                                if (categoryFilter == '') {
                                                                        categoryFilter = 'Region_Affiliate' + '__c ABOVE_OR_BELOW ' + categoryType + '__c';

                                                                } else {
                                                                        categoryFilter = categoryFilter + ' AND ' + 'Region_Affiliate' + '__c ABOVE_OR_BELOW ' + categoryType + '__c';

                                                                }
                                                        }

                                                        system.debug('Testing1 ---' +lstUser.contact.Employee_Bargaining_Union__c+'----'+lstUser.contact.Employee_Union_Affiliate__c );
                                                        system.debug('Testing2 ---' +info.getLabel()+'------'+info.getName() );
                                                        
                                                        
                                               /**        if (lstUser.contact.Employee_Bargaining_Union__c <> null){
                                                          
                                                           categoryType_BU = lstUser.contact.Employee_Bargaining_Union__c.replaceAll(' ','_');
                                                        
                                                        }
                                                        else{
                                                         
                                                         categoryType_BU = lstUser.contact.Employee_Union_Affiliate__c.replaceAll(' ','_');
                                                         system.debug('categoryType_BU ---' +categoryType_BU );
                                                        }   **/                                                     
                                                        
                                                        

                                                        if ((lstUser.contact.Employee_Bargaining_Union__c <> null && lstUser.contact.Employee_Bargaining_Union__c == info.getLabel()) || 
                                                        (lstUser.contact.Employee_Union_Affiliate__c <> null && lstUser.contact.Employee_Union_Affiliate__c == info.getLabel())  ) {
                                                        
                                                        
                                                                String categoryType = info.getName();


                                                                if (categoryFilter == '') {
                                                                        categoryFilter = 'Union_Status_BU' + '__c ABOVE ' + categoryType + '__c';

                                                                } else {
                                                                        categoryFilter = categoryFilter + ' AND ' + 'Union_Status_BU' + '__c ABOVE ' + categoryType + '__c';

                                                                }
                                                            } 



                                                        if (lstUser.contact.Employee_Employment_Status__c <> null && lstUser.contact.Employee_Employment_Status__c == info.getLabel()) {
                                                                String categoryType = info.getName();                                                            
                                                         
                                                         
                                                                if (categoryFilter == '') {
                                                                        categoryFilter = 'Benefit_Status' + '__c ABOVE ' + categoryType + '__c'; //Changed from ABOVE_OR_BELOW to BELOW

                                                                system.debug('Testing1 '+categoryFilter );
                                                                } else {
                                                                        categoryFilter = categoryFilter + ' AND ' + 'Benefit_Status' + '__c ABOVE ' + categoryType + '__c'; //Changed from ABOVE_OR_BELOW to BELOW
                                                                system.debug('Testing2 '+categoryFilter );
                                                                }
                                                           
                                                                
                                                        }
                                                }
                                        }
                                }



                                if (categoryFilter <> null && categoryFilter <> '') {

                                        String qryString = 'SELECT Id, title,Summary, ArticleType,ArticleNumber,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\') AND title like \'%2015 Open Enrollment%\' AND ArticleType = \'Reference_Material__kav\' WITH DATA CATEGORY ' + categoryFilter + ' limit 1';


                                        articleList = Database.query(qryString);



                                }



                        }
                } catch (Exception classException) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                        Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');

                }
                if (articleList <> null && !articleList.isEmpty() && articleList.size() == 1) {

                             //   reference = new PageReference('/' + articleList[0].KnowledgeArticleId); 
                             //   reference.getParameters().put('popup', 'true');
                             //   reference.setRedirect(true);
                                system.debug('Testing 1234');
                             
                            showMsg = false;
                } else
                
                {
                       // reference = new PageReference('/home/home.jsp'); 
                        showMsg = true;
                        system.debug('Testing 12345');
                }
               

        
        
       
       }


 
        public VFC_OE_14() {

                isClosed = false;
                showMsg = false;
                isDaysShow = false;
                isTimeShow = false;
                
               if (!Test.isRunningTest())
               {
                endDate = Date.parse(System.label.Current_Date);

                startDate = Date.parse(System.label.OEStartDate);

                today = date.Today();
               }
                
                Integer dateDiff = today.daysBetween(endDate);

                numberDaysDue = 'Open Enrollment is Just Around the Corner';
                numberdaysDueperiod = System.label.OEPeriod;

                if (startDate <= today && today < endDate) {

                        isDaysShow = true;
                        isTimeShow = false;
                        numberDays = dateDiff.format();
                        numberdaysDueperiod = '';
                        numberDaysDue = '';
                        Closedstatustext = '';
                }

                if (today == endDate) {
                        isDaysShow = false;
                        isTimeShow = true;
                        numberdaysDueperiod = '';
                        numberDaysDue = '';
                        Closedstatustext = '';
                }

                if (endDate < today) {

                        Closedstatustext = 'Open enrollment is now closed.';
                        isClosed = true;
                        numberdaysDueperiod = '';
                        numberDaysDue = '';
                }

        }

        

        
}