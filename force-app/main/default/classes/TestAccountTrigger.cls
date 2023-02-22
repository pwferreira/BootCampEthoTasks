@isTest
public with sharing class TestAccountTrigger {
    @isTest
    public static void testInsertOuroAccount(){
        List<Account> accountsToInsert =  AccountDataFactory.createAccounts(1,'Ouro');

        List<Vendedor__c> vendedores = new List<Vendedor__c>();

        vendedores.addAll(VendedorDataFactory.criarVendedores(1,'Interno'));
        
        Test.startTest();
        insert vendedores;
        insert accountsToInsert;

        Account[] assertAccount = [SELECT Id,QualificacaoCliente__c,Vendedor__c FROM Account WHERE QualificacaoCliente__c = 'Ouro'];
        Vendedor__c [] vendedor = [SELECT Id FROM Vendedor__C WHERE RecordTypeId = '012Dn000000Zxc0IAC'];

        Test.stopTest();

        System.assertEquals(vendedor[0].Id, assertAccount[0].Vendedor__c,'Vendedor da Conta não foi atualizada');
        

    }

    @isTest
    public static void testInsertBronzeAccount(){
        List<Account> accountsToInsert =  AccountDataFactory.createAccounts(1,'Bronze');

        List<Vendedor__c> vendedores = new List<Vendedor__c>();

        vendedores.addAll(VendedorDataFactory.criarVendedores(1,'Externo'));
        
        Test.startTest();
        insert vendedores;
        insert accountsToInsert;

        Account[] assertAccount = [SELECT Id,QualificacaoCliente__c,Vendedor__c FROM Account WHERE QualificacaoCliente__c = 'Bronze'];
        Vendedor__c [] vendedor = [SELECT Id FROM Vendedor__C WHERE RecordTypeId = '012Dn000000Zxc5IAC'];

        Test.stopTest();

        System.assertEquals(vendedor[0].Id, assertAccount[0].Vendedor__c,'Vendedor da Conta não foi atualizada');
        

    }

    @isTest
    public static void testInsertPrataAccount(){
        List<Account> accountsToInsert =  AccountDataFactory.createAccounts(1,'Prata');

        List<Vendedor__c> vendedores = new List<Vendedor__c>();

        vendedores.addAll(VendedorDataFactory.criarVendedores(1,'Externo'));
        
        Test.startTest();
        insert vendedores;
        insert accountsToInsert;

        Account[] assertAccount = [SELECT Id,QualificacaoCliente__c,Vendedor__c FROM Account WHERE QualificacaoCliente__c = 'Prata'];
        Vendedor__c [] vendedor = [SELECT Id FROM Vendedor__C ];

        Test.stopTest();

        System.assertEquals(vendedor[0].Id, assertAccount[0].Vendedor__c,'Vendedor da Conta não foi atualizada');
        

    }

    

}