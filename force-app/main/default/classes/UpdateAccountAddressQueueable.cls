public with sharing class UpdateAccountAddressQueueable implements Queueable,Database.AllowsCallouts{
    
    private List<Account> accounts;
    
    public UpdateAccountAddressQueueable(List<Account> newAccounts) {
        accounts = newAccounts;
    }
    
    public void execute(QueueableContext context) {
        List<Account> accountsToUpdate = new List<Account>();

        for(Account account : [SELECT Id, Cep__c FROM Account WHERE Id in : accounts WITH SECURITY_ENFORCED]){

           HttpResponse response = ViaCepCallout.getAddress(account.Cep__c);
    
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