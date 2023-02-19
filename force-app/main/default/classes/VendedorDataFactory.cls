public with sharing class VendedorDataFactory {
    public static List<Vendedor__c> criarVendedores(Integer numeroVendedorCriar, String tipoVendedor) {

        List<Vendedor__c> vendedores = new List<Vendedor__c>();

        string recordTypeParaCriar ;
        if(tipoVendedor == 'Interno'){
            recordTypeParaCriar = '012Dn000000Zxc0IAC';
        }else{
             recordTypeParaCriar = '012Dn000000Zxc5IAC';
        } 
        
        for(Integer i=0;i<numeroVendedorCriar;i++){

            Vendedor__c vendedor = new Vendedor__c(Name = 'Test ' + tipoVendedor + ' ' +  i,Email__c = 'pwferreira.info@gmail.com', RecordTypeId = recordTypeParaCriar);
            vendedores.add(vendedor);
        }

        return vendedores;

    }

    
}