# RoundUpFeature_StarlingBank
### Round Up Feature for Starling Bank

For  a  customer,  take  all  the  transactions  in  a  given  week  and  round  them  up  to  the nearest  pound.  For  example  with  spending  of  £4.35,  £5.20  and  £0.87,  the  round-up would  be £1.58.  This  amount  should  then  be  transferred  into  a savings  goal,  helping  the customer  save  for  future  adventures. 

## App breakdown

### 1. Login

Launch Screen -> Login Controller

* Textfield containing the access Token, which can be changed as it expires.
* Login button calls the API service to authenticate the access token and fetch user account details.
* Another textfield below the login Button to display any error resulting from authentication  

![alt text](https://user-images.githubusercontent.com/30627907/60475971-a8dffd80-9c71-11e9-9175-5a486668bc52.jpeg)

### 2. Transactions Feed Controller 

* User balance fetched in the viewDidLoad() method in the Transactions Feed Controller after the user has been authenticated via the access token.
* User Account number and current balance displayed in the header cell.
* The transactions are displayed in the cells below the header, with their amounts and possible round Up.
* “Save to Goals” button -> to the Goals View Controller, with the round up amount allocated to a file variable.

### 3. Goals View Controller

* Uses the Goals API to fetch any existing Goals: fetch the UID of every goal, from it fetch the value and associated assets like image etc. This information is used to populate the the collectionView Cells for each goal.
* The Goals API can then be used to update the relevant goal account with the added money. 
* An extra cell allows you to create a new goal with a pop over, that calls the API to create a new Goal and saves it, and displays some notification text in both success and failure case, and reloads the collectionView.

