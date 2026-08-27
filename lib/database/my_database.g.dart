// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_database.dart';

// ignore_for_file: type=lint
class $UnsentTableTable extends UnsentTable
    with TableInfo<$UnsentTableTable, Unsent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnsentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _unsentIdMeta =
      const VerificationMeta('unsentId');
  @override
  late final GeneratedColumn<int> unsentId = GeneratedColumn<int>(
      'unsent_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _unsentDateTimeMeta =
      const VerificationMeta('unsentDateTime');
  @override
  late final GeneratedColumn<int> unsentDateTime = GeneratedColumn<int>(
      'unsent_date_time', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unsentTypeMeta =
      const VerificationMeta('unsentType');
  @override
  late final GeneratedColumn<String> unsentType = GeneratedColumn<String>(
      'unsent_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unsentDataMeta =
      const VerificationMeta('unsentData');
  @override
  late final GeneratedColumn<String> unsentData = GeneratedColumn<String>(
      'unsent_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unsentTitleMeta =
      const VerificationMeta('unsentTitle');
  @override
  late final GeneratedColumn<String> unsentTitle = GeneratedColumn<String>(
      'unsent_title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [unsentId, unsentDateTime, unsentType, unsentData, unsentTitle];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unsent_table';
  @override
  VerificationContext validateIntegrity(Insertable<Unsent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('unsent_id')) {
      context.handle(_unsentIdMeta,
          unsentId.isAcceptableOrUnknown(data['unsent_id']!, _unsentIdMeta));
    }
    if (data.containsKey('unsent_date_time')) {
      context.handle(
          _unsentDateTimeMeta,
          unsentDateTime.isAcceptableOrUnknown(
              data['unsent_date_time']!, _unsentDateTimeMeta));
    } else if (isInserting) {
      context.missing(_unsentDateTimeMeta);
    }
    if (data.containsKey('unsent_type')) {
      context.handle(
          _unsentTypeMeta,
          unsentType.isAcceptableOrUnknown(
              data['unsent_type']!, _unsentTypeMeta));
    } else if (isInserting) {
      context.missing(_unsentTypeMeta);
    }
    if (data.containsKey('unsent_data')) {
      context.handle(
          _unsentDataMeta,
          unsentData.isAcceptableOrUnknown(
              data['unsent_data']!, _unsentDataMeta));
    } else if (isInserting) {
      context.missing(_unsentDataMeta);
    }
    if (data.containsKey('unsent_title')) {
      context.handle(
          _unsentTitleMeta,
          unsentTitle.isAcceptableOrUnknown(
              data['unsent_title']!, _unsentTitleMeta));
    } else if (isInserting) {
      context.missing(_unsentTitleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {unsentId};
  @override
  Unsent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unsent.fromDb(
      unsentTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unsent_title'])!,
      unsentData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unsent_data'])!,
      unsentDateTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unsent_date_time'])!,
      unsentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unsent_type'])!,
    );
  }

  @override
  $UnsentTableTable createAlias(String alias) {
    return $UnsentTableTable(attachedDatabase, alias);
  }
}

class UnsentTableCompanion extends UpdateCompanion<Unsent> {
  final Value<int> unsentId;
  final Value<int> unsentDateTime;
  final Value<String> unsentType;
  final Value<String> unsentData;
  final Value<String> unsentTitle;
  const UnsentTableCompanion({
    this.unsentId = const Value.absent(),
    this.unsentDateTime = const Value.absent(),
    this.unsentType = const Value.absent(),
    this.unsentData = const Value.absent(),
    this.unsentTitle = const Value.absent(),
  });
  UnsentTableCompanion.insert({
    this.unsentId = const Value.absent(),
    required int unsentDateTime,
    required String unsentType,
    required String unsentData,
    required String unsentTitle,
  })  : unsentDateTime = Value(unsentDateTime),
        unsentType = Value(unsentType),
        unsentData = Value(unsentData),
        unsentTitle = Value(unsentTitle);
  static Insertable<Unsent> custom({
    Expression<int>? unsentId,
    Expression<int>? unsentDateTime,
    Expression<String>? unsentType,
    Expression<String>? unsentData,
    Expression<String>? unsentTitle,
  }) {
    return RawValuesInsertable({
      if (unsentId != null) 'unsent_id': unsentId,
      if (unsentDateTime != null) 'unsent_date_time': unsentDateTime,
      if (unsentType != null) 'unsent_type': unsentType,
      if (unsentData != null) 'unsent_data': unsentData,
      if (unsentTitle != null) 'unsent_title': unsentTitle,
    });
  }

  UnsentTableCompanion copyWith(
      {Value<int>? unsentId,
      Value<int>? unsentDateTime,
      Value<String>? unsentType,
      Value<String>? unsentData,
      Value<String>? unsentTitle}) {
    return UnsentTableCompanion(
      unsentId: unsentId ?? this.unsentId,
      unsentDateTime: unsentDateTime ?? this.unsentDateTime,
      unsentType: unsentType ?? this.unsentType,
      unsentData: unsentData ?? this.unsentData,
      unsentTitle: unsentTitle ?? this.unsentTitle,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (unsentId.present) {
      map['unsent_id'] = Variable<int>(unsentId.value);
    }
    if (unsentDateTime.present) {
      map['unsent_date_time'] = Variable<int>(unsentDateTime.value);
    }
    if (unsentType.present) {
      map['unsent_type'] = Variable<String>(unsentType.value);
    }
    if (unsentData.present) {
      map['unsent_data'] = Variable<String>(unsentData.value);
    }
    if (unsentTitle.present) {
      map['unsent_title'] = Variable<String>(unsentTitle.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnsentTableCompanion(')
          ..write('unsentId: $unsentId, ')
          ..write('unsentDateTime: $unsentDateTime, ')
          ..write('unsentType: $unsentType, ')
          ..write('unsentData: $unsentData, ')
          ..write('unsentTitle: $unsentTitle')
          ..write(')'))
        .toString();
  }
}

class $DivisionTableTable extends DivisionTable
    with TableInfo<$DivisionTableTable, Division> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DivisionTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _divisionMeta =
      const VerificationMeta('division');
  @override
  late final GeneratedColumn<String> division = GeneratedColumn<String>(
      'division', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, division];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'division_table';
  @override
  VerificationContext validateIntegrity(Insertable<Division> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('division')) {
      context.handle(_divisionMeta,
          division.isAcceptableOrUnknown(data['division']!, _divisionMeta));
    } else if (isInserting) {
      context.missing(_divisionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Division map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Division.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      division: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}division'])!,
    );
  }

  @override
  $DivisionTableTable createAlias(String alias) {
    return $DivisionTableTable(attachedDatabase, alias);
  }
}

class DivisionTableCompanion extends UpdateCompanion<Division> {
  final Value<int> id;
  final Value<String> division;
  final Value<int> rowid;
  const DivisionTableCompanion({
    this.id = const Value.absent(),
    this.division = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DivisionTableCompanion.insert({
    required int id,
    required String division,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        division = Value(division);
  static Insertable<Division> custom({
    Expression<int>? id,
    Expression<String>? division,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (division != null) 'division': division,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DivisionTableCompanion copyWith(
      {Value<int>? id, Value<String>? division, Value<int>? rowid}) {
    return DivisionTableCompanion(
      id: id ?? this.id,
      division: division ?? this.division,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (division.present) {
      map['division'] = Variable<String>(division.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DivisionTableCompanion(')
          ..write('id: $id, ')
          ..write('division: $division, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DistrictTableTable extends DistrictTable
    with TableInfo<$DistrictTableTable, District> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DistrictTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _districtMeta =
      const VerificationMeta('district');
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
      'district', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _divisionIdFkMeta =
      const VerificationMeta('divisionIdFk');
  @override
  late final GeneratedColumn<int> divisionIdFk = GeneratedColumn<int>(
      'division_id_fk', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, district, divisionIdFk];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'district_table';
  @override
  VerificationContext validateIntegrity(Insertable<District> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('district')) {
      context.handle(_districtMeta,
          district.isAcceptableOrUnknown(data['district']!, _districtMeta));
    } else if (isInserting) {
      context.missing(_districtMeta);
    }
    if (data.containsKey('division_id_fk')) {
      context.handle(
          _divisionIdFkMeta,
          divisionIdFk.isAcceptableOrUnknown(
              data['division_id_fk']!, _divisionIdFkMeta));
    } else if (isInserting) {
      context.missing(_divisionIdFkMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  District map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return District.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      divisionIdFk: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}division_id_fk'])!,
      district: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}district'])!,
    );
  }

  @override
  $DistrictTableTable createAlias(String alias) {
    return $DistrictTableTable(attachedDatabase, alias);
  }
}

class DistrictTableCompanion extends UpdateCompanion<District> {
  final Value<int> id;
  final Value<String> district;
  final Value<int> divisionIdFk;
  final Value<int> rowid;
  const DistrictTableCompanion({
    this.id = const Value.absent(),
    this.district = const Value.absent(),
    this.divisionIdFk = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DistrictTableCompanion.insert({
    required int id,
    required String district,
    required int divisionIdFk,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        district = Value(district),
        divisionIdFk = Value(divisionIdFk);
  static Insertable<District> custom({
    Expression<int>? id,
    Expression<String>? district,
    Expression<int>? divisionIdFk,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (district != null) 'district': district,
      if (divisionIdFk != null) 'division_id_fk': divisionIdFk,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DistrictTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? district,
      Value<int>? divisionIdFk,
      Value<int>? rowid}) {
    return DistrictTableCompanion(
      id: id ?? this.id,
      district: district ?? this.district,
      divisionIdFk: divisionIdFk ?? this.divisionIdFk,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (divisionIdFk.present) {
      map['division_id_fk'] = Variable<int>(divisionIdFk.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DistrictTableCompanion(')
          ..write('id: $id, ')
          ..write('district: $district, ')
          ..write('divisionIdFk: $divisionIdFk, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DonorTableTable extends DonorTable
    with TableInfo<$DonorTableTable, Donor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DonorTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'donor_table';
  @override
  VerificationContext validateIntegrity(Insertable<Donor> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Donor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Donor.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $DonorTableTable createAlias(String alias) {
    return $DonorTableTable(attachedDatabase, alias);
  }
}

class DonorTableCompanion extends UpdateCompanion<Donor> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> rowid;
  const DonorTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DonorTableCompanion.insert({
    required int id,
    required String name,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Donor> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DonorTableCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? rowid}) {
    return DonorTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DonorTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuthorTableTable extends AuthorTable
    with TableInfo<$AuthorTableTable, AuthorBaseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthorTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'author_table';
  @override
  VerificationContext validateIntegrity(Insertable<AuthorBaseData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AuthorBaseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthorBaseData.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $AuthorTableTable createAlias(String alias) {
    return $AuthorTableTable(attachedDatabase, alias);
  }
}

class AuthorTableCompanion extends UpdateCompanion<AuthorBaseData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> rowid;
  const AuthorTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthorTableCompanion.insert({
    required int id,
    required String name,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<AuthorBaseData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthorTableCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? rowid}) {
    return AuthorTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthorTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoomTableTable extends RoomTable with TableInfo<$RoomTableTable, Room> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _libraryIdMeta =
      const VerificationMeta('libraryId');
  @override
  late final GeneratedColumn<int> libraryId = GeneratedColumn<int>(
      'library_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, libraryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'room_table';
  @override
  VerificationContext validateIntegrity(Insertable<Room> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('library_id')) {
      context.handle(_libraryIdMeta,
          libraryId.isAcceptableOrUnknown(data['library_id']!, _libraryIdMeta));
    } else if (isInserting) {
      context.missing(_libraryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Room map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Room.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      libraryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}library_id'])!,
    );
  }

  @override
  $RoomTableTable createAlias(String alias) {
    return $RoomTableTable(attachedDatabase, alias);
  }
}

class RoomTableCompanion extends UpdateCompanion<Room> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> libraryId;
  final Value<int> rowid;
  const RoomTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.libraryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoomTableCompanion.insert({
    required int id,
    required String name,
    required int libraryId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        libraryId = Value(libraryId);
  static Insertable<Room> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? libraryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (libraryId != null) 'library_id': libraryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoomTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? libraryId,
      Value<int>? rowid}) {
    return RoomTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      libraryId: libraryId ?? this.libraryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (libraryId.present) {
      map['library_id'] = Variable<int>(libraryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('libraryId: $libraryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoryTableTable extends CategoryTable
    with TableInfo<$CategoryTableTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_table';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $CategoryTableTable createAlias(String alias) {
    return $CategoryTableTable(attachedDatabase, alias);
  }
}

class CategoryTableCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> rowid;
  const CategoryTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoryTableCompanion.insert({
    required int id,
    required String name,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoryTableCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? rowid}) {
    return CategoryTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShelfTableTable extends ShelfTable
    with TableInfo<$ShelfTableTable, Shelf> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShelfTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _libraryIdMeta =
      const VerificationMeta('libraryId');
  @override
  late final GeneratedColumn<int> libraryId = GeneratedColumn<int>(
      'library_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, libraryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shelf_table';
  @override
  VerificationContext validateIntegrity(Insertable<Shelf> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('library_id')) {
      context.handle(_libraryIdMeta,
          libraryId.isAcceptableOrUnknown(data['library_id']!, _libraryIdMeta));
    } else if (isInserting) {
      context.missing(_libraryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Shelf map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shelf.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      libraryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}library_id'])!,
    );
  }

  @override
  $ShelfTableTable createAlias(String alias) {
    return $ShelfTableTable(attachedDatabase, alias);
  }
}

class ShelfTableCompanion extends UpdateCompanion<Shelf> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> libraryId;
  final Value<int> rowid;
  const ShelfTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.libraryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShelfTableCompanion.insert({
    required int id,
    required String name,
    required int libraryId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        libraryId = Value(libraryId);
  static Insertable<Shelf> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? libraryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (libraryId != null) 'library_id': libraryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShelfTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? libraryId,
      Value<int>? rowid}) {
    return ShelfTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      libraryId: libraryId ?? this.libraryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (libraryId.present) {
      map['library_id'] = Variable<int>(libraryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShelfTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('libraryId: $libraryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CountryTableTable extends CountryTable
    with TableInfo<$CountryTableTable, Country> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CountryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _citiesMeta = const VerificationMeta('cities');
  @override
  late final GeneratedColumn<String> cities = GeneratedColumn<String>(
      'cities', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [name, cities];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'country_table';
  @override
  VerificationContext validateIntegrity(Insertable<Country> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cities')) {
      context.handle(_citiesMeta,
          cities.isAcceptableOrUnknown(data['cities']!, _citiesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  Country map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Country.fromDb(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      cities: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cities']),
    );
  }

  @override
  $CountryTableTable createAlias(String alias) {
    return $CountryTableTable(attachedDatabase, alias);
  }
}

class CountryTableCompanion extends UpdateCompanion<Country> {
  final Value<String> name;
  final Value<String?> cities;
  final Value<int> rowid;
  const CountryTableCompanion({
    this.name = const Value.absent(),
    this.cities = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CountryTableCompanion.insert({
    required String name,
    this.cities = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Country> custom({
    Expression<String>? name,
    Expression<String>? cities,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (cities != null) 'cities': cities,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CountryTableCompanion copyWith(
      {Value<String>? name, Value<String?>? cities, Value<int>? rowid}) {
    return CountryTableCompanion(
      name: name ?? this.name,
      cities: cities ?? this.cities,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cities.present) {
      map['cities'] = Variable<String>(cities.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CountryTableCompanion(')
          ..write('name: $name, ')
          ..write('cities: $cities, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlatformPackageTableTable extends PlatformPackageTable
    with TableInfo<$PlatformPackageTableTable, PlatformPackage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlatformPackageTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<String> price = GeneratedColumn<String>(
      'price', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationTypeMeta =
      const VerificationMeta('durationType');
  @override
  late final GeneratedColumn<String> durationType = GeneratedColumn<String>(
      'duration_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationValueMeta =
      const VerificationMeta('durationValue');
  @override
  late final GeneratedColumn<int> durationValue = GeneratedColumn<int>(
      'duration_value', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _maxLibrariesMeta =
      const VerificationMeta('maxLibraries');
  @override
  late final GeneratedColumn<int> maxLibraries = GeneratedColumn<int>(
      'max_libraries', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, price, durationType, durationValue, maxLibraries, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'platform_package_table';
  @override
  VerificationContext validateIntegrity(Insertable<PlatformPackage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('duration_type')) {
      context.handle(
          _durationTypeMeta,
          durationType.isAcceptableOrUnknown(
              data['duration_type']!, _durationTypeMeta));
    }
    if (data.containsKey('duration_value')) {
      context.handle(
          _durationValueMeta,
          durationValue.isAcceptableOrUnknown(
              data['duration_value']!, _durationValueMeta));
    }
    if (data.containsKey('max_libraries')) {
      context.handle(
          _maxLibrariesMeta,
          maxLibraries.isAcceptableOrUnknown(
              data['max_libraries']!, _maxLibrariesMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  PlatformPackage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlatformPackage.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price']),
      durationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}duration_type']),
      durationValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_value']),
      maxLibraries: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_libraries']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
    );
  }

  @override
  $PlatformPackageTableTable createAlias(String alias) {
    return $PlatformPackageTableTable(attachedDatabase, alias);
  }
}

class PlatformPackageTableCompanion extends UpdateCompanion<PlatformPackage> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> price;
  final Value<String?> durationType;
  final Value<int?> durationValue;
  final Value<int?> maxLibraries;
  final Value<String?> description;
  final Value<int> rowid;
  const PlatformPackageTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.durationType = const Value.absent(),
    this.durationValue = const Value.absent(),
    this.maxLibraries = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlatformPackageTableCompanion.insert({
    required int id,
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.durationType = const Value.absent(),
    this.durationValue = const Value.absent(),
    this.maxLibraries = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<PlatformPackage> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? price,
    Expression<String>? durationType,
    Expression<int>? durationValue,
    Expression<int>? maxLibraries,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (durationType != null) 'duration_type': durationType,
      if (durationValue != null) 'duration_value': durationValue,
      if (maxLibraries != null) 'max_libraries': maxLibraries,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlatformPackageTableCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<String?>? price,
      Value<String?>? durationType,
      Value<int?>? durationValue,
      Value<int?>? maxLibraries,
      Value<String?>? description,
      Value<int>? rowid}) {
    return PlatformPackageTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      durationType: durationType ?? this.durationType,
      durationValue: durationValue ?? this.durationValue,
      maxLibraries: maxLibraries ?? this.maxLibraries,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<String>(price.value);
    }
    if (durationType.present) {
      map['duration_type'] = Variable<String>(durationType.value);
    }
    if (durationValue.present) {
      map['duration_value'] = Variable<int>(durationValue.value);
    }
    if (maxLibraries.present) {
      map['max_libraries'] = Variable<int>(maxLibraries.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlatformPackageTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('durationType: $durationType, ')
          ..write('durationValue: $durationValue, ')
          ..write('maxLibraries: $maxLibraries, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentMethodTableTable extends PaymentMethodTable
    with TableInfo<$PaymentMethodTableTable, PaymentMethod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentMethodTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _detailsMeta =
      const VerificationMeta('details');
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
      'details', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, details, instructions];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_method_table';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentMethod> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('details')) {
      context.handle(_detailsMeta,
          details.isAcceptableOrUnknown(data['details']!, _detailsMeta));
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  PaymentMethod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentMethod.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      details: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details']),
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions']),
    );
  }

  @override
  $PaymentMethodTableTable createAlias(String alias) {
    return $PaymentMethodTableTable(attachedDatabase, alias);
  }
}

class PaymentMethodTableCompanion extends UpdateCompanion<PaymentMethod> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> details;
  final Value<String?> instructions;
  final Value<int> rowid;
  const PaymentMethodTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.details = const Value.absent(),
    this.instructions = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentMethodTableCompanion.insert({
    required int id,
    required String name,
    this.details = const Value.absent(),
    this.instructions = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<PaymentMethod> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? details,
    Expression<String>? instructions,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (details != null) 'details': details,
      if (instructions != null) 'instructions': instructions,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentMethodTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? details,
      Value<String?>? instructions,
      Value<int>? rowid}) {
    return PaymentMethodTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      details: details ?? this.details,
      instructions: instructions ?? this.instructions,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('details: $details, ')
          ..write('instructions: $instructions, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoriteBookTableTable extends FavoriteBookTable
    with TableInfo<$FavoriteBookTableTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteBookTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalCopiesMeta =
      const VerificationMeta('totalCopies');
  @override
  late final GeneratedColumn<int> totalCopies = GeneratedColumn<int>(
      'total_copies', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishedYearMeta =
      const VerificationMeta('publishedYear');
  @override
  late final GeneratedColumn<String> publishedYear = GeneratedColumn<String>(
      'published_year', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverImageMeta =
      const VerificationMeta('coverImage');
  @override
  late final GeneratedColumn<String> coverImage = GeneratedColumn<String>(
      'cover_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authorNameMeta =
      const VerificationMeta('authorName');
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
      'author_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        totalCopies,
        status,
        title,
        description,
        publishedYear,
        coverImage,
        authorName,
        userId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_book_table';
  @override
  VerificationContext validateIntegrity(Insertable<Book> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('total_copies')) {
      context.handle(
          _totalCopiesMeta,
          totalCopies.isAcceptableOrUnknown(
              data['total_copies']!, _totalCopiesMeta));
    } else if (isInserting) {
      context.missing(_totalCopiesMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('published_year')) {
      context.handle(
          _publishedYearMeta,
          publishedYear.isAcceptableOrUnknown(
              data['published_year']!, _publishedYearMeta));
    }
    if (data.containsKey('cover_image')) {
      context.handle(
          _coverImageMeta,
          coverImage.isAcceptableOrUnknown(
              data['cover_image']!, _coverImageMeta));
    }
    if (data.containsKey('author_name')) {
      context.handle(
          _authorNameMeta,
          authorName.isAcceptableOrUnknown(
              data['author_name']!, _authorNameMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, userId};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book.fromDb(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      publishedYear: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}published_year']),
      coverImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_image']),
      authorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author_name']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      totalCopies: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_copies'])!,
    );
  }

  @override
  $FavoriteBookTableTable createAlias(String alias) {
    return $FavoriteBookTableTable(attachedDatabase, alias);
  }
}

class FavoriteBookTableCompanion extends UpdateCompanion<Book> {
  final Value<int> id;
  final Value<int> totalCopies;
  final Value<String?> status;
  final Value<String?> title;
  final Value<String?> description;
  final Value<String?> publishedYear;
  final Value<String?> coverImage;
  final Value<String?> authorName;
  final Value<int> userId;
  final Value<int> rowid;
  const FavoriteBookTableCompanion({
    this.id = const Value.absent(),
    this.totalCopies = const Value.absent(),
    this.status = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.publishedYear = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.authorName = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteBookTableCompanion.insert({
    required int id,
    required int totalCopies,
    this.status = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.publishedYear = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.authorName = const Value.absent(),
    required int userId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        totalCopies = Value(totalCopies),
        userId = Value(userId);
  static Insertable<Book> custom({
    Expression<int>? id,
    Expression<int>? totalCopies,
    Expression<String>? status,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? publishedYear,
    Expression<String>? coverImage,
    Expression<String>? authorName,
    Expression<int>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalCopies != null) 'total_copies': totalCopies,
      if (status != null) 'status': status,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (publishedYear != null) 'published_year': publishedYear,
      if (coverImage != null) 'cover_image': coverImage,
      if (authorName != null) 'author_name': authorName,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteBookTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? totalCopies,
      Value<String?>? status,
      Value<String?>? title,
      Value<String?>? description,
      Value<String?>? publishedYear,
      Value<String?>? coverImage,
      Value<String?>? authorName,
      Value<int>? userId,
      Value<int>? rowid}) {
    return FavoriteBookTableCompanion(
      id: id ?? this.id,
      totalCopies: totalCopies ?? this.totalCopies,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      publishedYear: publishedYear ?? this.publishedYear,
      coverImage: coverImage ?? this.coverImage,
      authorName: authorName ?? this.authorName,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (totalCopies.present) {
      map['total_copies'] = Variable<int>(totalCopies.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (publishedYear.present) {
      map['published_year'] = Variable<String>(publishedYear.value);
    }
    if (coverImage.present) {
      map['cover_image'] = Variable<String>(coverImage.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteBookTableCompanion(')
          ..write('id: $id, ')
          ..write('totalCopies: $totalCopies, ')
          ..write('status: $status, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('publishedYear: $publishedYear, ')
          ..write('coverImage: $coverImage, ')
          ..write('authorName: $authorName, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  $MyDatabaseManager get managers => $MyDatabaseManager(this);
  late final $UnsentTableTable unsentTable = $UnsentTableTable(this);
  late final $DivisionTableTable divisionTable = $DivisionTableTable(this);
  late final $DistrictTableTable districtTable = $DistrictTableTable(this);
  late final $DonorTableTable donorTable = $DonorTableTable(this);
  late final $AuthorTableTable authorTable = $AuthorTableTable(this);
  late final $RoomTableTable roomTable = $RoomTableTable(this);
  late final $CategoryTableTable categoryTable = $CategoryTableTable(this);
  late final $ShelfTableTable shelfTable = $ShelfTableTable(this);
  late final $CountryTableTable countryTable = $CountryTableTable(this);
  late final $PlatformPackageTableTable platformPackageTable =
      $PlatformPackageTableTable(this);
  late final $PaymentMethodTableTable paymentMethodTable =
      $PaymentMethodTableTable(this);
  late final $FavoriteBookTableTable favoriteBookTable =
      $FavoriteBookTableTable(this);
  late final UnsentDao unsentDao = UnsentDao(this as MyDatabase);
  late final CountryDao countryDao = CountryDao(this as MyDatabase);
  late final PlatformPackageDao platformPackageDao =
      PlatformPackageDao(this as MyDatabase);
  late final PaymentMethodDao paymentMethodDao =
      PaymentMethodDao(this as MyDatabase);
  late final CategoryDao categoryDao = CategoryDao(this as MyDatabase);
  late final DonorDao donorDao = DonorDao(this as MyDatabase);
  late final RoomDao roomDao = RoomDao(this as MyDatabase);
  late final ShelfDao shelfDao = ShelfDao(this as MyDatabase);
  late final AuthorDao authorDao = AuthorDao(this as MyDatabase);
  late final DistrictDao districtDao = DistrictDao(this as MyDatabase);
  late final DivisionDao divisionDao = DivisionDao(this as MyDatabase);
  late final FavoriteBookDao favoriteBookDao =
      FavoriteBookDao(this as MyDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        unsentTable,
        divisionTable,
        districtTable,
        donorTable,
        authorTable,
        roomTable,
        categoryTable,
        shelfTable,
        countryTable,
        platformPackageTable,
        paymentMethodTable,
        favoriteBookTable
      ];
}

typedef $$UnsentTableTableCreateCompanionBuilder = UnsentTableCompanion
    Function({
  Value<int> unsentId,
  required int unsentDateTime,
  required String unsentType,
  required String unsentData,
  required String unsentTitle,
});
typedef $$UnsentTableTableUpdateCompanionBuilder = UnsentTableCompanion
    Function({
  Value<int> unsentId,
  Value<int> unsentDateTime,
  Value<String> unsentType,
  Value<String> unsentData,
  Value<String> unsentTitle,
});

class $$UnsentTableTableFilterComposer
    extends Composer<_$MyDatabase, $UnsentTableTable> {
  $$UnsentTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get unsentId => $composableBuilder(
      column: $table.unsentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unsentDateTime => $composableBuilder(
      column: $table.unsentDateTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unsentType => $composableBuilder(
      column: $table.unsentType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unsentData => $composableBuilder(
      column: $table.unsentData, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unsentTitle => $composableBuilder(
      column: $table.unsentTitle, builder: (column) => ColumnFilters(column));
}

class $$UnsentTableTableOrderingComposer
    extends Composer<_$MyDatabase, $UnsentTableTable> {
  $$UnsentTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get unsentId => $composableBuilder(
      column: $table.unsentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unsentDateTime => $composableBuilder(
      column: $table.unsentDateTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unsentType => $composableBuilder(
      column: $table.unsentType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unsentData => $composableBuilder(
      column: $table.unsentData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unsentTitle => $composableBuilder(
      column: $table.unsentTitle, builder: (column) => ColumnOrderings(column));
}

class $$UnsentTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $UnsentTableTable> {
  $$UnsentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get unsentId =>
      $composableBuilder(column: $table.unsentId, builder: (column) => column);

  GeneratedColumn<int> get unsentDateTime => $composableBuilder(
      column: $table.unsentDateTime, builder: (column) => column);

  GeneratedColumn<String> get unsentType => $composableBuilder(
      column: $table.unsentType, builder: (column) => column);

  GeneratedColumn<String> get unsentData => $composableBuilder(
      column: $table.unsentData, builder: (column) => column);

  GeneratedColumn<String> get unsentTitle => $composableBuilder(
      column: $table.unsentTitle, builder: (column) => column);
}

class $$UnsentTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $UnsentTableTable,
    Unsent,
    $$UnsentTableTableFilterComposer,
    $$UnsentTableTableOrderingComposer,
    $$UnsentTableTableAnnotationComposer,
    $$UnsentTableTableCreateCompanionBuilder,
    $$UnsentTableTableUpdateCompanionBuilder,
    (Unsent, BaseReferences<_$MyDatabase, $UnsentTableTable, Unsent>),
    Unsent,
    PrefetchHooks Function()> {
  $$UnsentTableTableTableManager(_$MyDatabase db, $UnsentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnsentTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnsentTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnsentTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> unsentId = const Value.absent(),
            Value<int> unsentDateTime = const Value.absent(),
            Value<String> unsentType = const Value.absent(),
            Value<String> unsentData = const Value.absent(),
            Value<String> unsentTitle = const Value.absent(),
          }) =>
              UnsentTableCompanion(
            unsentId: unsentId,
            unsentDateTime: unsentDateTime,
            unsentType: unsentType,
            unsentData: unsentData,
            unsentTitle: unsentTitle,
          ),
          createCompanionCallback: ({
            Value<int> unsentId = const Value.absent(),
            required int unsentDateTime,
            required String unsentType,
            required String unsentData,
            required String unsentTitle,
          }) =>
              UnsentTableCompanion.insert(
            unsentId: unsentId,
            unsentDateTime: unsentDateTime,
            unsentType: unsentType,
            unsentData: unsentData,
            unsentTitle: unsentTitle,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UnsentTableTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $UnsentTableTable,
    Unsent,
    $$UnsentTableTableFilterComposer,
    $$UnsentTableTableOrderingComposer,
    $$UnsentTableTableAnnotationComposer,
    $$UnsentTableTableCreateCompanionBuilder,
    $$UnsentTableTableUpdateCompanionBuilder,
    (Unsent, BaseReferences<_$MyDatabase, $UnsentTableTable, Unsent>),
    Unsent,
    PrefetchHooks Function()>;
typedef $$DivisionTableTableCreateCompanionBuilder = DivisionTableCompanion
    Function({
  required int id,
  required String division,
  Value<int> rowid,
});
typedef $$DivisionTableTableUpdateCompanionBuilder = DivisionTableCompanion
    Function({
  Value<int> id,
  Value<String> division,
  Value<int> rowid,
});

class $$DivisionTableTableFilterComposer
    extends Composer<_$MyDatabase, $DivisionTableTable> {
  $$DivisionTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get division => $composableBuilder(
      column: $table.division, builder: (column) => ColumnFilters(column));
}

class $$DivisionTableTableOrderingComposer
    extends Composer<_$MyDatabase, $DivisionTableTable> {
  $$DivisionTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get division => $composableBuilder(
      column: $table.division, builder: (column) => ColumnOrderings(column));
}

class $$DivisionTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $DivisionTableTable> {
  $$DivisionTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get division =>
      $composableBuilder(column: $table.division, builder: (column) => column);
}

class $$DivisionTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $DivisionTableTable,
    Division,
    $$DivisionTableTableFilterComposer,
    $$DivisionTableTableOrderingComposer,
    $$DivisionTableTableAnnotationComposer,
    $$DivisionTableTableCreateCompanionBuilder,
    $$DivisionTableTableUpdateCompanionBuilder,
    (Division, BaseReferences<_$MyDatabase, $DivisionTableTable, Division>),
    Division,
    PrefetchHooks Function()> {
  $$DivisionTableTableTableManager(_$MyDatabase db, $DivisionTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DivisionTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DivisionTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DivisionTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> division = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DivisionTableCompanion(
            id: id,
            division: division,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required String division,
            Value<int> rowid = const Value.absent(),
          }) =>
              DivisionTableCompanion.insert(
            id: id,
            division: division,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DivisionTableTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $DivisionTableTable,
    Division,
    $$DivisionTableTableFilterComposer,
    $$DivisionTableTableOrderingComposer,
    $$DivisionTableTableAnnotationComposer,
    $$DivisionTableTableCreateCompanionBuilder,
    $$DivisionTableTableUpdateCompanionBuilder,
    (Division, BaseReferences<_$MyDatabase, $DivisionTableTable, Division>),
    Division,
    PrefetchHooks Function()>;
typedef $$DistrictTableTableCreateCompanionBuilder = DistrictTableCompanion
    Function({
  required int id,
  required String district,
  required int divisionIdFk,
  Value<int> rowid,
});
typedef $$DistrictTableTableUpdateCompanionBuilder = DistrictTableCompanion
    Function({
  Value<int> id,
  Value<String> district,
  Value<int> divisionIdFk,
  Value<int> rowid,
});

class $$DistrictTableTableFilterComposer
    extends Composer<_$MyDatabase, $DistrictTableTable> {
  $$DistrictTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get district => $composableBuilder(
      column: $table.district, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get divisionIdFk => $composableBuilder(
      column: $table.divisionIdFk, builder: (column) => ColumnFilters(column));
}

class $$DistrictTableTableOrderingComposer
    extends Composer<_$MyDatabase, $DistrictTableTable> {
  $$DistrictTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get district => $composableBuilder(
      column: $table.district, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get divisionIdFk => $composableBuilder(
      column: $table.divisionIdFk,
      builder: (column) => ColumnOrderings(column));
}

class $$DistrictTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $DistrictTableTable> {
  $$DistrictTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<int> get divisionIdFk => $composableBuilder(
      column: $table.divisionIdFk, builder: (column) => column);
}

class $$DistrictTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $DistrictTableTable,
    District,
    $$DistrictTableTableFilterComposer,
    $$DistrictTableTableOrderingComposer,
    $$DistrictTableTableAnnotationComposer,
    $$DistrictTableTableCreateCompanionBuilder,
    $$DistrictTableTableUpdateCompanionBuilder,
    (District, BaseReferences<_$MyDatabase, $DistrictTableTable, District>),
    District,
    PrefetchHooks Function()> {
  $$DistrictTableTableTableManager(_$MyDatabase db, $DistrictTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DistrictTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DistrictTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DistrictTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> district = const Value.absent(),
            Value<int> divisionIdFk = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DistrictTableCompanion(
            id: id,
            district: district,
            divisionIdFk: divisionIdFk,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required String district,
            required int divisionIdFk,
            Value<int> rowid = const Value.absent(),
          }) =>
              DistrictTableCompanion.insert(
            id: id,
            district: district,
            divisionIdFk: divisionIdFk,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DistrictTableTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $DistrictTableTable,
    District,
    $$DistrictTableTableFilterComposer,
    $$DistrictTableTableOrderingComposer,
    $$DistrictTableTableAnnotationComposer,
    $$DistrictTableTableCreateCompanionBuilder,
    $$DistrictTableTableUpdateCompanionBuilder,
    (District, BaseReferences<_$MyDatabase, $DistrictTableTable, District>),
    District,
    PrefetchHooks Function()>;
typedef $$DonorTableTableCreateCompanionBuilder = DonorTableCompanion Function({
  required int id,
  required String name,
  Value<int> rowid,
});
typedef $$DonorTableTableUpdateCompanionBuilder = DonorTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> rowid,
});

class $$DonorTableTableFilterComposer
    extends Composer<_$MyDatabase, $DonorTableTable> {
  $$DonorTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$DonorTableTableOrderingComposer
    extends Composer<_$MyDatabase, $DonorTableTable> {
  $$DonorTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$DonorTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $DonorTableTable> {
  $$DonorTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$DonorTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $DonorTableTable,
    Donor,
    $$DonorTableTableFilterComposer,
    $$DonorTableTableOrderingComposer,
    $$DonorTableTableAnnotationComposer,
    $$DonorTableTableCreateCompanionBuilder,
    $$DonorTableTableUpdateCompanionBuilder,
    (Donor, BaseReferences<_$MyDatabase, $DonorTableTable, Donor>),
    Donor,
    PrefetchHooks Function()> {
  $$DonorTableTableTableManager(_$MyDatabase db, $DonorTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DonorTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DonorTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DonorTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DonorTableCompanion(
            id: id,
            name: name,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required String name,
            Value<int> rowid = const Value.absent(),
          }) =>
              DonorTableCompanion.insert(
            id: id,
            name: name,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DonorTableTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $DonorTableTable,
    Donor,
    $$DonorTableTableFilterComposer,
    $$DonorTableTableOrderingComposer,
    $$DonorTableTableAnnotationComposer,
    $$DonorTableTableCreateCompanionBuilder,
    $$DonorTableTableUpdateCompanionBuilder,
    (Donor, BaseReferences<_$MyDatabase, $DonorTableTable, Donor>),
    Donor,
    PrefetchHooks Function()>;
typedef $$AuthorTableTableCreateCompanionBuilder = AuthorTableCompanion
    Function({
  required int id,
  required String name,
  Value<int> rowid,
});
typedef $$AuthorTableTableUpdateCompanionBuilder = AuthorTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> rowid,
});

class $$AuthorTableTableFilterComposer
    extends Composer<_$MyDatabase, $AuthorTableTable> {
  $$AuthorTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$AuthorTableTableOrderingComposer
    extends Composer<_$MyDatabase, $AuthorTableTable> {
  $$AuthorTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$AuthorTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $AuthorTableTable> {
  $$AuthorTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$AuthorTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $AuthorTableTable,
    AuthorBaseData,
    $$AuthorTableTableFilterComposer,
    $$AuthorTableTableOrderingComposer,
    $$AuthorTableTableAnnotationComposer,
    $$AuthorTableTableCreateCompanionBuilder,
    $$AuthorTableTableUpdateCompanionBuilder,
    (
      AuthorBaseData,
      BaseReferences<_$MyDatabase, $AuthorTableTable, AuthorBaseData>
    ),
    AuthorBaseData,
    PrefetchHooks Function()> {
  $$AuthorTableTableTableManager(_$MyDatabase db, $AuthorTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthorTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthorTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthorTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthorTableCompanion(
            id: id,
            name: name,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required String name,
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthorTableCompanion.insert(
            id: id,
            name: name,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuthorTableTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $AuthorTableTable,
    AuthorBaseData,
    $$AuthorTableTableFilterComposer,
    $$AuthorTableTableOrderingComposer,
    $$AuthorTableTableAnnotationComposer,
    $$AuthorTableTableCreateCompanionBuilder,
    $$AuthorTableTableUpdateCompanionBuilder,
    (
      AuthorBaseData,
      BaseReferences<_$MyDatabase, $AuthorTableTable, AuthorBaseData>
    ),
    AuthorBaseData,
    PrefetchHooks Function()>;
typedef $$RoomTableTableCreateCompanionBuilder = RoomTableCompanion Function({
  required int id,
  required String name,
  required int libraryId,
  Value<int> rowid,
});
typedef $$RoomTableTableUpdateCompanionBuilder = RoomTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> libraryId,
  Value<int> rowid,
});

class $$RoomTableTableFilterComposer
    extends Composer<_$MyDatabase, $RoomTableTable> {
  $$RoomTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get libraryId => $composableBuilder(
      column: $table.libraryId, builder: (column) => ColumnFilters(column));
}

class $$RoomTableTableOrderingComposer
    extends Composer<_$MyDatabase, $RoomTableTable> {
  $$RoomTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get libraryId => $composableBuilder(
      column: $table.libraryId, builder: (column) => ColumnOrderings(column));
}

class $$RoomTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $RoomTableTable> {
  $$RoomTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get libraryId =>
      $composableBuilder(column: $table.libraryId, builder: (column) => column);
}

class $$RoomTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $RoomTableTable,
    Room,
    $$RoomTableTableFilterComposer,
    $$RoomTableTableOrderingComposer,
    $$RoomTableTableAnnotationComposer,
    $$RoomTableTableCreateCompanionBuilder,
    $$RoomTableTableUpdateCompanionBuilder,
    (Room, BaseReferences<_$MyDatabase, $RoomTableTable, Room>),
    Room,
    PrefetchHooks Function()> {
  $$RoomTableTableTableManager(_$MyDatabase db, $RoomTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> libraryId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoomTableCompanion(
            id: id,
            name: name,
            libraryId: libraryId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required String name,
            required int libraryId,
            Value<int> rowid = const Value.absent(),
          }) =>
              RoomTableCompanion.insert(
            id: id,
            name: name,
            libraryId: libraryId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RoomTableTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $RoomTableTable,
    Room,
    $$RoomTableTableFilterComposer,
    $$RoomTableTableOrderingComposer,
    $$RoomTableTableAnnotationComposer,
    $$RoomTableTableCreateCompanionBuilder,
    $$RoomTableTableUpdateCompanionBuilder,
    (Room, BaseReferences<_$MyDatabase, $RoomTableTable, Room>),
    Room,
    PrefetchHooks Function()>;
typedef $$CategoryTableTableCreateCompanionBuilder = CategoryTableCompanion
    Function({
  required int id,
  required String name,
  Value<int> rowid,
});
typedef $$CategoryTableTableUpdateCompanionBuilder = CategoryTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> rowid,
});

class $$CategoryTableTableFilterComposer
    extends Composer<_$MyDatabase, $CategoryTableTable> {
  $$CategoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$CategoryTableTableOrderingComposer
    extends Composer<_$MyDatabase, $CategoryTableTable> {
  $$CategoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$CategoryTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $CategoryTableTable> {
  $$CategoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$CategoryTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $CategoryTableTable,
    Category,
    $$CategoryTableTableFilterComposer,
    $$CategoryTableTableOrderingComposer,
    $$CategoryTableTableAnnotationComposer,
    $$CategoryTableTableCreateCompanionBuilder,
    $$CategoryTableTableUpdateCompanionBuilder,
    (Category, BaseReferences<_$MyDatabase, $CategoryTableTable, Category>),
    Category,
    PrefetchHooks Function()> {
  $$CategoryTableTableTableManager(_$MyDatabase db, $CategoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoryTableCompanion(
            id: id,
            name: name,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required String name,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoryTableCompanion.insert(
            id: id,
            name: name,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoryTableTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $CategoryTableTable,
    Category,
    $$CategoryTableTableFilterComposer,
    $$CategoryTableTableOrderingComposer,
    $$CategoryTableTableAnnotationComposer,
    $$CategoryTableTableCreateCompanionBuilder,
    $$CategoryTableTableUpdateCompanionBuilder,
    (Category, BaseReferences<_$MyDatabase, $CategoryTableTable, Category>),
    Category,
    PrefetchHooks Function()>;
typedef $$ShelfTableTableCreateCompanionBuilder = ShelfTableCompanion Function({
  required int id,
  required String name,
  required int libraryId,
  Value<int> rowid,
});
typedef $$ShelfTableTableUpdateCompanionBuilder = ShelfTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> libraryId,
  Value<int> rowid,
});

class $$ShelfTableTableFilterComposer
    extends Composer<_$MyDatabase, $ShelfTableTable> {
  $$ShelfTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get libraryId => $composableBuilder(
      column: $table.libraryId, builder: (column) => ColumnFilters(column));
}

class $$ShelfTableTableOrderingComposer
    extends Composer<_$MyDatabase, $ShelfTableTable> {
  $$ShelfTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get libraryId => $composableBuilder(
      column: $table.libraryId, builder: (column) => ColumnOrderings(column));
}

class $$ShelfTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $ShelfTableTable> {
  $$ShelfTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get libraryId =>
      $composableBuilder(column: $table.libraryId, builder: (column) => column);
}

class $$ShelfTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $ShelfTableTable,
    Shelf,
    $$ShelfTableTableFilterComposer,
    $$ShelfTableTableOrderingComposer,
    $$ShelfTableTableAnnotationComposer,
    $$ShelfTableTableCreateCompanionBuilder,
    $$ShelfTableTableUpdateCompanionBuilder,
    (Shelf, BaseReferences<_$MyDatabase, $ShelfTableTable, Shelf>),
    Shelf,
    PrefetchHooks Function()> {
  $$ShelfTableTableTableManager(_$MyDatabase db, $ShelfTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShelfTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShelfTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShelfTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> libraryId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShelfTableCompanion(
            id: id,
            name: name,
            libraryId: libraryId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required String name,
            required int libraryId,
            Value<int> rowid = const Value.absent(),
          }) =>
              ShelfTableCompanion.insert(
            id: id,
            name: name,
            libraryId: libraryId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ShelfTableTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $ShelfTableTable,
    Shelf,
    $$ShelfTableTableFilterComposer,
    $$ShelfTableTableOrderingComposer,
    $$ShelfTableTableAnnotationComposer,
    $$ShelfTableTableCreateCompanionBuilder,
    $$ShelfTableTableUpdateCompanionBuilder,
    (Shelf, BaseReferences<_$MyDatabase, $ShelfTableTable, Shelf>),
    Shelf,
    PrefetchHooks Function()>;
typedef $$CountryTableTableCreateCompanionBuilder = CountryTableCompanion
    Function({
  required String name,
  Value<String?> cities,
  Value<int> rowid,
});
typedef $$CountryTableTableUpdateCompanionBuilder = CountryTableCompanion
    Function({
  Value<String> name,
  Value<String?> cities,
  Value<int> rowid,
});

class $$CountryTableTableFilterComposer
    extends Composer<_$MyDatabase, $CountryTableTable> {
  $$CountryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cities => $composableBuilder(
      column: $table.cities, builder: (column) => ColumnFilters(column));
}

class $$CountryTableTableOrderingComposer
    extends Composer<_$MyDatabase, $CountryTableTable> {
  $$CountryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cities => $composableBuilder(
      column: $table.cities, builder: (column) => ColumnOrderings(column));
}

class $$CountryTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $CountryTableTable> {
  $$CountryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get cities =>
      $composableBuilder(column: $table.cities, builder: (column) => column);
}

class $$CountryTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $CountryTableTable,
    Country,
    $$CountryTableTableFilterComposer,
    $$CountryTableTableOrderingComposer,
    $$CountryTableTableAnnotationComposer,
    $$CountryTableTableCreateCompanionBuilder,
    $$CountryTableTableUpdateCompanionBuilder,
    (Country, BaseReferences<_$MyDatabase, $CountryTableTable, Country>),
    Country,
    PrefetchHooks Function()> {
  $$CountryTableTableTableManager(_$MyDatabase db, $CountryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CountryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CountryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CountryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> name = const Value.absent(),
            Value<String?> cities = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CountryTableCompanion(
            name: name,
            cities: cities,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String name,
            Value<String?> cities = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CountryTableCompanion.insert(
            name: name,
            cities: cities,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CountryTableTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $CountryTableTable,
    Country,
    $$CountryTableTableFilterComposer,
    $$CountryTableTableOrderingComposer,
    $$CountryTableTableAnnotationComposer,
    $$CountryTableTableCreateCompanionBuilder,
    $$CountryTableTableUpdateCompanionBuilder,
    (Country, BaseReferences<_$MyDatabase, $CountryTableTable, Country>),
    Country,
    PrefetchHooks Function()>;
typedef $$PlatformPackageTableTableCreateCompanionBuilder
    = PlatformPackageTableCompanion Function({
  required int id,
  Value<String?> name,
  Value<String?> price,
  Value<String?> durationType,
  Value<int?> durationValue,
  Value<int?> maxLibraries,
  Value<String?> description,
  Value<int> rowid,
});
typedef $$PlatformPackageTableTableUpdateCompanionBuilder
    = PlatformPackageTableCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<String?> price,
  Value<String?> durationType,
  Value<int?> durationValue,
  Value<int?> maxLibraries,
  Value<String?> description,
  Value<int> rowid,
});

class $$PlatformPackageTableTableFilterComposer
    extends Composer<_$MyDatabase, $PlatformPackageTableTable> {
  $$PlatformPackageTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get durationType => $composableBuilder(
      column: $table.durationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationValue => $composableBuilder(
      column: $table.durationValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxLibraries => $composableBuilder(
      column: $table.maxLibraries, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));
}

class $$PlatformPackageTableTableOrderingComposer
    extends Composer<_$MyDatabase, $PlatformPackageTableTable> {
  $$PlatformPackageTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get durationType => $composableBuilder(
      column: $table.durationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationValue => $composableBuilder(
      column: $table.durationValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxLibraries => $composableBuilder(
      column: $table.maxLibraries,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));
}

class $$PlatformPackageTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $PlatformPackageTableTable> {
  $$PlatformPackageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get durationType => $composableBuilder(
      column: $table.durationType, builder: (column) => column);

  GeneratedColumn<int> get durationValue => $composableBuilder(
      column: $table.durationValue, builder: (column) => column);

  GeneratedColumn<int> get maxLibraries => $composableBuilder(
      column: $table.maxLibraries, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);
}

class $$PlatformPackageTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $PlatformPackageTableTable,
    PlatformPackage,
    $$PlatformPackageTableTableFilterComposer,
    $$PlatformPackageTableTableOrderingComposer,
    $$PlatformPackageTableTableAnnotationComposer,
    $$PlatformPackageTableTableCreateCompanionBuilder,
    $$PlatformPackageTableTableUpdateCompanionBuilder,
    (
      PlatformPackage,
      BaseReferences<_$MyDatabase, $PlatformPackageTableTable, PlatformPackage>
    ),
    PlatformPackage,
    PrefetchHooks Function()> {
  $$PlatformPackageTableTableTableManager(
      _$MyDatabase db, $PlatformPackageTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlatformPackageTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlatformPackageTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlatformPackageTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> price = const Value.absent(),
            Value<String?> durationType = const Value.absent(),
            Value<int?> durationValue = const Value.absent(),
            Value<int?> maxLibraries = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlatformPackageTableCompanion(
            id: id,
            name: name,
            price: price,
            durationType: durationType,
            durationValue: durationValue,
            maxLibraries: maxLibraries,
            description: description,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            Value<String?> name = const Value.absent(),
            Value<String?> price = const Value.absent(),
            Value<String?> durationType = const Value.absent(),
            Value<int?> durationValue = const Value.absent(),
            Value<int?> maxLibraries = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlatformPackageTableCompanion.insert(
            id: id,
            name: name,
            price: price,
            durationType: durationType,
            durationValue: durationValue,
            maxLibraries: maxLibraries,
            description: description,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlatformPackageTableTableProcessedTableManager
    = ProcessedTableManager<
        _$MyDatabase,
        $PlatformPackageTableTable,
        PlatformPackage,
        $$PlatformPackageTableTableFilterComposer,
        $$PlatformPackageTableTableOrderingComposer,
        $$PlatformPackageTableTableAnnotationComposer,
        $$PlatformPackageTableTableCreateCompanionBuilder,
        $$PlatformPackageTableTableUpdateCompanionBuilder,
        (
          PlatformPackage,
          BaseReferences<_$MyDatabase, $PlatformPackageTableTable,
              PlatformPackage>
        ),
        PlatformPackage,
        PrefetchHooks Function()>;
typedef $$PaymentMethodTableTableCreateCompanionBuilder
    = PaymentMethodTableCompanion Function({
  required int id,
  required String name,
  Value<String?> details,
  Value<String?> instructions,
  Value<int> rowid,
});
typedef $$PaymentMethodTableTableUpdateCompanionBuilder
    = PaymentMethodTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> details,
  Value<String?> instructions,
  Value<int> rowid,
});

class $$PaymentMethodTableTableFilterComposer
    extends Composer<_$MyDatabase, $PaymentMethodTableTable> {
  $$PaymentMethodTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));
}

class $$PaymentMethodTableTableOrderingComposer
    extends Composer<_$MyDatabase, $PaymentMethodTableTable> {
  $$PaymentMethodTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get details => $composableBuilder(
      column: $table.details, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));
}

class $$PaymentMethodTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $PaymentMethodTableTable> {
  $$PaymentMethodTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);
}

class $$PaymentMethodTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $PaymentMethodTableTable,
    PaymentMethod,
    $$PaymentMethodTableTableFilterComposer,
    $$PaymentMethodTableTableOrderingComposer,
    $$PaymentMethodTableTableAnnotationComposer,
    $$PaymentMethodTableTableCreateCompanionBuilder,
    $$PaymentMethodTableTableUpdateCompanionBuilder,
    (
      PaymentMethod,
      BaseReferences<_$MyDatabase, $PaymentMethodTableTable, PaymentMethod>
    ),
    PaymentMethod,
    PrefetchHooks Function()> {
  $$PaymentMethodTableTableTableManager(
      _$MyDatabase db, $PaymentMethodTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentMethodTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentMethodTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentMethodTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> details = const Value.absent(),
            Value<String?> instructions = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentMethodTableCompanion(
            id: id,
            name: name,
            details: details,
            instructions: instructions,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required String name,
            Value<String?> details = const Value.absent(),
            Value<String?> instructions = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentMethodTableCompanion.insert(
            id: id,
            name: name,
            details: details,
            instructions: instructions,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PaymentMethodTableTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $PaymentMethodTableTable,
    PaymentMethod,
    $$PaymentMethodTableTableFilterComposer,
    $$PaymentMethodTableTableOrderingComposer,
    $$PaymentMethodTableTableAnnotationComposer,
    $$PaymentMethodTableTableCreateCompanionBuilder,
    $$PaymentMethodTableTableUpdateCompanionBuilder,
    (
      PaymentMethod,
      BaseReferences<_$MyDatabase, $PaymentMethodTableTable, PaymentMethod>
    ),
    PaymentMethod,
    PrefetchHooks Function()>;
typedef $$FavoriteBookTableTableCreateCompanionBuilder
    = FavoriteBookTableCompanion Function({
  required int id,
  required int totalCopies,
  Value<String?> status,
  Value<String?> title,
  Value<String?> description,
  Value<String?> publishedYear,
  Value<String?> coverImage,
  Value<String?> authorName,
  required int userId,
  Value<int> rowid,
});
typedef $$FavoriteBookTableTableUpdateCompanionBuilder
    = FavoriteBookTableCompanion Function({
  Value<int> id,
  Value<int> totalCopies,
  Value<String?> status,
  Value<String?> title,
  Value<String?> description,
  Value<String?> publishedYear,
  Value<String?> coverImage,
  Value<String?> authorName,
  Value<int> userId,
  Value<int> rowid,
});

class $$FavoriteBookTableTableFilterComposer
    extends Composer<_$MyDatabase, $FavoriteBookTableTable> {
  $$FavoriteBookTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCopies => $composableBuilder(
      column: $table.totalCopies, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get publishedYear => $composableBuilder(
      column: $table.publishedYear, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));
}

class $$FavoriteBookTableTableOrderingComposer
    extends Composer<_$MyDatabase, $FavoriteBookTableTable> {
  $$FavoriteBookTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCopies => $composableBuilder(
      column: $table.totalCopies, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get publishedYear => $composableBuilder(
      column: $table.publishedYear,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));
}

class $$FavoriteBookTableTableAnnotationComposer
    extends Composer<_$MyDatabase, $FavoriteBookTableTable> {
  $$FavoriteBookTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalCopies => $composableBuilder(
      column: $table.totalCopies, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get publishedYear => $composableBuilder(
      column: $table.publishedYear, builder: (column) => column);

  GeneratedColumn<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
      column: $table.authorName, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);
}

class $$FavoriteBookTableTableTableManager extends RootTableManager<
    _$MyDatabase,
    $FavoriteBookTableTable,
    Book,
    $$FavoriteBookTableTableFilterComposer,
    $$FavoriteBookTableTableOrderingComposer,
    $$FavoriteBookTableTableAnnotationComposer,
    $$FavoriteBookTableTableCreateCompanionBuilder,
    $$FavoriteBookTableTableUpdateCompanionBuilder,
    (Book, BaseReferences<_$MyDatabase, $FavoriteBookTableTable, Book>),
    Book,
    PrefetchHooks Function()> {
  $$FavoriteBookTableTableTableManager(
      _$MyDatabase db, $FavoriteBookTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteBookTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteBookTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteBookTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> totalCopies = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> publishedYear = const Value.absent(),
            Value<String?> coverImage = const Value.absent(),
            Value<String?> authorName = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoriteBookTableCompanion(
            id: id,
            totalCopies: totalCopies,
            status: status,
            title: title,
            description: description,
            publishedYear: publishedYear,
            coverImage: coverImage,
            authorName: authorName,
            userId: userId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required int totalCopies,
            Value<String?> status = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> publishedYear = const Value.absent(),
            Value<String?> coverImage = const Value.absent(),
            Value<String?> authorName = const Value.absent(),
            required int userId,
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoriteBookTableCompanion.insert(
            id: id,
            totalCopies: totalCopies,
            status: status,
            title: title,
            description: description,
            publishedYear: publishedYear,
            coverImage: coverImage,
            authorName: authorName,
            userId: userId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoriteBookTableTableProcessedTableManager = ProcessedTableManager<
    _$MyDatabase,
    $FavoriteBookTableTable,
    Book,
    $$FavoriteBookTableTableFilterComposer,
    $$FavoriteBookTableTableOrderingComposer,
    $$FavoriteBookTableTableAnnotationComposer,
    $$FavoriteBookTableTableCreateCompanionBuilder,
    $$FavoriteBookTableTableUpdateCompanionBuilder,
    (Book, BaseReferences<_$MyDatabase, $FavoriteBookTableTable, Book>),
    Book,
    PrefetchHooks Function()>;

class $MyDatabaseManager {
  final _$MyDatabase _db;
  $MyDatabaseManager(this._db);
  $$UnsentTableTableTableManager get unsentTable =>
      $$UnsentTableTableTableManager(_db, _db.unsentTable);
  $$DivisionTableTableTableManager get divisionTable =>
      $$DivisionTableTableTableManager(_db, _db.divisionTable);
  $$DistrictTableTableTableManager get districtTable =>
      $$DistrictTableTableTableManager(_db, _db.districtTable);
  $$DonorTableTableTableManager get donorTable =>
      $$DonorTableTableTableManager(_db, _db.donorTable);
  $$AuthorTableTableTableManager get authorTable =>
      $$AuthorTableTableTableManager(_db, _db.authorTable);
  $$RoomTableTableTableManager get roomTable =>
      $$RoomTableTableTableManager(_db, _db.roomTable);
  $$CategoryTableTableTableManager get categoryTable =>
      $$CategoryTableTableTableManager(_db, _db.categoryTable);
  $$ShelfTableTableTableManager get shelfTable =>
      $$ShelfTableTableTableManager(_db, _db.shelfTable);
  $$CountryTableTableTableManager get countryTable =>
      $$CountryTableTableTableManager(_db, _db.countryTable);
  $$PlatformPackageTableTableTableManager get platformPackageTable =>
      $$PlatformPackageTableTableTableManager(_db, _db.platformPackageTable);
  $$PaymentMethodTableTableTableManager get paymentMethodTable =>
      $$PaymentMethodTableTableTableManager(_db, _db.paymentMethodTable);
  $$FavoriteBookTableTableTableManager get favoriteBookTable =>
      $$FavoriteBookTableTableTableManager(_db, _db.favoriteBookTable);
}
