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

        System.assertEquals(1, chatterService.batchInputs.size(), 'Number of posts is 0');
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
            System.assertEquals(0, chatterService.batchInputs.size(), 'Number of posts is 0');
        } catch (Exception ex) {
            System.assertEquals(Label.empty_Recipients, ex.getMessage());
        }
    }
}