trigger TradeTrigger on Trade__c (after insert) {
    TradeTriggerHelper helper = new TradeTriggerHelper();

    if (Trigger.isAfter && Trigger.isInsert) {
        helper.handleAfterInsert();
    }
}