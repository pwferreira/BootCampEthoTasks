@isTest
public with sharing class TestAccountTrigger {
    @isTest
    public static void testSetVendedorContaOuro(){
        List<Account> accountsToInsert =  AccountDataFactory.createAccounts(1,'Ouro');

        List<Vendedor__c> vendedores = new List<Vendedor__c>();

        vendedores.addAll(VendedorDataFactory.criarVendedores(1,'Interno'));

        GetAddressConfigTest.testConfig = 'QueueAble';
        
        Test.setMock(HttpCalloutMock.class, new ViaCepHttpCalloutMock());
        Test.startTest();
        insert vendedores;
        insert accountsToInsert;

        Account[] assertAccount = [SELECT Id,QualificacaoCliente__c,Vendedor__c,EnderecoEstado__c FROM Account WHERE QualificacaoCliente__c = 'Ouro'];
        Vendedor__c [] vendedor = [SELECT Id FROM Vendedor__C WHERE RecordTypeId = '012Dn000000Zxc0IAC'];
                
        Test.stopTest();
        
        System.assertEquals(vendedor[0].Id, assertAccount[0].Vendedor__c,'Vendedor da Conta não foi atualizada');
     
    }

    @isTest
    public static void testSetVendedorContaBronze(){
        List<Account> accountsToInsert =  AccountDataFactory.createAccounts(1,'Bronze');

        List<Vendedor__c> vendedores = new List<Vendedor__c>();

        vendedores.addAll(VendedorDataFactory.criarVendedores(1,'Externo'));

        GetAddressConfigTest.testConfig = 'QueueAble';
        
        Test.setMock(HttpCalloutMock.class, new ViaCepHttpCalloutMock());
        Test.startTest();
        insert vendedores;
        insert accountsToInsert;

        Account[] assertAccount = [SELECT Id,QualificacaoCliente__c,Vendedor__c,EnderecoEstado__c FROM Account WHERE QualificacaoCliente__c = 'Bronze'];
        Vendedor__c [] vendedor = [SELECT Id FROM Vendedor__C WHERE RecordTypeId = '012Dn000000Zxc5IAC'];

        Test.stopTest();

        System.assertEquals(vendedor[0].Id, assertAccount[0].Vendedor__c,'Vendedor da Conta não foi atualizada');

    }

    @isTest
    public static void testSetVendedorContaPrata(){
        List<Account> accountsToInsert =  AccountDataFactory.createAccounts(1,'Prata');

        List<Vendedor__c> vendedores = new List<Vendedor__c>();

        vendedores.addAll(VendedorDataFactory.criarVendedores(1,'Externo'));

        GetAddressConfigTest.testConfig = 'QueueAble';
        
        Test.setMock(HttpCalloutMock.class, new ViaCepHttpCalloutMock());
        Test.startTest();
        insert vendedores;
        insert accountsToInsert;

        Account[] assertAccount = [SELECT Id,QualificacaoCliente__c,Vendedor__c,EnderecoEstado__c FROM Account WHERE QualificacaoCliente__c = 'Prata'];
        Vendedor__c [] vendedor = [SELECT Id FROM Vendedor__C ];

        Test.stopTest();

        System.assertEquals(vendedor[0].Id, assertAccount[0].Vendedor__c,'Vendedor da Conta não foi atualizada');

    }

    @isTest
    public static void testSetVendedorContaOuroBulk(){
        List<Account> accountsToInsert =  AccountDataFactory.createAccounts(60,'Ouro');

        List<Vendedor__c> vendedores = new List<Vendedor__c>();

        vendedores.addAll(VendedorDataFactory.criarVendedores(1,'Interno'));

        GetAddressConfigTest.testConfig = 'QueueAble';
        
        Test.setMock(HttpCalloutMock.class, new ViaCepHttpCalloutMock());
        Test.startTest();
        insert vendedores;
        insert accountsToInsert;

        Account[] assertAccount = [SELECT Id,QualificacaoCliente__c,Vendedor__c,EnderecoEstado__c FROM Account WHERE QualificacaoCliente__c = 'Ouro' AND Vendedor__c != NULL];
        Vendedor__c [] vendedor = [SELECT Id FROM Vendedor__C WHERE RecordTypeId = '012Dn000000Zxc0IAC'];
                
        Test.stopTest();
        
        System.assertEquals(60, assertAccount.size(),'Alguma Conta não teve vendedor definido');
     
    }

    @isTest
    public static void testUpdateAddresQueueAble(){
        List<Account> accountsToInsert =  AccountDataFactory.createAccounts(1,'Ouro');

        List<Vendedor__c> vendedores = new List<Vendedor__c>();

        vendedores.addAll(VendedorDataFactory.criarVendedores(1,'Interno'));

        GetAddressConfigTest.testConfig = 'QueueAble';
        
        Test.setMock(HttpCalloutMock.class, new ViaCepHttpCalloutMock());
        Test.startTest();
        insert vendedores;
        insert accountsToInsert;

        Vendedor__c [] vendedor = [SELECT Id FROM Vendedor__C WHERE RecordTypeId = '012Dn000000Zxc0IAC'];
        
        Test.stopTest();
        Account[] assertAccount = [SELECT Id,QualificacaoCliente__c,Vendedor__c,EnderecoEstado__c FROM Account WHERE QualificacaoCliente__c = 'Ouro'];
                
        System.assertEquals('SP', assertAccount[0].EnderecoEstado__c,'Estado da Conta não foi atualizado');
    }

    @isTest
    public static void testUpdateAddresSchedulable(){
        List<Account> accountsToInsert =  AccountDataFactory.createAccounts(1,'Ouro');

        List<Vendedor__c> vendedores = new List<Vendedor__c>();

        vendedores.addAll(VendedorDataFactory.criarVendedores(1,'Interno'));

        GetAddressConfigTest.testConfig = 'Schedulable';
        
        Test.setMock(HttpCalloutMock.class, new ViaCepHttpCalloutMock());
        Test.startTest();
        insert vendedores;
        insert accountsToInsert;


        UpdateAccountAddressSchedulable accountAddresScheduleable = new UpdateAccountAddressSchedulable(accountsToInsert);
              
        String sch = '0 0 0 15 3 ? 2023';
                
        ID jobId = System.schedule('ScheduledApexTest', sch, accountAddresScheduleable);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId WITH SECURITY_ENFORCED]; 
        System.assertEquals(sch, ct.CronExpression,'Tarefa não foi agendada corretamente'); 
        
        System.assertEquals(0, ct.TimesTriggered,'Tarefa executou'); 


        System.assertEquals('2023-03-15 00:00:00', String.valueOf(ct.NextFireTime),'Agendamento configurado esta incorreto');   
        Test.stopTest();

    }
    
}