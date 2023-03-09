import { LightningElement,wire,track,api } from 'lwc';
import getAccountList from "@salesforce/apex/VendedoresPanelController.getAllAccountsByVendedor";


export default class VendedoresPanel extends LightningElement {
   
  center;

  zoomLevel = 10;
  mapMarkers = [];
  error;
  showMap = false;
  @api disableChildRows; 

  @track gridColumns = [
    {label : 'Nome' , fieldName : 'Name', type: 'text'},
    {label : 'Tipo' , fieldName : 'SalesPersonType', type: 'text', initialWidth: 120},
    {label : 'Qtd. Contas' , fieldName : 'Qty', type: 'number' , initialWidth: 120  }
  ]

  @track gridData;

  connectedCallback(){
      this.initializeVendedorData();
      this.initializeMapData();
  }

  initializeVendedorData() {
    getAccountList()
      .then(result =>{
        const vendedoresList = JSON.parse(JSON.stringify(result));

        console.log('vendedoresList....' + JSON.stringify(vendedoresList));
        for(var i=0; i<vendedoresList.length ; i++){
          var relatedAccount = vendedoresList[i]['Accounts__r'];
          console.log('**Account....' + JSON.stringify(relatedAccount));

          var salesPersonType = vendedoresList[i]['RecordType']['DeveloperName'];
          console.log('SalesPerson...:' + salesPersonType);

          vendedoresList[i]['SalesPersonType'] = salesPersonType;

          vendedoresList[i]['Qty'] = relatedAccount.length ;
          console.log('Qtd Contas: ' + relatedAccount.length);

          if(relatedAccount){
            this.disableChildRows = true;
            vendedoresList[i]._children = relatedAccount;
          }
        }
        
        this.gridData = vendedoresList; 
        
      })
      .catch(error =>{
        console.error(error);
      });
  }  

  initializeMapData() {
    navigator.geolocation.getCurrentPosition(position => {
      this.center = {
          location: {
              Latitude: position.coords.latitude,
              Longitude: position.coords.longitude
          }
      };
  });
  }

  handleRowSelection(event) {
    const selectedRows = event.detail.selectedRows;

    console.log('selectedRows.length....' + selectedRows.length);
    console.log('selectedRows object....' + JSON.stringify(selectedRows));

    if (selectedRows.length === 1){
      let mapMarkers =  [];
      let zoomLevel = 10;

      if(selectedRows[0]['level'] != 1){
        console.log('selectedRows[0]....' + JSON.stringify(selectedRows[0]));
        
          mapMarkers.push({
            location: {
              Street: selectedRows[0]['EnderecoRua__c'],
              City: selectedRows[0]['EnderecoCidade__c'],
              State: selectedRows[0]['EnderecoEstado__c']
            },
  
            title: selectedRows[0]['Name'],
            icon: 'standard:account'
          });

          zoomLevel = 15;

      }
      else{
        var relatedAccounts = selectedRows[0]['Accounts__r'];  

        relatedAccounts.forEach(account => {
          mapMarkers.push({
              location: {
                Street: account.EnderecoRua__c,
                City: account.EnderecoCidade__c,
                State: account.EnderecoEstado__c
              },
    
              title: account.Name,
              icon: 'standard:account'
            });
        });
      }
      this.mapMarkers = mapMarkers;
      this.showMap = true;
      this.zoomLevel = zoomLevel;
    }        
  }
    
}






