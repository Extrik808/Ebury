@isTest
private class ChatterServiceTest {

    @isTest
    private static void createPostPositive() {
        Set<Id> recipients = new Set<Id>{ UserInfo.getUserId() };
        String message = 'message';

        ChatterService chatterService;
        Test.startTest();
        chatterService = new ChatterService();
        chatterService.createPost(recipients, message, UserInfo.getUserId());
        Test.stopTest();

        System.assertEquals(1, chatterService.inputs.size(), 'Chatter not contain posts');
    }

    @isTest
    private static void createPostWithoutRecipientsNegative() {
        Set<Id> recipients = new Set<Id>();
        String message = 'message';

        try {
            ChatterService chatterService;
            Test.startTest();
            chatterService = new ChatterService();
            chatterService.createPost(recipients, message, UserInfo.getUserId());
            Test.stopTest();
            System.assertEquals(0, chatterService.inputs.size(), 'Chatter contain posts');
        } catch (Exception ex) {
            System.assertEquals('Empty recipients.', ex.getMessage());
        }
    }
}