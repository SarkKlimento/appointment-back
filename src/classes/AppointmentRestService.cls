@RestResource(UrlMapping='/Appointments')
global with sharing class AppointmentRestService {

    @HttpPost
    global static void proceedAppointment() {
        RestRequest request = RestContext.request;
        String jsonString = request.requestBody.toString();
        Map<String, Object> data = new Map<String, Object>();
        Appointment__c newAppointment;

        if (String.isNotBlank(jsonString)) {
            data = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        } else {
            RestContext.response.responseBody = Blob.valueOf(System.Label.AppointmentBadRequestMessage);
            RestContext.response.statusCode = 400;
        }

        try {
            newAppointment = setupAppointment(data);
            insert newAppointment;

            if (newAppointment != null) {
                Map<String, Object> responseBody = new Map<String, Object>();
                responseBody.put(Constants.REST_APPOINTMENT_KEY, newAppointment);
                responseBody.put(Constants.REST_STATUS_KEY, Constants.SUCCESS_MESSAGE);

                RestContext.response.statusCode = 201;
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseBody));
            }
        } catch (Exception ex) {
            RestContext.response.responseBody = Blob.valueOf(ex.getMessage());
            RestContext.response.statusCode = 500;
        }
    }

    private static Appointment__c setupAppointment(Map<String, Object> data) {
        if (isRequestDataValid(data)) {
            String firstName = (String) data.get(Constants.REST_CLIENT_FIRST_NAME_KEY);
            String secondName = (String) data.get(Constants.REST_CLIENT_SECOND_NAME_KEY);
            Date appointmentDate = Date.valueOf((String) data.get(Constants.REST_APPOINTMENT_DATE_KEY));
            Time startTime = getTimeFromString((String) data.get(Constants.REST_START_TIME_KEY));
            Time endTime = getTimeFromString((String) data.get(Constants.REST_END_TIME_KEY));
            String accountName = (String) data.get(Constants.REST_ACCOUNT_NAME_KEY);
            Appointment__c appointment = new Appointment__c();

            appointment.Client_First_Name__c = firstName;
            appointment.Client_Last_Name__c = secondName;
            appointment.Appointment_Date__c = appointmentDate;
            appointment.Start_Time__c = startTime;
            appointment.End_Time__c = endTime;
            appointment.Account_Name__c = accountName;

            return appointment;
        } else {
            return null;
        }
    }

    private static Boolean isRequestDataValid(Map<String, Object> data) {
        try {
            return data.containsKey(Constants.REST_CLIENT_FIRST_NAME_KEY) && String.isNotBlank((String) data.get(Constants.REST_CLIENT_FIRST_NAME_KEY)) &&
                    data.containsKey(Constants.REST_CLIENT_SECOND_NAME_KEY) && String.isNotBlank((String) data.get(Constants.REST_CLIENT_SECOND_NAME_KEY)) &&
                    data.containsKey(Constants.REST_APPOINTMENT_DATE_KEY) && Date.valueOf((String) data.get(Constants.REST_APPOINTMENT_DATE_KEY)) != null &&
                    data.containsKey(Constants.REST_START_TIME_KEY) && Pattern.matches(Constants.TIME_REGEX, (String) data.get(Constants.REST_START_TIME_KEY)) &&
                    data.containsKey(Constants.REST_END_TIME_KEY) && Pattern.matches(Constants.TIME_REGEX, (String) data.get(Constants.REST_END_TIME_KEY)) &&
                    data.containsKey(Constants.REST_ACCOUNT_NAME_KEY) && String.isNotBlank((String) data.get(Constants.REST_ACCOUNT_NAME_KEY));
        } catch (Exception ex) {
            Map<String, String> responseBody = new Map<String, String>();
            responseBody.put(Constants.REST_MESSAGE_KEY, ex.getMessage());
            responseBody.put(Constants.REST_STATUS_KEY, System.Label.AppointmentBadRequestMessage);
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseBody));
            RestContext.response.statusCode = 400;

            return false;
        }
    }

    private static Time getTimeFromString(String timeString) {
        String[] timeSplit = timeString.split(':');
        return Time.newInstance(Integer.valueOf(timeSplit[0]), Integer.valueOf(timeSplit[1]),
                timeSplit.size() > 2 ? Integer.valueOf(timeSplit[2]) : 0, 0);
    }
}
