# RoundUpFeature_StarlingBank
### Round Up Feature for Starling Bank

![alt text](https://user-images.githubusercontent.com/30627907/60704917-b01b3b80-9efd-11e9-9a38-5bba60c8085f.jpeg)

For  a  customer,  take  all  the  transactions  in  a  given  week  and  round  them  up  to  the nearest  pound.  For  example  with  spending  of  £4.35,  £5.20  and  £0.87,  the  round-up would  be £1.58.  This  amount  should  then  be  transferred  into  a savings  goal,  helping  the customer  save  for  future  adventures. 

## App breakdown

### 1. Login

Launch Screen -> Login Controller

* LOGIN button calls the API service to authenticate the access token and fetch user account details.
* REFRESH TOKEN button refreshes the access token (currently experiencing error: Status Code 400). 
* Another textfield below the REFRESH and LOGIN Button to display any error resulting from refreshing and logging in.

![alt text](https://user-images.githubusercontent.com/30627907/60585546-e5058200-9d87-11e9-8ea2-9d1f0cf43ae2.jpeg)

### 2. Transactions Feed Controller 

* User balance fetched in the viewDidLoad() method in the Transactions Feed Controller after the user has been authenticated via the access token.
* User Account number and current balance displayed in the header cell.
* The transactions are displayed in the cells below the header, with their amounts and possible round Up.
* “Save to Goals” button -> to the Goals View Controller, with the round up amount allocated to a file variable.

![alt text](https://user-images.githubusercontent.com/30627907/60705049-05efe380-9efe-11e9-99c6-eab22b96eb7a.jpeg)

### 3. Goals View Controller

* Uses the Goals API to fetch any existing Goals; by fetching the UID of every goal, and associated assets like image etc. This information is used to populate the the collectionView Cells for each goal.
* TRANSFER FUNDS button transfers the round up amount to the selected goal. (currently experiencing error: Status Code 400)
* An extra cell allows you to create a new goal, by presenting a new View Controller: Create New Goal Controller

![alt text](https://user-images.githubusercontent.com/30627907/60585636-12eac680-9d88-11e9-9216-8c5d55cf7ede.jpeg)

### 4. Create New Goal Controller

* Uses UIImage Picker to allow selection of goal photo from Photo Library. Also the title and target amount (£) of the goal can be specified.
* Calls the API to create a new Goal and saves it, and displays  error text in both failure case, and reloads the collectionView.

![alt text](https://user-images.githubusercontent.com/30627907/60585648-1b430180-9d88-11e9-8126-fa0c664112d8.jpeg)





