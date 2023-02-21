trigger AccountTrigger on Account (before insert) {

    if(trigger.isInsert){
        if(trigger.isBefore){
            AccountTriggerHandler.isBeforeInsert(trigger.new,trigger.newMap,trigger.oldMap);
        }
        else {
            
        }
    }

    if(trigger.isUpdate){
        if(trigger.isAfter){
            AccountTriggerHandler.isAfterUpdate(trigger.new,trigger.newMap,trigger.oldMap);
        }
    }
}