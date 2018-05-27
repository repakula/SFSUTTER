/*
    This class is used to cover the SH_Login class
    ==========================================================
    Name                    Date                       version
    ==========================================================
    Alok verma             24/09/2015                   1.0
    ==========================================================  
*/
@isTest
private class SH_LoginTest {

    static testmethod void ValidateLogin(){
        Apexpages.currentpage().getparameters().put('startURL','test');
        SH_Login objLogin =new SH_Login();
        objLogin.login();
    }
}