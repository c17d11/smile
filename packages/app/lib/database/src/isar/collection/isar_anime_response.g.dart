// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_anime_response.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarAnimeResponseCollection on Isar {
  IsarCollection<IsarAnimeResponse> get isarAnimeResponses => this.collection();
}

const IsarAnimeResponseSchema = CollectionSchema(
  name: r'IsarAnimeResponse',
  id: 3882575714011715493,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'expires': PropertySchema(
      id: 1,
      name: r'expires',
      type: IsarType.dateTime,
    ),
    r'q': PropertySchema(
      id: 2,
      name: r'q',
      type: IsarType.string,
    )
  },
  estimateSize: _isarAnimeResponseEstimateSize,
  serialize: _isarAnimeResponseSerialize,
  deserialize: _isarAnimeResponseDeserialize,
  deserializeProp: _isarAnimeResponseDeserializeProp,
  idName: r'id',
  indexes: {
    r'q': IndexSchema(
      id: -992931083124165738,
      name: r'q',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'q',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'isarAnimes': LinkSchema(
      id: 7231215793506359752,
      name: r'isarAnimes',
      target: r'IsarAnime',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _isarAnimeResponseGetId,
  getLinks: _isarAnimeResponseGetLinks,
  attach: _isarAnimeResponseAttach,
  version: '3.1.0+1',
);

int _isarAnimeResponseEstimateSize(
  IsarAnimeResponse object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.q.length * 3;
  return bytesCount;
}

void _isarAnimeResponseSerialize(
  IsarAnimeResponse object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeDateTime(offsets[1], object.expires);
  writer.writeString(offsets[2], object.q);
}

IsarAnimeResponse _isarAnimeResponseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarAnimeResponse(
    q: reader.readString(offsets[2]),
  );
  object.date = reader.readDateTimeOrNull(offsets[0]);
  object.expires = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  return object;
}

P _isarAnimeResponseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarAnimeResponseGetId(IsarAnimeResponse object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _isarAnimeResponseGetLinks(
    IsarAnimeResponse object) {
  return [object.isarAnimes];
}

void _isarAnimeResponseAttach(
    IsarCollection<dynamic> col, Id id, IsarAnimeResponse object) {
  object.id = id;
  object.isarAnimes
      .attach(col, col.isar.collection<IsarAnime>(), r'isarAnimes', id);
}

extension IsarAnimeResponseByIndex on IsarCollection<IsarAnimeResponse> {
  Future<IsarAnimeResponse?> getByQ(String q) {
    return getByIndex(r'q', [q]);
  }

  IsarAnimeResponse? getByQSync(String q) {
    return getByIndexSync(r'q', [q]);
  }

  Future<bool> deleteByQ(String q) {
    return deleteByIndex(r'q', [q]);
  }

  bool deleteByQSync(String q) {
    return deleteByIndexSync(r'q', [q]);
  }

  Future<List<IsarAnimeResponse?>> getAllByQ(List<String> qValues) {
    final values = qValues.map((e) => [e]).toList();
    return getAllByIndex(r'q', values);
  }

  List<IsarAnimeResponse?> getAllByQSync(List<String> qValues) {
    final values = qValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'q', values);
  }

  Future<int> deleteAllByQ(List<String> qValues) {
    final values = qValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'q', values);
  }

  int deleteAllByQSync(List<String> qValues) {
    final values = qValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'q', values);
  }

  Future<Id> putByQ(IsarAnimeResponse object) {
    return putByIndex(r'q', object);
  }

  Id putByQSync(IsarAnimeResponse object, {bool saveLinks = true}) {
    return putByIndexSync(r'q', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByQ(List<IsarAnimeResponse> objects) {
    return putAllByIndex(r'q', objects);
  }

  List<Id> putAllByQSync(List<IsarAnimeResponse> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'q', objects, saveLinks: saveLinks);
  }
}

extension IsarAnimeResponseQueryWhereSort
    on QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QWhere> {
  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarAnimeResponseQueryWhere
    on QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QWhereClause> {
  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterWhereClause>
      qEqualTo(String q) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'q',
        value: [q],
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterWhereClause>
      qNotEqualTo(String q) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'q',
              lower: [],
              upper: [q],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'q',
              lower: [q],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'q',
              lower: [q],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'q',
              lower: [],
              upper: [q],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarAnimeResponseQueryFilter
    on QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QFilterCondition> {
  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      dateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      dateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      dateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      dateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      expiresIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expires',
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      expiresIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expires',
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      expiresEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expires',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      expiresGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expires',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      expiresLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expires',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      expiresBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expires',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      qEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'q',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      qGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'q',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      qLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'q',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      qBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'q',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      qStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'q',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      qEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'q',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      qContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'q',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      qMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'q',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      qIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'q',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      qIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'q',
        value: '',
      ));
    });
  }
}

extension IsarAnimeResponseQueryObject
    on QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QFilterCondition> {}

extension IsarAnimeResponseQueryLinks
    on QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QFilterCondition> {
  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      isarAnimes(FilterQuery<IsarAnime> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'isarAnimes');
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      isarAnimesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'isarAnimes', length, true, length, true);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      isarAnimesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'isarAnimes', 0, true, 0, true);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      isarAnimesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'isarAnimes', 0, false, 999999, true);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      isarAnimesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'isarAnimes', 0, true, length, include);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      isarAnimesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'isarAnimes', length, include, 999999, true);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterFilterCondition>
      isarAnimesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'isarAnimes', lower, includeLower, upper, includeUpper);
    });
  }
}

extension IsarAnimeResponseQuerySortBy
    on QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QSortBy> {
  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy>
      sortByExpires() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expires', Sort.asc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy>
      sortByExpiresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expires', Sort.desc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy> sortByQ() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'q', Sort.asc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy>
      sortByQDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'q', Sort.desc);
    });
  }
}

extension IsarAnimeResponseQuerySortThenBy
    on QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QSortThenBy> {
  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy>
      thenByExpires() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expires', Sort.asc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy>
      thenByExpiresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expires', Sort.desc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy> thenByQ() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'q', Sort.asc);
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QAfterSortBy>
      thenByQDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'q', Sort.desc);
    });
  }
}

extension IsarAnimeResponseQueryWhereDistinct
    on QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QDistinct> {
  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QDistinct>
      distinctByExpires() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expires');
    });
  }

  QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QDistinct> distinctByQ(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'q', caseSensitive: caseSensitive);
    });
  }
}

extension IsarAnimeResponseQueryProperty
    on QueryBuilder<IsarAnimeResponse, IsarAnimeResponse, QQueryProperty> {
  QueryBuilder<IsarAnimeResponse, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarAnimeResponse, DateTime?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<IsarAnimeResponse, DateTime?, QQueryOperations>
      expiresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expires');
    });
  }

  QueryBuilder<IsarAnimeResponse, String, QQueryOperations> qProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'q');
    });
  }
}
