public without sharing class ServiceRequestController 
{
    //public Service_Request__c sr {get;set;}
    public Set<ServiceRequests__c> customSettingValues {get;set;}
    public List<ServiceRequestLinksWrapper> srWrapperMap {get;set;}
    public Map<String, List<ServiceRequests__c>> ServiceRequestMap {get;set;}
    public List<String> profiles {get;set;}
    public List<String> permissionSet {get;set;}
    public List<PermissionSetAssignment> userPermSetList {get;set;}
    public Map<String,String> userPermSetMap {get;set;}

    public class ServiceRequestLinksWrapper
    {
        public string  Section_Name {get;set;}
        public Map<string,string> LabelLinksMap {get;set;}
    }

    public ServiceRequestController()
    {
        srWrapperMap = new List<ServiceRequestLinksWrapper>();
        ServiceRequestMap =new Map<String, List<ServiceRequests__c>>();
        customSettingValues = new Set<ServiceRequests__c> ();
        profiles = new List<String>();
        permissionSet = new List<String>();
        userPermSetList = new List<PermissionSetAssignment>();
        userPermSetMap = new Map<String,String>();
        
        //get all values from customs setting
       // List<ServiceRequests__c> tsrs = [SELECT Name,Link_Label__c,Link_URL__c,Permissionset_Visibility_To__c,Profile_Visibility_To__c,Section_Name__c,Section_Sequence__c FROM ServiceRequests__c order by Section_Sequence__c];
 
        Map<String,ServiceRequests__c> customSetting =  ServiceRequests__c.getAll();
        
        User u =[Select Id, ProfileId from User where Id =: UserInfo.getUserId()];
        Profile p = [Select Id, Name from Profile Where Id =: u.ProfileId];
        userPermSetList=[Select Id , PermissionSet.Label,PermissionSet.Name from PermissionSetAssignment where AssigneeId=:UserInfo.getUserId()];
        for(PermissionSetAssignment ps: userPermSetList)
        {
            userPermSetMap.put(ps.PermissionSet.Label,ps.PermissionSet.Name);
        }
        
        for(String setting: customSetting.keySet())
        {
            String profile=customsetting.get(setting).Profile_Visibility_To__c;
            String pSet= customsetting.get(setting).Permissionset_Visibility_To__c;
            if(profile != null)
            {
                profiles = profile.split(',');
                
                for(String prof : profiles)
                {
                   if(prof.equalsIgnoreCase(p.Name))
                    {
                        customSettingValues.add(customSetting.get(setting));
                    }
                }
            }
            
            if(pSet!=null)
            {   
                permissionSet= pSet.split(',');
                for(String tempPSet: permissionSet)
                {
                    if(userPermSetMap.get(tempPSet)!=null)
                    {
                        customSettingValues.add(customSetting.get(setting));
                    }
                }
            }
        }
        
       for(ServiceRequests__c srs:customSettingValues )
       {
            if(ServiceRequestMap.get(srs.Section_Name__c)!=null)
            {
                List<ServiceRequests__c> tempList= new List<ServiceRequests__c>();
                tempList.addAll(ServiceRequestMap.get(srs.Section_Name__c));
                tempList.add(srs);
               // tempList.sort;
                ServiceRequestMap.put(srs.Section_Name__c,tempList);
            }
            else
            {
                ServiceRequestMap.put(srs.Section_Name__c,new List<ServiceRequests__c>{srs});
            }
            
       }
       for(String secName:ServiceRequestMap.keyset())
       {
            ServiceRequestLinksWrapper wr= new ServiceRequestLinksWrapper();
            wr.Section_Name=secName;
            wr.LabelLinksMap = new Map<string,string>();
            for(ServiceRequests__c sr: ServiceRequestMap.get(secName))
            {
               wr.LabelLinksMap.put(sr.Link_Label__c, sr.Link_URL__c);
            }
            srWrapperMap.add(wr);
       }
        system.debug('----------------'+srWrapperMap);
    }
}