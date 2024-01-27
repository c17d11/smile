import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoPod = FutureProvider<PackageInfo>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return info;
});
