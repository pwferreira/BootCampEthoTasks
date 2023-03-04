public without sharing class AccountTriggerHandler {
    
    public static void isBeforeInsert(Account [] newAccounts, Map<Id,Account> newAccountsMap,Map<Id,Account> oldAccountsMap ){
        
        AccountService.setVendedor(newAccounts);
    }
    
    public static void isAfterInsert(Account [] newAccounts, Map<Id,Account> newAccountsMap,Map<Id,Account> oldAccountsMap ){
        AccountService.callUpdateAddressMethod(newAccounts);
    }
    
    //public static void isBeforeUpdate(Account [] newAccounts, Map<Id,Account> newAccountsMap,Map<Id,Account> oldAccountsMap ){
    //}
    
    public static void isAfterUpdate(Account [] newAccounts, Map<Id,Account> newAccountsMap,Map<Id,Account> oldAccountsMap ){
        AccountService.callUpdateAddressMethod(newAccounts);
    }
}