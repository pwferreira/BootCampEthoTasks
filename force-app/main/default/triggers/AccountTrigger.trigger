trigger AccountTrigger on Account (before insert) {

    if(trigger.isInsert){
        if(trigger.isBefore){
            AccountTriggerHandler.IsBeforeInsert(trigger.new,trigger.newMap,trigger.oldMap);
        }
    }
    
    
    
}