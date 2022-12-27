trigger AccountAddressTrigger on Account (before insert,before update) 
{
    if(trigger.isBefore)
    {
        if(trigger.isInsert)
        {
            AccountAddressTriggerclass.OnbeforeInsert(Trigger.new);
        }
        else if(trigger.isUpdate)
        {
            
            AccountAddressTriggerclass.OnbeforeUpdate(Trigger.new);
        }
    }
}