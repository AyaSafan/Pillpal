// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MedicineDao? _medicineDaoInstance;

  ReminderDao? _reminderDaoInstance;

  CyclicReminderDao? _cyclicDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `medicine` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `desc` TEXT NOT NULL, `amountAvailable` INTEGER NOT NULL, `supplyMin` INTEGER NOT NULL, `dose` INTEGER NOT NULL, `capSize` INTEGER NOT NULL, `pillShape` TEXT NOT NULL, `pillColor` INTEGER NOT NULL, `tags` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `reminder` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `medicine_id` INTEGER NOT NULL, `dateTime` INTEGER NOT NULL, `label` TEXT NOT NULL, `checked` INTEGER NOT NULL, FOREIGN KEY (`medicine_id`) REFERENCES `medicine` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `cyclic_reminder` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `medicine_id` INTEGER NOT NULL, `dates` TEXT NOT NULL, `dateTime` INTEGER NOT NULL, `label` TEXT NOT NULL, `checked` INTEGER NOT NULL, FOREIGN KEY (`medicine_id`) REFERENCES `medicine` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MedicineDao get medicineDao {
    return _medicineDaoInstance ??= _$MedicineDao(database, changeListener);
  }

  @override
  ReminderDao get reminderDao {
    return _reminderDaoInstance ??= _$ReminderDao(database, changeListener);
  }

  @override
  CyclicReminderDao get cyclicDao {
    return _cyclicDaoInstance ??= _$CyclicReminderDao(database, changeListener);
  }
}

class _$MedicineDao extends MedicineDao {
  _$MedicineDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _medicineInsertionAdapter = InsertionAdapter(
            database,
            'medicine',
            (Medicine item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'desc': item.desc,
                  'amountAvailable': item.amountAvailable,
                  'supplyMin': item.supplyMin,
                  'dose': item.dose,
                  'capSize': item.capSize,
                  'pillShape': item.pillShape,
                  'pillColor': _colorIntConverter.encode(item.pillColor),
                  'tags': _listConverter.encode(item.tags)
                }),
        _medicineUpdateAdapter = UpdateAdapter(
            database,
            'medicine',
            ['id'],
            (Medicine item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'desc': item.desc,
                  'amountAvailable': item.amountAvailable,
                  'supplyMin': item.supplyMin,
                  'dose': item.dose,
                  'capSize': item.capSize,
                  'pillShape': item.pillShape,
                  'pillColor': _colorIntConverter.encode(item.pillColor),
                  'tags': _listConverter.encode(item.tags)
                }),
        _medicineDeletionAdapter = DeletionAdapter(
            database,
            'medicine',
            ['id'],
            (Medicine item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'desc': item.desc,
                  'amountAvailable': item.amountAvailable,
                  'supplyMin': item.supplyMin,
                  'dose': item.dose,
                  'capSize': item.capSize,
                  'pillShape': item.pillShape,
                  'pillColor': _colorIntConverter.encode(item.pillColor),
                  'tags': _listConverter.encode(item.tags)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Medicine> _medicineInsertionAdapter;

  final UpdateAdapter<Medicine> _medicineUpdateAdapter;

  final DeletionAdapter<Medicine> _medicineDeletionAdapter;

  @override
  Future<List<Medicine>> findAllMedicines() async {
    return _queryAdapter.queryList('SELECT * FROM medicine',
        mapper: (Map<String, Object?> row) => Medicine(
            id: row['id'] as int?,
            name: row['name'] as String,
            desc: row['desc'] as String,
            amountAvailable: row['amountAvailable'] as int,
            supplyMin: row['supplyMin'] as int,
            dose: row['dose'] as int,
            capSize: row['capSize'] as int,
            pillShape: row['pillShape'] as String,
            pillColor: _colorIntConverter.decode(row['pillColor'] as int),
            tags: _listConverter.decode(row['tags'] as String)));
  }

  @override
  Future<List<Medicine>> findMedicineByName(String name) async {
    return _queryAdapter.queryList('SELECT * FROM medicine WHERE name =?1',
        mapper: (Map<String, Object?> row) => Medicine(
            id: row['id'] as int?,
            name: row['name'] as String,
            desc: row['desc'] as String,
            amountAvailable: row['amountAvailable'] as int,
            supplyMin: row['supplyMin'] as int,
            dose: row['dose'] as int,
            capSize: row['capSize'] as int,
            pillShape: row['pillShape'] as String,
            pillColor: _colorIntConverter.decode(row['pillColor'] as int),
            tags: _listConverter.decode(row['tags'] as String)),
        arguments: [name]);
  }

  @override
  Future<Medicine?> findMedicineById(int id) async {
    return _queryAdapter.query('SELECT * FROM medicine WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Medicine(
            id: row['id'] as int?,
            name: row['name'] as String,
            desc: row['desc'] as String,
            amountAvailable: row['amountAvailable'] as int,
            supplyMin: row['supplyMin'] as int,
            dose: row['dose'] as int,
            capSize: row['capSize'] as int,
            pillShape: row['pillShape'] as String,
            pillColor: _colorIntConverter.decode(row['pillColor'] as int),
            tags: _listConverter.decode(row['tags'] as String)),
        arguments: [id]);
  }

  @override
  Future<void> updateAmountAvailable(int amount, int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE medicine SET amountAvailable =?1 WHERE id = ?2',
        arguments: [amount, id]);
  }

  @override
  Future<void> takeDose(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE medicine SET amountAvailable = amountAvailable-dose WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> updateTags(List<String> tags, int id) async {
    const offset = 2;
    final _sqliteVariablesForTags =
        Iterable<String>.generate(tags.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'UPDATE medicine SET tags IN (' +
            _sqliteVariablesForTags +
            ') WHERE id = ?1',
        arguments: [id, ...tags]);
  }

  @override
  Future<void> deleteAllMedicine() async {
    await _queryAdapter.queryNoReturn('DELETE FROM medicine');
  }

  @override
  Future<void> insertMedicine(Medicine medicine) async {
    await _medicineInsertionAdapter.insert(medicine, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMedicine(Medicine medicine) async {
    await _medicineUpdateAdapter.update(medicine, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMedicine(Medicine medicine) async {
    await _medicineDeletionAdapter.delete(medicine);
  }
}

class _$ReminderDao extends ReminderDao {
  _$ReminderDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _reminderInsertionAdapter = InsertionAdapter(
            database,
            'reminder',
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'checked': item.checked ? 1 : 0
                }),
        _reminderUpdateAdapter = UpdateAdapter(
            database,
            'reminder',
            ['id'],
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'checked': item.checked ? 1 : 0
                }),
        _reminderDeletionAdapter = DeletionAdapter(
            database,
            'reminder',
            ['id'],
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'checked': item.checked ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Reminder> _reminderInsertionAdapter;

  final UpdateAdapter<Reminder> _reminderUpdateAdapter;

  final DeletionAdapter<Reminder> _reminderDeletionAdapter;

  @override
  Future<List<Reminder>> findAllReminders() async {
    return _queryAdapter.queryList('SELECT * FROM reminder',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int),
            label: row['label'] as String,
            checked: (row['checked'] as int) != 0));
  }

  @override
  Future<Reminder?> findReminderById(int id) async {
    return _queryAdapter.query('SELECT * FROM reminder WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int),
            label: row['label'] as String,
            checked: (row['checked'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<List<Reminder>> findReminderByDate(DateTime dateTime) async {
    return _queryAdapter.queryList('SELECT * FROM reminder WHERE dateTime = ?1',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int),
            label: row['label'] as String,
            checked: (row['checked'] as int) != 0),
        arguments: [_dateTimeConverter.encode(dateTime)]);
  }

  @override
  Future<void> deleteAllReminders() async {
    await _queryAdapter.queryNoReturn('DELETE FROM reminder');
  }

  @override
  Future<void> insertReminder(Reminder reminder) async {
    await _reminderInsertionAdapter.insert(reminder, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    await _reminderUpdateAdapter.update(reminder, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteReminder(Reminder reminder) async {
    await _reminderDeletionAdapter.delete(reminder);
  }
}

class _$CyclicReminderDao extends CyclicReminderDao {
  _$CyclicReminderDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _cyclicReminderInsertionAdapter = InsertionAdapter(
            database,
            'cyclic_reminder',
            (CyclicReminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'dates': _listConverter.encode(item.dates),
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'checked': item.checked ? 1 : 0
                }),
        _cyclicReminderUpdateAdapter = UpdateAdapter(
            database,
            'cyclic_reminder',
            ['id'],
            (CyclicReminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'dates': _listConverter.encode(item.dates),
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'checked': item.checked ? 1 : 0
                }),
        _cyclicReminderDeletionAdapter = DeletionAdapter(
            database,
            'cyclic_reminder',
            ['id'],
            (CyclicReminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'dates': _listConverter.encode(item.dates),
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'checked': item.checked ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CyclicReminder> _cyclicReminderInsertionAdapter;

  final UpdateAdapter<CyclicReminder> _cyclicReminderUpdateAdapter;

  final DeletionAdapter<CyclicReminder> _cyclicReminderDeletionAdapter;

  @override
  Future<List<CyclicReminder>> findAllCyclicReminder() async {
    return _queryAdapter.queryList('SELECT * FROM cyclic_reminder',
        mapper: (Map<String, Object?> row) => CyclicReminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            dates: _listConverter.decode(row['dates'] as String),
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int),
            label: row['label'] as String,
            checked: (row['checked'] as int) != 0));
  }

  @override
  Future<CyclicReminder?> findCyclicReminderById(int id) async {
    return _queryAdapter.query('SELECT * FROM cyclic_reminder WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CyclicReminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            dates: _listConverter.decode(row['dates'] as String),
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int),
            label: row['label'] as String,
            checked: (row['checked'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllCyclicReminders() async {
    await _queryAdapter.queryNoReturn('DELETE FROM cyclic_reminder');
  }

  @override
  Future<void> insertCyclicReminder(CyclicReminder reminder) async {
    await _cyclicReminderInsertionAdapter.insert(
        reminder, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCyclicReminder(CyclicReminder reminder) async {
    await _cyclicReminderUpdateAdapter.update(
        reminder, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCyclicReminder(CyclicReminder reminder) async {
    await _cyclicReminderDeletionAdapter.delete(reminder);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _listConverter = ListConverter();
final _colorIntConverter = ColorIntConverter();
