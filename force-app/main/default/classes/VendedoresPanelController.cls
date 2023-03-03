public with sharing class VendedoresPanelController {
    @AuraEnabled(cacheable=true)
    public static List<Vendedor__c> getAccountsByVendedor(){
        try {
            return [SELECT Id, Name, RecordType.DeveloperName, (SELECT Id,Name FROM Accounts__r) FROM Vendedor__c WITH SECURITY_ENFORCED];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}