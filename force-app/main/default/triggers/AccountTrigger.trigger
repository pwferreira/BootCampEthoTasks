trigger AccountTrigger on Account (after insert) {

    if(trigger.isInsert){
        if(trigger.isAfter){
            AccountTriggerHandler.isAfterInsert(trigger.new,trigger.newMap,trigger.oldMap);
        }
    }
    
    
    
}