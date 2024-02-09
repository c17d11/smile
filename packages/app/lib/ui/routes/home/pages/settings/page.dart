import 'dart:math';

import 'package:app/object/anime_response.dart';
import 'package:app/object/settings.dart';
import 'package:app/database/src/interface/database.dart';
import 'package:app/ui/common/blank_slider_select.dart';
import 'package:app/ui/common/selection_widget/src/confirm_button.dart';
import 'package:app/ui/common/slider_select.dart';
import 'package:app/ui/common/text_divider.dart';
import 'package:app/ui/routes/home/common/anime_portrait.dart';
import 'package:app/ui/state/main.dart';
import 'package:app/ui/state/settings.dart';
import 'package:app/ui/style/colors.dart';
import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsPod);
    Future<AnimeResponse> res = ref
        .read(databasePod)
        .getLastResponse()
        .then((value) => value ?? AnimeResponse());
    return _SettingsPage(settings: settings.copy(), res: res);
  }
}

class _SettingsPage extends ConsumerStatefulWidget {
  final Settings settings;
  final Future<AnimeResponse> res;
  const _SettingsPage({super.key, required this.settings, required this.res});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<_SettingsPage> {
  late Settings localSettings;

  @override
  void initState() {
    super.initState();
    localSettings = widget.settings;
  }

  @override
  Widget build(BuildContext context) {
    Widget buildRateLimitWidget() {
      return MultiSliver(pushPinnedChildren: true, children: <Widget>[
        SliverPinnedHeader(
          child: Container(
              color: Theme.of(context).colorScheme.background,
              child: const TextDivider("Api")),
        ),
        SliverToBoxAdapter(
          child: SliderSelect(
            "Requests per Second",
            "Limits the number of requests that can be made per second.",
            localSettings.apiSettings.requestsPerSecond.toDouble(),
            stepSize: 1,
            showInts: true,
            hideReset: true,
            min: 1,
            max: 3,
            onChanged: (value) {
              if (value != null) {
                localSettings.apiSettings.requestsPerSecond = value.toInt();
              }
            },
          ),
        ),
        SliverToBoxAdapter(
          child: SliderSelect(
            "Requests per Minute",
            "Limits the number of requests that can be made per minute.",
            localSettings.apiSettings.requestsPerMinute.toDouble(),
            stepSize: 1,
            showInts: true,
            hideReset: true,
            min: 1,
            max: 60,
            onChanged: (value) {
              if (value != null) {
                localSettings.apiSettings.requestsPerMinute = value.toInt();
              }
            },
          ),
        ),
      ]);
    }

    Widget buildDatabaseWidget() {
      return MultiSliver(
        pushPinnedChildren: true,
        children: <Widget>[
          SliverPinnedHeader(
            child: Container(
                color: Theme.of(context).colorScheme.background,
                child: const TextDivider("Database")),
          ),
          SliverToBoxAdapter(
            child: SliderSelect(
              "Cache Expiration (Hours)",
              """The number of hours before stored cached is invalid and needs to be refetched.""",
              localSettings.dbSettings.cacheTimeoutHours.toDouble(),
              stepSize: 1,
              showInts: true,
              hideReset: true,
              min: 0,
              max: 72,
              onChanged: (value) {
                if (value != null) {
                  localSettings.dbSettings.cacheTimeoutHours = value.toInt();
                }
              },
            ),
          ),
        ],
      );
    }

    Widget buildStatisticsContentRow() {
      Database db = ref.watch(databasePod);

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
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
      return MultiSliver(
        pushPinnedChildren: true,
        children: <Widget>[
          SliverToBoxAdapter(child: buildStatisticsContentRow()),
        ],
      );
    }

    Widget buildViewSettings(BuildContext context) {
      return MultiSliver(
        pushPinnedChildren: true,
        children: <Widget>[
          SliverPinnedHeader(
            child: Container(
                color: Theme.of(context).colorScheme.background,
                child: const TextDivider("View settings")),
          ),
          SliverToBoxAdapter(
            child: SliderSelect(
              "Anime width",
              "How many animes per row.",
              localSettings.viewSettings.animePerDeviceWidth.toDouble(),
              stepSize: 1,
              showInts: true,
              hideReset: true,
              min: 1,
              max: min(10, MediaQuery.of(context).size.width / 75),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    localSettings.viewSettings.animePerDeviceWidth =
                        value.toInt();
                  });
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: BlankSliderSelect(
              "Anime ratio",
              "Ratio of the image displayed for each anime.",
              localSettings.viewSettings.animeRatio,
              stepSize: 0.05,
              showInts: false,
              min: 0.5,
              max: 2,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    localSettings.viewSettings.animeRatio = value;
                  });
                }
              },
            ),
          ),
          FutureBuilder<AnimeResponse>(
            future: widget.res,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: snapshot.data?.animes?.length,
                    (context, index) => AnimePortrait(
                      snapshot.data?.animes?[index],
                      heroId: "$index",
                      onAnimeUpdate: (_) {},
                      stopNavigation: true,
                    ),
                  ),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width /
                        localSettings.viewSettings.animePerDeviceWidth,
                    childAspectRatio: localSettings.viewSettings.animeRatio,
                  ),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                    child: Center(
                        child: Text("Error", style: AppTextStyle.small)));
              }
              return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()));
            },
          ),
        ],
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await ref.read(settingsPod.notifier).set(localSettings).then(
              (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Saved"),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    duration: const Duration(milliseconds: 250),
                    behavior: SnackBarBehavior.floating,
                  )));
        },
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            buildRateLimitWidget(),
            buildDatabaseWidget(),
            buildStatistics(),
            buildViewSettings(context),
            const SliverToBoxAdapter(child: SizedBox(height: 100))
          ]),
    );
  }
}
