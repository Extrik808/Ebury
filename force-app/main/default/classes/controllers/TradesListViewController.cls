public with sharing class TradesListViewController {

    @AuraEnabled(cacheable=true)
    public static List<Trade__c> getTradeList() {
        return [
            SELECT Id, Sell_Currency__c, Sell_Amount__c, Buy_Currency__c,
                Buy_Amount__c, Rate__c, Date_Booked__c
            FROM Trade__c
            ORDER BY Date_Booked__c DESC
        ];
    }

}