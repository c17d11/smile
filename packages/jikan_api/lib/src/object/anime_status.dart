// abstract class AnimeStatus {
//   String get code;
//   String get text;
// }

// class StatusAiring implements AnimeStatus {
//   @override
//   String get code => "airing";

//   @override
//   String get text => "Airing";
// }

// class StatusComplete implements AnimeStatus {
//   @override
//   String get code => "complete";

//   @override
//   String get text => "Complete";
// }

// class StatusUpcoming implements AnimeStatus {
//   @override
//   String get code => "upcoming";

//   @override
//   String get text => "Upcoming";
// }

enum AnimeStatus { airing, complete, upcoming }

extension AnimeStatusText on AnimeStatus {
  String get capitalize => name[0].toUpperCase() + name.substring(1);
  String get lowerCase => name.toLowerCase();
}
