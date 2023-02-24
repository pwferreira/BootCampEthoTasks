public with sharing class ViaCepCallout {

    
    public static HttpResponse makeGetCallout(String cep){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://viacep.com.br/ws/' + account.Cep__c + '/json/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        return response;
        
    }


    @future(callout=true)
    public static void updateAccountAddressCallout(String accountsString){
        List<Account> accountList = (List<Account>) JSON.deserialize(accountsString, List<Account>.class);
        List<Account> accountsToUpdate = new List<Account>();

        for(Account account : [SELECT Id, Cep__c FROM Account WHERE Id in : accountList WITH SECURITY_ENFORCED]){

            HttpResponse response = makeGetCallout(account.Cep__c);

            // If the request is successful, parse the JSON response.
            if(response.getStatusCode() == 200) {
            
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                
                //O campo EnderecoCompletoSemNumero__c deverá ser preenchido concatenando as informações Rua, Bairro, Cidade e Estado, retornadas na API.
                account.EnderecoCompletoSemNumero__c = (String) result.get('logradouro') + ', ' + 
                    (String) result.get('bairro') + ' ' +
                    (String) result.get('localidade') + ' ' +
                    (String) result.get('uf');

                account.EnderecoEstado__c = (String) result.get('uf');
                   
                accountsToUpdate.add(account);
            
            }

        }

        if (!Schema.sObjectType.Account.fields.EnderecoCompletoSemNumero__c.isUpdateable() ||!Schema.sObjectType.Account.fields.EnderecoEstado__c.isUpdateable())  {
            return ;
        }

        update accountsToUpdate;

    }
}