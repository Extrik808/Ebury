import { LightningElement, api } from 'lwc';

export default class ModalWindow extends LightningElement {

    _showModal = false;

    @api hideCloseButton;
    @api hideFooter;

    @api
    showModal() {
        this._showModal = true;
    }

    @api
    hideModal() {
        this._showModal = false;
    }

}