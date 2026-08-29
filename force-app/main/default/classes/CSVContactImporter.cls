public with sharing class CSVContactImporter {

    public static void processUploadedCSV(
        Set<Id> setContentVersionIds
    ) {
        if (setContentVersionIds == null ||
            setContentVersionIds.isEmpty()) {
            return;
        }

        List<ContentVersion> listContentVersions = [
            SELECT Id,
                   Title,
                   VersionData
            FROM ContentVersion
            WHERE Id IN :setContentVersionIds
        ];

        List<Contact> listContactsToInsert =
            new List<Contact>();

        for (ContentVersion contentVersion :
             listContentVersions) {

            String csvContent =
                contentVersion.VersionData.toString();

            List<String> listRows =
                csvContent.split('\n');

            for (Integer rowIndex = 1;
                 rowIndex < listRows.size();
                 rowIndex++) {

                List<String> listColumns =
                    listRows[rowIndex].split(',');

                if (listColumns.size() < 2) {
                    continue;
                }

                listContactsToInsert.add(
                    new Contact(
                        FirstName = listColumns[0].trim(),
                        LastName = listColumns[1].trim()
                    )
                );
            }
        }

        if (!listContactsToInsert.isEmpty()) {
            insert listContactsToInsert;
        }
    }
}