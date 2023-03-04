public with sharing class Utilities {

    public static Map<Integer,List<SObject>> splitList(List<SObject> listToSplit,Integer splitSize){
        
        Map<Integer,List<SObject>> mapToReturn = new Map<Integer,List<SObject>>();
        Integer currentMapIndex = 0;
        
        if(listToSplit.size() < splitSize){
            mapToReturn.put(currentMapIndex, listToSplit);
            return mapToReturn;
        }
        
        List<SObject> listToAddInMap =  new List<SObject>();
        
        for(SObject obj : listToSplit){
            
            if(listToAddInMap.size() == 50){
                mapToReturn.put(currentMapIndex, listToAddInMap);
                listToAddInMap.clear();
                currentMapIndex++;
            }
            
            listToAddInMap.add(obj);
            
        }
        
        if(listToAddInMap.size() > 0){
            mapToReturn.put(currentMapIndex, listToAddInMap);
        }

        return mapToReturn;
        
    }
   
}