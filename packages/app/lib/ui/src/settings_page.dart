import 'package:app/controller/src/object/settings_intern.dart';
import 'package:app/database/src/database_base.dart';
import 'package:app/ui/selection_widget/src/confirm_button.dart';
import 'package:app/ui/src/pod.dart';
import 'package:app/ui/src/slider_select.dart';
import 'package:app/ui/src/text_divider.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.read(settingsPod);
    Settings localSettings = Settings.from(settings);

    Widget buildRateLimitSecondsWidget(Settings s) {
      return SliderSelect(
        "Requests per Second",
        """Limits the number of requests that can be made per second.
        The limit should not exceed the limit of the jikan api.""",
        (s.apiSettings.requestsPerSecond!).toDouble(),
        stepSize: 1,
        showInts: true,
        min: 1,
        max: 3,
        onChanged: (value) {
          if (value == null) {
            s.apiSettings.requestsPerSecond = 3;
          } else {
            s.apiSettings.requestsPerSecond = value.toInt();
          }
        },
      );
    }

    Widget buildRateLimitMinuteWidget(Settings s) {
      return SliderSelect(
        "Requests per Minute",
        """Limits the number of requests that can be made per minute.
        The limit should not exceed the limit of the jikan api.""",
        (s.apiSettings.requestsPerMinute!).toDouble(),
        stepSize: 1,
        showInts: true,
        min: 1,
        max: 60,
        onChanged: (value) {
          if (value == null) {
            s.apiSettings.requestsPerMinute = 60;
          } else {
            s.apiSettings.requestsPerMinute = value.toInt();
          }
        },
      );
    }

    Widget buildDatabaseCacheLimitWidget(Settings s) {
      return SliderSelect(
        "Cache Expiration (Hours)",
        """The number of hours before stored cached is invalid and needs to be refetched.""",
        (s.dbSettings.cacheTimeoutHours!).toDouble(),
        stepSize: 1,
        showInts: true,
        min: 0,
        max: 72,
        onChanged: (value) {
          if (value == null) {
            s.dbSettings.cacheTimeoutHours = 24;
          } else {
            s.dbSettings.cacheTimeoutHours = value.toInt();
          }
        },
      );
    }

    Widget buildStatisticsMenuRow() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 10, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextHeadline("Database actions".toUpperCase()),
          ],
        ),
      );
    }

    Widget buildStatisticsContentRow() {
      Database db = ref.watch(databasePod);

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ConfirmButton(
              title: "Drop database",
              description: "Remove all data stored in the database.",
              onConfirm: () {
                db.remove();
              },
            ),
            FutureBuilder(
                future: db.getDatabaseSize(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return TextHeadline("Error: ${snapshot.error}");
                  }
                  if (snapshot.hasData) {
                    return TextHeadline("Database size: ${snapshot.data}");
                  }
                  return const CircularProgressIndicator();
                }),
          ],
        ),
      );
    }

    Widget buildStatistics() {
      return Container(
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildStatisticsMenuRow(),
              buildStatisticsContentRow(),
              const SizedBox(height: 10),
            ],
          ));
    }

    Widget buildAboutWidget() {
      AsyncValue<PackageInfo> info = ref.watch(packageInfoPod);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          switch (info) {
            AsyncData(:final value) => value.buildNumber == ""
                ? TextHeadline("Version: ${value.version}")
                : TextHeadline(
                    "Version: ${value.version}+${value.buildNumber}"),
            AsyncError(:final error) => TextHeadline("$error"),
            _ => const CircularProgressIndicator(),
          }
        ],
      );
    }

    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const TextDivider("About"),
                      buildAboutWidget(),
                      const TextDivider("Api"),
                      buildRateLimitSecondsWidget(localSettings),
                      buildRateLimitMinuteWidget(localSettings),
                      const TextDivider("Database"),
                      buildDatabaseCacheLimitWidget(localSettings),
                      buildStatistics(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green[200],
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  ref.read(settingsPod.notifier).set(localSettings);
                },
                child: TextHeadline("Apply".toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
