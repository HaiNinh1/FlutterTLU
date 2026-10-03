// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables.dart';

// ignore_for_file: type=lint
class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _subjectPkMeta = const VerificationMeta(
    'subjectPk',
  );
  @override
  late final GeneratedColumn<String> subjectPk = GeneratedColumn<String>(
    'subject_pk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v4(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colourMeta = const VerificationMeta('colour');
  @override
  late final GeneratedColumn<String> colour = GeneratedColumn<String>(
    'colour',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateCreatedMeta = const VerificationMeta(
    'dateCreated',
  );
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
    'date_created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _dateTimeModifiedMeta = const VerificationMeta(
    'dateTimeModified',
  );
  @override
  late final GeneratedColumn<DateTime> dateTimeModified =
      GeneratedColumn<DateTime>(
        'date_time_modified',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    subjectPk,
    name,
    colour,
    order,
    dateCreated,
    dateTimeModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('subject_pk')) {
      context.handle(
        _subjectPkMeta,
        subjectPk.isAcceptableOrUnknown(data['subject_pk']!, _subjectPkMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('colour')) {
      context.handle(
        _colourMeta,
        colour.isAcceptableOrUnknown(data['colour']!, _colourMeta),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
        _dateCreatedMeta,
        dateCreated.isAcceptableOrUnknown(
          data['date_created']!,
          _dateCreatedMeta,
        ),
      );
    }
    if (data.containsKey('date_time_modified')) {
      context.handle(
        _dateTimeModifiedMeta,
        dateTimeModified.isAcceptableOrUnknown(
          data['date_time_modified']!,
          _dateTimeModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {subjectPk};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      subjectPk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_pk'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colour: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}colour'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      dateCreated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_created'],
      )!,
      dateTimeModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_time_modified'],
      ),
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final String subjectPk;
  final String name;
  final String? colour;
  final int order;
  final DateTime dateCreated;
  final DateTime? dateTimeModified;
  const Subject({
    required this.subjectPk,
    required this.name,
    this.colour,
    required this.order,
    required this.dateCreated,
    this.dateTimeModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['subject_pk'] = Variable<String>(subjectPk);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || colour != null) {
      map['colour'] = Variable<String>(colour);
    }
    map['order'] = Variable<int>(order);
    map['date_created'] = Variable<DateTime>(dateCreated);
    if (!nullToAbsent || dateTimeModified != null) {
      map['date_time_modified'] = Variable<DateTime>(dateTimeModified);
    }
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      subjectPk: Value(subjectPk),
      name: Value(name),
      colour: colour == null && nullToAbsent
          ? const Value.absent()
          : Value(colour),
      order: Value(order),
      dateCreated: Value(dateCreated),
      dateTimeModified: dateTimeModified == null && nullToAbsent
          ? const Value.absent()
          : Value(dateTimeModified),
    );
  }

  factory Subject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      subjectPk: serializer.fromJson<String>(json['subjectPk']),
      name: serializer.fromJson<String>(json['name']),
      colour: serializer.fromJson<String?>(json['colour']),
      order: serializer.fromJson<int>(json['order']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      dateTimeModified: serializer.fromJson<DateTime?>(
        json['dateTimeModified'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'subjectPk': serializer.toJson<String>(subjectPk),
      'name': serializer.toJson<String>(name),
      'colour': serializer.toJson<String?>(colour),
      'order': serializer.toJson<int>(order),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'dateTimeModified': serializer.toJson<DateTime?>(dateTimeModified),
    };
  }

  Subject copyWith({
    String? subjectPk,
    String? name,
    Value<String?> colour = const Value.absent(),
    int? order,
    DateTime? dateCreated,
    Value<DateTime?> dateTimeModified = const Value.absent(),
  }) => Subject(
    subjectPk: subjectPk ?? this.subjectPk,
    name: name ?? this.name,
    colour: colour.present ? colour.value : this.colour,
    order: order ?? this.order,
    dateCreated: dateCreated ?? this.dateCreated,
    dateTimeModified: dateTimeModified.present
        ? dateTimeModified.value
        : this.dateTimeModified,
  );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      subjectPk: data.subjectPk.present ? data.subjectPk.value : this.subjectPk,
      name: data.name.present ? data.name.value : this.name,
      colour: data.colour.present ? data.colour.value : this.colour,
      order: data.order.present ? data.order.value : this.order,
      dateCreated: data.dateCreated.present
          ? data.dateCreated.value
          : this.dateCreated,
      dateTimeModified: data.dateTimeModified.present
          ? data.dateTimeModified.value
          : this.dateTimeModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('subjectPk: $subjectPk, ')
          ..write('name: $name, ')
          ..write('colour: $colour, ')
          ..write('order: $order, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateTimeModified: $dateTimeModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    subjectPk,
    name,
    colour,
    order,
    dateCreated,
    dateTimeModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.subjectPk == this.subjectPk &&
          other.name == this.name &&
          other.colour == this.colour &&
          other.order == this.order &&
          other.dateCreated == this.dateCreated &&
          other.dateTimeModified == this.dateTimeModified);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<String> subjectPk;
  final Value<String> name;
  final Value<String?> colour;
  final Value<int> order;
  final Value<DateTime> dateCreated;
  final Value<DateTime?> dateTimeModified;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.subjectPk = const Value.absent(),
    this.name = const Value.absent(),
    this.colour = const Value.absent(),
    this.order = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateTimeModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    this.subjectPk = const Value.absent(),
    required String name,
    this.colour = const Value.absent(),
    required int order,
    this.dateCreated = const Value.absent(),
    this.dateTimeModified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       order = Value(order);
  static Insertable<Subject> custom({
    Expression<String>? subjectPk,
    Expression<String>? name,
    Expression<String>? colour,
    Expression<int>? order,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateTimeModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (subjectPk != null) 'subject_pk': subjectPk,
      if (name != null) 'name': name,
      if (colour != null) 'colour': colour,
      if (order != null) 'order': order,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateTimeModified != null) 'date_time_modified': dateTimeModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith({
    Value<String>? subjectPk,
    Value<String>? name,
    Value<String?>? colour,
    Value<int>? order,
    Value<DateTime>? dateCreated,
    Value<DateTime?>? dateTimeModified,
    Value<int>? rowid,
  }) {
    return SubjectsCompanion(
      subjectPk: subjectPk ?? this.subjectPk,
      name: name ?? this.name,
      colour: colour ?? this.colour,
      order: order ?? this.order,
      dateCreated: dateCreated ?? this.dateCreated,
      dateTimeModified: dateTimeModified ?? this.dateTimeModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (subjectPk.present) {
      map['subject_pk'] = Variable<String>(subjectPk.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colour.present) {
      map['colour'] = Variable<String>(colour.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateTimeModified.present) {
      map['date_time_modified'] = Variable<DateTime>(dateTimeModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('subjectPk: $subjectPk, ')
          ..write('name: $name, ')
          ..write('colour: $colour, ')
          ..write('order: $order, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateTimeModified: $dateTimeModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _documentPkMeta = const VerificationMeta(
    'documentPk',
  );
  @override
  late final GeneratedColumn<String> documentPk = GeneratedColumn<String>(
    'document_pk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => uuid.v4(),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DocumentType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DocumentType>($DocumentsTable.$convertertype);
  static const VerificationMeta _subjectFkMeta = const VerificationMeta(
    'subjectFk',
  );
  @override
  late final GeneratedColumn<String> subjectFk = GeneratedColumn<String>(
    'subject_fk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (subject_pk)',
    ),
  );
  static const VerificationMeta _linkMeta = const VerificationMeta('link');
  @override
  late final GeneratedColumn<String> link = GeneratedColumn<String>(
    'link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
    'pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _searchTextMeta = const VerificationMeta(
    'searchText',
  );
  @override
  late final GeneratedColumn<String> searchText = GeneratedColumn<String>(
    'search_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sortTitleMeta = const VerificationMeta(
    'sortTitle',
  );
  @override
  late final GeneratedColumn<String> sortTitle = GeneratedColumn<String>(
    'sort_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dateCreatedMeta = const VerificationMeta(
    'dateCreated',
  );
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
    'date_created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _dateTimeModifiedMeta = const VerificationMeta(
    'dateTimeModified',
  );
  @override
  late final GeneratedColumn<DateTime> dateTimeModified =
      GeneratedColumn<DateTime>(
        'date_time_modified',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    documentPk,
    title,
    description,
    type,
    subjectFk,
    link,
    author,
    dueDate,
    pinned,
    searchText,
    sortTitle,
    dateCreated,
    dateTimeModified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Document> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('document_pk')) {
      context.handle(
        _documentPkMeta,
        documentPk.isAcceptableOrUnknown(data['document_pk']!, _documentPkMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('subject_fk')) {
      context.handle(
        _subjectFkMeta,
        subjectFk.isAcceptableOrUnknown(data['subject_fk']!, _subjectFkMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectFkMeta);
    }
    if (data.containsKey('link')) {
      context.handle(
        _linkMeta,
        link.isAcceptableOrUnknown(data['link']!, _linkMeta),
      );
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('pinned')) {
      context.handle(
        _pinnedMeta,
        pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta),
      );
    }
    if (data.containsKey('search_text')) {
      context.handle(
        _searchTextMeta,
        searchText.isAcceptableOrUnknown(data['search_text']!, _searchTextMeta),
      );
    }
    if (data.containsKey('sort_title')) {
      context.handle(
        _sortTitleMeta,
        sortTitle.isAcceptableOrUnknown(data['sort_title']!, _sortTitleMeta),
      );
    }
    if (data.containsKey('date_created')) {
      context.handle(
        _dateCreatedMeta,
        dateCreated.isAcceptableOrUnknown(
          data['date_created']!,
          _dateCreatedMeta,
        ),
      );
    }
    if (data.containsKey('date_time_modified')) {
      context.handle(
        _dateTimeModifiedMeta,
        dateTimeModified.isAcceptableOrUnknown(
          data['date_time_modified']!,
          _dateTimeModifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {documentPk};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      documentPk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_pk'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      type: $DocumentsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      subjectFk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_fk'],
      )!,
      link: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}link'],
      ),
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      pinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pinned'],
      )!,
      searchText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_text'],
      )!,
      sortTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_title'],
      )!,
      dateCreated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_created'],
      )!,
      dateTimeModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_time_modified'],
      ),
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DocumentType, int, int> $convertertype =
      const EnumIndexConverter<DocumentType>(DocumentType.values);
}

class Document extends DataClass implements Insertable<Document> {
  final String documentPk;
  final String title;
  final String? description;
  final DocumentType type;
  final String subjectFk;
  final String? link;
  final String? author;
  final DateTime? dueDate;
  final bool pinned;
  final String searchText;
  final String sortTitle;
  final DateTime dateCreated;
  final DateTime? dateTimeModified;
  const Document({
    required this.documentPk,
    required this.title,
    this.description,
    required this.type,
    required this.subjectFk,
    this.link,
    this.author,
    this.dueDate,
    required this.pinned,
    required this.searchText,
    required this.sortTitle,
    required this.dateCreated,
    this.dateTimeModified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['document_pk'] = Variable<String>(documentPk);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['type'] = Variable<int>($DocumentsTable.$convertertype.toSql(type));
    }
    map['subject_fk'] = Variable<String>(subjectFk);
    if (!nullToAbsent || link != null) {
      map['link'] = Variable<String>(link);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['pinned'] = Variable<bool>(pinned);
    map['search_text'] = Variable<String>(searchText);
    map['sort_title'] = Variable<String>(sortTitle);
    map['date_created'] = Variable<DateTime>(dateCreated);
    if (!nullToAbsent || dateTimeModified != null) {
      map['date_time_modified'] = Variable<DateTime>(dateTimeModified);
    }
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      documentPk: Value(documentPk),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      subjectFk: Value(subjectFk),
      link: link == null && nullToAbsent ? const Value.absent() : Value(link),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      pinned: Value(pinned),
      searchText: Value(searchText),
      sortTitle: Value(sortTitle),
      dateCreated: Value(dateCreated),
      dateTimeModified: dateTimeModified == null && nullToAbsent
          ? const Value.absent()
          : Value(dateTimeModified),
    );
  }

  factory Document.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      documentPk: serializer.fromJson<String>(json['documentPk']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      type: $DocumentsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      subjectFk: serializer.fromJson<String>(json['subjectFk']),
      link: serializer.fromJson<String?>(json['link']),
      author: serializer.fromJson<String?>(json['author']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      searchText: serializer.fromJson<String>(json['searchText']),
      sortTitle: serializer.fromJson<String>(json['sortTitle']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      dateTimeModified: serializer.fromJson<DateTime?>(
        json['dateTimeModified'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'documentPk': serializer.toJson<String>(documentPk),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<int>(
        $DocumentsTable.$convertertype.toJson(type),
      ),
      'subjectFk': serializer.toJson<String>(subjectFk),
      'link': serializer.toJson<String?>(link),
      'author': serializer.toJson<String?>(author),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'pinned': serializer.toJson<bool>(pinned),
      'searchText': serializer.toJson<String>(searchText),
      'sortTitle': serializer.toJson<String>(sortTitle),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'dateTimeModified': serializer.toJson<DateTime?>(dateTimeModified),
    };
  }

  Document copyWith({
    String? documentPk,
    String? title,
    Value<String?> description = const Value.absent(),
    DocumentType? type,
    String? subjectFk,
    Value<String?> link = const Value.absent(),
    Value<String?> author = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    bool? pinned,
    String? searchText,
    String? sortTitle,
    DateTime? dateCreated,
    Value<DateTime?> dateTimeModified = const Value.absent(),
  }) => Document(
    documentPk: documentPk ?? this.documentPk,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    type: type ?? this.type,
    subjectFk: subjectFk ?? this.subjectFk,
    link: link.present ? link.value : this.link,
    author: author.present ? author.value : this.author,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    pinned: pinned ?? this.pinned,
    searchText: searchText ?? this.searchText,
    sortTitle: sortTitle ?? this.sortTitle,
    dateCreated: dateCreated ?? this.dateCreated,
    dateTimeModified: dateTimeModified.present
        ? dateTimeModified.value
        : this.dateTimeModified,
  );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      documentPk: data.documentPk.present
          ? data.documentPk.value
          : this.documentPk,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      subjectFk: data.subjectFk.present ? data.subjectFk.value : this.subjectFk,
      link: data.link.present ? data.link.value : this.link,
      author: data.author.present ? data.author.value : this.author,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
      searchText: data.searchText.present
          ? data.searchText.value
          : this.searchText,
      sortTitle: data.sortTitle.present ? data.sortTitle.value : this.sortTitle,
      dateCreated: data.dateCreated.present
          ? data.dateCreated.value
          : this.dateCreated,
      dateTimeModified: data.dateTimeModified.present
          ? data.dateTimeModified.value
          : this.dateTimeModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('documentPk: $documentPk, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('subjectFk: $subjectFk, ')
          ..write('link: $link, ')
          ..write('author: $author, ')
          ..write('dueDate: $dueDate, ')
          ..write('pinned: $pinned, ')
          ..write('searchText: $searchText, ')
          ..write('sortTitle: $sortTitle, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateTimeModified: $dateTimeModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    documentPk,
    title,
    description,
    type,
    subjectFk,
    link,
    author,
    dueDate,
    pinned,
    searchText,
    sortTitle,
    dateCreated,
    dateTimeModified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.documentPk == this.documentPk &&
          other.title == this.title &&
          other.description == this.description &&
          other.type == this.type &&
          other.subjectFk == this.subjectFk &&
          other.link == this.link &&
          other.author == this.author &&
          other.dueDate == this.dueDate &&
          other.pinned == this.pinned &&
          other.searchText == this.searchText &&
          other.sortTitle == this.sortTitle &&
          other.dateCreated == this.dateCreated &&
          other.dateTimeModified == this.dateTimeModified);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<String> documentPk;
  final Value<String> title;
  final Value<String?> description;
  final Value<DocumentType> type;
  final Value<String> subjectFk;
  final Value<String?> link;
  final Value<String?> author;
  final Value<DateTime?> dueDate;
  final Value<bool> pinned;
  final Value<String> searchText;
  final Value<String> sortTitle;
  final Value<DateTime> dateCreated;
  final Value<DateTime?> dateTimeModified;
  final Value<int> rowid;
  const DocumentsCompanion({
    this.documentPk = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.subjectFk = const Value.absent(),
    this.link = const Value.absent(),
    this.author = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.pinned = const Value.absent(),
    this.searchText = const Value.absent(),
    this.sortTitle = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateTimeModified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.documentPk = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    required DocumentType type,
    required String subjectFk,
    this.link = const Value.absent(),
    this.author = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.pinned = const Value.absent(),
    this.searchText = const Value.absent(),
    this.sortTitle = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateTimeModified = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title),
       type = Value(type),
       subjectFk = Value(subjectFk);
  static Insertable<Document> custom({
    Expression<String>? documentPk,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? type,
    Expression<String>? subjectFk,
    Expression<String>? link,
    Expression<String>? author,
    Expression<DateTime>? dueDate,
    Expression<bool>? pinned,
    Expression<String>? searchText,
    Expression<String>? sortTitle,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateTimeModified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (documentPk != null) 'document_pk': documentPk,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (subjectFk != null) 'subject_fk': subjectFk,
      if (link != null) 'link': link,
      if (author != null) 'author': author,
      if (dueDate != null) 'due_date': dueDate,
      if (pinned != null) 'pinned': pinned,
      if (searchText != null) 'search_text': searchText,
      if (sortTitle != null) 'sort_title': sortTitle,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateTimeModified != null) 'date_time_modified': dateTimeModified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsCompanion copyWith({
    Value<String>? documentPk,
    Value<String>? title,
    Value<String?>? description,
    Value<DocumentType>? type,
    Value<String>? subjectFk,
    Value<String?>? link,
    Value<String?>? author,
    Value<DateTime?>? dueDate,
    Value<bool>? pinned,
    Value<String>? searchText,
    Value<String>? sortTitle,
    Value<DateTime>? dateCreated,
    Value<DateTime?>? dateTimeModified,
    Value<int>? rowid,
  }) {
    return DocumentsCompanion(
      documentPk: documentPk ?? this.documentPk,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      subjectFk: subjectFk ?? this.subjectFk,
      link: link ?? this.link,
      author: author ?? this.author,
      dueDate: dueDate ?? this.dueDate,
      pinned: pinned ?? this.pinned,
      searchText: searchText ?? this.searchText,
      sortTitle: sortTitle ?? this.sortTitle,
      dateCreated: dateCreated ?? this.dateCreated,
      dateTimeModified: dateTimeModified ?? this.dateTimeModified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (documentPk.present) {
      map['document_pk'] = Variable<String>(documentPk.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $DocumentsTable.$convertertype.toSql(type.value),
      );
    }
    if (subjectFk.present) {
      map['subject_fk'] = Variable<String>(subjectFk.value);
    }
    if (link.present) {
      map['link'] = Variable<String>(link.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (searchText.present) {
      map['search_text'] = Variable<String>(searchText.value);
    }
    if (sortTitle.present) {
      map['sort_title'] = Variable<String>(sortTitle.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateTimeModified.present) {
      map['date_time_modified'] = Variable<DateTime>(dateTimeModified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('documentPk: $documentPk, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('subjectFk: $subjectFk, ')
          ..write('link: $link, ')
          ..write('author: $author, ')
          ..write('dueDate: $dueDate, ')
          ..write('pinned: $pinned, ')
          ..write('searchText: $searchText, ')
          ..write('sortTitle: $sortTitle, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateTimeModified: $dateTimeModified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$StudyDatabase extends GeneratedDatabase {
  _$StudyDatabase(QueryExecutor e) : super(e);
  $StudyDatabaseManager get managers => $StudyDatabaseManager(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [subjects, documents];
}

typedef $$SubjectsTableCreateCompanionBuilder = SubjectsCompanion Function({
  Value<String> subjectPk,
  required String name,
  Value<String?> colour,
  required int order,
  Value<DateTime> dateCreated,
  Value<DateTime?> dateTimeModified,
  Value<int> rowid,
});
typedef $$SubjectsTableUpdateCompanionBuilder = SubjectsCompanion Function({
  Value<String> subjectPk,
  Value<String> name,
  Value<String?> colour,
  Value<int> order,
  Value<DateTime> dateCreated,
  Value<DateTime?> dateTimeModified,
  Value<int> rowid,
});

final class $$SubjectsTableReferences
    extends BaseReferences<_$StudyDatabase, $SubjectsTable, Subject> {
  $$SubjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DocumentsTable, List<Document>>
  _documentsRefsTable(_$StudyDatabase db) => MultiTypedResultKey.fromTable(
    db.documents,
    aliasName: 'subjects__subject_pk__documents__subject_fk',
  );

  $$DocumentsTableProcessedTableManager get documentsRefs {
    final manager = $$DocumentsTableTableManager($_db, $_db.documents).filter(
      (f) =>
          f.subjectFk.subjectPk.sqlEquals($_itemColumn<String>('subject_pk')!),
    );

    final cache = $_typedResult.readTableOrNull(_documentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubjectsTableFilterComposer
    extends Composer<_$StudyDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get subjectPk => $composableBuilder(
    column: $table.subjectPk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colour => $composableBuilder(
    column: $table.colour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateTimeModified => $composableBuilder(
    column: $table.dateTimeModified,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> documentsRefs(
    Expression<bool> Function($$DocumentsTableFilterComposer f) f,
  ) {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectPk,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.subjectFk,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$StudyDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get subjectPk => $composableBuilder(
    column: $table.subjectPk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colour => $composableBuilder(
    column: $table.colour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateTimeModified => $composableBuilder(
    column: $table.dateTimeModified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$StudyDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get subjectPk =>
      $composableBuilder(column: $table.subjectPk, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colour =>
      $composableBuilder(column: $table.colour, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateTimeModified => $composableBuilder(
    column: $table.dateTimeModified,
    builder: (column) => column,
  );

  Expression<T> documentsRefs<T extends Object>(
    Expression<T> Function($$DocumentsTableAnnotationComposer a) f,
  ) {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectPk,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.subjectFk,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableTableManager
    extends
        RootTableManager<
          _$StudyDatabase,
          $SubjectsTable,
          Subject,
          $$SubjectsTableFilterComposer,
          $$SubjectsTableOrderingComposer,
          $$SubjectsTableAnnotationComposer,
          $$SubjectsTableCreateCompanionBuilder,
          $$SubjectsTableUpdateCompanionBuilder,
          (Subject, $$SubjectsTableReferences),
          Subject,
          PrefetchHooks Function({bool documentsRefs})
        > {
  $$SubjectsTableTableManager(_$StudyDatabase db, $SubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> subjectPk = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> colour = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<DateTime> dateCreated = const Value.absent(),
                Value<DateTime?> dateTimeModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion(
                subjectPk: subjectPk,
                name: name,
                colour: colour,
                order: order,
                dateCreated: dateCreated,
                dateTimeModified: dateTimeModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> subjectPk = const Value.absent(),
                required String name,
                Value<String?> colour = const Value.absent(),
                required int order,
                Value<DateTime> dateCreated = const Value.absent(),
                Value<DateTime?> dateTimeModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion.insert(
                subjectPk: subjectPk,
                name: name,
                colour: colour,
                order: order,
                dateCreated: dateCreated,
                dateTimeModified: dateTimeModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubjectsTable, Subject>(table),
                  $$SubjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({documentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (documentsRefs) db.documents],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (documentsRefs)
                    await $_getPrefetchedData<
                      Subject,
                      $SubjectsTable,
                      Document
                    >(
                      currentTable: table,
                      referencedTable: $$SubjectsTableReferences
                          ._documentsRefsTable(db),
                      managerFromTypedResult: (p0) => $$SubjectsTableReferences(
                        db,
                        table,
                        p0,
                      ).documentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.subjectFk == item.subjectPk,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$StudyDatabase,
      $SubjectsTable,
      Subject,
      $$SubjectsTableFilterComposer,
      $$SubjectsTableOrderingComposer,
      $$SubjectsTableAnnotationComposer,
      $$SubjectsTableCreateCompanionBuilder,
      $$SubjectsTableUpdateCompanionBuilder,
      (Subject, $$SubjectsTableReferences),
      Subject,
      PrefetchHooks Function({bool documentsRefs})
    >;
typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  Value<String> documentPk,
  required String title,
  Value<String?> description,
  required DocumentType type,
  required String subjectFk,
  Value<String?> link,
  Value<String?> author,
  Value<DateTime?> dueDate,
  Value<bool> pinned,
  Value<String> searchText,
  Value<String> sortTitle,
  Value<DateTime> dateCreated,
  Value<DateTime?> dateTimeModified,
  Value<int> rowid,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<String> documentPk,
  Value<String> title,
  Value<String?> description,
  Value<DocumentType> type,
  Value<String> subjectFk,
  Value<String?> link,
  Value<String?> author,
  Value<DateTime?> dueDate,
  Value<bool> pinned,
  Value<String> searchText,
  Value<String> sortTitle,
  Value<DateTime> dateCreated,
  Value<DateTime?> dateTimeModified,
  Value<int> rowid,
});

final class $$DocumentsTableReferences
    extends BaseReferences<_$StudyDatabase, $DocumentsTable, Document> {
  $$DocumentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectsTable _subjectFkTable(_$StudyDatabase db) =>
      db.subjects.createAlias('documents__subject_fk__subjects__subject_pk');

  $$SubjectsTableProcessedTableManager get subjectFk {
    final $_column = $_itemColumn<String>('subject_fk')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.subjectPk.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectFkTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DocumentsTableFilterComposer
    extends Composer<_$StudyDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get documentPk => $composableBuilder(
    column: $table.documentPk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DocumentType, DocumentType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortTitle => $composableBuilder(
    column: $table.sortTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateTimeModified => $composableBuilder(
    column: $table.dateTimeModified,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectFk {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectFk,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.subjectPk,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$StudyDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get documentPk => $composableBuilder(
    column: $table.documentPk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get link => $composableBuilder(
    column: $table.link,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortTitle => $composableBuilder(
    column: $table.sortTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateTimeModified => $composableBuilder(
    column: $table.dateTimeModified,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectFk {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectFk,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.subjectPk,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$StudyDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get documentPk => $composableBuilder(
    column: $table.documentPk,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DocumentType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get link =>
      $composableBuilder(column: $table.link, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);

  GeneratedColumn<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sortTitle =>
      $composableBuilder(column: $table.sortTitle, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCreated => $composableBuilder(
    column: $table.dateCreated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateTimeModified => $composableBuilder(
    column: $table.dateTimeModified,
    builder: (column) => column,
  );

  $$SubjectsTableAnnotationComposer get subjectFk {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectFk,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.subjectPk,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentsTableTableManager
    extends
        RootTableManager<
          _$StudyDatabase,
          $DocumentsTable,
          Document,
          $$DocumentsTableFilterComposer,
          $$DocumentsTableOrderingComposer,
          $$DocumentsTableAnnotationComposer,
          $$DocumentsTableCreateCompanionBuilder,
          $$DocumentsTableUpdateCompanionBuilder,
          (Document, $$DocumentsTableReferences),
          Document,
          PrefetchHooks Function({bool subjectFk})
        > {
  $$DocumentsTableTableManager(_$StudyDatabase db, $DocumentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> documentPk = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DocumentType> type = const Value.absent(),
                Value<String> subjectFk = const Value.absent(),
                Value<String?> link = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<bool> pinned = const Value.absent(),
                Value<String> searchText = const Value.absent(),
                Value<String> sortTitle = const Value.absent(),
                Value<DateTime> dateCreated = const Value.absent(),
                Value<DateTime?> dateTimeModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentsCompanion(
                documentPk: documentPk,
                title: title,
                description: description,
                type: type,
                subjectFk: subjectFk,
                link: link,
                author: author,
                dueDate: dueDate,
                pinned: pinned,
                searchText: searchText,
                sortTitle: sortTitle,
                dateCreated: dateCreated,
                dateTimeModified: dateTimeModified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> documentPk = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                required DocumentType type,
                required String subjectFk,
                Value<String?> link = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<bool> pinned = const Value.absent(),
                Value<String> searchText = const Value.absent(),
                Value<String> sortTitle = const Value.absent(),
                Value<DateTime> dateCreated = const Value.absent(),
                Value<DateTime?> dateTimeModified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentsCompanion.insert(
                documentPk: documentPk,
                title: title,
                description: description,
                type: type,
                subjectFk: subjectFk,
                link: link,
                author: author,
                dueDate: dueDate,
                pinned: pinned,
                searchText: searchText,
                sortTitle: sortTitle,
                dateCreated: dateCreated,
                dateTimeModified: dateTimeModified,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentsTable, Document>(table),
                  $$DocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subjectFk = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subjectFk) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.subjectFk,
                        referencedTable: $$DocumentsTableReferences
                            ._subjectFkTable(db),
                        referencedColumn: $$DocumentsTableReferences
                            ._subjectFkTable(db)
                            .subjectPk,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$StudyDatabase,
      $DocumentsTable,
      Document,
      $$DocumentsTableFilterComposer,
      $$DocumentsTableOrderingComposer,
      $$DocumentsTableAnnotationComposer,
      $$DocumentsTableCreateCompanionBuilder,
      $$DocumentsTableUpdateCompanionBuilder,
      (Document, $$DocumentsTableReferences),
      Document,
      PrefetchHooks Function({bool subjectFk})
    >;

class $StudyDatabaseManager {
  final _$StudyDatabase _db;
  $StudyDatabaseManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
}
