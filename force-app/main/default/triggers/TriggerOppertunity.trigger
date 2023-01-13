trigger TriggerOppertunity on Opportunity (after insert,after update) 
{
    if(trigger.IsAfter && trigger.isInsert)
    {
        OppertunityHandler.onAfterInsert(Trigger.new);
    }
    else if(trigger.IsAfter && trigger.isUpdate){
        
         OppertunityHandler.onAfterUpdate(Trigger.new,Trigger.oldMap);
    }
 
}