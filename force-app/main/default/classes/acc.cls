public class acc {

    public static Integer maxRecords = 200;

    public static void ProcessAccounts(
        List<Account> accounts
    ) {

        Boolean valid = false;

        for(Account a : accounts){

            if(a.AnnualRevenue != null &&
               a.AnnualRevenue > 100000){

                valid = true;
            }

            Contact c = new Contact();

            c.LastName = a.Name;

            insert c;
        }

        if(valid){

            List<Account> accs = [
                SELECT Id,
                       Name,
                       Rating
                FROM Account
                LIMIT 100
            ];

            for(Account x : accs){

                x.Rating = 'Hot';

                update x;
            }
        }

        System.debug('done');
    }

    public static void m1(List<Account> a){

        Map<Id, Account> m =
            new Map<Id, Account>();

        for(Account x : a){

            m.put(x.Id, x);
        }

        System.debug(m);
    }

    public static Boolean check(Account a){

        if(a.Name != null){
            return true;
        }

        return false;
    }

    public static void upd(List<Account> a){

        for(Account x : a){

            List<Contact> contacts = [
                SELECT Id,
                       LastName
                FROM Contact
                WHERE AccountId = :x.Id
            ];

            for(Contact c : contacts){

                c.Description = 'Updated';

                update c;
            }
        }
    }
}