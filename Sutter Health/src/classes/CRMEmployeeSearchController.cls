public class CRMEmployeeSearchController {

    // Employee Binding varibles
    public String firstName {get;set;}
    public String lastName {get;set;}
    public String employeeId {get;set;}
    public String employeeAdId {get;set;}
    public String username {get; set;}
    public String password {get; set;}
    public boolean isLoggedIn {get; set;}
    public boolean isEmployeeSearch {get;set;}
    public boolean isProviderSearch {get;set;}
    public String searchType {get;set;} 
    
    // Provider Binding varibles
    public String pFirstName {get;set;}
    public String pLastName {get;set;}
    public String pEmail {get;set;}
    public String pUsername {get;set;}
    public String pFax {get;set;}
   
    
    //Pagination variables
    public Integer pageSize {get;set;}
    public boolean display {get;set;}
    public Paginate paginater {get;set;}
    
    //Employee Wrapper List variables
    public transient List<EmployeeResultWrapper> employeeResultWrapperList {get;set;}
    public transient List<EmployeeResultWrapper> currentEmployeeResultWrapperList{get;set;}     
    public List<List<EmployeeResultWrapper>> allEmployeeResultWrapperList{get;set;} 
    
    //Provider Wrapper List variables
    public transient List<ProviderResultWrapper> providerResultWrapperList {get;set;}
    public transient List<ProviderResultWrapper> currentProviderResultWrapperList{get;set;}     
    public List<List<ProviderResultWrapper>> allProviderResultWrapperList{get;set;} 
    
    
    //Constructor
    public CRMEmployeeSearchController() 
    {
        this.isEmployeeSearch = true;
        this.isProviderSearch = false;
    }
    
     //Employee Result Wrapper will store Employee and User details for Community Users
     public class EmployeeResultWrapper
     {
        public String employeeName {get;set;}
        public String employeeEmail {get;set;}
        public String username{get;set;}
        public String userEmail{get;set;}
       
     }
     
     public class ProviderResultWrapper
     {
        public String ProviderName {get;set;}
        public String ProviderEmail {get;set;}
        public String UserEmail {get;set;}
        public String ProviderID {get;set;}
        public String Username {get;set;}
        public String Phone {get;set;}
        public String City {get;set;}
        public String State{get;set;}        
        public String Zip {get;set;}   
        public String Fax {get;set;}     
        
       
     }
    
   
     //Login Logic
    public void LoginCall() 
    {
        this.isLoggedIn = false;
        
        String Username = System.Label.Site_Username;
         String Password = System.Label.Site_Password;
        
        
        if(this.username.equals(Username) && this.password.equals(Password ))
        {
            this.isLoggedIn = true;
        }
        if(!this.isLoggedIn)
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Your login attempt has failed. The username or password may be incorrect. Please try again.')); 
        }
    }
    
    public void setRenderVariables()
    {
        //clear the variables
        
        this.firstName = '';
        this.lastName = '';
        this.employeeId = '';
        this.employeeAdId ='';
        this.pFirstName = '';
        this.pLastName = '';
        this.pEmail = '';
        this.pUsername = '';
        this.pFax = '';
       
        providerResultWrapperList = new List<ProviderResultWrapper>();
        currentProviderResultWrapperList = new List<ProviderResultWrapper>();   
        allProviderResultWrapperList = new List<List<ProviderResultWrapper>>();
        employeeResultWrapperList = new List<EmployeeResultWrapper>();
        currentEmployeeResultWrapperList = new List<EmployeeResultWrapper>();     
        allEmployeeResultWrapperList = new List<List<EmployeeResultWrapper>>(); 
        display = false;
        
        if(this.isLoggedIn && searchType == 'Employee')
        {
            this.isEmployeeSearch = true;
            this.isProviderSearch = false;
        }
        if(this.isLoggedIn && searchType == 'Provider')
        {
            this.isEmployeeSearch = false;
            this.isProviderSearch = true;
        }
    }
    
     public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Employee','Employee'));
        options.add(new SelectOption('Provider','Provider'));
        return options;
    }
    
    //Employee search logic
    public void SearchEmployee() 
    {
           //set the display to false
            display =false;
           
            //Set the page size         
            pageSize = Integer.valueOf(System.Label.PaginationSize);
            
            //clear the provider lists
            providerResultWrapperList = new List<ProviderResultWrapper>();
            currentProviderResultWrapperList = new List<ProviderResultWrapper>();   
            allProviderResultWrapperList = new List<List<ProviderResultWrapper>>();
            
            boolean isBlank = true;
            
           //Make a dynamic query
           String query = 'SELECT Id, Name, Username, Email , Contact.Employee_Work_Email__c , Contact.Name,Contact.Employee_ID__c,Contact.Employee_ADID__c FROM User Where Profile.Name like \'%Community%\'';
           if(this.firstName !='' && this.lastName !='')
           {
               query = query + ' AND FirstName like \'%' + String.escapeSingleQuotes(this.firstName) +'%\'';
               query = query + ' AND LastName like \'%' + String.escapeSingleQuotes(this.lastName) +'%\'';
               
               isBlank = false;
           }
           else if(this.firstName != '')
           {
               query = query + ' AND FirstName like \'%' + String.escapeSingleQuotes(this.firstName) +'%\'';
               
               isBlank = false;
           }
           else if (this.lastName != '')
           {
               query = query + ' AND LastName like \'%' + String.escapeSingleQuotes(this.lastName) +'%\'';
               
               isBlank = false;
           }
           
           if(this.employeeId != '')
           {
              query = query + ' AND Contact.Employee_ID__c like \'%' + String.escapeSingleQuotes(this.employeeId) +'%\'';
              
              isBlank = false;

           }
           if(this.employeeAdId != '')
           {
                
                query = query + ' AND (Contact.Employee_ADID__c like \'%' + String.escapeSingleQuotes(this.employeeAdId)+'%\' OR Contact.Employee_Work_Email__c like \'%' + String.escapeSingleQuotes(this.employeeAdId) +'%\')';
                
                isBlank = false;
           }
           
           query = query + ' AND isActive=true';
           
           system.debug('*******'+query);
           
           //Execute Query
           transient List<User> userResults = new List<User>();
           
            if (!isBlank)
            {
                userResults = database.query(query);
                system.debug('*******'+userResults);
                employeeResultWrapperList =new List<EmployeeResultWrapper>();
               for(User u : userResults)
               {
                   EmployeeResultWrapper wrap = new EmployeeResultWrapper();
                   wrap.employeeName = u.Name;
                   wrap.userEmail = u.Email;
                   wrap.username = u.username;
                   wrap.employeeEmail = u.Contact.Employee_Work_Email__c;
                   employeeResultWrapperList.add(wrap);
               }
               
               
                //Create a new instance of Paginate passing in the overall size of the list of data and the page size you want         
                this.paginater = new Paginate(employeeResultWrapperList.size(), pageSize); 

                //Creating an instance of allCasesWithAttachmentsData and curCasesWithAttachmentsData lists 
                 
                this.allEmployeeResultWrapperList = new List<List<EmployeeResultWrapper>>();         
                this.currentEmployeeResultWrapperList = new List<EmployeeResultWrapper>();           
                
                //Break out the full list into a list of lists         
                if(employeeResultWrapperList.size() > 0)
                {             
                    List<EmployeeResultWrapper> tempWrapList = new List<EmployeeResultWrapper>();                      
                    Integer i = 0;             
                    for(EmployeeResultWrapper wrap : employeeResultWrapperList){                 
                        tempWrapList.add(wrap);                 
                        i++;                 
                        if(i == pageSize){                     
                            this.allEmployeeResultWrapperList.add(tempWrapList);                     
                            tempWrapList = new List<EmployeeResultWrapper>();                     
                            i = 0;                 
                        }             
                    }             
                    if(!tempWrapList.isEmpty()){                 
                        this.allEmployeeResultWrapperList.add(tempWrapList);             
                    }               
                    //Gets the correct list of data to show on the page             
                    this.currentEmployeeResultWrapperList = this.allEmployeeResultWrapperList.get(this.paginater.index);
                    
                    if(!this.currentEmployeeResultWrapperList.isEmpty())   
                    {
                        display = true;
                    }
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'No Result Found')); 
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Please enter at least one criteria')); 
            }
           
           
    }
    
    
    //Provider search logic
    public void SearchProvider() 
    {
        //set the display to false
        display =false;
       
        //Set the page size         
        pageSize = Integer.valueOf(System.Label.PaginationSize);
        
        //clear the employee lists
        employeeResultWrapperList = new List<EmployeeResultWrapper>();
        currentEmployeeResultWrapperList = new List<EmployeeResultWrapper>();     
        allEmployeeResultWrapperList = new List<List<EmployeeResultWrapper>>(); 
        
       //Make a dynamic query
       String query = 'SELECT Id, Name, Contact.PROVIDER_ID__C, contact.Provider_Correspondence_Fax_Number__c,Contact.Email ,User.Email,User.Username,Contact.Provider_Correspondence_Phone__c,Contact.Provider_Correspondence_City__c,Contact.Provider_Correspondence_State__c,Contact.Provider_Correspondence_PostalCode__c, Contact.PROVIDER_NPI__C , Contact.SUPPLIER_NPI__C FROM User WHERE Contact.RecordType.Name like \'%Provider%\'';
       
        // flag variable to check if input is blank
        boolean isBlank = true;
       
        if(this.pFirstName !='' && this.pLastName !='')
        {
           query = query + ' AND User.FirstName like \'%' + String.escapeSingleQuotes(this.pFirstName) +'%\'';
           query = query + ' AND User.LastName like \'%' + String.escapeSingleQuotes(this.pLastName) +'%\'';
           
           isBlank =false;
        }
        else if(this.pFirstName != '')
        {
           query = query + ' AND User.FirstName like \'%' + String.escapeSingleQuotes(this.pFirstName) +'%\'';
           
           isBlank =false;
        }
        else if (this.pLastName != '')
        {
           query = query + ' AND User.LastName like \'%' + String.escapeSingleQuotes(this.pLastName) +'%\'';
           
           isBlank =false;
        }

       
        if(this.pEmail != '')
        {
          query = query + ' AND (Contact.Email like \'%' + String.escapeSingleQuotes(this.pEmail) +'%\' OR User.Email like \'%' + String.escapeSingleQuotes(this.pEmail) +'%\')';
          
          isBlank = false;

        }
        if(this.pUsername != '')
        {
          query = query + ' AND User.Username like \'%' + String.escapeSingleQuotes(this.pUsername) +'%\'';
          
          isBlank = false;

        }
        
        if(this.pFax != '')
        {
          query = query + ' AND Contact.Provider_Correspondence_Fax_Number__c like \'%' + String.escapeSingleQuotes(this.pFax) +'%\'';
          
          isBlank = false;

        }
       
        system.debug('*******'+query);
       
            
       //Execute Query
       transient List<User> providerResults = new List<User>();
       
       if(!isBlank)
       {
           providerResults = database.query(query);
           
           system.debug('*******'+providerResults);
            providerResultWrapperList =new List<ProviderResultWrapper>();
           for(User currentUser : providerResults)
           {
               
               //create wrapper record
               
               ProviderResultWrapper wrap = new ProviderResultWrapper();
               wrap.providerName  = currentUser.Name;
               wrap.providerEmail  = currentUser.Contact.Email;
               wrap.UserEmail  = currentUser.Email;
               wrap.providerID = currentUser.Contact.PROVIDER_ID__C;
               wrap.Username = currentUser.Username;
               wrap.Phone = currentUser.Contact.Provider_Correspondence_Phone__c;
               wrap.City = currentUser.Contact.Provider_Correspondence_City__c;
               wrap.State = currentUser.Contact.Provider_Correspondence_State__c;
               wrap.Zip = currentUser.Contact.Provider_Correspondence_PostalCode__c;
               wrap.Fax = currentUser.Contact.Provider_Correspondence_Fax_Number__c;
               providerResultWrapperList.add(wrap);
           }
           
           
            //Create a new instance of Paginate passing in the overall size of the list of data and the page size you want         
            this.paginater = new Paginate(providerResultWrapperList.size(), pageSize); 

            //Creating an instance of allCasesWithAttachmentsData and curCasesWithAttachmentsData lists 
             
            this.allProviderResultWrapperList = new List<List<ProviderResultWrapper>>();         
            this.currentProviderResultWrapperList = new List<ProviderResultWrapper>();           
            
            //Break out the full list into a list of lists         
            if(providerResultWrapperList.size() > 0)
            {             
                List<ProviderResultWrapper> tempWrapList = new List<ProviderResultWrapper>();                      
                Integer i = 0;             
                for(ProviderResultWrapper wrap : providerResultWrapperList){                 
                    tempWrapList.add(wrap);                 
                    i++;                 
                    if(i == pageSize){                     
                        this.allProviderResultWrapperList.add(tempWrapList);                     
                        tempWrapList = new List<ProviderResultWrapper>();                     
                        i = 0;                 
                    }             
                }             
                if(!tempWrapList.isEmpty()){                 
                    this.allProviderResultWrapperList.add(tempWrapList);             
                }               
                //Gets the correct list of data to show on the page             
                this.currentProviderResultWrapperList = this.allProviderResultWrapperList.get(this.paginater.index);
                
                if(!this.currentProviderResultWrapperList.isEmpty())   
                {
                    display = true;
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'No Result Found')); 
            }
        }
       else
       {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Please enter at least one criteria')); 
       }
       
       
    }
    
    
    // Methods to go to previous 
    public PageReference previousPage(){         
        this.paginater.decrement();         
        return changeData();     
    }       
    public PageReference nextPage(){         
        this.paginater.increment();         
        return changeData();     
    }   
    public PageReference updatePage(){         
        this.paginater.updateNumbers();         
        return changeData();     
    }       
    public PageReference changeData(){         
        if(this.isEmployeeSearch)
        {
            this.currentEmployeeResultWrapperList = this.allEmployeeResultWrapperList.get(this.paginater.index);         
           
        }
        if(this.isProviderSearch)
        {
            this.currentProviderResultWrapperList = this.allProviderResultWrapperList.get(this.paginater.index);  
        }
        return null;     
    }

}