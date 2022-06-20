import { LightningElement, wire } from 'lwc';
import getTradeList from '@salesforce/apex/TradesListViewController.getTradeList';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import columns from './tradesListColumns'
import { TOAST_VARIANT, TOAST_TITLE } from 'c/constants'

export default class TradesListView extends LightningElement {

    columns = columns;
    wiredResult;
    tradesData;
    showSpinner = true;

    @wire(getTradeList)
    wiredTrades(result) {
        this.wiredResult = result;

        if (result.data) {
            this.tradesData = result.data;
            this.showSpinner = false;
        } else if (result.error) {
            this.showToast(TOAST_TITLE.ERROR, result.error, TOAST_VARIANT.ERROR);
            this.tradesData = [];
            this.showSpinner = false;
        }
    }

    connectedCallback() {
        window.addEventListener('success', this.updateListView.bind(this))
    }

    updateListView() {
        refreshApex(this.wiredResult);
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        }));
    }

}