@isTest
private class ViaCepCalloutTest {
    @isTest
    static void testGetCallout(){

        Test.setMock(HttpCalloutMock.class, new ViaCepHttpCalloutMock());

        HttpResponse response = ViaCepCallout.makeGetCallout('13801035');
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assertEquals('application/json',contentType,'Content-Type in response is Wrong');

        String expectedValue = '{"cep": "13801-035","logradouro": "Rua Paschoal Stabile","complemento": "","bairro": "Jardim Brasília","localidade": "Mogi Mirim","uf": "SP","ibge": "3530805","gia": "4560","ddd": "19","siafi": "6717"}';

        System.assertEquals(expectedValue,  response.getBody(), 'Response body is Wrong');

        System.assertEquals(200, response.getStatusCode(),'Status Code in Response is Wrong');


    }

}