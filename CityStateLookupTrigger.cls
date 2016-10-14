trigger CityStateLookup on Lead (before insert, before update) {

    Set<String> zipCodes = new Set<String>();
    for (Lead lead : Trigger.new) {
        if (lead.PostalCode != null) {
            if (Trigger.isInsert || lead.PostalCode != Trigger.oldMap.get(lead.id).PostalCode) {
                zipCodes.add(lead.PostalCode);
            }
        }
    }

    if (!zipCodes.isEmpty()) {
       Map<String, Zip_Code__c> cacheMap = new Map<String, Zip_Code__c>();
       for (Zip_Code__c zipCode : [SELECT Id, Name, City__c, State__c FROM Zip_Code__c WHERE Name in :zipCodes]) {
            if (zipCode != null) {
                cacheMap.put(zipCode.Name, zipCode);
            }
       }
    }

    for (Lead lead : Trigger.new) {
        Zip_Code__c zipCode = cacheMap.get(lead.PostalCode);
        if (zipCode != null) {
            lead.City = zipCode.City;
            lead.State = zipCode.State;
        }
    }
}