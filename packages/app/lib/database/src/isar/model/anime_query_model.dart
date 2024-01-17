import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:app/database/src/isar/collection/isar_genre.dart';
import 'package:app/database/src/isar/collection/isar_producer.dart';
import 'package:app/database/src/isar/collection/isar_anime_query.dart';
import 'package:app/database/src/isar/collection/isar_tag.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';

class IsarAnimeQueryModel extends IsarModel implements AnimeQueryModel {
  IsarAnimeQueryModel(super.db, {required super.expirationHours});

  @override
  Future<AnimeQueryIntern?> getAnimeQuery() async {
    IsarAnimeQuery? query;
    await read(() async {
      query = await db.isarAnimeQuerys.where().findFirst();
    });
    query?.type = query?.isarType;
    query?.rating = query?.isarRating;
    query?.status = query?.isarStatus;
    query?.orderBy = query?.isarOrder;
    query?.sort = query?.isarSort;
    query?.producers = query?.isarProducers.toList();
    query?.genresInclude = query?.isarGenresInclude.toList();
    query?.genresExclude = query?.isarGenresExclude.toList();
    query?.tag = query?.isarTag.value?.toTag();
    return query;
  }

  @override
  Future<void> updateAnimeQuery(AnimeQueryIntern query) async {
    IsarAnimeQuery isarQuery = IsarAnimeQuery.from(query);

    List<IsarProducer> producers =
        isarQuery.producers?.map((e) => IsarProducer.from(e)).toList() ?? [];
    List<IsarGenre> genresInclude =
        isarQuery.genresInclude?.map((e) => IsarGenre.from(e)).toList() ?? [];
    List<IsarGenre> genresExclude =
        isarQuery.genresExclude?.map((e) => IsarGenre.from(e)).toList() ?? [];
    IsarTag? tag =
        isarQuery.tag != null ? IsarTag.fromTag(isarQuery.tag!) : null;

    await write(() async {
      if (producers.isNotEmpty) {
        await db.isarProducers.putAll(producers);
        isarQuery.isarProducers.addAll(producers);
      }
      if (genresInclude.isNotEmpty) {
        await db.isarGenres.putAll(genresInclude);
        isarQuery.isarGenresInclude.addAll(genresInclude);
      }
      if (genresExclude.isNotEmpty) {
        await db.isarGenres.putAll(genresExclude);
        isarQuery.isarGenresExclude.addAll(genresExclude);
      }
      if (tag != null) {
        await db.isarTags.put(tag);
      }
      await db.isarAnimeQuerys.put(isarQuery);
      await isarQuery.isarProducers.save();
      await isarQuery.isarGenresInclude.save();
      await isarQuery.isarGenresExclude.save();
      await isarQuery.isarTag.save();
    });
  }
}
