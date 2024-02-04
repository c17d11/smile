enum JikanAnimeOrder {
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

extension AnimeOrderText on JikanAnimeOrder {
  String get queryName {
    switch (this) {
      case JikanAnimeOrder.malId:
        return "mal_id";
      case JikanAnimeOrder.title:
        return "title";
      case JikanAnimeOrder.startDate:
        return "start_date";
      case JikanAnimeOrder.endDate:
        return "end_date";
      case JikanAnimeOrder.episodes:
        return "episodes";
      case JikanAnimeOrder.score:
        return "score";
      case JikanAnimeOrder.scoredBy:
        return "scored_by";
      case JikanAnimeOrder.rank:
        return "rank";
      case JikanAnimeOrder.popularity:
        return "popularity";
      case JikanAnimeOrder.members:
        return "members";
      case JikanAnimeOrder.favorites:
        return "favorites";
    }
  }
}
