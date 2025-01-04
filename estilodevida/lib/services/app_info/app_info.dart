import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  late final PackageInfo packageInfo;
  static final AppInfo _instance = AppInfo._privateConstructor();
  AppInfo._privateConstructor();

  factory AppInfo() {
    return _instance;
  }

  init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  String getAppVersion() {
    return packageInfo.version;
  }
}
