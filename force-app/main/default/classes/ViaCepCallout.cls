public with sharing class ViaCepCallout {

    public static HttpResponse getAddress(String cep){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://viacep.com.br/ws/' + cep + '/json/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        return response;

    }

    @future(callout=true)
    public static void updateAccountAddresFuture(String accountsString){

        List<Account> accounts = (List<Account>) JSON.deserialize(accountsString, List<Account>.class);
        List<Account> accountsToUpdate = new List<Account>();

        for(Account account : [SELECT Id, Cep__c FROM Account WHERE Id in : accounts WITH SECURITY_ENFORCED]){

           HttpResponse response =  getAddress(account.Cep__c);
    
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

        if ((!Schema.sObjectType.Account.fields.EnderecoCompletoSemNumero__c.isUpdateable()) || (!Schema.sObjectType.Account.fields.EnderecoEstado__c.isUpdateable()))  {
            return ;
        }

        if(accountsToUpdate.size() > 0 ){
            update accountsToUpdate;
        }
    }
}