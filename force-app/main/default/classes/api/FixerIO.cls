public with sharing class FixerIO {

    private FixerIO__c fixerSetting;
    private static final String path = '/fixer/latest?symbols={0}&base={1}';
    private static final String HTTP_METHOD_GET = 'GET';

    public FixerIO() {
        fixerSetting = FixerIO__c.getOrgDefaults();
    }

    public String getLatestRate(String fromCurrency, String toCurrency) {
        if (String.isBlank(fixerSetting.Endpoint__c) || String.isBlank(fixerSetting.Token__c)) {
            throw new CustomException(Label.fixer_Setting_Blank_Message);
        }

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(this.callToFixerIO(fromCurrency, toCurrency));

        return ((Map<String, String>) JSON.deserialize(JSON.serialize(result.get('rates')), Map<String, String>.class)).get(toCurrency);
    }

    private String callToFixerIO(String fromCurrency, String toCurrency) {
        String url = fixerSetting.Endpoint__c + String.format(path, new List<String>{ toCurrency, fromCurrency });
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod(HTTP_METHOD_GET);
        request.setHeader('apikey', fixerSetting.Token__c);

        HttpResponse response = (new Http()).send(request);

        if (response.getStatusCode() != 200) {
            throw new CustomException(Label.fixer_Error_Message);
        }

        return response.getBody();
    }

}