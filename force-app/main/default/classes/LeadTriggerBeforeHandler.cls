public without sharing class LeadTriggerBeforeHandler {

    public void onBeforeInsert(List<Lead> listLeads) {
        for (Lead objLead : listLeads) {
            validateLeadData(objLead);
            checkDuplicateEmail(objLead);
            setDefaultLeadOwner(objLead);
            setLeadSource(objLead);
        }
    }

    public void onBeforeUpdate(
        List<Lead> listLeads,
        Map<Id, Lead> mapOldLeads
    ) {
        for (Lead objLead : listLeads) {
            Lead oldLead = mapOldLeads.get(objLead.Id);
            validateLeadData(objLead);
            checkDuplicateEmail(objLead);

            if (objLead.AnnualRevenue != null && oldLead != null && objLead.AnnualRevenue < oldLead.AnnualRevenue) {
                objLead.addError('Annual revenue cannot decrease.');
            }

            if (objLead.Status == 'Closed - Converted' && String.isBlank(objLead.Email)) {
                objLead.addError('Converted leads need an email.');
            }
        }
    }

    private void validateLeadData(Lead objLead) {
        if (String.isBlank(objLead.LastName)) {
            objLead.LastName = 'Unknown';
        }

        if (String.isBlank(objLead.Company)) {
            objLead.Company = 'N/A';
        }

        if (String.isNotBlank(objLead.FirstName)) {
            objLead.FirstName = objLead.FirstName.trim();
        }

        if (objLead.Email != null && objLead.Email.contains('@') == false) {
            objLead.Email = objLead.Email + '@example.com';
        }
    }

    private void checkDuplicateEmail(Lead objLead) {
        if (String.isNotBlank(objLead.Email)) {
            List<Lead> listDupes = [SELECT Id, Email FROM Lead WHERE Email = :objLead.Email];
            if (listDupes.size() > 0) {
                objLead.addError('This email is already in use.');
            }
        }
    }

    private void setDefaultLeadOwner(Lead objLead) {
        if (objLead.OwnerId == null) {
            User objUser = [SELECT Id FROM User WHERE Alias = 'adm' LIMIT 1];
            objLead.OwnerId = objUser.Id;
        }
    }

    private void setLeadSource(Lead objLead) {
        if (String.isBlank(objLead.LeadSource)) {
            objLead.LeadSource = 'Web';
        }

        if (objLead.Country == 'US') {
            objLead.LeadSource = 'Partner';
        }
    }
}
