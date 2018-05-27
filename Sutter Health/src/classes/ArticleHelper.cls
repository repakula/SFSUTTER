/**  
*     Class Name  : ArticleHelper
*     Author      : IDC Offshore
*     Date        : 10-Aug-2015
*     Project Name: Sutter Health
*     Description : ArticleHelper Class to exclude SHP & Executive Article Types.
*
*     History
*      
*     VERSION        AUTHOR            DATE          DETAIL Description
*       1.0          Ankit Garg       08/10/2015     Helper Class for Article filters functionality. 
*
**/
public with sharing class ArticleHelper {
    /*******************************************************************
    Purpose: Method used to exclude SHP & Executive Article Types - Req 3145
    Parameters: [NA]
    Returns: [List<String>]
    Throws [Exceptions]: [EXEPTION_MSG]
    ********************************************************************/ 
	public static List<string> getArticleType() {
		List<string> articleTypeLst = new List<string>();
		try {
			Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
			// Label Article_Type_Exclusion
			string[] excludeArticleTypeArr = Label.Article_Type_Exclusion.split(',');
			set<String> excludeArticleTypeSet = new set<String>();
			// Add All articles that needs to exclude
			excludeArticleTypeSet.addALL(excludeArticleTypeArr);
			for (Schema.SObjectType obj : gd.values()) {
		 		if(obj.getDescribe().getName().containsIgnoreCase('kav') && !obj.getDescribe().getName().startsWithIgnoreCase('SHP') && !excludeArticleTypeSet.contains(obj.getDescribe().getName())) { 
		 			articleTypeLst.add(obj.getDescribe().getName());
		 		}	
			}
		} catch(Exception ex) {}
		return articleTypeLst;
	}
}