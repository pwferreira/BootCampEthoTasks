public with sharing class UpdateAccountAddressQueueable implements Queueable{
    
    private List<Account> accounts;
    
    public UpdateAccountAddressQueueable(List<Account> newAccounts) {
        accounts = newAccounts;
    }
    
    public void execute(QueueableContext context) {
        ViaCepCallout.updateAccountAddressCallout(JSON.serialize(accounts));
    }
}