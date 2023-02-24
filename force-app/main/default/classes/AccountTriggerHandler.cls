public without sharing class AccountTriggerHandler {
    
    public static void isBeforeInsert(Account [] newAccounts, Map<Id,Account> newAccountsMap,Map<Id,Account> oldAccountsMap ){
        
        setVendedor(newAccounts);
    }
    
    public static void isAfterInsert(Account [] newAccounts, Map<Id,Account> newAccountsMap,Map<Id,Account> oldAccountsMap ){
        updateAddress(newAccounts);
    }
    
    //public static void isBeforeUpdate(Account [] newAccounts, Map<Id,Account> newAccountsMap,Map<Id,Account> oldAccountsMap ){
    //}
    
    public static void isAfterUpdate(Account [] newAccounts, Map<Id,Account> newAccountsMap,Map<Id,Account> oldAccountsMap ){
        updateAddress(newAccounts);
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
                    
                    Integer quantidade = mapVendedoresQuantidades.get(tipoRegistro).get(vendedor);
                    quantidade++;
                    
                    Map<Id,Integer> putNewMap = new Map<Id,Integer>();
                    putNewMap.put(vendedor,quantidade);
                    mapVendedoresQuantidades.put(tipoRegistro,putNewMap);
                }
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

    public static void updateAddress(Account[] newAccounts){

        String updateVia = getConfig();

        if(String.isBlank(updateVia)){
            return;
        }

        List<Account> accountsToUpdate = new List<Account>();

        for(Account newAccount : [SELECT ID,EnderecoCompletoSemNumero__c,CEP__c FROM Account WHERE Id IN : newAccounts WITH SECURITY_ENFORCED]){

            if((newAccount.EnderecoCompletoSemNumero__c == null) && (newAccount.CEP__c != null)){
                accountsToUpdate.add(newAccount);
            }
        }

        if(accountsToUpdate.size() == 0){
            return;
        }

        if(updateVia == 'BuscaCepViaTrigger__c'){
            updateAddressQueueAble(accountsToUpdate);
        }
        else{
            updateAdressSchedulable(accountsToUpdate);
        }

    }

    //Schedulable
    public static void updateAdressSchedulable(Account[] newAccounts){
        try {

            Map<Integer,List<Account>> scheduleList = splitList(newAccounts, 100);
            
            for(Integer currentSchedule : scheduleList.keySet()){
                

                UpdateAccountAddressSchedulable accountAddresScheduleable = new UpdateAccountAddressSchedulable(scheduleList.get(currentSchedule));
                
                //Seconds Minutes Hours Day_of_month Month Day_of_week Optional_year
                String sch = '0 0 0 25 2 ? 2023';
                
                ID jobId = System.schedule('Update Account Address', sch, accountAddresScheduleable);
            }
            
        } catch (Exception exc) {
            System.debug('Ocorreu um erro ao atualizar endereço' + exc.getMessage() + exc.getStackTraceString());
        }
    }
    
    //QueueAble
    public static void updateAddressQueueAble(Account[] newAccounts){
        try{
            
            Map<Integer,List<Account>> queueList = splitList(newAccounts, 50);
            
            for(Integer currentQueue : queueList.keySet()){
                
                ID jobId = System.enqueueJob(new UpdateAccountAddressQueueable(queueList.get(currentQueue)));
            }
            
        } catch (Exception exc) {
            System.debug('Ocorreu um erro ao atualizar endereço' + exc.getMessage() + exc.getStackTraceString());
        }
    }
    
    public static Map<Integer,List<Account>> splitList(List<Account> listToSplit,Integer splitSize){
        
        Map<Integer,List<Account>> mapToReturn = new Map<Integer,List<Account>>();
        Integer currentMapIndex = 0;
        
        if(listToSplit.size() < splitSize){
            mapToReturn.put(currentMapIndex, listToSplit);
            return mapToReturn;
        }
        
        List<Account> listToAddInMap =  new List<Account>();
        
        
        for(Account account : listToSplit){
            
            if(listToAddInMap.size() == 50){
                mapToReturn.put(currentMapIndex, listToAddInMap);
                listToAddInMap.clear();
                currentMapIndex++;
            }
            
            listToAddInMap.add(account);
            
        }
        
        if(listToAddInMap.size() > 0){
            mapToReturn.put(currentMapIndex, listToAddInMap);
        }
        
        
        return mapToReturn;
        
    }

    public static String getConfig(){

        String result;

        AccountGetAddressConfig__mdt[] mcs = [SELECT QualifiedApiName, BuscaCepViaTrigger__c,   BuscaCepViaScheduledApex__c
                                              FROM AccountGetAddressConfig__mdt     
                                              WHERE TestConfig__c = :GetAddressConfigTest.testConfig WITH SECURITY_ENFORCED];
        
        if(mcs.size() > 0){
            result = mcs[0].BuscaCepViaTrigger__c ? 'BuscaCepViaTrigger__c' : (mcs[0].BuscaCepViaScheduledApex__c ? 'BuscaCepViaScheduledApex__c' : '');
        }

        return result;

    }
    
    
}