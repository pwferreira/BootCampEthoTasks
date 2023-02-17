public with sharing class AccountDataFactory {
    public static List<Account> createAccounts(Integer noOfAccountsToCreate, String qualification) {

        
        List<Account> accounts = new List<Account>();
        
        for(Integer i=0;i<noOfAccountsToCreate;i++){
            Account acc = new Account(Name = 'Test' + i,CEP__c = '13801035');
            acc.QualificacaoCliente__c = qualification;
            accounts.add(acc);
        }

        return accounts;

    }
}