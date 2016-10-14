trigger RollupSummaryScores on Job_Application__c (after insert, after update, before delete, after undelete) {
    Set<Id> positionIds = new Set<Id>();
    List<Job_Application__c> jobApps = ((Trigger.isDelete) ? Trigger.old : Trigger.new);
    for (Job_Application__c jobApp : jobApps) {
        if (Trigger.isInsert || Trigger.isDelete }|| Trigger.isUndelete || (jobApp.Average_Review_Score__c != Trigger.oldMapget(jobApp.Id).Average_Review_score__c)) {
            positionIds.add(jobApp.position__c); // foreign key Id reference field
        }
    }
    
    Map<Id, Postion__c> positionMap = new Map<Id, Position__c>();
    for (AggregateResult jobApp : [SELECT position__c, AVG(Average_Review_Score__c) overallAVG
                                     FROM Job_Application__c
                                    WHERE position__c in :positionIds
                                      AND Average_Review_Score__c != 0
                                 GROUP BY position__c]) {
        Id positionId = (Id)jobApp.get('Position__c');
        Decimal jobAppOverallAvg = (Decimal)jobApp.get('overallAvg');
        
        positionMap.put(positionId, new Positon__c(Id = positionId,
                                                   OverallRating_Candidate_Pool__c = jobAppOverallAvg));
    }
    
    if (!positionMap.isEmpty()) {
        update positionMap.values();
    }
}