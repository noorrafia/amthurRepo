public class AccountAddressTriggerclass
{
    public static void OnbeforeInsert(List<Account> newlist)//for insert event
    {
        
        for(Account a:newlist)
        {
            if(a.Match_Billing_Address__c == true)
            {
                
                a.ShippingPostalCode = a.BillingPostalCode;//assign billing address to shipping
                
            }
        }
    }
    
    public static void OnbeforeUpdate(List<Account> newlist)//for update event
    {
        
        for(Account a:newlist)
        {
            if(a.Match_Billing_Address__c == true)
            {
                
                    a.ShippingPostalCode = a.BillingPostalCode;
                
            }
        }
    }
}