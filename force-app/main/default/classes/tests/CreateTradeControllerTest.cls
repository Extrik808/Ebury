@isTest
private class CreateTradeControllerTest {

    @isTest
    private static void getLatestRateWithoutParamsNegative() {
        try {
            String result = CreateTradeController.getLatestRate(null, null);
            System.assert(String.isBlank(result), 'Rate is not blank');
        } catch (AuraHandledException ex) {
            System.assertEquals('Attempt to send bad parameters to Fixer.io.', ex.getMessage());
        }
    }

    @isTest
    private static void getLatestRateWithoutFixerIOSettingNegative() {
        try {
            String result = CreateTradeController.getLatestRate('USD', 'EUR');
            System.assert(String.isBlank(result), 'Rate is not blank');
        } catch (AuraHandledException ex) {
            System.assertEquals('Set up a custom Fixer IO setting.', ex.getMessage());
        }
    }

    @isTest
    private static void getLatestRateNegative() {
        try {
            createFixerIOSetting();
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FixerIOMockNegative());
            String result = CreateTradeController.getLatestRate('USD', 'EUR');
            System.assert(String.isBlank(result), 'Rate is not blank');
            Test.stopTest();
        } catch (AuraHandledException ex) {
            System.assertEquals(Label.fixer_Error_Message, ex.getMessage());
        }
    }

    @isTest
    private static void getLatestRatePositive() {
        try {
            createFixerIOSetting();
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FixerIOMockPositive());
            String result = CreateTradeController.getLatestRate('USD', 'EUR');
            System.assertEquals('0.813399', result);
            Test.stopTest();
        } catch (AuraHandledException ex) {
            System.assert(ex.getMessage().length() == 0, 'Unexpected error');
        }
    }

    public class FixerIOMockPositive implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"success": true, "timestamp": 1519296206, "base": "USD","date": "2022-06-21","rates": {"EUR": 0.813399}}');
            return res;
        }
    }

    private static void createFixerIOSetting() {
        insert new FixerIO__c(Endpoint__c = 'https://test.com', Token__c = '123');
    }

    public class FixerIOMockNegative implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setStatusCode(503);
            res.setBody('');
            return res;
        }
    }

}