public with sharing class VendedoresPanelController {
    @AuraEnabled(cacheable=true)
    public static List<Vendedor__c> getAllAccountsByVendedor(){
        try {
            return [SELECT Id, Name, RecordType.DeveloperName, (SELECT Id
                                                                       ,Name
                                                                       ,AnnualRevenue
                                                                       ,EnderecoCompletoSemNumero__c
                                                                       ,EnderecoEstado__c
                                                                       ,EnderecoRua__c
                                                                       ,EnderecoCidade__c
                                                                       ,EnderecoPais__c
                                                                FROM Accounts__r) FROM Vendedor__c WITH SECURITY_ENFORCED];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}