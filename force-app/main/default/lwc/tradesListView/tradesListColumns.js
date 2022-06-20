import sellCCYLabel from '@salesforce/label/c.sell_CCY';
import sellAmountLabel from '@salesforce/label/c.sell_Amount';
import buyCCYLabel from '@salesforce/label/c.buy_CCY';
import buyAmountLabel from '@salesforce/label/c.buy_Amount';
import rateLabel from '@salesforce/label/c.rate';
import dateBookedLabel from '@salesforce/label/c.date_Booked';

export default [
    {
        label: sellCCYLabel,
        fieldName: 'Sell_Currency__c',
        type: 'text',
        sortable: false
    },
    {
        label: sellAmountLabel,
        fieldName: 'Sell_Amount__c',
        type: 'Currency',
        sortable: false
    },
    {
        label: buyCCYLabel,
        fieldName: 'Buy_Currency__c',
        type: 'Currency',
        sortable: false
    },
    {
        label: buyAmountLabel,
        fieldName: 'Buy_Amount__c',
        type: 'Currency',
        sortable: false
    },
    {
        label: rateLabel,
        fieldName: 'Rate__c',
        type: 'number',
        sortable: false
    },
    {
        label: dateBookedLabel,
        fieldName: 'Date_Booked__c',
        type: 'date',
        sortable: false,
        typeAttributes: {
            day: 'numeric',
            month: 'numeric',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
        },
    }
]