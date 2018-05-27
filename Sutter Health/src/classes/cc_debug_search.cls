public with sharing class cc_debug_search {
     @AuraEnabled
        public List<Nursing__kav> getSearchResults(){ 
        String qryString = 'SELECT Id,title,Summary,Article_Body__c FROM Nursing__kav WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH  DATA CATEGORY learn_articles__c AT( part1__c, part2__c)  ORDER BY Id ASC  LIMIT 2 '; 
        List<Nursing__kav> articleList= Database.query(qryString);
        return articleList;
    }
      @AuraEnabled
       
 public static List<SObject> getArticle() { 
 	Id id = ApexPages.currentPage().getParameters().get('Id');

      String qryString = 'SELECT Id,title,Summary,Article_Body__c FROM Nursing__kav WHERE (Id=:id and PublishStatus = \'online\' and Language = \'en_US\') LIMIT 2 '; 

      List<SObject> articles = Database.query(qryString);
        
   return articles;

}
  public static List<SObject> getArticleDetails() { 
 	Id id = ApexPages.currentPage().getParameters().get('Id');

      String qryString = 'SELECT Id,title,Summary,Article_Body__c FROM Nursing__kav WHERE (Id=:id and PublishStatus = \'online\' and Language = \'en_US\') LIMIT 2 '; 

      List<SObject> articles = Database.query(qryString);
        
   return articles;

}
   
    
 @AuraEnabled
    public static List<SObject> getArticleByCategory(){
  //  String catString ='iam__c';
	String qryString = 'SELECT Id,Title,Article_Video__c FROM Nursing__kav WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH  DATA CATEGORY learn_articles__c AT(iam_subarticles__c)  ORDER BY Id '; 
	List<SObject> articles=Database.query(qryString);
    return articles;
    }
    
	@AuraEnabled
    public static List<SObject> getMegaMenuArticles(){
 	String qryString = 'SELECT Id,Title,customShorttext__c,CustomImage__c  FROM Nursing__kav WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH  DATA CATEGORY learn_articles__c AT(iam_subarticles__c)  ORDER BY Id DESC '; 
	List<SObject> articles=Database.query(qryString);
    return articles;
    }
    
    @AuraEnabled
  public static List<List<SObject>> getIamArticle(){
    String qryString ='I AM';
     List<List<SObject>> articles = [FIND :qryString RETURNING Nursing__kav (Id, Title,Summary,Article_Body__c,CustomImage__c WHERE PublishStatus='online' AND Language = 'en_US' ) WITH  DATA CATEGORY learn_articles__c AT(iam__c)  LIMIT 1];
        return articles;
    }
	
   
 
}