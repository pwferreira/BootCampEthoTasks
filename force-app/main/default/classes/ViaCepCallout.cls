public with sharing class ViaCepCallout {

    public static HttpResponse getAddress(String cep){
        
        try{
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://viacep.com.br/ws/' + cep + '/json/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        return response;
        }catch(Exception exc){
            System.debug('Ocorreu um erro ao consultar endereço' + exc.getMessage() + exc.getStackTraceString());
            return new HttpResponse();
        }
    }
}