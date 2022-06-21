public with sharing class ChatterService {

    @testVisible
    private List<ConnectApi.BatchInput> inputs;

    public ChatterService() {
        inputs = new List<ConnectApi.BatchInput>();
    }

    public void createPost(Set<Id> recipients, String message, Id subjectId) {
        if (recipients.isEmpty()) {
            throw new CustomException('Empty recipients.');
        }

        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = this.getChatterBody(recipients, message);
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = subjectId;
        ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
        this.inputs.add(batchInput);
    }

    public void send() {
        if (!Test.isRunningTest()) {
            List<ConnectApi.BatchResult> results = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), this.inputs);
            for (ConnectApi.BatchResult batchResult : results) {
                if (!batchResult.isSuccess()) {
                    throw new CustomException(batchResult.getErrorMessage());
                }
            }
        }
    }

    private ConnectApi.MessageBodyInput getChatterBody(Set<Id> recipients, String message) {
        ConnectApi.MessageBodyInput messageBody = new ConnectApi.MessageBodyInput();
        messageBody.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = message;
        messageBody.messageSegments.add(textSegment);
        messageBody.messageSegments.addAll(this.getMentionSegments(recipients));

        return messageBody;
    }

    private List<ConnectApi.MentionSegmentInput> getMentionSegments(Set<Id> recipients) {
        List<ConnectApi.MentionSegmentInput> mentions = new List<ConnectApi.MentionSegmentInput>();

        for (Id userId : recipients) {
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            mentionSegmentInput.Id = userId;
            mentions.add(mentionSegmentInput);
        }

        return mentions;
    }

}