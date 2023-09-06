import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/src/anime_list.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return const SizedBox(
        child: Text("Not mounted"),
      );
    }
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite)),
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.schedule)),
            ],
          ),
          toolbarHeight: 0,
        ),
        body: const TabBarView(
          children: [
            SizedBox(child: Text("Yo1")),
            AnimeList(),
            SizedBox(child: Text("Yo3")),
          ],
        ),
      ),
    );
  }
}
