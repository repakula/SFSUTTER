/**
 * Name : ServiceRequestController_Test
 * Author : NovaCop Unit Test Generator
 * Description : Test class used for testing the ServiceRequestController
 * Date : 6/23/14 1:34 PM 
 * Version : <intial Draft> 
 */
@isTest(SeeAllData=true)
private class ServiceRequestController_Test { 

    static testMethod void testServiceRequestController()
    {
        //Instantiate the controller to fire the constructor.
        ServiceRequestController controller= new ServiceRequestController();
        // Assert to check Service Request controller
        system.assertnotequals(controller,null);
    }
}