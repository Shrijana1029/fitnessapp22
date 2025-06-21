import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/firebase_services/firebase_auth.dart';
import 'package:fitnessapp/screens/login_signup/change_password.dart';
import 'package:fitnessapp/screens/login_signup/edit_personalInfo.dart';
import 'package:fitnessapp/screens/login_signup/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';

class ManageProfile extends StatefulWidget {
  String name;
  String frontLetter;
  String email;
  ManageProfile(
      {super.key,
      required this.name,
      required this.email,
      required this.frontLetter});

  @override
  State<ManageProfile> createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  final AuthService _auth = AuthService();
  User? user;
  DocumentReference<Map<String, dynamic>>? userDoc;
  // late String userId;
  // void _deleteAccountAndLogout() async {
  //   try {
  //     // Delete user data from Firestore
  //     if (userDoc != null) {
  //       await userDoc!.delete();
  //     }

  //     // Delete the user from Firebase Authentication
  //     final currentUser = FirebaseAuth.instance.currentUser;
  //     if (currentUser != null) {
  //       await currentUser.delete();
  //     }

  //     // Clear local data (e.g., SharedPreferences)
  //     final SharedPreferences sharedPreferences =
  //         await SharedPreferences.getInstance();
  //     await sharedPreferences.clear();

  //     await sharedPreferences.remove('email');
  //     AuthService.logout();
  //     // Navigate to Login Page
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => const LoginPage()),
  //       (Route<dynamic> route) => false, // Remove all previous routes
  //     );
  //     ();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Account removed!")),
  //     );
  //   } catch (e) {
  //     // Handle errors (e.g., re-authentication required)
  //     if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text(
  //             "Re-authentication required to delete the account. Please log in again.",
  //           ),
  //         ),
  //       );
  //       // Optionally, navigate to the login page for re-authentication
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Error deleting account: ${e.toString()}"),
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  //stores the uid of logged-in user
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
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.messenger)),
        ],
        backgroundColor: const Color.fromARGB(255, 184, 216, 201),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blue,
                              child: Text(
                                widget.frontLetter ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EditPersonalinfo()));
                              },
                              child: const Positioned(
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      Center(
                        child: Text(
                          widget.name ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Center(
                        child: Text(widget.email),
                      )
                      // Add more fields as necessary
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {},
                  child: buildListTile(
                    icon: Icons.info_outline,
                    title: 'Account Information',
                    subtitle: 'View and edit your account information',
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigate to the change password screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ChangePasswordScreen()));
                  },
                  child: buildListTile(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: 'Change or reset your account password',
                  ),
                ),
                /////////delete user account
                InkWell(
                  onTap: () async {
                    ///first delete the firestore then only authentication
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm Action"),
                          content: const Text(
                              "Are you sure you want to delete your account?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  // Delete user data from Firestore
                                  if (userDoc != null) {
                                    await userDoc!.delete();
                                  }

                                  // Delete the user from Firebase Authentication
                                  final currentUser =
                                      FirebaseAuth.instance.currentUser;
                                  if (currentUser != null) {
                                    await currentUser.delete();
                                  }

                                  // Clear local data (e.g., SharedPreferences)
                                  final SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  await sharedPreferences.clear();

                                  await sharedPreferences.remove('email');
                                  AuthService.logout();
                                  // Navigate to Login Page
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                    (Route<dynamic> route) =>
                                        false, // Remove all previous routes
                                  );
                                  ();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Account removed!")),
                                  );
                                } catch (e) {
                                  // Handle errors (e.g., re-authentication required)
                                  if (e is FirebaseAuthException &&
                                      e.code == 'requires-recent-login') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Re-authentication required to delete the account. Please log in again.",
                                        ),
                                      ),
                                    );
                                    // Optionally, navigate to the login page for re-authentication
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Error deleting account: ${e.toString()}"),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text("Confirm"),
                            ),
                          ],
                        );
                      },
                    );

                    // Navigate after the deletion
                  },
                  child: buildListTile(
                    icon: Icons.delete_forever,
                    title: 'Delete Account',
                    subtitle:
                        'Permanently remove your account and all of its content',
                    titleColor: Colors.red,
                    subtitleColor: Colors.red,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Theme.of(context).primaryColorDark,
                          title: const Text("Confirm Action"),
                          content: const Text(
                              "Are you sure you want to logout your account?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                final SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                await sharedPreferences.remove('email');
                                AuthService.logout();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (Route<dynamic> route) =>
                                      false, // Remove all previous routes
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("User logged out!!")),
                                );
                              },
                              // Add your confirm action logic here

                              // Navigator.of(context).pop(); // Close the dialog

                              child: const Text("Confirm"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: buildListTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Sign out from this device',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? titleColor,
    Color? subtitleColor,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: titleColor ?? Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: subtitleColor ?? Colors.grey,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  }
}
