public with sharing class ViaCepCallout {
    public static HttpResponse makeGetCallout(string cep) {
    
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://viacep.com.br/ws/' + cep + '/json/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        return response;
    
    
    }
}