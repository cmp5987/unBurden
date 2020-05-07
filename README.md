# unBurden
Young Adult Campers want to plan and organize the packing process of camping. unBurden is a shared tasklist application that lets users plan which items need to be packed and declare their intentions to a group which they will be responsible for bringing. Unlike other shared tasklist applications, our product will be specialized toward a camping experience using knowledge of different camping styles, length of the journey, and weather to advise users items that could be helpful or commonly forgotten when packing.

##  Feature List
### Sign up and Login
Users are able to sign up with an email and password. This email and password are stored with their credentials in a Firestore database for authentication.
### Authentication Preservation
Users are not required to sign up or login each time they access the app. If there is a uid stored in UserDefaults, their sign in is remembered and they are moved directly to the home page. 
### Ability to Create a Trip
Users are able to create a trip that contains trip detail info like the trip name, items needing to be packed, and items already packed..
### Ability to Delete a Trip
Users are able to delete a trip to remove it from their triplist and the Firestore database, 
Ability to Add Items to Pack
Users are able to add items that they need to pack to a pack list that is stored in the Firestore Database.
### Ability to Mark Items as Packed
Users  are able to mark items as packed and see a selection of packed items.
Suggestions Provided for Items  to Pack
When adding items to pack, users will be able to see a list of suggested items that are necessary for camping.
### Filtered Suggestions
Users are able to filter the items that they may add to their list of items that they need to pack. 
### Stored User Data
User trip lists are stored on a FireStore Database, The way the database has been created, there is potential to have multiple users be able to manipulate the same trip.  Essentially sharing their trip packing.

