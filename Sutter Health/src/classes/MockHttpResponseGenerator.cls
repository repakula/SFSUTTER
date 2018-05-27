@isTest
                        
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"oxgfsd4231656"}');
        res.setStatusCode(200);
        //Assert to check Response is available 
         System.assertNotEquals(null,res);
        return res;        
    }
    
}