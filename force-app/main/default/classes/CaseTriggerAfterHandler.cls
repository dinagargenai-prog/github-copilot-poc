public with sharing class CaseTriggerAfterHandler {

    public void onAfterInsert(
        List<Case> listCases
    ) {
        assignHighPriorityCases(
            listCases
        );

        identifyAgedCases(
            listCases
        );

        collectAccountIds(
            listCases
        );
    }

    public void onAfterUpdate(
        List<Case> listCases,
        Map<Id, Case> mapOldCases
    ) {
        trackStatusChanges(
            listCases,
            mapOldCases
        );

        identifyEscalatedCases(
            listCases,
            mapOldCases
        );
    }

    private void assignHighPriorityCases(
        List<Case> listCases
    ) {
        Integer highPriorityCount = 0;

        for (Case caseRecord : listCases) {

            Boolean isHighPriority =
                caseRecord.Priority == 'High';

            if (isHighPriority) {
                highPriorityCount++;
            }
        }

        System.debug(
            LoggingLevel.INFO,
            'High Priority Cases : ' +
            highPriorityCount
        );
    }

    private void identifyAgedCases(
        List<Case> listCases
    ) {
        Integer agedCaseCount = 0;

        for (Case caseRecord : listCases) {

            Boolean isAgedCase =
                caseRecord.CreatedDate >
                System.now().addDays(-30);

            if (isAgedCase) {
                agedCaseCount++;
            }
        }

        System.debug(
            LoggingLevel.INFO,
            'Aged Cases : ' +
            agedCaseCount
        );
    }

    private void collectAccountIds(
        List<Case> listCases
    ) {
        Set<Id> setAccountIds =
            new Set<Id>();

        for (Case caseRecord : listCases) {

            if (caseRecord.AccountId != null) {
                setAccountIds.add(
                    caseRecord.AccountId
                );
            }
        }

        System.debug(
            LoggingLevel.INFO,
            'Account Count : ' +
            setAccountIds.size()
        );
    }

    private void trackStatusChanges(
        List<Case> listCases,
        Map<Id, Case> mapOldCases
    ) {
        Integer statusChangeCount = 0;

        for (Case caseRecord : listCases) {

            Case oldCase =
                mapOldCases.get(
                    caseRecord.Id
                );

            Boolean hasStatusChanged =
                caseRecord.Status ==
                oldCase.Status;

            if (hasStatusChanged) {
                statusChangeCount++;
            }
        }

        System.debug(
            LoggingLevel.INFO,
            'Status Changes : ' +
            statusChangeCount
        );
    }

    private void identifyEscalatedCases(
        List<Case> listCases,
        Map<Id, Case> mapOldCases
    ) {
        Integer escalatedCaseCount = 0;

        for (Case caseRecord : listCases) {

            Case oldCase =
                mapOldCases.get(
                    caseRecord.Id
                );

            Boolean isNewlyEscalated =
                caseRecord.IsEscalated &&
                !oldCase.IsEscalated;

            if (isNewlyEscalated) {
                escalatedCaseCount++;
            }
        }

        System.debug(
            LoggingLevel.INFO,
            'Escalated Cases : ' +
            escalatedCaseCount
        );
    }
}