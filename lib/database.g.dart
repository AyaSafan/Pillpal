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
            'CREATE TABLE IF NOT EXISTS `medicines` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `desc` TEXT NOT NULL, `amountAvailable` INTEGER NOT NULL, `supplyMin` INTEGER NOT NULL, `dose` INTEGER NOT NULL, `capSize` INTEGER NOT NULL, `pillShape` TEXT NOT NULL, `pillColor` INTEGER NOT NULL, `tags` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `reminders` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `medicine_id` INTEGER NOT NULL, `date` TEXT NOT NULL, `day` INTEGER NOT NULL, `dateTime` INTEGER NOT NULL, `label` TEXT NOT NULL, `repeated` INTEGER NOT NULL, FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `reminders_check` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `reminder_id` INTEGER NOT NULL, `scheduledDateTime` INTEGER NOT NULL, `checkedDateTime` INTEGER NOT NULL, FOREIGN KEY (`reminder_id`) REFERENCES `medicines` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

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
      : _queryAdapter = QueryAdapter(database),
        _medicineInsertionAdapter = InsertionAdapter(
            database,
            'medicines',
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
                  'tags': _listStringConverter.encode(item.tags)
                }),
        _medicineUpdateAdapter = UpdateAdapter(
            database,
            'medicines',
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
                  'tags': _listStringConverter.encode(item.tags)
                }),
        _medicineDeletionAdapter = DeletionAdapter(
            database,
            'medicines',
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
                  'tags': _listStringConverter.encode(item.tags)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Medicine> _medicineInsertionAdapter;

  final UpdateAdapter<Medicine> _medicineUpdateAdapter;

  final DeletionAdapter<Medicine> _medicineDeletionAdapter;

  @override
  Future<List<Medicine>> findAllMedicines() async {
    return _queryAdapter.queryList('SELECT * FROM medicines',
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
            tags: _listStringConverter.decode(row['tags'] as String)));
  }

  @override
  Future<List<Medicine>> findMedicineByName(String name) async {
    return _queryAdapter.queryList('SELECT * FROM medicines WHERE name =?1',
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
            tags: _listStringConverter.decode(row['tags'] as String)),
        arguments: [name]);
  }

  @override
  Future<Medicine?> findMedicineById(int id) async {
    return _queryAdapter.query('SELECT * FROM medicines WHERE id = ?1',
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
            tags: _listStringConverter.decode(row['tags'] as String)),
        arguments: [id]);
  }

  @override
  Future<void> updateAmountAvailable(int amount, int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE medicines SET amountAvailable =?1 WHERE id = ?2',
        arguments: [amount, id]);
  }

  @override
  Future<void> takeDose(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE medicines SET amountAvailable = amountAvailable-dose WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> updateTags(List<String> tags, int id) async {
    const offset = 2;
    final _sqliteVariablesForTags =
        Iterable<String>.generate(tags.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'UPDATE medicines SET tags IN (' +
            _sqliteVariablesForTags +
            ') WHERE id = ?1',
        arguments: [id, ...tags]);
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
      : _queryAdapter = QueryAdapter(database),
        _reminderInsertionAdapter = InsertionAdapter(
            database,
            'reminders',
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'date': item.date,
                  'day': item.day,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'repeated': item.repeated ? 1 : 0
                }),
        _reminderUpdateAdapter = UpdateAdapter(
            database,
            'reminders',
            ['id'],
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'date': item.date,
                  'day': item.day,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'repeated': item.repeated ? 1 : 0
                }),
        _reminderDeletionAdapter = DeletionAdapter(
            database,
            'reminders',
            ['id'],
            (Reminder item) => <String, Object?>{
                  'id': item.id,
                  'medicine_id': item.medicineId,
                  'date': item.date,
                  'day': item.day,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'label': item.label,
                  'repeated': item.repeated ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Reminder> _reminderInsertionAdapter;

  final UpdateAdapter<Reminder> _reminderUpdateAdapter;

  final DeletionAdapter<Reminder> _reminderDeletionAdapter;

  @override
  Future<List<Reminder>> findAllReminders() async {
    return _queryAdapter.queryList('SELECT * FROM reminders',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            date: row['date'] as String,
            day: row['day'] as int,
            dateTime: row['dateTime'] as int,
            label: row['label'] as String,
            repeated: (row['repeated'] as int) != 0));
  }

  @override
  Future<Reminder?> findReminderById(int id) async {
    return _queryAdapter.query('SELECT * FROM reminders WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            date: row['date'] as String,
            day: row['day'] as int,
            dateTime: row['dateTime'] as int,
            label: row['label'] as String,
            repeated: (row['repeated'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<List<Reminder>> findReminderByDate(String date) async {
    return _queryAdapter.queryList(
        'SELECT * FROM reminders WHERE repeated = 0 AND date =?1',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            date: row['date'] as String,
            day: row['day'] as int,
            dateTime: row['dateTime'] as int,
            label: row['label'] as String,
            repeated: (row['repeated'] as int) != 0),
        arguments: [date]);
  }

  @override
  Future<List<Reminder>> findRepeatedReminders() async {
    return _queryAdapter.queryList('SELECT * FROM reminders WHERE repeated = 1',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            date: row['date'] as String,
            day: row['day'] as int,
            dateTime: row['dateTime'] as int,
            label: row['label'] as String,
            repeated: (row['repeated'] as int) != 0));
  }

  @override
  Future<List<Reminder>> findRepeatedReminderByDay(int day) async {
    return _queryAdapter.queryList(
        'SELECT * FROM reminders WHERE repeated = 1 AND day =?1',
        mapper: (Map<String, Object?> row) => Reminder(
            id: row['id'] as int?,
            medicineId: row['medicine_id'] as int,
            date: row['date'] as String,
            day: row['day'] as int,
            dateTime: row['dateTime'] as int,
            label: row['label'] as String,
            repeated: (row['repeated'] as int) != 0),
        arguments: [day]);
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
                  'reminder_id': item.reminderID,
                  'scheduledDateTime':
                      _dateTimeConverter.encode(item.scheduledDateTime),
                  'checkedDateTime':
                      _dateTimeConverter.encode(item.checkedDateTime)
                }),
        _reminderCheckUpdateAdapter = UpdateAdapter(
            database,
            'reminders_check',
            ['id'],
            (ReminderCheck item) => <String, Object?>{
                  'id': item.id,
                  'reminder_id': item.reminderID,
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
                  'reminder_id': item.reminderID,
                  'scheduledDateTime':
                      _dateTimeConverter.encode(item.scheduledDateTime),
                  'checkedDateTime':
                      _dateTimeConverter.encode(item.checkedDateTime)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ReminderCheck> _reminderCheckInsertionAdapter;

  final UpdateAdapter<ReminderCheck> _reminderCheckUpdateAdapter;

  final DeletionAdapter<ReminderCheck> _reminderCheckDeletionAdapter;

  @override
  Future<List<ReminderCheck>> findAllReminderChecks() async {
    return _queryAdapter.queryList('SELECT * FROM reminders_check',
        mapper: (Map<String, Object?> row) => ReminderCheck(
            id: row['id'] as int?,
            reminderID: row['reminder_id'] as int,
            scheduledDateTime:
                _dateTimeConverter.decode(row['scheduledDateTime'] as int),
            checkedDateTime: row['checkedDateTime'] as int));
  }

  @override
  Future<ReminderCheck?> findReminderCheckById(int id) async {
    return _queryAdapter.query('SELECT * FROM reminders_check WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ReminderCheck(
            id: row['id'] as int?,
            reminderID: row['reminder_id'] as int,
            scheduledDateTime:
                _dateTimeConverter.decode(row['scheduledDateTime'] as int),
            checkedDateTime: row['checkedDateTime'] as int),
        arguments: [id]);
  }

  @override
  Future<List<ReminderCheck>> findReminderByScheduledDate(
      DateTime datetime) async {
    return _queryAdapter.queryList(
        'SELECT * FROM reminders_check WHERE scheduledDateTime =?1',
        mapper: (Map<String, Object?> row) => ReminderCheck(
            id: row['id'] as int?,
            reminderID: row['reminder_id'] as int,
            scheduledDateTime:
                _dateTimeConverter.decode(row['scheduledDateTime'] as int),
            checkedDateTime: row['checkedDateTime'] as int),
        arguments: [_dateTimeConverter.encode(datetime)]);
  }

  @override
  Future<void> deleteAllReminderChecks() async {
    await _queryAdapter.queryNoReturn('DELETE FROM reminders_check');
  }

  @override
  Future<void> insertReminderCheck(ReminderCheck check) async {
    await _reminderCheckInsertionAdapter.insert(
        check, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateReminderCheck(ReminderCheck check) async {
    await _reminderCheckUpdateAdapter.update(check, OnConflictStrategy.abort);
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
