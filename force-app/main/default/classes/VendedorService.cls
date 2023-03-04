public with sharing class VendedorService {
  
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