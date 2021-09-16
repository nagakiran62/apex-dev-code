@RestResource (urlMapping='/wte/test/*')
global class WTE_SampleRESTService {
    @HttpGet
    global static void doGet() {
        String id = RestContext.request.params.get('id');
        System.debug('ID: '+ id);
    }

    @HttpPost
    global static void doPost() {
    
       system.debug('thevalue' +RestContext.request);
        Map<String,Object> reqBody = (Map<String,Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
    
    //List<Map<String, Object>> data = new List<Map<String, Object>>();
    
    //for (Object o: (List<Object>)reqBody.get('data'))
    //data.add((Map<String, Object>)o);
    
    system.debug('reqbody'+reqBody);
    }
    
  
}