trigger MaintenanceRequest on Case (before update, after update) {
    // ToDo: call maintenance request helper.updateworkorders
    system.debug('***Trigger Initiated***' );

    Map<Id, Case> caseList = new Map<Id, Case>();

    if(trigger.isUpdate && Trigger.isAfter){
        for (Case cas : Trigger.New ){
            if (cas.Type=='Repair' || cas.Type == 'Routine Maintenance' && cas.IsClosed == True){
                caseList.put(cas.Id, cas);
            } 
        }
    }
    
    if (!caseList.isEmpty()){
        system.debug('Calling MaintenanceRequestHelper.updateWorkOrders');
        MaintenanceRequestHelper.updateWorkOrders(caseList);
    }
}