public with sharing class ChatterService {

    @testVisible
    private List<ConnectApi.BatchInput> batchInputs;

    public ChatterService() {
        batchInputs = new List<ConnectApi.BatchInput>();
    }

    public void createPost(Set<Id> recipients, String message, Id subjectId) {
        if (recipients.isEmpty()) {
            throw new CustomException('Empty recipients.');
        }

        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = this.generateBody(recipients, message);
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = subjectId;
        this.batchInputs.add(new ConnectApi.BatchInput(feedItemInput));
    }

    public void sendPost() {
        ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), this.batchInputs);
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