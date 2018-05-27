/**  
 *     Name  : VFC18_EOW
 *     Author      : Saket
 *     Date        : 10/06/2014
 *     Project Name: CRM - SFT - Sutter Health
 *     Description :This class shows EOW article to manger and employee.
 **/
public class VFC18_EOW {

        public boolean showMsg {
                get;
                set;
        }

        public User lstUser;

        Map < String, List < DataCategoryInfo >> categoryGroupToDataCategoryList_Map = new Map < String, List < DataCategoryInfo >> ();

        public List < KnowledgeArticleVersion > articleList {
                get;
                set;
        }
        public List < KnowledgeArticleVersion > articleListcounter;
        public static final string COMMUNITY_PORTAL_MANGER = 'Community Portal Manager';
        public static final string COMMUNITY_PORTAL = 'Community Portal';
        public static final string HOME_URL = '/home/home.jsp';
        
        /**
         * @author Saket
         * @date 10/06/2014
         * @description This method shows EOW article to manger and employee on the basis of logged in user.
         * @param
         * @return
         */

        public PageReference gotoLink() {

                PageReference reference;

                try {

                        lstUser = [select u.Id, u.contact.Employee_Employment_Status__c, u.profile.name, u.contact.Employee_Affiliate_Facility__c, u.contact.Employee_Union_Affiliate__c, u.contact.Employee_Region__c, u.contact.Employee_Bargaining_Union__c from User u where u.id = : UserInfo.getUserId() limit 1];

                        String qryString;

                        if (lstUser.profile.name == COMMUNITY_PORTAL_MANGER) {

                                qryString = 'SELECT Id, title,Summary, ArticleType,ArticleNumber,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\') AND title like \'%EOW for Manager%\'  limit 1';

                        } else if (lstUser.profile.name == COMMUNITY_PORTAL) {
                                qryString = 'SELECT Id, title,Summary, ArticleType,ArticleNumber,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\') AND title like \'%EOW for Employees%\'  limit 1';
                        }


                        articleList = Database.query(qryString);


                } catch (Exception classException) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, classException.getMessage()));
                        Utility.handleExceptionFromCode(classException.getMessage() + '\r\n' + classException.getStackTraceString() + '\r\n' + classException.getTypeName() + '\r\n' + System.now() + '\r\n' + '--------------');

                }


                if (articleList <> null && !articleList.isEmpty() && articleList.size() == 1) {
                       
                                reference = new PageReference('/' + articleList[0].KnowledgeArticleId);
                                reference.getParameters().put('popup', 'true');
                                reference.setRedirect(true);

                 }

                else {
                        reference = new PageReference(HOME_URL);

                        showMsg = true;


                }
                return reference;
        }

}