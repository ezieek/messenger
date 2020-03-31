# Messenger
<img src="https://swift.org/assets/images/swift.svg" alt="Swift logo" height="50" >

# Overview
Messenger is an example of MVC Design Pattern project. It is based on the most popular application on the Internet called Messenger designed by Facebook Inc. Backend services are provides by Firebase. It supports authentication using paswords, phone numbers, Google, Facebook and more. Data is synced across all clients in realtime and remains available even when an app goes offline. 

# Design
Graphic appearance of the application is prepared to work on every size of iPhone's. Selected colors, size of objects, and places where they were used were invented by me.

# Networking

# Registration and login process
The successful registration and login process takes place through Firebase Authentication. Sign-in method allows users to register using email and password. There is no way to register two accounts with the same email addresses also there is no possible to create a lot of new accounts with the same IP address.

<img src="https://user-images.githubusercontent.com/13642892/78055768-53618a00-7384-11ea-807f-5af89a3244b9.png" width="320">  <img src="https://user-images.githubusercontent.com/13642892/78055781-565c7a80-7384-11ea-91a7-67bf96e52bbb.png" width="320">

# Messaging process
Messaging process starts only when new user is added to your friend list. Sent messages are stored in Realtime Database provided by Firebase. There are implemented methods to protect them against getting messages that were not addressed to us.

<img src="https://user-images.githubusercontent.com/13642892/78057102-78ef9300-7386-11ea-8adf-2244d3948110.png" width="320"> <img src="https://user-images.githubusercontent.com/13642892/78055776-552b4d80-7384-11ea-8d74-fc5d3f3930dd.png" width="320">
