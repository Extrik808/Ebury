public with sharing class TradeTriggerHelper {

    private static final String QUEUE = 'Queue';

    public void handleAfterInsert() {
        this.createChatterPosts();
    }

    private void createChatterPosts() {
        Set<Id> queueMemberIds = this.getQueueMemberIds();

        try {
            ChatterService chatter = new ChatterService();

            for (Trade__c trade: (List<Trade__c>) Trigger.new) {
                chatter.createPost(queueMemberIds, this.generatePostMessage(trade), trade.Id);
            }

            chatter.send();
        } catch(CustomException exc) {
            Trigger.new[0].addError('Cannot create Chatter post: ' + exc.getMessage());
        }
    }

    private String getQueueName() {
        return Chatter_Setting__c.getOrgDefaults().Queue_Name__c;
    }

    private Id getQueueByName(String name) {
        return [SELECT Id FROM Group WHERE Type = :QUEUE AND Name = :name].Id;
    }

    private Set<Id> getQueueMemberIds() {
        Set<Id> result = new Set<Id>();

        try {
            String queueName = this.getQueueName();

            for (GroupMember member : [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :this.getQueueByName(queueName)]) {
                result.add(member.UserOrGroupId);
            }
        } catch (QueryException exc) {
            Trigger.new[0].addError('We cannot find queue.');
        }

        return result;
    }

    private String generatePostMessage(Trade__c trade) {
        List<String> params = new List<String>{
            trade.Sell_Currency__c,
            String.valueOf(trade.Sell_Amount__c),
            trade.Buy_Currency__c,
            String.valueOf(trade.Buy_Amount__c),
            String.valueOf(trade.Rate__c),
            trade.Date_Booked__c.format() + '\n'
        };

        return String.format(Label.chatter_Notification_Message, params);
    }

}