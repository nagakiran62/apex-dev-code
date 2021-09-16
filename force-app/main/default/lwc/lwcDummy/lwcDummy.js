import { LightningElement,track } from 'lwc';

export default class LwcDummy extends LightningElement {

    @track king= 'Nagaaa';

    handlechange(event){
        this.king= event.target.value;
    }
