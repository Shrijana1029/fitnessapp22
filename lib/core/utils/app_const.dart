import 'dart:io' show Platform;
import 'package:package_info_plus/package_info_plus.dart';

class AppConst {
  static const userAgentAppName = "FitTrack";
  static const platformNameAndroid = "Android";
  static const platformNameIOS = "iOS";
  static const reportErrorEmail = "epayment2423@gmail.com";
  static const sourceCodeUrl =
      "https://github.com/geniusdude1012/fitnessapp.git";

  static Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static String getPlatformName() {
    if (Platform.isAndroid) {
      return platformNameAndroid;
    } else if (Platform.isIOS) {
      return platformNameIOS;
    } else {
      return "";
    }
  }

  static Future<String> getUserAgentString() async {
    final versionNumber = await getVersionNumber();
    final platformVersion = getPlatformName();
    return '$userAgentAppName - $platformVersion - Version $versionNumber - $sourceCodeUrl';
  }
}
