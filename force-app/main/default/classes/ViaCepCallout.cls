public with sharing class ViaCepCallout {
    public static HttpResponse makeGetCallout(string cep) {
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('viacep.com.br/ws/' + 01001000 + '/json/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        return response;
    
    
    }
}