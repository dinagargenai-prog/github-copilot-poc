public with sharing class AccountTriggerHandler {

    public void onAfterInsert(List<Account> listAccounts) {
        triggerS3FolderCreation(listAccounts);
    }

    public void onAfterUpdate(
        List<Account> listAccounts,
        Map<Id, Account> mapOldAccounts
    ) {
        triggerS3FolderCreation(listAccounts);
    }

    private void triggerS3FolderCreation(List<Account> listAccounts) {
        Set<Id> setAccountIds = new Set<Id>();

        for (Account accountRecord : listAccounts) {
            if (accountRecord == null || accountRecord.Id == null) {
                continue;
            }

            Boolean shouldProcess =
                String.isBlank(accountRecord.S3_Folder_Id__c);

            if (shouldProcess) {
                setAccountIds.add(accountRecord.Id);
            }
        }

        AccountS3FolderService.enqueueForProcessing(setAccountIds);
    }
}
