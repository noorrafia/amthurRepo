/** 
*  Description:When we are creating an oppertunity task will be created and mail should me sent to contact owner which is given in task
* * @author : amthurrafia
* */

public class OppertunityHandler
{
    public static void onAfterInsert(List<Opportunity> newlist)
        
    {
        
        //contact to assign to task
        Contact con = [SELECT  ID,LastName,Email FROM Contact WHERE LastName =: 'Noor r' ];
        
        //metadata value will be taken in list
        List<Opp_Data__mdt>  metaList = [SELECT MasterLabel,Subject__c FROM Opp_Data__mdt ];//call ,email
        System.debug(metaList);
        
        //new task list to insert in oppertunity
        List<Task> taskList = new List<Task>();
        
        
        
        //metadata value with key as record and value as data
        Map<String,Opp_Data__mdt> mapdata = new  Map<String,Opp_Data__mdt>();//all value,call/email
        
        for(Opp_Data__mdt data : metaList)
        {
            mapdata.put(data.MasterLabel.toLowercase(),data);
            System.debug(mapdata);
        }
        
        Id NewCustomerRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Customer').getRecordTypeId();
        System.debug(NewCustomerRecordTypeId);
        //   String s = 
        
        for(Opportunity oppdata:newlist)
        {
            String st = oppdata.NextStep.toLowercase();
           
            if(oppdata.CloseDate == Date.today() && oppdata.StageName == 'Closed Won' && mapdata.containsKey(st)  && oppdata.Type == 'New Customer' && oppdata.RecordTypeId == NewCustomerRecordTypeId && Type__c.getInstance(UserInfo.getProfileId()).Typeopp1__c == true )
            {
                
                Task newtask = new Task();
                newtask.Subject = mapdata.get(st).Subject__c;
                // newtask.Subject  = 'Call';
                newtask.ActivityDate =Date.today()+2;
                newtask.Status = 'In Progress';
                newtask.WhatId = oppdata.Id;
                newtask.WhoId = con.Id ;
                taskList.add(newtask);
            }  
            
            
            
        }
        //after insert sending mail to contact owner by using  Messaging.SingleEmailMessage class and its methods
        insert taskList;
       Messaging.SingleEmailMessage Email = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {con.Id}; 
            
            String[] ccAddresses = new String[] {con.Email};
                
                Email.setToAddresses(toAddresses);
        Email.setCcAddresses(ccAddresses);
        Email .setsubject ( 'Task Creation');
        Email .setplainTextBody( 'Task has been Created.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { Email });
        
        
        
    }
    
    /** 
*  Description:When we are editing oppertunity Nextstage Field from 'Closed won' se 'Closed Lost'  then task should be delete and email notification should be sent to contact owner
* * @author : amthurrafia
* */
    
    public static void onAfterUpdate(List<Opportunity> newlist,Map<Id,Opportunity> oldMap)
    {    
        //oppertunity id
        set<String> s = new set<string>();
        
        //task id
        set<String> p = new set<String>();
        
         Contact con = [SELECT  ID,LastName,Email FROM Contact WHERE LastName =: 'Noor r' ];
        
    //new task list to insert in oppertunity
        List<Task> taskList = new List<Task>();
                
          //metadata value will be taken in list
        List<Opp_Data__mdt>  metaList = [SELECT MasterLabel,Subject__c FROM Opp_Data__mdt ];//call ,email
        System.debug(metaList);
        
          //metadata value with key as record and value as data
        Map<String,Opp_Data__mdt> mapdata = new  Map<String,Opp_Data__mdt>();//all value,call/email
        
        for(Opp_Data__mdt data : metaList)
        {
            mapdata.put(data.MasterLabel.toLowercase(),data);
            System.debug(mapdata);
        }
        //oppertunity stage 'Closed Lostoppdata' 
        for(Opportunity oppdata:newlist)
        {
              String st = oppdata.NextStep.toLowercase();
            
          
            
         if(oppdata.StageName == 'Closed Won' && Type__c.getInstance(UserInfo.getProfileId()).Typeopp1__c == true )
            {
              //Task newt = new Task();
                 Task newtask = new Task();
                newtask.Subject = mapdata.get(st).Subject__c;
               newtask.ActivityDate =Date.today()+2;
               newtask.Status = 'In Progress';
              newtask.WhatId = oppdata.Id;
              newtask.WhoId = con.Id ;
              taskList.add(newtask);
                
            }
            
           else if(oldMap.get(oppdata.Id).StageName == 'Closed Won' && oppdata.StageName == 'Closed Lost')
            {
                
                s.add(oppdata.Id); 
                
            }
         
        }
        //taking task from oppertunity and deleting
        List<Task> tasklist1 = [SELECT WhoId from task WHERE WhatId  =: s ];
        for (task t2 : tasklist1 )
        {
            
            p.add(t2.WhoId); 
        }
        
        insert taskList;
        delete taskList1;
        List<Contact> cont = [select Id,Email From Contact Where Id IN : p];
        
        //sending mail to contact owner after oppertunity is edited
        for(Contact con1 : cont)
        {
            Messaging.SingleEmailMessage Email = new Messaging.SingleEmailMessage();
            
            String[] toAddresses = new String[] {con1.Email}; 
                String[] ccAddresses = new String[] {con1.Email};
                    Email.setToAddresses(toAddresses);
            
            Email .setsubject ( 'Task delete');
            Email .setplainTextBody( 'Task has been Deleted.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { Email }); 
        }
    }
}