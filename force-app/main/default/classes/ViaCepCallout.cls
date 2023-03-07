public with sharing class ViaCepCallout {

    public static HttpResponse getAddress(String cep){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://viacep.com.br/ws/' + cep + '/json/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        return response;

    }
}