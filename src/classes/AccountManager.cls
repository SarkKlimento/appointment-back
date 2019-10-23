public with sharing class AccountManager {

    public static List<Account> createAccountsByNames(Set<String> names) {
        if (names.isEmpty()) {
            return new List<Account>();
        }

        List<Account> accountsToInsert = new List<Account>();

        for (String name : names) {
            accountsToInsert.add(new Account(Name = name));
        }

        insert accountsToInsert;
        return accountsToInsert;
    }

    public static List<Account> getAccountsByNames(List<String> accountNames) {
        if (accountNames == null || accountNames.isEmpty()) {
            return new List<Account>();
        }

        return [
                SELECT
                        Id,
                        Name
                FROM Account
                WHERE Name IN :accountNames
        ];
    }
}
