public with sharing class TradeTriggerHelper {

    private static final String QUEUE = 'Queue';

    public void handleAfterInsert() {
        this.createChatterPosts();
    }

    private void createChatterPosts() {
        try {
            Set<Id> queueMemberIds = this.getQueueMemberIds();
            ChatterService chatter = new ChatterService();

            for (Trade__c trade: (List<Trade__c>) Trigger.new) {
                chatter.createPost(queueMemberIds, chatter.generatePostMessage(trade), trade.Id);
            }

            chatter.sendPost();
        } catch (CustomException ex) {
            Trigger.new[0].addError(Label.chatter_Error_Message + ex.getMessage());
        }
    }

    private String getQueueName() {
        return Chatter_Setting__c.getOrgDefaults().Queue_Name__c;
    }

    private Id getQueueByName(String name) {
        return [SELECT Id FROM Group WHERE Type = :QUEUE AND Name = :name LIMIT 1].Id;
    }

    private Set<Id> getQueueMemberIds() {
        Set<Id> result = new Set<Id>();

        try {
            String queueName = this.getQueueName();

            if (String.isBlank(queueName)) {
                throw new CustomException(Label.setup_Chatter_Setting_Message);
            }

            for (GroupMember member : [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :this.getQueueByName(queueName)]) {
                result.add(member.UserOrGroupId);
            }
        } catch (QueryException exc) {
            Trigger.new[0].addError(Label.not_Find_Queue_Message);
        }

        return result;
    }

}