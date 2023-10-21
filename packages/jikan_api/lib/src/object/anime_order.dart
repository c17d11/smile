enum AnimeOrder {
  malId,
  title,
  startDate,
  endDate,
  episodes,
  score,
  scoredBy,
  rank,
  popularity,
  members,
  favorites,
}

extension AnimeOrderText on AnimeOrder {
  String get queryName {
    switch (this) {
      case AnimeOrder.malId:
        return "mal_id";
      case AnimeOrder.title:
        return "title";
      case AnimeOrder.startDate:
        return "start_date";
      case AnimeOrder.endDate:
        return "end_date";
      case AnimeOrder.episodes:
        return "episodes";
      case AnimeOrder.score:
        return "score";
      case AnimeOrder.scoredBy:
        return "scored_by";
      case AnimeOrder.rank:
        return "rank";
      case AnimeOrder.popularity:
        return "popularity";
      case AnimeOrder.members:
        return "members";
      case AnimeOrder.favorites:
        return "favorites";
    }
  }
}
