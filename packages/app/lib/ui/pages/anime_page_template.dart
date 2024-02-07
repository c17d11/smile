import 'package:app/ui/pages/anime_response_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimePageTemplate<T extends ResponseView> extends ConsumerStatefulWidget {
  final T responseTemplate;
  const AnimePageTemplate(this.responseTemplate, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnimeSchedulePageState<T>();
}

class _AnimeSchedulePageState<T extends ResponseView>
    extends ConsumerState<AnimePageTemplate<T>> {
  final _scroll = ScrollController();
  int lastPage = 1;
  List<ResponseView> responses = [];

  void loadNextResponse() {
    ResponseView nextRes = responses.last.next();
    if (lastPage > (nextRes.page ?? 1)) {
      setState(() {
        responses.add(nextRes);
      });
    }
  }

  void addFirstResponse() {}

  @override
  void initState() {
    super.initState();

    responses = [
      widget.responseTemplate
          .copyWith(page: 1, updateLastPage: (int page) => lastPage = page)
    ];

    _scroll.addListener(() {
      if (_scroll.offset >= _scroll.position.maxScrollExtent) {
        loadNextResponse();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentTotal <
              MediaQuery.of(context).size.height) {
            loadNextResponse();
          }
          return false;
        },
        child: CustomScrollView(
          controller: _scroll,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[...responses],
        ),
      ),
    );
  }
}

abstract class ResponseView extends ConsumerWidget with AnimeResponseViewUtils {
  final int? page;
  final Function(int)? updateLastPage;
  ResponseView({super.key, this.page, this.updateLastPage});

  ResponseView copyWith({page, updateLastPage});
  ResponseView next();
}
