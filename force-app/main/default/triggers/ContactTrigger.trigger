trigger ContactTrigger on Contact(Before insert,After update,after delete) {
    
    
    if(trigger.isInsert)
    {
        
        if(trigger.isBefore)
        {
            ContactTriggerHandler.OnAfterInsert(Trigger.new);
        }
    }
    else if(trigger.isAfter)
    {
        
        if(trigger.isUpdate)
        {
            ContactTriggerHandler.OnAfterUpdate(Trigger.new,Trigger.old);
        }
        if(trigger.isDelete)
        {
            ContactTriggerHandler.OnAfterDelete(Trigger.old);
        }
    }
    
}