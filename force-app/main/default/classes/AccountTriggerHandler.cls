public without sharing class AccountTriggerHandler {
    
    public static void isBeforeInsert(Account [] newAccounts, Map<Id,Account> newAccountsMap,Map<Id,Account> oldAccountsMap ){
        
        setVendedor(newAccounts);
    }
    
    public static void setVendedor(Account [] newAccounts){
        try{
            
            List<Account> contasParaAtualizar = new List<Account>();
            
            			           
            for(Account account : newAccounts){
                
                switch on (account.QualificacaoCliente__c){
                    when 'Ouro' {
                        
                    }
                    when 'Prata'{
                        
                    }
                    when 'Bronze'{
                        
                    }
                    when else{
                        
                    }
                    
                }
                
                
            }
        }catch(Exception e)
        {
            System.debug('Ocorreu um erro ao definir vendedor' + e.getMessage());
        }
    }
    
    public static Map<Id,Integer> getVendedor(String recordType){
        
        Map<Id,Integer> mapVendedores = new Map<Id,Integer>();
        
       
        return mapVendedores;
        
    }
    
    
}