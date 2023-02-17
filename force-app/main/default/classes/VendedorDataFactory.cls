public with sharing class VendedorDataFactory {
    public static List<Vendedor__c> criarVendedoresInternos(Integer numeroVendedorCriar) {

        List<Vendedor__c> vendedores = new List<Vendedor__c>();
        
        for(Integer i=0;i<numeroVendedorCriar;i++){

            Vendedor__c vendedor = new Vendedor__c(Name = 'Test Interno' + i,Email__c = 'pwferreira.info@gmail.com', RecordTypeId = '012Dn000000Zxc0IAC');
            vendedores.add(vendedor);
        }

        return vendedores;

    }

    public static List<Vendedor__c> criarVendedoresExternos(Integer numeroVendedorCriar) {

        List<Vendedor__c> vendedores = new List<Vendedor__c>();
        
        for(Integer i=0;i<numeroVendedorCriar;i++){

            Vendedor__c vendedor = new Vendedor__c(Name = 'Test Externo' + i,Email__c = 'pwferreira.info@gmail.com', RecordTypeId = '012Dn000000Zxc5IAC');
            vendedores.add(vendedor);
        }

        return vendedores;

    }
}