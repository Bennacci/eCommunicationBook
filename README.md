
# eCommunicationBook
An app created for “parents” and “teachers” to interact in real-time, where the former can get their children's attendance record, class performance, learning progress, homework status, school calendar, and event information, and the latter can provide all the corresponding information with only a few taps.

[<img src="https://user-images.githubusercontent.com/77099990/123499177-59b5e300-d667-11eb-970f-1eab40490396.jpeg" width="180">](https://apps.apple.com/gb/app/ecommunicationbook/id1571593401?ign-mpt=uo%3D2)

```
If you need to build the project, please create new project on 
Google Firebase and download GoogleService-Info.plist from it.
```
  
## Table of Contents
- [Features and Screen Shots](#features-and-screen-shots)
  - [Dual roles](#dual-roles)
  - [Attendance system](#attendance-system)
  - [Communication book](#communication-book)
  - [Teacher's additional features](#teachers-additional-features)
  - [Chat rooms](#chat-rooms)
  - [Calendar](#calendar)
  - [Profile page](#profile-page)
- [Library](#library)
- [Requirements](#requirements)
- [Version](#version)
- [Contacts](#contacts)

## Features and Screen Shots

### Dual roles

Based on the user's role: **Teacher** or **Parent**, eCommunicationBook provides corresponding features.

  <img src="https://media.giphy.com/media/A1ou3b5Cin7I6XBTzx/giphy.gif" width="" height="384" align=center> <img width="200" alt="homepage_teacher2" src="https://user-images.githubusercontent.com/77099990/123513809-dbd2f580-d6c1-11eb-8990-40d95079e5aa.png" align=center> <img width="200" alt="homepage_parents" src="https://user-images.githubusercontent.com/77099990/123510556-da4c0200-d6ae-11eb-9179-57d1e597c8c6.png" align=center>

* **Sign in :**
   * Sign in with Apple ID.
   * Teachers can sign in with the invitation codes that the school has provided.
   * Parents can enter the parent page directly. An invitaion code will be requested upon checking any particular student's information.
* **Teacher :**
   * **Attendace system :**
      *  record students’ time in and out by scanning a QR code on their ID cards
   * **Communication book :**
       * fill in students’ class performance and test results
       * keep records of today’s lesson and homework
       * share lesson contents with co-teachers
   * **Chat rooms :** 
       * create chat rooms
       * leave messages to the parents
   * **Additional features:** 
       * create **course**, **event**, **news**, and **add student info**
*  **Parent :**
   * **Attendace system :**
       * see their kids’ attendance
   * **Communication book :** 
       * know the lesson content and homework
       * get information about school events
   * **Chat rooms :**
       * leave messages to the teachers

### Attendance system

Track attendance by scanning QR code and sharing location.
Calculate the student's attendance rate with GCD framework,  searching all the selected class's **Time in datas** and comparing it with the **class schedule** to see if the student is **on time**, **late** or **abscent**.

  <img width="200" align=center alt="scanQR" src="https://user-images.githubusercontent.com/77099990/123510849-58f56f00-d6b0-11eb-9a73-2f2fd64031a9.png"><img width="200" align=center alt="attendance_teacher" src="https://user-images.githubusercontent.com/77099990/123510544-d0c29a00-d6ae-11eb-8b60-c33644ce32dc.png"> <img width="200" align=center alt="attendance_parent" src="https://user-images.githubusercontent.com/77099990/123510510-a07afb80-d6ae-11eb-9207-c0974bed41ae.png"><img width="200" align=center alt="attendance_parent2" src="https://user-images.githubusercontent.com/77099990/123516498-ea73d980-d6ce-11eb-8f55-6dbc0a9ba13f.png">
 
* **Teacher :**
  * Scan students' ID cards to record their **Time in** or **Time out**.
  * Choose a class to see the whole class attendace sheet.
  * The first column of the attendance sheet is fixed, and will always show on the screen.
  * The attendace sheet will sort in ascending or  descending order alternately every time **name**, **date** or  **attendance rate** is tapped.

* **Parent :**  
  * See their kids’ **Time in** and **Time out**.
  * Know the location of their kids before they leave the school.
   
### Communication book
   
Display all the classes that the user is involved in.
The status of the button will change according to the comparsion of **class hour** and **curret time**.

  <img width="200" align=center alt="communicationbook_teacher" src="https://user-images.githubusercontent.com/77099990/123510551-d8823e80-d6ae-11eb-8e17-4a6b6a85fdc3.png"> <img width="200" align=center alt="communicationbook_paret" src="https://user-images.githubusercontent.com/77099990/123510550-d6b87b00-d6ae-11eb-88a6-c4b2cc3e2bb7.png">

* **Teacher :**
  * The **Edit** button will switch to **Done**, and the **QR code** button will disapear once the class is finished 
  * The **Edit** button directs to the page of editing lesson plan and filling student class perfomances.
  * The **QR code** button directs to attendace system's scanning page.

* **Parent :**
  * The **Read** button directing to class performance page will appear once the class is finished.

### Teacher's additional features
   
Teachers can create **course**, **event**, **news**, and add **student info**

  <img width="200" align=center alt="create_class" src="https://user-images.githubusercontent.com/77099990/123510555-d9b36b80-d6ae-11eb-9437-0f6264c50520.png"><img width="200" align=center alt="selectuser" src="https://user-images.githubusercontent.com/77099990/123510559-df10b600-d6ae-11eb-9ce0-5a4c012a4894.png"><img width="200"  align=center alt="create_event" src="https://user-images.githubusercontent.com/77099990/123512654-32890100-d6bb-11eb-8376-fa9fffaa4449.png"><img width="200" align=center alt="create_student" src="https://user-images.githubusercontent.com/77099990/123512658-3583f180-d6bb-11eb-9248-ae49bb2f056a.png">

### Chat rooms

Users can chat in a real-time chatroom created with UiKit and Firebase Firestore listeners

  <img width="200" alt="chatroom" src="https://user-images.githubusercontent.com/77099990/123510549-d4eeb780-d6ae-11eb-8464-7dec1dfa5967.png">

### Calendar
  
Users can get information about school events and student lesson performance.

  <img width="200" alt="calendar" src="https://user-images.githubusercontent.com/77099990/123510547-d324f400-d6ae-11eb-8e40-b7b01dd6dfc4.png">

### Profile page

Users can customize  their personal information.
  
  <img height="384" alt="accountPage" src="https://media.giphy.com/media/h2tR6uxK7hyv5AJS29/giphy.gif">

## Library

- [Charts](https://github.com/danielgindi/Charts)
- [ChamelonFramework](https://github.com/sanfreefeng/ChameleonFramework)
- [CollectionViewPagingLayout](https://github.com/amirdew/CollectionViewPagingLayout)
- [Crashlytics](https://github.com/firebase/firebase-ios-sdk/tree/master/Crashlytics)
- [EasyRefresher](https://github.com/Pircate/EasyRefresher)
- [FSCalendar](https://github.com/WenchaoD/FSCalendar)
- [Firebase](https://github.com/firebase/)
- [lottie-ios](https://github.com/airbnb/lottie-ios)
- [IQKeyboard](https://github.com/hackiftekhar/IQKeyboardManager)
- [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)
- [Kingfisher](https://github.com/onevcat/Kingfisher)
- [SwiftLint](https://github.com/realm/SwiftLint)
- [SwiftyMenu](https://github.com/KarimEbrahemAbdelaziz/SwiftyMenu)

## Requirements

* iOS 13.7+
* Xcode 12.0+

## Version

* 1.0 - 2021/06/14
* First release
  
## Contacts

Ben Tee [b258061@gmail.com](b258061@gmail.com)
