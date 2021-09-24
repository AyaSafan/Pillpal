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

  ReminderCheckDao? _reminderCheckDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `medicines` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `desc` TEXT NOT NULL, `supplyCurrent` REAL NOT NULL, `supplyMin` REAL NOT NULL, `dose` REAL NOT NULL, `doseFrequency` REAL NOT NULL, `capSize` REAL NOT NULL, `pillShape` TEXT NOT NULL, `pillColor` INTEGER NOT NULL, `tags` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `reminders` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `medicine_id` INTEGER NOT NULL, `medicineName` TEXT NOT NULL, `date` TEXT NOT NULL, `day` INTEGER NOT NULL, `dateTime` INTEGER NOT NULL, `label` TEXT NOT NULL, `repeated` INTEGER NOT NULL, FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `reminders_check` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `reminder_id` INTEGER, `scheduledDateTime` INTEGER NOT NULL, `checkedDateTime` INTEGER NOT NULL, FOREIGN KEY (`reminder_id`) REFERENCES `reminders` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

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
  ReminderCheckDao get reminderCheckDao {
    return _reminderCheckDaoInstance ??=
        _$ReminderCheckDao(database, changeListener);
  }
}

class _$MedicineDao extends MedicineDao {
  _$MedicineDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _medicineInsertionAdapter = InsertionAdapter(
            database,
            'medicines',
            (Medicine item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'desc': item.desc,
                  'supplyCurrent': item.supplyCurrent,
                  'supplyMin': item.supplyMin,
                  'dose': item.dose,
                  'doseFrequency': item.doseFrequency,
                  'capSize': item.capSize,
                  'pillShape': item.pillShape,
                  'pillColor': _colorIntConverter.encode(item.pillColor),
                  'tags': _listStringConverter.encode(item.tags)
                },
            changeListener),
        _medicineUpdateAdapter = UpdateAdapter(
            database,
            'medicines',
            ['id'],
            (Medicine item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'desc': item.desc,
                  'supplyCurrent': item.supplyCurrent,
                  'supplyMin': item.supplyMin,
                  'dose': item.dose,
                  'doseFrequency': item.doseFrequency,
                  'capSize': item.capSize,
                  'pillShape': item.pillShape,
                  'pillColor': _colorIntConverter.encode(item.pillColor),
                  'tags': _listStringConverter.encode(item.tags)
                },
            changeListener),
        _medicineDeletionAdapter = DeletionAdapter(
            database,
            'medicines',
            ['id'],
            (Medicine item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'desc': item.desc,
                  'supplyCurrent': item.supplyCurrent,
                  'supplyMin': item.supplyMin,
                  'dose': item.dose,
                  'doseFrequency': item.doseFrequency,
                  'capSize': item.capSize,
                  'pillShape': item.pillShape,
                  'pillColor': _colorIntConverter.encode(item.pillColor),
                  'tags': _listStringConverter.encode(item.tags)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Medicine> _medicineInsertionAdapter;

  final UpdateAdapter<Medicine> _medicineUpdateAdapter;

  final DeletionAdapter<Medicine> _medicineDeletionAdapter;

  @override
  Stream<List<Medicine>> findAllMedicinesAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM medicines',
        mapper: (Map<String, Object?> row) => Medicine(
            id: row['id'] as int?,
            name: row['name'] as String,
            desc: row['desc'] as String,
            supplyCurrent: row['supplyCurrent'] as double,
            supplyMin: row['supplyMin'] as double,
            dose: row['dose'] as double,
            doseFrequency: row['doseFrequency'] as double,
            capSize: row['capSize'] as double,
            pillShape: row['pillShape'] as String,
            pillColor: _colorIntConverter.decode(row['pillColor'] as int),
            tags: _listStringConverter.decode(row['tags'] as String)),
        queryableName: 'medicines',
        isView: false);
  }

  @override
  Future<List<Medicine>> findAllMedicines() async {
    return _queryAdapter.queryList('SELECT * FROM medicines',
        mapper: (Map<String, Object?> row) => Medicine(
            id: row['id'] as int?,
            name: row['name'] as String,
            desc: row['desc'] as String,
            supplyCurrent: row['supplyCurrent'] as double,
            supplyMin: row['supplyMin'] as double,
            dose: row['dose'] as double,
            doseFrequency: row['doseFrequency'] as double,
            capSize: row['capSize'] as double,
            pillShape: row['pillShape'] as String,
            pillColor: _colorIntConverter.decode(row['pillColor'] as int),
            tags: _listStringConverter.decode(row['tags'] as String)));
  }

  @override
  Future<Medicine?> findMedicineById(int id) async {
    return _queryAdapter.query('SELECT * FROM medicines WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Medicine(
            id: row['id'] as int?,
            name: row['name'] as String,
            desc: row['desc'] as String,
            supplyCurrent: row['supplyCurrent'] as double,
            supplyMin: row['supplyMin'] as double,
            dose: row['dose'] as double,
            doseFrequency: row['doseFrequency'] as double,
            capSize: row['capSize'] as double,
            pillShape: row['pillShape'] as String,
            pillColor: _colorIntConverter.decode(row['pillColor'] as int),
            tags: _listStringConverter.decode(row['tags'] as String)),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllMedicine() async {
    await _queryAdapter.queryNoReturn('DELETE FROM medicines');
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
      : _queryAdapter = QueryAdapter(database, changeListener),
        _reminderInsertionAdapter = InsertionAdapter(
            database,
            'reminders',
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'medicineName': item.medicineName,
                  'date': item.date,
                  'day': item.day,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'repeated': item.repeated ? 1 : 0
                },
            changeListener),
        _reminderUpdateAdapter = UpdateAdapter(
            database,
            'reminders',
            ['id'],
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'medicineName': item.medicineName,
                  'date': item.date,
                  'day': item.day,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'repeated': item.repeated ? 1 : 0
                },
            changeListener),
        _reminderDeletionAdapter = DeletionAdapter(
            database,
            'reminders',
            ['id'],
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'medicineName': item.medicineName,
                  'date': item.date,
                  'day': item.day,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'repeated': item.repeated ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Reminder> _reminderInsertionAdapter;

  final UpdateAdapter<Reminder> _reminderUpdateAdapter;

  final DeletionAdapter<Reminder> _reminderDeletionAdapter;

  @override
  Stream<List<Reminder>> findAllRemindersAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM reminders',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            medicineName: row['medicineName'] as String,
            date: row['date'] as String,
            day: row['day'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int),
            label: row['label'] as String,
            repeated: (row['repeated'] as int) != 0),
        queryableName: 'reminders',
        isView: false);
  }

  @override
  Future<List<Reminder>> findReminderByMedicineId(int medicineId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM reminders WHERE medicine_id = ?1',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            medicineName: row['medicineName'] as String,
            date: row['date'] as String,
            day: row['day'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int),
            label: row['label'] as String,
            repeated: (row['repeated'] as int) != 0),
        arguments: [medicineId]);
  }

  @override
  Future<List<Reminder>> findReminderForDay(String date, int day) async {
    return _queryAdapter.queryList(
        'SELECT * FROM reminders WHERE repeated = 0 AND date =?1 OR repeated = 1 AND day =?2 OR day=0',
        mapper: (Map<String, Object?> row) => Reminder(id: row['id'] as int?, medicineId: row['medicine_id'] as int, medicineName: row['medicineName'] as String, date: row['date'] as String, day: row['day'] as int, dateTime: _dateTimeConverter.decode(row['dateTime'] as int), label: row['label'] as String, repeated: (row['repeated'] as int) != 0),
        arguments: [date, day]);
  }

  @override
  Stream<List<Reminder>> findReminderForDayAsStream(String date, int day) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM reminders WHERE repeated = 0 AND date =?1 OR repeated = 1 AND day =?2 OR day=0',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            medicineName: row['medicineName'] as String,
            date: row['date'] as String,
            day: row['day'] as int,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int),
            label: row['label'] as String,
            repeated: (row['repeated'] as int) != 0),
        arguments: [date, day],
        queryableName: 'reminders',
        isView: false);
  }

  @override
  Future<void> deleteAllReminders() async {
    await _queryAdapter.queryNoReturn('DELETE FROM reminders');
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

class _$ReminderCheckDao extends ReminderCheckDao {
  _$ReminderCheckDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _reminderCheckInsertionAdapter = InsertionAdapter(
            database,
            'reminders_check',
            (ReminderCheck item) => <String, Object?>{
                  'id': item.id,
                  'reminder_id': item.reminderId,
                  'scheduledDateTime':
                      _dateTimeConverter.encode(item.scheduledDateTime),
                  'checkedDateTime':
                      _dateTimeConverter.encode(item.checkedDateTime)
                }),
        _reminderCheckDeletionAdapter = DeletionAdapter(
            database,
            'reminders_check',
            ['id'],
            (ReminderCheck item) => <String, Object?>{
                  'id': item.id,
                  'reminder_id': item.reminderId,
                  'scheduledDateTime':
                      _dateTimeConverter.encode(item.scheduledDateTime),
                  'checkedDateTime':
                      _dateTimeConverter.encode(item.checkedDateTime)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ReminderCheck> _reminderCheckInsertionAdapter;

  final DeletionAdapter<ReminderCheck> _reminderCheckDeletionAdapter;

  @override
  Future<ReminderCheck?> findReminderByScheduledDate(
      DateTime datetime, int reminderId) async {
    return _queryAdapter.query(
        'SELECT * FROM reminders_check WHERE scheduledDateTime =?1 AND reminder_id =?2',
        mapper: (Map<String, Object?> row) => ReminderCheck(id: row['id'] as int?, reminderId: row['reminder_id'] as int?, scheduledDateTime: _dateTimeConverter.decode(row['scheduledDateTime'] as int), checkedDateTime: _dateTimeConverter.decode(row['checkedDateTime'] as int)),
        arguments: [_dateTimeConverter.encode(datetime), reminderId]);
  }

  @override
  Future<void> insertReminderCheck(ReminderCheck check) async {
    await _reminderCheckInsertionAdapter.insert(
        check, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteReminderCheck(ReminderCheck check) async {
    await _reminderCheckDeletionAdapter.delete(check);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _listStringConverter = ListStringConverter();
final _colorIntConverter = ColorIntConverter();
