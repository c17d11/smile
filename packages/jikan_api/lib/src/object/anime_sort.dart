enum AnimeSort { asc, desc }

extension AnimeSortText on AnimeSort {
  String get queryName {
    switch (this) {
      case AnimeSort.asc:
        return "asc";
      case AnimeSort.desc:
        return "desc";
    }
  }
}
