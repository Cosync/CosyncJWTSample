# CosyncJWTiOS
iOS Sample App for CosyncJWT

On the CosyncJWT portal

* create an application called CosynJWTiOS
* In the Settings/Metadata Fields section
* Select 'Automatically add email field to meta data with handle'.
* Add two meta data fields
* Path 'user_data.name.first' with field name 'firstName'
* Path 'user_data.name.last' with field name 'lastName'

On the MongoDB Atlas side

* Create a Free Atlas Cluster. Under 'Additional Settings' select version 'MongoDB 4.4 - Betea'
* Name new Atlas Cluster CosyncJWTiOS
* Hit Create Cluster

Once the cluster has been created, select the Realm tab 

* Select Create a New App
* Select Mobile, iOS, No I'm starting from Scratch as your options
* Hit 'Start a new Realm App'
* Name the new Realm App 'CosyncJWTiOS'
* Link it to the CosyncJWTiOS cluster created above (default choice)
* Hit Create Realm Application

Set up Sync in Dev Mode

* Select Cluster to Sync 'CosyncJWTiOS'
* Define a Database called 'CosyncJWTiOS_DB'
* Create a partition key called '_partition' as a string
* Hit 'Turn Dev Mode On'

Set up user provider 

* Copy the Realm Public Key for the Application from the Keys section in the CosyncJWT portal
* In the Realm app go to the User tab
* Select the Providers tab
* Select 'Custom JWT Authentication' and hit 'Edit'
* Toggle the Provider Enable control to on
* Select 'Signing Algorithm" as RS256
* Create a Signing Key called 'CosyncJWTiOSKey' and enter the Public Key copied above
* Add a metadata field with path "user_data.email' and with field name email
* Hit 'Save'

Deploy the Realm App

* Hit 'REVIEW & DEPLOY'

XCode Project

* Download the source code from Github
* Set up pods by typing 'pod install' at the command line
* Open generated workspace file
* Copy the Realm id from the top left button in the Realm panel in the web UI
* Edit the REALM_APP_ID in the Constants.swift function with the copied Realm Id

Run the app
