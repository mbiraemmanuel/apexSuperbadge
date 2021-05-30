@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here 1
    @isTest
    static void testWareHouseCallout(){
        Test.startTest();
        // implement mock callout test here
        Test.setMock(HTTPCalloutMock.class, new WarehouseCalloutServiceMock());
        System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM Product2]);
    }     

}