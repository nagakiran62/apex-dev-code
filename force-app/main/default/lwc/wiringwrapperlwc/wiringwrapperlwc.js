import { LightningElement,wire } from 'lwc';
import displayacccontact from '@salesforce/apex/accountcontact.displayacccontact';


export default class Wiringwrapperlwc extends LightningElement {
    @wire(displayacccontact) wrappers;


}