trigger AppointmentTrigger on Appointment__c (before insert) {
    AppointmentTriggerHandler handler = new AppointmentTriggerHandler();
    handler.onBeforeInsert(Trigger.new);
}
