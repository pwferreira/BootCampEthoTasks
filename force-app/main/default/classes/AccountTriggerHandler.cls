public without sharing class AccountTriggerHandler {
    
    public static void isAfterInsert(Account [] newAccounts, Map<Id,Account> newAccountsMap,Map<Id,Account> oldAccountsMap ){
        
        setVendedor(newAccounts);
    }

    public static Set<String> setRecordTypes(Account [] newAccounts){
        
        Set<String> recordTypeVendedor = new Set<String>();

        for(Account newAcccount : newAccounts){
            
            if(newAcccount.QualificacaoCliente__c == 'Ouro' ){
                recordTypeVendedor.add('Interno');
            }

            if(newAcccount.QualificacaoCliente__c == 'Prata' ){
                recordTypeVendedor.add('Todos');
            }

            if(newAcccount.QualificacaoCliente__c == 'Bronze' ){
                recordTypeVendedor.add('Externo');
            }

            

        }
        return recordTypeVendedor;

    }
    
    public static void setVendedor(Account [] newAccounts){
        try{
            
            List<Account> accountsToUpdate = new List<Account>();
            
            Set<String> recordTypeVendedor = setRecordTypes(newAccounts);
            
            Map<String,Map<Id,Integer>> mapVendedoresQuantidades = new Map<String,Map<Id,Integer>>();

            if(recordTypeVendedor.contains('Interno')){
                
                Map<Id,Integer> vendedoresInternos = getVendedor('Interno');
                mapVendedoresQuantidades.put('Interno',vendedoresInternos);

            }

            if(recordTypeVendedor.contains('Externo')){
                
                Map<Id,Integer> vendedoresExternos = getVendedor('Externo');
                mapVendedoresQuantidades.put('Externo',vendedoresExternos);

            }

            if(recordTypeVendedor.contains('Todos')){
                
                Map<Id,Integer> todosVendedores = getVendedor('Todos');
                mapVendedoresQuantidades.put('Todos',todosVendedores);

            }

            for(String tipoRegistro : mapVendedoresQuantidades.keySet()){
                for(Account newAccount : newAccounts){
                
                    Id vendedor = getVendedorComMenosConta(mapVendedoresQuantidades.get(tipoRegistro));

                    newAccount.Vendedor__c = string.valueOf(vendedor);
                    
                    if(newAccount.Vendedor__c != null){
                        accountsToUpdate.add(newAccount);
                    }

                    Integer quantidade = mapVendedoresQuantidades.get(tipoRegistro).get(vendedor);
                    quantidade++;

                    Map<Id,Integer> putNewMap = new Map<Id,Integer>();
                    putNewMap.put(vendedor,quantidade);
                    mapVendedoresQuantidades.put(tipoRegistro,putNewMap);
                }
            }


            // Make sure we can update the database before even trying
            if (Schema.sObjectType.Account.fields.Vendedor__c.isUpdateable()) {
                update accountsToUpdate;
            }


        }
        catch(Exception e)
        {
            System.debug('Ocorreu um erro ao definir vendedor' + e.getMessage());
        }
    }
    
    public static Map<Id,Integer> getVendedor(String recordType){
        
       
        Map<Id,Integer> mapVendedor = new  Map<Id,Integer>();

        List<Vendedor__c> vendedores = new  List<Vendedor__c>();

        if(recordType == 'Todos'){
            vendedores =  [SELECT Id, (SELECT Id FROM Accounts__r) FROM Vendedor__c WITH SECURITY_ENFORCED];
        }
        else{
            vendedores =  [SELECT Id, (SELECT Id FROM Accounts__r) FROM Vendedor__c WHERE RecordType.DeveloperName = :recordType WITH SECURITY_ENFORCED];
        }

         
        
        for(Vendedor__c vendedor : vendedores){           
            mapVendedor.put(vendedor.Id,vendedor.Accounts__r.size());
        }
        
        return mapVendedor;
        
    }

    public static Id getVendedorComMenosConta(Map<Id,Integer> vendedores){

        Id vendedorComMenosConta ;

        Integer menorQuantidadeAtual =  0;
        for(Id vendedor : vendedores.keySet()){

            if((vendedores.get(vendedor) < menorQuantidadeAtual) || (vendedorComMenosConta == null)){
                menorQuantidadeAtual = vendedores.get(vendedor);
                vendedorComMenosConta = string.valueOf(vendedor);
            }

        }
	
        return vendedorComMenosConta;

    }
    
    
}