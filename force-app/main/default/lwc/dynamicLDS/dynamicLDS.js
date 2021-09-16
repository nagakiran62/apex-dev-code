import { LightningElement,api} from 'lwc';

export default class DynamicLDS extends LightningElement {

    @api recordId;
    @api objectApiName;
    fields =['AccountId', 'Name'];
}