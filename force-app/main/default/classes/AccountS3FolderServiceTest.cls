@IsTest
private class AccountS3FolderServiceTest {

    @IsTest
    static void testCreateFolderOnSuccess() {
        Account accountRecord =
            new Account(
                Name = 'Account Folder Success'
            );

        insert accountRecord;

        Test.setMock(
            HttpCalloutMock.class,
            new AwsS3FolderMock(
                200,
                '{"folderId":"' + accountRecord.Id + '/"}'
            )
        );

        Test.startTest();

        AccountS3FolderService.enqueueForProcessing(
            new Set<Id>{ accountRecord.Id }
        );

        Test.stopTest();

        Account updatedAccount = [
            SELECT Id, S3_Folder_Id__c
            FROM Account
            WHERE Id = :accountRecord.Id
        ];

        System.assertEquals(
            accountRecord.Id + '/',
            updatedAccount.S3_Folder_Id__c
        );
    }

    @IsTest
    static void testCreateFolderOnFailure() {
        Account accountRecord =
            new Account(
                Name = 'Account Folder Failure'
            );

        insert accountRecord;

        Test.setMock(
            HttpCalloutMock.class,
            new AwsS3FolderMock(
                500,
                '{"message":"Internal server error"}'
            )
        );

        Test.startTest();

        AccountS3FolderService.enqueueForProcessing(
            new Set<Id>{ accountRecord.Id }
        );

        Test.stopTest();

        Account updatedAccount = [
            SELECT Id, S3_Folder_Id__c
            FROM Account
            WHERE Id = :accountRecord.Id
        ];

        System.assertEquals(
            null,
            updatedAccount.S3_Folder_Id__c
        );
    }

    private class AwsS3FolderMock implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;

        private AwsS3FolderMock(
            Integer statusCode,
            String responseBody
        ) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }

        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(this.statusCode);
            response.setBody(this.responseBody);

            return response;
        }
    }
}
