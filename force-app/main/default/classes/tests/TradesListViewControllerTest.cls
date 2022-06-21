@isTest
private class TradesListViewControllerTest {
    private static final String QUEUE_NAME = 'Trade reviewers';

    @isTest
    private static void getTradeListNegative() {
        List<Trade__c> tradeList = TradesListViewController.getTradeList();
        System.assertEquals(tradeList.size(), 0, 'Trade List is not empty');
    }

    @isTest
    private static void getTradeListWithoutQueueNameNegative() {
        try {
            createTrades(5);
            List<Trade__c> tradeList = TradesListViewController.getTradeList();
            System.assertEquals(tradeList.size(), 0, 'Trade List is not empty');
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains('Cannot create Chatter post: Fill in the name of the queue in the custom Chatter Setting'));
        }
    }

    @isTest
    private static void getTradeListWithoutChatterRecipientsNegative() {
        try {
            createChatterSetting();
            createTrades(5);
            List<Trade__c> tradeList = TradesListViewController.getTradeList();
            System.assertEquals(tradeList.size(), 0, 'Trade List is not empty');
        } catch (Exception ex) {
            System.assert(ex.getMessage().contains('Cannot create Chatter post: Empty recipients.'));
        }
    }

    @isTest
    private static void getTradeListPositive() {
        try {
            createChatterSetting();
            Test.startTest();
            assignUserInQueue();
            Test.stopTest();
            createTrades(5);
            List<Trade__c> tradeList = TradesListViewController.getTradeList();
            System.assertEquals(tradeList.size(), 5, 'Trade List is not empty');
        } catch (Exception ex) {
            System.assert(ex.getMessage().length() == 0, 'Unexpected error');
        }
    }

    private static void createChatterSetting() {
        insert new Chatter_Setting__c(Queue_Name__c = QUEUE_NAME);
    }

    @future
    private static void assignUserInQueue() {
        Id queueId = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :QUEUE_NAME LIMIT 1].Id;
        insert new GroupMember(UserOrGroupId = UserInfo.getUserId(), GroupId = queueId);
    }

    private static void createTrades(Integer count) {
        List<Trade__c> tradeList = new List<Trade__c>();

        for (Integer i = 0; i < count; i++) {
            tradeList.add(new Trade__c(
                Sell_Currency__c = 'EUR',
                Sell_Amount__c = i,
                Buy_Currency__c = 'USD',
                Buy_Amount__c = i,
                Rate__c = i,
                Date_Booked__c = Datetime.now()
            ));
        }

        insert tradeList;
    }

}