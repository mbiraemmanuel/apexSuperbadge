public with sharing class WarehouseCalloutService implements queueable, Database.AllowsCallouts {
    
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200){
            List<Object> equipments = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<Product2> products = new List<Product2> ();

            System.debug('The following items were received: ');
            for (Object Equip : equipments){
                System.debug(Equip);
                Map<String, Object> productMap = (Map<String, Object>) Equip;
                Product2 prod = new Product2();

                prod.Replacement_Part__c = (Boolean)productMap.get('replacement');
                prod.Cost__c = (Integer)productMap.get('cost');
                prod.Current_Inventory__c = (Integer)productMap.get('quantity');
                prod.Lifespan_Months__c = (Integer)productMap.get('lifespan');
                prod.Maintenance_Cycle__c = (Integer)productMap.get('maintenanceperiod');
                prod.Warehouse_SKU__c = (String)productMap.get('sku');
                prod.ProductCode = (String)productMap.get('_id');
                prod.Name = (String)productMap.get('name');

                products.add(prod);
            }
            if (products.size() > 0)
                upsert products;
        }

    }
    public static void execute(QueueableContext context){
        runWarehouseEquipmentSync();
    }
}