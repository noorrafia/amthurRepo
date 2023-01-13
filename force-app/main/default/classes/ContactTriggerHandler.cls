public class ContactTriggerHandler
{
    public static void OnAfterInsert(List<Contact> newlist)//After Insert new accid in accids in contact object update the size of contacts
    {
        
        Set<id> accountIds = new Set<id>();
        for(Contact c:newlist)
        {
            if(c.accountId!=null)
            {
                accountIds.add(c.accountId);
            }
        }
        List<Account> accList=[SELECT Id,Number_of_Contacts__c,(SELECT Id from Contacts) from Account where id=:accountIds];
        if(!accList.isEmpty())
        {
            for(Account acc:accList)
            {
                acc.Number_of_Contacts__c=acc.contacts.size();
            }
        }
        UPDATE accList;
    }
    
    public static void OnAfterUpdate(List<Contact> newlist,List<Contact> oldlist)//After update old and new accid in accids in contact object update the size of contacts
    {
        
        Set<id> accountIds = new Set<id>();
        for(Contact c:newlist)
        {
            if(c.accountId!=null)
            {
                accountIds.add(c.accountId);
            }
        }
        for(Contact c:oldlist)
        {
            if(c.accountId!=null)
            {
                accountIds.add(c.accountId);
            }
        }
        
        List<Account> accList=[SELECT Id,Number_of_Contacts__c,(SELECT Id from Contacts) from Account where id=:accountIds];
        if(!accList.isEmpty())
        {
            for(Account acc:accList)
            {
                acc.Number_of_Contacts__c=acc.contacts.size();
            }
        }
        UPDATE accList;
    }
    public static void OnAfterDelete(List<Contact> oldlist)//After delete old accid in accids in contact object update the size of contacts
    {
        //check old list and add accid*/
        Set<id> accountIds = new Set<id>();
        for(Contact c:oldlist)
        {
            if(c.accountId!=null)
            {
                accountIds.add(c.accountId);
            }
        }
        List<Account> accList=[SELECT Id,Number_of_Contacts__c,(SELECT Id from Contacts) from Account where id=:accountIds];
        if(!accList.isEmpty())
        {
            for(Account acc:accList)
            {
                acc.Number_of_Contacts__c=acc.contacts.size();
            }
        }
        UPDATE accList;
    }
    
}