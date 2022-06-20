import successLabel from '@salesforce/label/c.success';
import warningLabel from '@salesforce/label/c.warning';
import errorLabel from '@salesforce/label/c.error';

export const TOAST_VARIANT = {
    ERROR: 'error',
    WARNING: 'warning',
    SUCCESS: 'success'
};

export const TOAST_TITLE = {
    ERROR: errorLabel,
    WARNING: warningLabel,
    SUCCESS: successLabel
};