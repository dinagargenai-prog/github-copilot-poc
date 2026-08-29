@IsTest
private class CaseTriggerAfterHandlerTest {

    @IsTest
    static void testAfterInsert() {

        Account accountRecord =
            new Account(
                Name = 'Test Account'
            );

        insert accountRecord;

        List<Case> listCases =
            new List<Case>();

        for (Integer index = 0;
             index < 5;
             index++) {

            listCases.add(
                new Case(
                    Subject = 'Test Case ' + index,
                    Status = 'New',
                    Priority = 'High',
                    Origin = 'Phone',
                    AccountId = accountRecord.Id
                )
            );
        }

        System.Test.startTest();

        insert listCases;

        System.Test.stopTest();

        System.assertEquals(
            5,
            [
                SELECT Count()
                FROM Case
                WHERE AccountId =
                    :accountRecord.Id
            ]
        );
    }

    @IsTest
    static void testStatusUpdate() {

        Case caseRecord =
            new Case(
                Subject = 'Status Test',
                Status = 'New',
                Origin = 'Phone'
            );

        insert caseRecord;

        System.Test.startTest();

        caseRecord.Status = 'Closed';

        update caseRecord;

        System.Test.stopTest();

        Case updatedCase =
            [
                SELECT Id,
                       Status
                FROM Case
                WHERE Id =
                    :caseRecord.Id
            ];

        System.assertEquals(
            'Closed',
            updatedCase.Status
        );
    }

    @IsTest
    static void testEscalationUpdate() {

        Case caseRecord =
            new Case(
                Subject = 'Escalation Test',
                Status = 'New',
                Origin = 'Web'
            );

        insert caseRecord;

        System.Test.startTest();

        caseRecord.IsEscalated = true;

        update caseRecord;

        System.Test.stopTest();

        Case updatedCase =
            [
                SELECT Id,
                       IsEscalated
                FROM Case
                WHERE Id =
                    :caseRecord.Id
            ];

        System.assertEquals(
            true,
            updatedCase.IsEscalated
        );
    }
}