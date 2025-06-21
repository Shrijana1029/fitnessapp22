import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/firebase_services/firebase_auth.dart';
import 'package:fitnessapp/screens/activity/activity_tracker.dart';
import 'package:fitnessapp/screens/foods/diet_list.dart';
// import 'package:fitnessapp/screens/activity/activity_tracking.dart';
import 'package:fitnessapp/screens/login_signup/manage_profle.dart';
import 'package:fitnessapp/screens/profile/contact.dart';
import 'package:fitnessapp/screens/profile/priavcy.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/screens/profile/setting_row.dart';
import 'package:fitnessapp/screens/activity/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fitnessapp/profile/title_subtitle_cell.dart';
// import 'package:fitnessapp/firebase_services/firebase_auth.dart';
import 'package:fitnessapp/screens/profile/title_subtitle_cell.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool positive = false;
  late Map<String, dynamic> iObj;

  // List<Map<String, dynamic>> accountArr = [
  //   {
  //     "image": "assets/img1/img/p_personal.png",
  //     "name": "Personal Data",
  //     "tag": "1"
  //   },
  //   {"image": "assets/img1/img/p_achi.png", "name": "Achievement", "tag": "2"},
  //   {
  //     "image": "assets/img1/img/p_activity.png",
  //     "name": "Activity History",
  //     "tag": "3"
  //   },
  //   // {
  //   //   "image": "assets/img1/img/p_workout.png",
  //   //   "name": "Workout Progress",
  //   //   "tag": "4"
  //   // },
  // ];

  List<Map<String, dynamic>> otherArr = [
    {
      "image": "assets/img1/img/p_personal.png",
      "name": "Personal Data",
      "tag": "1"
    },
    {"image": "assets/img1/img/p_achi.png", "name": "Achievement", "tag": "2"},
    {
      "image": "assets/img1/img/p_activity.png",
      "name": "Activity History",
      "tag": "3"
    },
    {
      "image": "assets/img1/img/p_workout.png",
      "name": "Workout Progress",
      "tag": "4"
    },
    {
      "image": "assets/img1/img/p_contact.png",
      "name": "Contact Us",
      "tagi": "5"
    },
    {
      "image": "assets/img1/img/p_privacy.png",
      "name": "Privacy Policy",
      "tagi": "6"
    },
    {"image": "assets/img1/img/p_setting.png", "name": "Setting", "tagi": "7"},
  ];
  final AuthService _auth = AuthService();
  User? user;
  DocumentReference<Map<String, dynamic>>? userDoc;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      //  / Points to the 'user_info' document with the user's UID as the document ID.
      userDoc =
          FirebaseFirestore.instance.collection('user_info').doc(user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DietList()),
                );
              },
              icon: const Icon(Icons.more))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ///////information detail section////
              FutureBuilder<Map<String, dynamic>?>(
                future: _auth.fetchUserData(userDoc),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data != null) {
                    var userData = snapshot.data!;
                    return Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                "assets/img1/img/sugar.png",
                                width: 60,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${userData['name']}",
                                        style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${userData['last_name']}",
                                        style: TextStyle(
                                          color: TColor.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${userData['email']}",
                                    style: TextStyle(
                                      color: TColor.gray,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   width: 70,
                            //   height: 25,
                            //   child: RoundButton(
                            //     title: "Edit",
                            //     type: RoundButtonType.bgGradient,
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.w400,
                            //     onPressed: () {
                            //       navigatorKey.currentState?.push(
                            //         MaterialPageRoute(
                            //           builder: (context) => ManageProfile(
                            //             name: '${userData['name']}',
                            //             frontLetter:
                            //                 userData['name'][0].toUpperCase(),
                            //             email: userData['email'],
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // )
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TitleSubtitleCell(
                                title: "${userData['height']}",
                                subtitle: "Height",
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: TitleSubtitleCell(
                                title: "${userData['weight']}",
                                subtitle: "Weight",
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: TitleSubtitleCell(
                                title: "${userData['age']}",
                                subtitle: "Age",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        ////////ACCOUNT////////

                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 2)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Account ",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              //  /Inside ListView.builder
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: otherArr.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> iObj = otherArr[index];

                                  return SettingRow(
                                    icon: iObj["image"].toString(),
                                    title: iObj["name"].toString(),
                                    onPressed: () {
                                      // Handle navigation based on the tag
                                      switch (iObj["tagi"]) {
                                        case "1": // Navigate to Contact Us
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ActivityTracker()),
                                          );
                                        case "2": // Navigate to Contact Us
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ActivityTracker()),
                                          );
                                        case "3": // Navigate to Contact Us
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ActivityTracker()),
                                          );
                                        case "4": // Navigate to Contact Us
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ActivityTracker()),
                                          );
                                          break;
                                        case "5": // Navigate to Contact Us
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ContactUsPage()),
                                          );
                                          break;
                                        case "6": // Navigate to Privacy Policy
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PrivacyPolicyPage()),
                                          );
                                          break;
                                        case "7": // Navigate to Settings
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ManageProfile(
                                                name: '${userData['name']}',
                                                frontLetter: userData['name'][0]
                                                    .toUpperCase(),
                                                email: userData['email'],
                                              ),
                                            ),
                                          );

                                          break;
                                        default:
                                          // Handle unmatched cases
                                          break;
                                      }
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text("No user data found.");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
