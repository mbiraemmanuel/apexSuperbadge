@isTest
private class MaintenanceRequestHelperTest {

    @isTest
    static void TestUpdateCaseValues(){
                
        Vehicle__c  v = new Vehicle__c(Name = 'Test Method Vehicle');
        List<Product2> prodList = new List<Product2>();
        Product2 p = new Product2(Name = 'Test Method Product', Maintenance_Cycle__c = 90, Replacement_Part__c =true, Lifespan_Months__c = 36);
        ProdList.add(p);
        Product2 p1 = new Product2(Name = 'Test Method Product1', Maintenance_Cycle__c = 60, Lifespan_Months__c = 36);
        ProdList.add(p1);
        Product2 p2 = new Product2(Name = 'Test Method Product2', Maintenance_Cycle__c = 70, Lifespan_Months__c = 36);
        ProdList.add(p2);
        insert v;
        insert prodList;
        system.debug('P Id : ' + p.Id);
        Case c = new Case(Subject = 'TEST Method Maintenance Request', 
                 Origin = 'Phone', Status = 'New', 
                 Type = 'Repair',
                 Vehicle__c = v.Id, 
                 Date_Due__c = Date.today().addDays((Integer)p.Maintenance_Cycle__c) , 
                 Date_Reported__c = Date.today());
        insert c ;
        Equipment_Maintenance_Item__c newMaintenanceItem = New Equipment_Maintenance_Item__c(
            Equipment__c = p.Id,
            Maintenance_Request__c = c.Id
        );
        insert newMaintenanceItem;
        List<Equipment_Maintenance_Item__c> junc = [SELECT Id, Equipment__c, Maintenance_Request__c  FROM Equipment_Maintenance_Item__c] ;
        system.debug('Junc: ' + junc);
        c.Status = 'Closed';
        Test.startTest();
        Database.SaveResult res = Database.update(c);
        Test.stopTest();
        System.assert(res.isSuccess());
        Id vid = v.Id;
        Integer casecount = Database.countQuery('SELECT count() FROM Case WHERE (Vehicle__c = :vId AND Status = \'New\')');
        System.assertEquals(1, casecount);

    }
}