trigger AccountTrigger on Account (before insert) {

    if(trigger.isInsert){
        if(trigger.isBefore){
            AccountTriggerHandler.isAfterInsert(trigger.new,trigger.newMap,trigger.oldMap);
        }
    }
    
    
    
}