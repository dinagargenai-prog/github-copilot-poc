trigger ContentVersionAfterTrigger on ContentVersion (after insert) {
    Set<Id> targetIds = new Set<Id>();
    
    for (ContentVersion cv : Trigger.new) {
        if (cv.FileExtension == 'csv') {
            targetIds.add(cv.Id);
        }
    }
    
    if (!targetIds.isEmpty()) {
        CSVContactImporter.processUploadedCSV(targetIds);
    }
}