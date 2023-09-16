// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_producer.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarProducerCollection on Isar {
  IsarCollection<IsarProducer> get isarProducers => this.collection();
}

const IsarProducerSchema = CollectionSchema(
  name: r'IsarProducer',
  id: 888877889967724312,
  properties: {},
  estimateSize: _isarProducerEstimateSize,
  serialize: _isarProducerSerialize,
  deserialize: _isarProducerDeserialize,
  deserializeProp: _isarProducerDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _isarProducerGetId,
  getLinks: _isarProducerGetLinks,
  attach: _isarProducerAttach,
  version: '3.1.0+1',
);

int _isarProducerEstimateSize(
  IsarProducer object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _isarProducerSerialize(
  IsarProducer object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {}
IsarProducer _isarProducerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarProducer(
    id: id,
  );
  return object;
}

P _isarProducerDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarProducerGetId(IsarProducer object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarProducerGetLinks(IsarProducer object) {
  return [];
}

void _isarProducerAttach(
    IsarCollection<dynamic> col, Id id, IsarProducer object) {
  object.id = id;
}

extension IsarProducerQueryWhereSort
    on QueryBuilder<IsarProducer, IsarProducer, QWhere> {
  QueryBuilder<IsarProducer, IsarProducer, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarProducerQueryWhere
    on QueryBuilder<IsarProducer, IsarProducer, QWhereClause> {
  QueryBuilder<IsarProducer, IsarProducer, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarProducer, IsarProducer, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<IsarProducer, IsarProducer, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarProducer, IsarProducer, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarProducer, IsarProducer, QAfterWhereClause> idBetween(
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
}

extension IsarProducerQueryFilter
    on QueryBuilder<IsarProducer, IsarProducer, QFilterCondition> {
  QueryBuilder<IsarProducer, IsarProducer, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarProducer, IsarProducer, QAfterFilterCondition> idGreaterThan(
    Id value, {
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

  QueryBuilder<IsarProducer, IsarProducer, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<IsarProducer, IsarProducer, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
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
}

extension IsarProducerQueryObject
    on QueryBuilder<IsarProducer, IsarProducer, QFilterCondition> {}

extension IsarProducerQueryLinks
    on QueryBuilder<IsarProducer, IsarProducer, QFilterCondition> {}

extension IsarProducerQuerySortBy
    on QueryBuilder<IsarProducer, IsarProducer, QSortBy> {}

extension IsarProducerQuerySortThenBy
    on QueryBuilder<IsarProducer, IsarProducer, QSortThenBy> {
  QueryBuilder<IsarProducer, IsarProducer, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarProducer, IsarProducer, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension IsarProducerQueryWhereDistinct
    on QueryBuilder<IsarProducer, IsarProducer, QDistinct> {}

extension IsarProducerQueryProperty
    on QueryBuilder<IsarProducer, IsarProducer, QQueryProperty> {
  QueryBuilder<IsarProducer, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }
}
