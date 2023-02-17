@isTest
public with sharing class TestAccountTrigger {
    @isTest
    public static void testInsertGoldAccount(){
        List<Account> accountsToInsert =  AccountDataFactory.createAccounts(1,'Ouro');

        List<Vendedor__c> vendedores = new List<Vendedor__c>();

        vendedores.addAll(VendedorDataFactory.criarVendedoresInternos(1));
        vendedores.addAll(VendedorDataFactory.criarVendedoresExternos(1));

        Test.startTest();
        insert vendedores;
        insert accountsToInsert;

        Account[] assertAccount = [SELECT Id,QualificacaoCliente__c FROM Account WHERE QualificacaoCliente__c = 'Ouro'];

        Test.stopTest();

        System.assertNotEquals(null, assertAccount[0].Vendedor__c,'Vendedor da Conta não foi atualizada');
        

    }

}