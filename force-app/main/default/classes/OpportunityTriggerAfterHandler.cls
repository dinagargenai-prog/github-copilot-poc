public class OpportunityTriggerAfterHandler {

    public void onAfterInsert(List<Opportunity> listOpportunities) {
        logInsertedOpportunities(listOpportunities);
        calculateTotalAmount(listOpportunities);
        identifyLargeOpportunities(listOpportunities);
        countWonOpportunities(listOpportunities);
        collectAccountIds(listOpportunities);
    }

    public void onAfterUpdate(
        List<Opportunity> listOpportunities,
        Map<Id, Opportunity> mapOldOpportunities
    ) {
        trackStageChanges(
            listOpportunities,
            mapOldOpportunities
        );
        calculateTotalAmount(listOpportunities);
        identifyLargeOpportunities(listOpportunities);
        countWonOpportunities(listOpportunities);
        collectAccountIds(listOpportunities);
    }

    public void onAfterDelete(List<Opportunity> listOpportunities) {
        logDeletedOpportunities(listOpportunities);
    }

    public void onAfterUndelete(List<Opportunity> listOpportunities) {
        logUndeletedOpportunities(listOpportunities);
    }

    private void logInsertedOpportunities(
        List<Opportunity> listOpportunities
    ) {
        System.debug(
            'Inserted Opportunities Count : ' +
            listOpportunities.size()
        );
    }

    private void calculateTotalAmount(
        List<Opportunity> listOpportunities
    ) {
        Decimal totalOpportunityAmount = 0;

        for (Opportunity opportunity : listOpportunities) {
            if (opportunity.Amount != null) {
                totalOpportunityAmount += opportunity.Amount;
            }
        }

        System.debug(
            'Total Opportunity Amount : ' +
            totalOpportunityAmount
        );
    }

    private void identifyLargeOpportunities(
        List<Opportunity> listOpportunities
    ) {
        for (Opportunity opportunity : listOpportunities) {

            Boolean isLargeOpportunity =
                opportunity.Amount != null &&
                opportunity.Amount > 100000;

            if (isLargeOpportunity) {
                System.debug(
                    'Large Opportunity : ' +
                    opportunity.Name
                );
            }
        }
    }

    private void countWonOpportunities(
        List<Opportunity> listOpportunities
    ) {
        Integer wonOpportunityCount = 0;

        for (Opportunity opportunity : listOpportunities) {
            if (opportunity.IsWon) {
                wonOpportunityCount++;
            }
        }

        System.debug(
            'Won Opportunities Count : ' +
            wonOpportunityCount
        );
    }

    private void collectAccountIds(
        List<Opportunity> listOpportunities
    ) {
        Set<Id> setAccountIds = new Set<Id>();

        for (Opportunity opportunity : listOpportunities) {
            if (opportunity.AccountId != null) {
                setAccountIds.add(opportunity.AccountId);
            }
        }

        System.debug(
            'Related Account Ids : ' +
            setAccountIds
        );
    }

    private void trackStageChanges(
        List<Opportunity> listOpportunities,
        Map<Id, Opportunity> mapOldOpportunities
    ) {
        for (Opportunity opportunity : listOpportunities) {

            Opportunity oldOpportunity =
                mapOldOpportunities.get(opportunity.Id);

            Boolean hasStageChanged =
                opportunity.StageName !=
                oldOpportunity.StageName;

            if (hasStageChanged) {
                System.debug(
                    'Stage Changed From ' +
                    oldOpportunity.StageName +
                    ' To ' +
                    opportunity.StageName
                );
            }
        }
    }

    private void logDeletedOpportunities(
        List<Opportunity> listOpportunities
    ) {
        System.debug(
            'Deleted Opportunities Count : ' +
            listOpportunities.size()
        );
    }

    // Method 8
    private void logUndeletedOpportunities(
        List<Opportunity> listOpportunities
    ) {
        System.debug(
            'Undeleted Opportunities Count : ' +
            listOpportunities.size()
        );
    }
}