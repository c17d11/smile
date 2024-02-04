enum JikanAnimeSort { asc, desc }

extension AnimeSortText on JikanAnimeSort {
  String get queryName {
    switch (this) {
      case JikanAnimeSort.asc:
        return "asc";
      case JikanAnimeSort.desc:
        return "desc";
    }
  }
}
