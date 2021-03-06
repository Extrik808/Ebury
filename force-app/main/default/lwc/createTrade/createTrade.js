import {api, LightningElement} from 'lwc';
import getLatestRate from '@salesforce/apex/CreateTradeController.getLatestRate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { TOAST_VARIANT, TOAST_TITLE } from 'c/constants'

import newTradeLabel from '@salesforce/label/c.new_Trade';
import createLabel from '@salesforce/label/c.create';
import cancelLabel from '@salesforce/label/c.cancel';
import rateLabel from '@salesforce/label/c.rate';
import buyAmountLabel from '@salesforce/label/c.buy_Amount';
import sellAmountLabel from '@salesforce/label/c.sell_Amount';
import lowNumberMessageLabel from '@salesforce/label/c.low_Number_Message';

const LABELS = {
    newTradeLabel: newTradeLabel,
    createLabel: createLabel,
    cancelLabel: cancelLabel,
    rateLabel: rateLabel,
    buyAmountLabel: buyAmountLabel,
    sellAmountLabel: sellAmountLabel,
    lowNumberMessageLabel: lowNumberMessageLabel
}

export default class CreateTrade extends LightningElement {

    LABELS = LABELS;
    rate = 'X';
    dateBooked;
    buyAmount = 0;
    showSpinner = true;
    _showModal = false;

    @api
    showModal() {
        this._showModal = true;
    }

    @api
    hideModal() {
        this._showModal = false;
    }


    get disabled() {
        let sellCurrency = this.template.querySelector('[data-id="sellCurrency"]');
        let buyCurrency = this.template.querySelector('[data-id="buyCurrency"]');
        let sellAmount = this.template.querySelector('[data-id="sellAmount"]');

        return !(sellCurrency?.value && buyCurrency?.value && sellAmount?.value);
    }
    handleClick(e) {
        const actionName = e.currentTarget.dataset.action;

        switch (actionName) {
            case 'open':
                this.showModalWindow();
                break;
            case 'cancel':
                this.hideModalWindow();
                break;
            case 'create':
                this.createTrade(e);
                break;
        }
    }

    handleChange(e) {
        const actionName = e.currentTarget.dataset.action;

        switch (actionName) {
            case 'getRate':
                this.getRate();
                break;
            case 'updateSellAmount':
                this.setValidity(e);
                this.calculateBuyAmount();
                break;
        }
    }

    handleBlur(e) {
        e.currentTarget.reportValidity();
    }

    showModalWindow() {
        this.showModal();
    }

    hideModalWindow() {
        this.hideModal();
        this.reset();
    }

    async getRate() {
        let sellCurrency = this.template.querySelector('[data-id="sellCurrency"]').value;
        let buyCurrency = this.template.querySelector('[data-id="buyCurrency"]').value;

        if (sellCurrency && buyCurrency) {
            this.showSpinner = true;

            try {
                this.rate = Number(await getLatestRate({
                    fromCurrency: sellCurrency,
                    toCurrency: buyCurrency
                })).toFixed(4);
                this.dateBooked = Date.now();
                this.calculateBuyAmount();
            } catch (error) {
                this.showNotification(TOAST_TITLE.ERROR, error.body.message, TOAST_VARIANT.ERROR);
            } finally {
                this.showSpinner = false;
            }
        }
    }

    setValidity(e) {
        const currentTarget = e.currentTarget;

        if (currentTarget.value === '-0') {
            currentTarget.setCustomValidity(this.LABELS.lowNumberMessageLabel);
        } else {
            currentTarget.setCustomValidity('');
        }

        currentTarget.reportValidity();
    }

    calculateBuyAmount() {
        let sellCurrency = this.template.querySelector('[data-id="sellCurrency"]').value;
        let buyCurrency = this.template.querySelector('[data-id="buyCurrency"]').value;
        let sellAmount = this.template.querySelector('[data-id="sellAmount"]').value;

        if (sellCurrency && buyCurrency && sellAmount && this.rate !== 'X') {
            this.buyAmount = Number(sellAmount * this.rate).toFixed(2);
        }
    }

    createTrade(e) {
        e.preventDefault();
        let sellAmount = this.template.querySelector('[data-id="sellAmount"]');
        if (!sellAmount.value || !sellAmount.checkValidity()) return;

        this.showSpinner = true;
        const fields = e.detail.fields;
        fields.Rate__c = this.rate === 'X' ? 0 : this.rate;
        fields.Date_Booked__c = this.dateBooked ? new Date(this.dateBooked).toISOString() : null;
        fields.Sell_Amount__c = sellAmount.value ? sellAmount.value : 0;
        fields.Buy_Amount__c = this.buyAmount ? this.buyAmount : 0;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess() {
        this.showSpinner = false;
        this.dispatchEvent(new CustomEvent('success', { composed: true }));
        this.hideModalWindow();
        this.showNotification(TOAST_TITLE.SUCCESS, 'The record was created', TOAST_VARIANT.SUCCESS);
    }

    handleError(event) {
        this.showSpinner = false;
        this.showNotification(TOAST_TITLE.ERROR, event.detail.detail, TOAST_VARIANT.ERROR);
    }

    reset() {
        this.rate = 'X';
        this.showSpinner = true;
        this.buyAmount = 0;
    }

    handleOnload() {
        this.showSpinner = false;
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}