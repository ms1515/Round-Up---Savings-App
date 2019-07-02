# RoundUpFeature_StarlingBank
Round Up Feature for Starling Bank

For  a  customer,  take  all  the  transactions  in  a  given  week  and  round  them  up  to  the nearest  pound.  For  example  with  spending  of  £4.35,  £5.20  and  £0.87,  the  round-up would  be £1.58.  This  amount  should  then  be  transferred  into  a savings  goal,  helping  the customer  save  for  future  adventures. 

## App breakdown

1. Login

Launch Screen -> Login Controller

* Textfield containing the access Token, which can be changed as it expires.
* Login button calls the API service to authenticate the access token and fetch user account details.
* Another textfield below the login Button to display any error resulting from authentication  

![alt text](https://user-images.githubusercontent.com/30627907/60475971-a8dffd80-9c71-11e9-9175-5a486668bc52.jpeg)

