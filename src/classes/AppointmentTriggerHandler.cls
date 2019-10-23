public class AppointmentTriggerHandler {

    public void onBeforeInsert(List<Appointment__c> appointments) {
        Map<Appointment__c, String> appointmentAccountsNamesMap = getAppointmentsAccountsNamesMap(appointments);
        Map<Appointment__c, String> appointmentsWithoutAccounts = new Map<Appointment__c, String>();
        List<Account> accounts = new List<Account>();

        if (!appointmentAccountsNamesMap.isEmpty()) {
            accounts = AccountManager.getAccountsByNames(appointmentAccountsNamesMap.values());
        }

        setAppointmentAccounts(appointments, appointmentsWithoutAccounts, accounts);

        List<Account> newAccounts = AccountManager.createAccountsByNames(new Set<String>(appointmentsWithoutAccounts.values()));
        setAppointmentAccounts(new List<Appointment__c>(appointmentsWithoutAccounts.keySet()), new Map<Appointment__c, String>(), newAccounts);
    }

    private Map<Appointment__c, String> getAppointmentsAccountsNamesMap(List<Appointment__c> appointments) {
        Map<Appointment__c, String> appointmentsAccountsNamesMap = new Map<Appointment__c, String>();

        for (Appointment__c appointment : appointments) {
            appointmentsAccountsNamesMap.put(appointment, appointment.Account_Name__c);
        }

        return appointmentsAccountsNamesMap;
    }

    private void setAppointmentAccounts(List<Appointment__c> appointments, Map<Appointment__c, String> appointmentsWithoutAccounts, List<Account> accounts) {
        for (Appointment__c appointment : appointments) {
            String accountName = appointment.Account_Name__c;

            for (Account account : accounts) {
                if (account.Name.equals(accountName)) {
                    appointment.Account__c = account.Id;
                    break;
                }
            }

            if (appointment.Account__c == null) {
                appointmentsWithoutAccounts.put(appointment, accountName);
            }
        }
    }
}
