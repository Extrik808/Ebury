public with sharing class CreateTradeController {

    @AuraEnabled
    public static String getLatestRate(String fromCurrency, String toCurrency) {
        try {
            return new FixerIO().getLatestRate(fromCurrency, toCurrency);
        } catch (CustomException ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

}