@isTest
public with sharing class TestAccountTrigger {
    @isTest
    public static void testInsertGoldAccount(){
        List<Account> accountsToInsert =  AccountDataFactory.createAccounts(1,'Ouro');

        Test.startTest();
        insert accountsToInsert;

        Account[] assertAccount = [SELECT Id,QualificacaoCliente__c FROM Account WHERE QualificacaoCliente__c = 'Ouro'];

        Test.stopTest();

        System.assertNotEquals(null, assertAccount[0].Vendedor__c,'Vendedor da Conta não foi atualizada');
        

    }

}