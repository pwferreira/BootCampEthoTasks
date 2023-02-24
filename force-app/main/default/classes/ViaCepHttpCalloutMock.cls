@isTest
public class ViaCepHttpCalloutMock implements HttpCalloutMock{
   
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"cep": "13801035","logradouro": "Rua Paschoal Stabile","complemento": "","bairro": "Jardim Brasília","localidade": "Mogi Mirim","uf": "SP","ibge": "3530805","gia": "4560","ddd": "19","siafi": "6717"}');
        response.setStatusCode(200);
        return response; 
    }
}