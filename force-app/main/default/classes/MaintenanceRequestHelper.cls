public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(Map<Id, Case> applicableCases){
		System.debug('*******Inside MaintenanceRequestHelper Class*******');
	    Map<Id, Integer> mapProduct = new Map<Id, Integer>(); 
   		List<Case> newCaseList = new List<Case>();

        Integer count = 0;
        Integer leastDays;
        List<Product2> listProduct = [select Id, Maintenance_Cycle__c from Product2];       							
            for (Product2 p : listProduct) {
                if (p != null) {
                    if (count == 0){
                        leastDays = Integer.valueOf(p.Maintenance_Cycle__c);
                    }
                    else{
                        if (Integer.valueOf(p.Maintenance_Cycle__c) < leastDays){
                            leastDays = Integer.valueOf(p.Maintenance_Cycle__c);
                        }
                    }
                    count ++ ;             
                }
            }
       
        List<Equipment_Maintenance_Item__c> junc = [SELECT Id, Equipment__c, Maintenance_Request__c  FROM Equipment_Maintenance_Item__c] ;
        
        List<Equipment_Maintenance_Item__c> newJunc = new List<Equipment_Maintenance_Item__c>();
        for(Case a: applicableCases.values()){
            
            Case newCase = new Case();
            newCase.Vehicle__c = a.Vehicle__c;                     
            system.debug(a.Product__c);
            newCase.Type = 'Routine Maintenance';
            newCase.Subject = String.isBlank(a.Subject) ? 'Routine Maintenance Request' : a.Subject;
            newCase.Date_Reported__c = Date.today();
            newCase.Status = 'New';
            newCase.Product__c = a.Product__c;
            newCase.AccountId = a.AccountId;
            newCase.ContactId = a.ContactId;
            newCase.AssetId = a.AssetId;
            newCase.Origin = a.Origin;
            newCase.Reason = a.Reason;
            newCase.Date_Due__c =  Date.today().addDays(leastDays);
            newCase.prevId__c = a.Id;
            newCaseList.add(newCase);

        }
        
        if(newCaseList.size() > 0){
            insert newCaseList;
            system.debug(newCaseList)
            for (Case newCase : newCaseList){
                for (Equipment_Maintenance_Item__c it : junc){
                    system.debug('Equipment_Maintenance__c');
                    system.debug(it );
                    if (it.Maintenance_Request__c == newCase.prevId__c){
                        Equipment_Maintenance_Item__c Equp = new Equipment_Maintenance_Item__c();
                        Equp.Equipment__c = it.Equipment__c;
                        Equp.Maintenance_Request__c = newCase.Id;
                        newJunc.add(Equp);
                    }
                }
            }
        }
        

        if(newJunc.size() > 0){
            insert newJunc;
        }
        }
        

        
		        
        
    }        
    
