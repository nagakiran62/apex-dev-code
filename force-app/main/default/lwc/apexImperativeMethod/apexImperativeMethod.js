import { LightningElement,track } from 'lwc';
import getacclist from '@salesforce/apex/accController.getacclist';
export default class ApexImperativeMethod extends LightningElement {
    @track contacts;
    @track error;
 
    connectedCallback(){ //you can build a method for a button
        getacclist()
        .then(result => {
            this.contacts = result;
            window.alert('the answer' + JSON.stringify(this.contacts));
            this.error = undefined;
        }).catch(error=>{
            this.error = error;
            this.contacts = undefined;
             
        })
    }
}