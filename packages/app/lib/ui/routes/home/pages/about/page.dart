import 'package:app/ui/routes/home/pages/about/state.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final Color _foregroundSecondary = Colors.grey[400]!;
final Color _foregroundThird = Colors.grey[600]!;

const String _ABOUT = """
The purpose of this app is to provide a simple way to browse animes and store some personal notes about the animes.
""";

const String _ABOUT_JIKAN_API = """
All data comes from the Jikan API (https://docs.api.jikan.moe/), which is an unofficial MyAnimeList API that scrapes the MyAnimeList website.

This app uses only a subset of the Jikan API. This might be expanded in the future.
""";

const String _RATE_LIMITS = """
The Jikan API rate limits how often the requests to the API can be made. These are 60 requests per minute and 3 requests per second.

This means that sometimes the requests might take a little longer.

Despite using the specified rate limits, it is still possible to be rate limited by MyAnimeList.net. If this happen just reload the page after a while.

This app provides settings to lower the request rates.
""";

const String _DATABASE = """
To reduce the requests sent to the API, this app contains a local database that store the responses and reuses them if needed. This way the same request is not sent to the API.

This app uses a 24 hour cache of the requests by default. After those 24 hours a new request will be made to the API and the local database is updated.

This can be changed in the settings-page. 
""";

const String _PRODUCERS_GENRES = """
To search animes by producers or genres requires the MalIDs of those producers and genres. This means that the informations about those producers of genres need the be fetch from the API first.

Since the Jikan API do not like that the apps mass fetch data and store locally there is likely that when using this app you won't have all the producers or genres. To solve this issue the app contains separate pages for produers and genres, where the producers and genres can be fetch.

Due to limitations of the API the producers can only be search by letter and not words.
""";

const String _SCHEDULE = """
The schedule page only contains the current airing season.
""";

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<PackageInfo> info = ref.watch(packageInfoPod);

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundColor: Color.fromARGB(255, 161, 202, 200),
                  child: ClipOval(
                    child: Image(
                        image:
                            AssetImage("assets/icon/smile-no-background.png"),
                        fit: BoxFit.fill),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  switch (info) {
                    AsyncData(:final value) => value.buildNumber == ""
                        ? TextFields("Version: ${value.version}")
                        : TextFields(
                            "Version: ${value.version}+${value.buildNumber}"),
                    AsyncError(:final error) => TextFields("$error"),
                    _ => const CircularProgressIndicator(),
                  },
                ]),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              _ABOUT,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: _foregroundThird,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "JIKAN API",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
                color: _foregroundSecondary,
              ),
            ),
            const Divider(),
            Text(
              _ABOUT_JIKAN_API,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: _foregroundThird,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "RATE LIMITS",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
                color: _foregroundSecondary,
              ),
            ),
            const Divider(),
            Text(
              _RATE_LIMITS,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: _foregroundThird,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "DATABASE",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
                color: _foregroundSecondary,
              ),
            ),
            const Divider(),
            Text(
              _DATABASE,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: _foregroundThird,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "PRODUCERS & GENRES",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
                color: _foregroundSecondary,
              ),
            ),
            const Divider(),
            Text(
              _PRODUCERS_GENRES,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: _foregroundThird,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "SCHDEDULE",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
                color: _foregroundSecondary,
              ),
            ),
            const Divider(),
            Text(
              _SCHEDULE,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: _foregroundThird,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
