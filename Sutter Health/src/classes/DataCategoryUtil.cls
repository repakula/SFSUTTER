/**  
*     Class Name  : DataCategoryUtil
*     Author      : IDC Offshore
*     Date        : 27-Sept-2013
*     Project Name: CRM - SFT - Sutter Health
*     Description : DataCategoryUtil Class.
*
*     History
*      
*     VERSION        AUTHOR            DATE          DETAIL Description
*      1.0          IDC Off shore      14/12/2015    Added Articles filter functionality related to REQ-3145 & REQ-3146.
*
**/
public with sharing class DataCategoryUtil {
	// Static Variables
	private static final DataCategoryUtil INSTANCE = new DataCategoryUtil();
	private static final String NON_BREAKING_SPACE = '&nbsp;&nbsp;';
	private final String ARTICLE_TYPE = 'KnowledgeArticleVersion';
	
	/*******************************************************************
    Purpose: Constructor to initialize the variables
    Parameters: NA
    Returns: NA
    Throws [Exceptions]: NA
    ********************************************************************/
	private DataCategoryUtil() { }
	public static DataCategoryUtil getInstance() {return INSTANCE;}
	
	/************************************************************************************
    Purpose: Retrieves a List of DataCategoryGroupInfo of all the data category groups associated with Knowledge Article Version
    Parameters: NA
    Returns: DataCategoryGroupInfo[]
    Throws [Exceptions]: NA
    ************************************************************************************/
	public DataCategoryGroupInfo[] getAllCategoryGroups() {
	    Describedatacategorygroupresult[] results = getDescribeDataCategoryGroupResults();
	    DataCategoryGroupInfo[] dataCategoryGroups = new DataCategoryGroupInfo[] { };
	    for (Describedatacategorygroupresult singleResult : results) {
	        dataCategoryGroups.add(new DataCategoryGroupInfo(singleResult.getName(), singleResult.getLabel(),singleResult.getDescription(), getCategoryStructure(singleResult.getName())));
	    }
		//Req 2978 Release 5 Bargaining Unit Code(ordering of data category values) 
	    DataCategoryGroupInfo[] result2 = new List<DataCategoryGroupInfo>();
	    DataCategoryGroupInfo managerProfile, unionStatus, regionOrAffiliate, benefitStatus;
	    for (DataCategoryGroupInfo r : dataCategoryGroups) {
	        if(r.getname() == label.CL44_Manager_Profile) {
	            managerProfile = r;
	        }
	        else if(r.getname()== label.CL45_Union_Status_BU) {
	            unionStatus = r;
	        }
	        else if(r.getname()== label.CL46_Region_Affiliate) {
	            regionOrAffiliate = r;
	        }
	        else if(r.getname()== label.CL47_Benefit_Status) {
	            benefitStatus = r;
	        }                         
	    }
	    try {
	    	Contact C = [select Employee_Affiliate_Facility__c,Employee_Bargaining_Union__c,Employee_Union_Affiliate__c,Employee_Employment_Status__c from Contact where Id=:TestStatic.ContactID];
	    	unionStatus.setValue(c.Employee_Bargaining_Union__c);
	   
	    } catch(exception e){}
	    result2.add(unionStatus );
	    result2.add(regionOrAffiliate );
	    // Req 3145,3146. Commented Benefit Status & Manager Profile filters. 
	    //result2.add(benefitStatus );
	    //result2.add(managerProfile);
	    //return dataCategoryGroups;
      	return result2;
	}

	private Describedatacategorygroupresult[] getDescribeDataCategoryGroupResults() {
	    String[] objTypes = new String[] {ARTICLE_TYPE};
	    return Schema.describeDataCategoryGroups(objTypes);
	}

	/************************************************************************************
    Purpose: Retrieves an ordered list of all Categories for the specified category group
    Parameters: [string]
    Returns: DataCategoryGroupInfo[]
    Throws [Exceptions]: NA
    ************************************************************************************/
	private DataCategoryInfo[] getCategoryStructure(String categoryGroupName) {
	    DataCategory root = getRootCategory(categoryGroupName);
	    DataCategory[] yetToBeProcessed = root.getChildCategories();
	    DataCategoryInfo[] allCategories = new DataCategoryInfo[] { processCategory(root, '') };
	    getAllCategories(yetToBeProcessed, allCategories, NON_BREAKING_SPACE);
	    return allCategories;
	}
	
	private void getAllCategories(DataCategory[] yetToBeProcessed, DataCategoryInfo[] processed,String labelPrefix) {
	    for (DataCategory category : yetToBeProcessed) {
	        processed.add(processCategory(category, labelPrefix));
	        getAllCategories(category.getChildCategories(), processed, labelPrefix + NON_BREAKING_SPACE);
	    }
	}

	private DataCategoryInfo processCategory(DataCategory category, String labelPrefix) {
	    return new DataCategoryInfo(category.getName(), category.getLabel(), labelPrefix + category.getLabel());
	}
	
	private DataCategory getRootCategory(String categoryGroupName) {
	    Describedatacategorygroupstructureresult structureResult = getDescribeDataCategoryGroupStructureResults(categoryGroupName);
	    return structureResult.getTopCategories()[0];
	}
	
	private Describedatacategorygroupstructureresult getDescribeDataCategoryGroupStructureResults(String categoryGroupName) {
	    Datacategorygroupsobjecttypepair pair = new Datacategorygroupsobjecttypepair();
	    pair.setSobject(ARTICLE_TYPE);
	    pair.setDataCategoryGroupName(categoryGroupName);
	    return Schema.describeDataCategoryGroupStructures(new Datacategorygroupsobjecttypepair[] { pair }, false)[0];
	}
}