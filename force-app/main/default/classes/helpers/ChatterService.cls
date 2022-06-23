public with sharing class ChatterService {

    // Used ConnectApi because FeedItem not supported mention

    @testVisible
    private List<ConnectApi.BatchInput> batchInputs;

    public ChatterService() {
        batchInputs = new List<ConnectApi.BatchInput>();
    }

    public void createPost(Set<Id> recipients, String message, Id subjectId) {
        if (recipients.isEmpty()) {
            throw new CustomException(Label.empty_Recipients);
        }

        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = this.generateBody(recipients, message);
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = subjectId;
        this.batchInputs.add(new ConnectApi.BatchInput(feedItemInput));
    }

    public void sendPost() {
        if (!Test.isRunningTest()) {
            ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), this.batchInputs);
        }
    }

    public String generatePostMessage(Trade__c trade) {
        List<String> params = new List<String>{
                trade.Sell_Currency__c,
                String.valueOf(trade.Sell_Amount__c),
                trade.Buy_Currency__c,
                String.valueOf(trade.Buy_Amount__c),
                String.valueOf(trade.Rate__c),
                trade.Date_Booked__c != null ? trade.Date_Booked__c.format() : null,
                URL.getSalesforceBaseUrl().toExternalForm() + '/' + trade.Id + '\n'
        };

        return String.format(Label.chatter_Notification_Message, params);
    }

    private ConnectApi.MessageBodyInput generateBody(Set<Id> recipients, String message) {
        ConnectApi.MessageBodyInput messageBody = new ConnectApi.MessageBodyInput();
        messageBody.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = message;
        messageBody.messageSegments.add(textSegment);

        for (Id userId : recipients) {
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            mentionSegmentInput.Id = userId;
            messageBody.messageSegments.add(mentionSegmentInput);
        }

        return messageBody;
    }

}