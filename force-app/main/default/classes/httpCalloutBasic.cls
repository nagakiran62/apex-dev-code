public class httpCalloutBasic{

public void getHttpResponse(){

Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint('https://postman-echo.com/get?foo1=bar1&foo2=bar2');
request.setMethod('GET');
HttpResponse response = http.send(request);
// If the request is successful, parse the JSON response.
if (response.getStatusCode() == 200) {
    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    System.debug('the test' +results);
}

} // end of method

}// end of class