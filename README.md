For the Angular Code We have a separate repository to be able to clear deploy it to Heroku

Step 1:
With help of UI, create sObject Appointment__c
And it's fields:
    Account__c - Lookup(Account)
    Account_Name__c - Text(255)
    Appointment_Date__c - Date
    Client_First_Name__c - Text(255)
    Client_Last_Name__c - Text(255)
    End_Time__c - Time
    Start_Time__c - Time

Step 2:
    Create Custom label:
        Name: AppointmentBadRequestMessage
        Value: Data of the request is empty or in invalid format.

Step 3:
    Deploy code from branch (Apex)
