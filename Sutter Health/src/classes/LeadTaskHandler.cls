/**********************************************************************
Name: LeadTaskHandler
======================================================
======================================================
Purpose:
This class manage candidate connect task for candidate type lead. Lead trigger calls this class.
======================================================
======================================================
History
-------
VERSION             AUTHOR              DATE                DETAIL                  Description
1.0                 Sandeep Sharma      05-11-2015      INITIAL DEVELOPMENT         This class manage candidate connect task for candidate type lead. It is used to manage 30/60/90         days                                                                                candidate connect task for candidate lead
***********************************************************************/

public class LeadTaskHandler{

        // Variable declaration section
        Map < string, Candidate_Connect_Task__c > mapCandidateConnect;    
        string DAY30STASKSUBJECTConst = Label.CL_30_days + ' days connect task with Candidate ';
        string DAYS60TASKSUBJECTConst = Label.CL_60_days + ' days connect task with Candidate ';
        string DAYS90TASKSUBJECTConst = Label.CL_90_days + ' days connect task with Candidate ';
        string DAY30STASKSUBJECT = '';
        string DAYS60TASKSUBJECT = '';
        string DAYS90TASKSUBJECT = '';
        string TASKPRIORITY = 'Normal';
        string TASKSTATUS = 'Not Started';
        string TASKTYPE = 'Action';
        string LEAD = 'Lead';
        string TASK = 'Task';
        string CANDIDATE = 'Candidate';
        string SOURCINGCONNECTTASK = 'Sourcing Connect Task';
        RecordType taskRecordType = null;
       
       public LeadTaskHandler()
       {
            // Get Candidate lead record type
            taskRecordType = [SELECT DeveloperName, Id, Name, SobjectType FROM RecordType WHERE SobjectType = : TASK And Name = : SOURCINGCONNECTTASK Limit 1];
       
       }
        
        
        
        /*******************************************************************
        Purpose: This function creates candidate connect task instance of 30/60/90 days connect task (Service Connect Task) for candidate lead creation.
        Parameters: List<Lead>
        Returns: NA
        Throws [Exceptions]: NA
        ********************************************************************/
        public void manageTaskAfterLeadInsert(List<Lead> leadList){         
            
            List < Task > lTask = new List < Task > ();
            for (Lead leadObj: leadList) {
                // Create task subject
                DAY30STASKSUBJECT = DAY30STASKSUBJECTConst + leadObj.FirstName + ' ' + leadObj.LastName;                
                DAYS60TASKSUBJECT = DAYS60TASKSUBJECTConst + leadObj.FirstName + ' ' + leadObj.LastName;                
                DAYS90TASKSUBJECT = DAYS90TASKSUBJECTConst + leadObj.FirstName + ' ' + leadObj.LastName;

                if ((leadObj.X30_Day_Connect_Session__c == true || leadObj.X60_Day_Connect_Session__c == true || leadObj.X90_Day_Connect_Session__c == true)) {


                    if (leadObj.X30_Day_Connect_Session__c == true) {
                        // Create service connect task for 30 days connect
                        task t = LeadTaskHandler.createNewLeadTask(leadObj, DAY30STASKSUBJECT, TASKPRIORITY, TASKSTATUS, TASKTYPE, Integer.valueOf(Label.CL_30_days), taskRecordType.Id);

                        lTask.add(t);
                    }
                    if (leadObj.X60_Day_Connect_Session__c == true) {
                        // Create service connect task for 60 days connect
                        task t = LeadTaskHandler.createNewLeadTask(leadObj, DAYS60TASKSUBJECT, TASKPRIORITY, TASKSTATUS, TASKTYPE, Integer.valueOf(Label.CL_60_days), taskRecordType.Id);

                        lTask.add(t);

                    }
                    if (leadObj.X90_Day_Connect_Session__c == true) {
                        // Create service connect task for 90 days connect
                        task t = LeadTaskHandler.createNewLeadTask(leadObj, DAYS90TASKSUBJECT, TASKPRIORITY, TASKSTATUS, TASKTYPE, Integer.valueOf(Label.CL_90_days), taskRecordType.Id);

                        lTask.add(t);
                    }

                }
                
                
            }
            if (lTask.size() > 0) {

                Database.insert(lTask, false);
            }
        
        }

        /*******************************************************************
        Purpose: This function manage candidate connect task instance of 30/60/90 days connect task (Service Connect Task) for candidate lead updation. If 
        we are unchecking any option for candidate connect and if the corresponding task is isn 'In Progress' status, then we are deleting this task. If thae corresponding task is 
        not 'in Progrss' mode, then we are throwing an error to end user.
        Parameters: List<Lead> , map<Id,Lead> , map<Id,Lead> 
        Returns: NA
        Throws [Exceptions]: NA
        ********************************************************************/

        public void manageTaskAfterLeadUpdate(List<Lead> newleadList, map<Id,Lead> newLeadMap, map<Id,Lead> oldLeadMap){
            
            Map < Id, List < Task >> candidateTaskMap = new Map < Id, List < Task >> ();
            Set < Id > candidateIds = new Set < Id > ();
            for (Lead leadObj: newleadList) {
                candidateIds.Add(leadObj.Id);
            }
            // Get List of Task for leads
            List < Task > taskList = [Select Id, Subject, Status, WhoId, Candidate_Connect__c From Task Where WhoId in : candidateIds AND RecordTypeId =: taskRecordType.Id];

            // Create map of candidate lead Id and Task list
            for (Task t: taskList) {
                List < Task > tList;
                if (candidateTaskMap.get(t.WhoId) == null) {
                    tList = new List < Task > ();
                } else {
                    tList = candidateTaskMap.get(t.WhoId);
                }
                tList.add(t);
                candidateTaskMap.put(t.WhoId, tList);
            }
            List < Task > taskToInsert = new List < Task > ();
            List < Task > taskToDelete = new List < Task > ();
            for (Lead leadObj: newleadList) {
              
                // Create Task subject
                DAY30STASKSUBJECT = DAY30STASKSUBJECTConst + leadObj.FirstName + ' ' + leadObj.LastName;
                DAYS60TASKSUBJECT = DAYS60TASKSUBJECTConst + leadObj.FirstName + ' ' + leadObj.LastName;
                DAYS90TASKSUBJECT = DAYS90TASKSUBJECTConst + leadObj.FirstName + ' ' + leadObj.LastName;
                if (newLeadMap.get(leadObj.Id).X30_Day_Connect_Session__c != oldLeadMap.get(leadObj.Id).X30_Day_Connect_Session__c && newLeadMap.get(leadObj.Id).X30_Day_Connect_Session__c == false) {
                    if (candidateTaskMap.get(leadObj.Id) != null) {
                        List < Task > days30Task = candidateTaskMap.get(leadObj.Id);
                        //boolean found = false;
                        for (Task t: days30Task) {
                            // Lead task is other than 'Not Started' then, raise an error, else add them in a list to be deleted
                            if ((!Label.Lead_task_status_to_be_deleted.contains(t.Status)) && t.Candidate_Connect__c == Label.CL_30_days) {
                                leadObj.addError(Label.Active_task_Deletion_Error_message);
                            } else if (Label.Lead_task_status_to_be_deleted.contains(t.Status) && t.Candidate_Connect__c == Label.CL_30_days) {
                                taskToDelete.add(t);
                            }
                        }
                    }
                }
                if (newLeadMap.get(leadObj.Id).X60_Day_Connect_Session__c != oldLeadMap.get(leadObj.Id).X60_Day_Connect_Session__c && newLeadMap.get(leadObj.Id).X60_Day_Connect_Session__c == false) {
                    if (candidateTaskMap.get(leadObj.Id) != null) {
                        List < Task > days60Task = candidateTaskMap.get(leadObj.Id);
                        //boolean found = false;
                        for (Task t: days60Task) {
                            // Lead task is other than 'Not Started' then, raise an error, else add them in a list to be deleted
                            if ((!Label.Lead_task_status_to_be_deleted.contains(t.Status)) && t.Candidate_Connect__c == Label.CL_60_days) {
                                leadObj.addError(Label.X60_Active_task_Deletion_Error_message);
                            } else if (Label.Lead_task_status_to_be_deleted.contains(t.Status) && t.Candidate_Connect__c == Label.CL_60_days) {
                                taskToDelete.add(t);
                            }
                        }
                    }
                }

                if (newLeadMap.get(leadObj.Id).X90_Day_Connect_Session__c != oldLeadMap.get(leadObj.Id).X90_Day_Connect_Session__c && newLeadMap.get(leadObj.Id).X90_Day_Connect_Session__c == false) {

                    if (candidateTaskMap.get(leadObj.Id) != null) {
                        List < Task > days90Task = candidateTaskMap.get(leadObj.Id);



                        //boolean found = false;
                        for (Task t: days90Task) {
                            // Lead task is other than 'Not Started' then, raise an error, else add them in a list to be deleted
                            if ((!Label.Lead_task_status_to_be_deleted.contains(t.Status)) && t.Candidate_Connect__c == Label.CL_90_days) {
                                leadObj.addError(Label.X90_days_connect_Session_Deletion_Error_message);
                            } else if (Label.Lead_task_status_to_be_deleted.contains(t.Status) && t.Candidate_Connect__c == Label.CL_90_days) {
                                taskToDelete.add(t);
                            }
                        }
                    }
                }

                if (newLeadMap.get(leadObj.Id).X30_Day_Connect_Session__c != oldLeadMap.get(leadObj.Id).X30_Day_Connect_Session__c && newLeadMap.get(leadObj.Id).X30_Day_Connect_Session__c == true) {
                    if (candidateTaskMap.get(leadObj.Id) == null) {
                        task t = LeadTaskHandler.createNewLeadTask(leadObj, DAY30STASKSUBJECT, TASKPRIORITY, TASKSTATUS, TASKTYPE, Integer.valueOf(Label.CL_30_days), taskRecordType.Id);

                        taskToInsert.add(t);
                    } else {
                        List < Task > days30Task = candidateTaskMap.get(leadObj.Id);
                        boolean found = false;
                        for (Task t: days30Task) {
                            if (!found && t.Candidate_Connect__c == Label.CL_30_days) {
                                found = true;
                            }
                        }
                        if (!found) {
                            // if task not found then create a new task instance and add then a list to be inserted
                            task t = LeadTaskHandler.createNewLeadTask(leadObj, DAY30STASKSUBJECT, TASKPRIORITY, TASKSTATUS, TASKTYPE, Integer.valueOf(Label.CL_30_days), taskRecordType.Id);

                            taskToInsert.add(t);
                        }
                    }
                }
                if (newLeadMap.get(leadObj.Id).X60_Day_Connect_Session__c != oldLeadMap.get(leadObj.Id).X60_Day_Connect_Session__c && newLeadMap.get(leadObj.Id).X60_Day_Connect_Session__c == true) {
                    if (candidateTaskMap.get(leadObj.Id) == null) {
                        // if there is no task for this candidate lead then create a new task instance and add then a list to be inserted
                        task t = LeadTaskHandler.createNewLeadTask(leadObj, DAYS60TASKSUBJECT, TASKPRIORITY, TASKSTATUS, TASKTYPE, Integer.valueOf(Label.CL_60_days), taskRecordType.Id);

                        taskToInsert.add(t);
                    } else {
                        List < Task > days60Task = candidateTaskMap.get(leadObj.Id);
                        boolean found = false;
                        for (Task t: days60Task) {
                            if (!found && t.Candidate_Connect__c == Label.CL_60_days) {
                                found = true;
                            }
                        }
                        if (!found) {
                            // if there is existing task for this candidate lead but there is no task for 60 days connect then create a new task instance and add then a list to be inserted
                            task t = LeadTaskHandler.createNewLeadTask(leadObj, DAYS60TASKSUBJECT, TASKPRIORITY, TASKSTATUS, TASKTYPE, Integer.valueOf(Label.CL_60_days), taskRecordType.Id);

                            taskToInsert.add(t);
                        }
                    }
                }

                if (newLeadMap.get(leadObj.Id).X90_Day_Connect_Session__c != oldLeadMap.get(leadObj.Id).X90_Day_Connect_Session__c && newLeadMap.get(leadObj.Id).X90_Day_Connect_Session__c == true) {
                    if (candidateTaskMap.get(leadObj.Id) == null) {
                        // if there is no task for this candidate lead then create a new task instance and add then a list to be inserted
                        
                        task t = LeadTaskHandler.createNewLeadTask(leadObj, DAYS90TASKSUBJECT, TASKPRIORITY, TASKSTATUS, TASKTYPE, Integer.valueOf(Label.CL_90_days), taskRecordType.Id);

                        taskToInsert.add(t);
                    } else {
                        List < Task > days90Task = candidateTaskMap.get(leadObj.Id);
                        boolean found = false;
                        for (Task t: days90Task) {
                            if (!found && t.Candidate_Connect__c == Label.CL_90_days) {
                                found = true;
                            }
                        }
                        if (!found) {
                            // if there is existing task for this candidate lead but there is no task for 90 days connect then create a new task instance and add then a list to be inserted
                            task t = LeadTaskHandler.createNewLeadTask(leadObj, DAYS90TASKSUBJECT, TASKPRIORITY, TASKSTATUS, TASKTYPE, Integer.valueOf(Label.CL_90_days), taskRecordType.Id);

                            taskToInsert.add(t);
                        }
                    }
                }
                
            }

        
            if (taskToInsert.size() > 0) {
                Database.insert(taskToInsert, false);
                
            }
            if (taskToDelete.size() > 0) {
                Database.delete(taskToDelete, false);
            }
        
        }
        
        /*******************************************************************
        Purpose: This function returns instance of 30/60/90 days connect task (Service Connect Task) for candidate lead.
        Parameters: Lead,string,string , string, string , integer ,string 
        Returns: Task
        Throws [Exceptions]: NA
        ********************************************************************/
     
    public static Task createNewLeadTask(Lead leadObj, string subject, string priority, string status, string type, integer days, string recordTypeId) {
        Date dueDate;
        string connectSession = Label.CL_30_days;
        if (leadObj.First_Contact_Date__c != null) {
            if (days == Integer.valueOf(Label.CL_30_days)) {
                // Activity date will be 30 days ahead from first contact date
                dueDate = leadObj.First_Contact_Date__c.addDays(Integer.valueOf(Label.CL_30_days));
                connectSession = Label.CL_30_days;
            } else if (days == Integer.valueOf(Label.CL_60_days)) {
                // Activity date will be 60 days ahead from first contact date
                dueDate = leadObj.First_Contact_Date__c.addDays(Integer.valueOf(Label.CL_60_days));
                connectSession = Label.CL_60_days;
            } else if (days == Integer.valueOf(Label.CL_90_days)) {
                // Activity date will be 90 days ahead from first contact date
                dueDate = leadObj.First_Contact_Date__c.addDays(Integer.valueOf(Label.CL_90_days));
                connectSession = Label.CL_90_days;
            }
        }
        // Create a new candidate connect task
        return new Task(
            WhoId = leadObj.id,
            Subject = subject,
            Priority = priority,
            Status = status,
            Type = type,
            ownerID = leadObj.ownerID,
            ActivityDate = dueDate,
            Candidate_Connect__c = connectSession,
            RecordTypeId = recordTypeId
        );

    }
}