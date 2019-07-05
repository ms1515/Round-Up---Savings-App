# RoundUpFeature_StarlingBank iOS
### Round Up Feature for Starling Bank 

![alt text](https://user-images.githubusercontent.com/30627907/60704917-b01b3b80-9efd-11e9-9a38-5bba60c8085f.jpeg)

For  a  customer,  take  all  the  transactions  in  a  given  week  and  round  them  up  to  the nearest  pound.  For  example  with  spending  of  £4.35,  £5.20  and  £0.87,  the  round-up would  be £1.58.  This  amount  should  then  be  transferred  into  a savings  goal,  helping  the customer  save  for  future  adventures. 

## App breakdown

### 1. Login

Launch Screen -> Login Controller

* LOG IN button calls the API service to authenticate the access token and fetch user account details.
* REFRESH TOKEN button refreshes the access token using the refresh token upon selection as the access token expires after 24 hours (currently experiencing error: Status Code 400. Cannot understand why as the request and parameters seem to be correct). 
* Another textfield below the REFRESH and LOGIN Button to display any error resulting from refreshing and logging in.

![alt text](https://user-images.githubusercontent.com/30627907/60585546-e5058200-9d87-11e9-8ea2-9d1f0cf43ae2.jpeg)

### 2. Transactions Feed Controller 

* User balance fetched in the viewDidLoad() method in the Transactions Feed Controller after the user has been authenticated via the access token.
* User Account number and current balance displayed in the header cell.
* The transactions are displayed in the cells below the header, with their amounts and possible round Up.
* The view can be refreshed by swiping down to activate the refresh control on tableView after any new transactions or transferring of funds to saving goals..
* SAVE TO GOALS button takes the user to the Goals View Controller, with the round up amount allocated to a file variable.
* The POWER button takes the user back to the Login Controller to simulate logging out.

![alt text](https://user-images.githubusercontent.com/30627907/60705049-05efe380-9efe-11e9-99c6-eab22b96eb7a.jpeg)

### 3. Goals View Controller

* Uses the Goals API to fetch any existing Goals; by fetching the UID of every goal, and associated assets like image etc. This information is used to populate the the collectionView Cells for each goal. However the images for each goal in base64encoded format are not being retreived (as they are not found in the API destination), even though they are being uploaded during goal creation. 
* The Cells' transform changes upon selection via animation to provide a satisfactory interactive experience.
* TRANSFER FUNDS button transfers the round up amount to the selected goal, and a notification view animates upwards to show the result of transfer (success or failure).
* CANCEL Button dismisses the current View Controller and takes the user back to the Transaction Feed Controller.
* The view can be refreshed by swiping down to activate the refresh control on collectionView to retrieve any new saving goals.
* An extra cell allows you to create a new goal, by presenting a new View Controller: Create New Goal Controller.

![alt text](https://user-images.githubusercontent.com/30627907/60705136-3a639f80-9efe-11e9-8467-32703f78a95c.jpeg)

### 4. Create New Goal Controller

* Uses UIImage Picker to allow selection of goal photo from Photo Library. Also the title and target amount (£) of the goal can be specified.
* CREATE GOAL Button Calls the API to create a new Goal and saves it, displays any error in the textfield and notification view appears in the case of successful creation of new goal. 
* CANCEL Button dismisses the current View Controller and takes the user back to the Goals Controller.
* Upon clicking done, the user is taken back to Goals View Controller, where the view can be refreshed by swiping down.

![alt text](https://user-images.githubusercontent.com/30627907/60705265-94fcfb80-9efe-11e9-94fd-1b46fe488fcd.jpeg)





