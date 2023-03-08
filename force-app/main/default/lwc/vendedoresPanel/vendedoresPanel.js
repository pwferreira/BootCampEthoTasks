import { LightningElement,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccountList from "@salesforce/apex/VendedoresPanelController.getAccountsByVendedor";

export default class VendedoresPanel extends LightningElement {
   
  @track gridColumns = [
    {label : 'Nome' , fieldName : 'Name', type: 'text'},
    {label : 'Tipo' , fieldName : 'SalesPersonType', type: 'text', initialWidth: 120},
    {label : 'Qtd. Contas' , fieldName : 'Qty', type: 'number' , initialWidth: 120  }
  ]

  @track gridData;

  connectedCallback(){
      getAccountList()
      .then(result =>{
        const temp = JSON.parse(JSON.stringify(result));

        console.log('temp....' + JSON.stringify(temp));
        for(var i=0; i<temp.length ; i++){
          var relatedAccount = temp[i]['Accounts__r'];
          console.log('**Account....' + JSON.stringify(relatedAccount));

          var salesPersonType = temp[i]['RecordType']['DeveloperName'];
          console.log('SalesPerson...:' + salesPersonType);

          temp[i]['SalesPersonType'] = salesPersonType;

          temp[i]['Qty'] = relatedAccount.length ;
          console.log('Qtd Contas: ' + relatedAccount.length);

          if(relatedAccount){
            temp[i]._children = relatedAccount;
            delete temp[i].Accounts__r;
          }
        }
       
        this.gridData = temp; 

        console.log('temp final data....' + JSON.stringify(this.gridData));

      })
      .catch(error =>{
        console.error(error);
      })
  }

  handleRowSelection(event) {
    const selectedRows = event.detail.selectedRows;
    if (selectedRows.length === 1) {
        const selectedRowData = selectedRows[0];
        const toastEvent = new ShowToastEvent({
            title: 'Selected Row',
            message: `You selected row` + selectedRowData['Name'],
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);
    }
}

}




