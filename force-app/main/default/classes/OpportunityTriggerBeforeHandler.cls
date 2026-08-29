public class OpportunityTriggerBeforeHandler {

    public void onBeforeInsert(List<Opportunity> listOpportunities) {
        validateCloseDates(listOpportunities);
        validateAmounts(listOpportunities);
        defaultStageNames(listOpportunities);
        formatOpportunityNames(listOpportunities);
        validateProbabilities(listOpportunities);
    }

    public void onBeforeUpdate(
        List<Opportunity> listOpportunities,
        Map<Id, Opportunity> mapOldOpportunities
    ) {
        validateAmountDecrease(
            listOpportunities,
            mapOldOpportunities
        );

        validateCloseDates(listOpportunities);
        formatOpportunityNames(listOpportunities);
        validateProbabilities(listOpportunities);
        validateWonOpportunities(listOpportunities);
    }

    public void onBeforeDelete(
        List<Opportunity> listOpportunities
    ) {
        preventWonOpportunityDeletion(listOpportunities);
    }

    private void validateCloseDates(
        List<Opportunity> listOpportunities
    ) {
        for (Opportunity opportunity : listOpportunities) {
            if (opportunity.CloseDate < Date.today()) {
                opportunity.addError(
                    'Close Date cannot be in the past.'
                );
            }
        }
    }

    private void validateAmounts(
        List<Opportunity> listOpportunities
    ) {
        for (Opportunity opportunity : listOpportunities) {
            Boolean hasNegativeAmount =
                opportunity.Amount != null &&
                opportunity.Amount < 0;

            if (hasNegativeAmount) {
                opportunity.addError(
                    'Amount cannot be negative.'
                );
            }
        }
    }

    private void defaultStageNames(
        List<Opportunity> listOpportunities
    ) {
        for (Opportunity opportunity : listOpportunities) {
            if (String.isBlank(opportunity.StageName)) {
                opportunity.StageName = 'Prospecting';
            }
        }
    }

    private void formatOpportunityNames(
        List<Opportunity> listOpportunities
    ) {
        for (Opportunity opportunity : listOpportunities) {
            if (String.isNotBlank(opportunity.Name)) {
                opportunity.Name =
                    opportunity.Name.trim().toUpperCase();
            }
        }
    }

    private void validateProbabilities(
        List<Opportunity> listOpportunities
    ) {
        for (Opportunity opportunity : listOpportunities) {

            Boolean isProbabilityInvalid =
                opportunity.Probability != null &&
                (opportunity.Probability < 0 ||
                 opportunity.Probability > 100);

            if (isProbabilityInvalid) {
                opportunity.addError(
                    'Probability must be between 0 and 100.'
                );
            }
        }
    }

    private void validateAmountDecrease(
        List<Opportunity> listOpportunities,
        Map<Id, Opportunity> mapOldOpportunities
    ) {
        for (Opportunity opportunity : listOpportunities) {

            Opportunity oldOpportunity =
                mapOldOpportunities.get(opportunity.Id);

            Boolean isAmountDecreased =
                opportunity.Amount != null &&
                oldOpportunity.Amount != null &&
                opportunity.Amount < oldOpportunity.Amount;

            if (isAmountDecreased) {
                opportunity.addError(
                    'Amount cannot be decreased.'
                );
            }
        }
    }

    private void validateWonOpportunities(
        List<Opportunity> listOpportunities
    ) {
        for (Opportunity opportunity : listOpportunities) {

            Boolean isWonWithoutAmount =
                opportunity.IsWon &&
                (opportunity.Amount == null ||
                 opportunity.Amount <= 0);

            if (isWonWithoutAmount) {
                opportunity.addError(
                    'Won Opportunities must have a positive Amount.'
                );
            }
        }
    }

    private void preventWonOpportunityDeletion(
        List<Opportunity> listOpportunities
    ) {
        for (Opportunity opportunity : listOpportunities) {
            if (opportunity.IsWon) {
                opportunity.addError(
                    'Won Opportunities cannot be deleted.'
                );
            }
        }
    }
}