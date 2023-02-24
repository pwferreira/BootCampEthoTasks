public with sharing class UpdateAccountAddressSchedulable implements Schedulable{

    private List<Account> accounts;

    public UpdateAccountAddressSchedulable(List<Account> newAccounts) {
        accounts = newAccounts;
    }
    
    public void execute(SchedulableContext ctx) {

        ViaCepCallout.updateAccountAddressCalloutAsync(JSON.serialize(accounts));
       
    }
}