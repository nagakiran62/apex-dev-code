import { LightningElement,track } from 'lwc';

export default class SimpleAdd extends LightningElement {
      @track number1;
      @track number2;
      @track total;
    handlechange(event){
        alert('add');
        this.total == `${number1 + number2}`;
    }
}