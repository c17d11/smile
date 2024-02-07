import 'package:app/ui/routes/home/pages/about/state.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final Color _foregroundSecondary = Colors.grey[400]!;
final Color _foregroundThird = Colors.grey[600]!;

const String _ABOUT = """
The purpose of the app is to provide a simple way to browse animes and store some personal notes about the animes.
""";

const String _ABOUT_JIKAN_API = """
Jikan API (https://docs.api.jikan.moe/) is an unofficial MyAnimeList API that scrapes the MyAnimeList website and exposes an API.

Since the webscraping isn't done per request there might be a information on MyAnimeList that not yet have to be scraped to be available in the API.

Therefore, new animes added to MyAnimeList will not be available immediately in this app.

This app uses only a subset of the Jikan API. This might be expanded in the future.
""";

const String _LIMITATIONS = """
The Jikan API rate limits how often the requests to the API can be made. These are 60 requests per minute and 3 requests per second.

This means that sometimes the requests might take a little longer.
""";

const String _DATABASE = """
To facilitate the API, this app contains a local database that store the responses and reuses them if needed. This way the same request is not sent to the API.

But sometimes you might want to re-fetch the same request to see if the data has changes. This app uses a 24 hour cache of the requests by default. After those 24 hours a new request will be made to the API. This can be changed in the settings-page. 
""";

const String _PRODUCERS_GENRES = """
To search for animes by producers or genres requires to know the MalIDs of those producers and genres. This means that the informations about thos producers of genres need the be fetch from the API first.

Since the Jikan API do not like that the apps mass fetch data and store locally there is likely that when using this app you won't have all the producers or genres. To solve this issue the app contains separate pages for produers and genres, where the producers and genres can be fetch, and then later used in searching for animes.

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
                fontWeight: FontWeight.w800,
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
                fontWeight: FontWeight.w800,
                color: _foregroundThird,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "LIMITATIONS",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w800,
                color: _foregroundSecondary,
              ),
            ),
            const Divider(),
            Text(
              _LIMITATIONS,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w800,
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
                fontWeight: FontWeight.w800,
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
                fontWeight: FontWeight.w800,
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
                fontWeight: FontWeight.w800,
                color: _foregroundThird,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
