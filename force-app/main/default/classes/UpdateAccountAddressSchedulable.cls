public with sharing class UpdateAccountAddressSchedulable implements Schedulable{

    private List<Account> accounts;
    
    public UpdateAccountAddressSchedulable(List<Account> newAccounts) {
        accounts = newAccounts;
    }
    
    public void execute(SchedulableContext ctx) {
        Map<Integer,List<Account>> queueList = Utilities.splitList(accounts, 50);
            
        for(Integer currentQueue : queueList.keySet()){
            
            ID jobId = System.enqueueJob(new UpdateAccountAddressQueueable(queueList.get(currentQueue)));
        }
    }
    
   
}