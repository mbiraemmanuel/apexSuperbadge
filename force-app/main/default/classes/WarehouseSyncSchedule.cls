global class WarehouseSyncSchedule implements Schedulable {
    global void execute (SchedulableContext ctx){
       System.enqueueJob(New WarehouseCalloutService());
    }
}
