import 'package:flutter/material.dart';

class TColor {
  //get, to make it look like property of Tcolor class,, for easy use without function, it return value
  //static, can access property without making object of class
  static Color get primaryColor1 => const Color(0xff92A3FD);
  static Color get primaryColor2 => const Color(0xff9DCEFF);

  static Color get secondaryColor1 => const Color(0xffC58BF2);
  static Color get secondaryColor2 => const Color(0xffEEA4CE);

  static List<Color> get primaryG => [primaryColor2, primaryColor1];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];

  static Color get black => const Color(0xff1D1617);
  static Color get gray => const Color(0xff786F72);
  static Color get white => Colors.white;
  static Color get lightGray => const Color(0xffF7F8F8);

  // static void sendNotification() {
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //         id: 1,
  //         channelKey: 'basic',
  //         title: 'Reminder',
  //         body: 'Drink Water  ',
  //         notificationLayout: NotificationLayout.Default),
  //   );
  // }
}
