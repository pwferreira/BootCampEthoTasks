trigger AccountTrigger on Account (before insert,after insert,after update) {

    if(trigger.isInsert){
        if(trigger.isBefore){
            AccountTriggerHandler.isBeforeInsert(trigger.new,trigger.newMap,trigger.oldMap);
        }
        else {
            AccountTriggerHandler.isAfterInsert(trigger.new,trigger.newMap,trigger.oldMap);
        }
    }

    if(trigger.isUpdate){
        if(trigger.isAfter){
            AccountTriggerHandler.isAfterUpdate(trigger.new,trigger.newMap,trigger.oldMap);
        }
    }
}