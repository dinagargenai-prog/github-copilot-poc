public with sharing class AccountS3FolderService {

    private static final String ACCOUNT_ID_FIELD = 'accountId';
    private static final Integer SUCCESS_STATUS_CODE_MIN = 200;
    private static final Integer SUCCESS_STATUS_CODE_MAX = 299;

    public static void enqueueForProcessing(Set<Id> setAccountIds) {
        if (setAccountIds == null || setAccountIds.isEmpty()) {
            System.debug(LoggingLevel.INFO, 'AccountS3FolderService.enqueueForProcessing called with null/empty setAccountIds.');
            return;
        }

        System.debug(LoggingLevel.INFO, 'AccountS3FolderService.enqueueForProcessing called for account IDs: ' + setAccountIds);
        List<Id> listAccountIds = new List<Id>(setAccountIds);
        createFolderAsync(listAccountIds);
    }

    @Future(callout=true)
    public static void createFolderAsync(List<Id> listAccountIds) {
        if (listAccountIds == null || listAccountIds.isEmpty()) {
            System.debug(LoggingLevel.INFO, 'AccountS3FolderService.createFolderAsync called with null/empty listAccountIds.');
            return;
        }

        Set<Id> uniqueAccountIds = new Set<Id>(listAccountIds);
        Map<Id, Account> mapAccountsById = new Map<Id, Account>(
            [
                SELECT Id, S3_Folder_Id__c
                FROM Account
                WHERE Id IN :uniqueAccountIds
            ]
        );

        List<Account> listAccountsToUpdate = new List<Account>();

        for (Id accountId : uniqueAccountIds) {
            Account accountRecord = mapAccountsById.get(accountId);

            if (accountRecord == null) {
                continue;
            }

            try {
                HttpResponse response = makeRequest(accountId);
                Integer statusCode = (response == null) ? -1 : response.getStatusCode();
                String responseBody = (response == null) ? null : response.getBody();

                System.debug(
                    LoggingLevel.INFO,
                    'AWS S3 Folder Creation Status: ' + statusCode +
                    ' Response: ' + responseBody
                );

                if (statusCode >= SUCCESS_STATUS_CODE_MIN && statusCode <= SUCCESS_STATUS_CODE_MAX) {
                    String folderId = parseFolderId(responseBody, accountId);

                    if (String.isNotBlank(folderId)) {
                        if (folderId != accountRecord.S3_Folder_Id__c) {
                            accountRecord.S3_Folder_Id__c = folderId;
                            listAccountsToUpdate.add(accountRecord);
                        }
                    } else {
                        System.debug(
                            LoggingLevel.WARN,
                            'No valid S3 folder ID returned for Account: ' + accountId +
                            '. Response body: ' + responseBody
                        );
                    }
                } else {
                    System.debug(
                        LoggingLevel.WARN,
                        'AWS S3 folder creation failed for Account: ' + accountId +
                        '. Status code: ' + statusCode +
                        '. Response body: ' + responseBody
                    );
                }
            } catch (Exception ex) {
                System.debug(
                    LoggingLevel.ERROR,
                    'Error creating AWS S3 folder for Account: ' + accountId +
                    '. Message: ' + ex.getMessage() +
                    '. Stack Trace: ' + ex.getStackTraceString()
                );
            }
        }

        if (!listAccountsToUpdate.isEmpty()) {
            update listAccountsToUpdate;
        }
    }

    private static HttpResponse makeRequest(Id accountId) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(
            'callout:AWS_S3_Folder_API/create-folder'
        );
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(120000);
        request.setBody(
            JSON.serialize(
                new Map<String, String>{
                    ACCOUNT_ID_FIELD => String.valueOf(accountId)
                }
            )
        );

        Http httpClient = new Http();
        return httpClient.send(request);
    }

    private static String parseFolderId(String responseBody, Id accountId) {
        if (String.isBlank(responseBody)) {
            return null;
        }

        try {
            Map<String, Object> responseMap =
                (Map<String, Object>) JSON.deserializeUntyped(responseBody);

            if (responseMap.containsKey('folderId')) {
                Object folderIdValue = responseMap.get('folderId');
                if (folderIdValue != null) {
                    return String.valueOf(folderIdValue);
                }
            }

            if (responseMap.containsKey('s3FolderId')) {
                Object folderIdValue = responseMap.get('s3FolderId');
                if (folderIdValue != null) {
                    return String.valueOf(folderIdValue);
                }
            }
        } catch (Exception ex) {
            System.debug(
                LoggingLevel.WARN,
                'Failed to parse AWS response body for account ' + accountId +
                '. Body: ' + responseBody +
                '. Error: ' + ex.getMessage()
            );
        }

        return null;
    }
}
