# Messenger
<img src="https://swift.org/assets/images/swift.svg" alt="Swift logo" height="50" >

# Overview
Messenger is an example of MVC Design Pattern project. It is based on the most popular application on the Internet called Messenger designed by Facebook Inc. Backend services are provides by Firebase. It supports authentication using paswords, phone numbers, Google, Facebook and more. Data is synced across all clients in realtime and remains available even when an app goes offline. Graphic appearance of the application is prepared to work on every size of iPhone's.

# Registration and login process
The successful registration and login process takes place through Firebase Authentication. Sign-in method allows users to register using email and password. There is no way to register two accounts with the same email addresses also there is no possible to create a lot of new accounts with the same IP address.

![registrationProcess](https://user-images.githubusercontent.com/13642892/75624113-a099e280-5bb1-11ea-99ee-e76c6758a53a.gif)
![login](https://user-images.githubusercontent.com/13642892/75624171-287fec80-5bb2-11ea-9956-801c71fb913b.gif)

# Messaging process
Messaging process starts only when new user is added to your friend list. Sent messages are stored in Realtime Database provided by Firebase. There are implemented methods to protect them against getting messages that were not addressed to us.

