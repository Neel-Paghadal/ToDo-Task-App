// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_class.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorToDoData {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ToDoDataBuilder databaseBuilder(String name) =>
      _$ToDoDataBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ToDoDataBuilder inMemoryDatabaseBuilder() => _$ToDoDataBuilder(null);
}

class _$ToDoDataBuilder {
  _$ToDoDataBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$ToDoDataBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$ToDoDataBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<ToDoData> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ToDoData();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ToDoData extends ToDoData {
  _$ToDoData([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ToDoDetailDao? _detailDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
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
            'CREATE TABLE IF NOT EXISTS `ToDoDetail` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `priority` TEXT NOT NULL, `dueDate` TEXT NOT NULL, `createdDate` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ToDoDetailDao get detailDao {
    return _detailDaoInstance ??= _$ToDoDetailDao(database, changeListener);
  }
}

class _$ToDoDetailDao extends ToDoDetailDao {
  _$ToDoDetailDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _toDoDetailInsertionAdapter = InsertionAdapter(
            database,
            'ToDoDetail',
            (ToDoDetail item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'priority': item.priority,
                  'dueDate': item.dueDate,
                  'createdDate': item.createdDate
                }),
        _toDoDetailUpdateAdapter = UpdateAdapter(
            database,
            'ToDoDetail',
            ['id'],
            (ToDoDetail item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'priority': item.priority,
                  'dueDate': item.dueDate,
                  'createdDate': item.createdDate
                }),
        _toDoDetailDeletionAdapter = DeletionAdapter(
            database,
            'ToDoDetail',
            ['id'],
            (ToDoDetail item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'priority': item.priority,
                  'dueDate': item.dueDate,
                  'createdDate': item.createdDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ToDoDetail> _toDoDetailInsertionAdapter;

  final UpdateAdapter<ToDoDetail> _toDoDetailUpdateAdapter;

  final DeletionAdapter<ToDoDetail> _toDoDetailDeletionAdapter;

  @override
  Future<List<ToDoDetail>> getAllDetail() async {
    return _queryAdapter.queryList('SELECT * FROM ToDoDetail',
        mapper: (Map<String, Object?> row) => ToDoDetail(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            priority: row['priority'] as String,
            dueDate: row['dueDate'] as String,
            createdDate: row['createdDate'] as String));
  }

  @override
  Future<List<ToDoDetail>> getAlldetailsByid(String id) async {
    return _queryAdapter.queryList('SELECT * FROM ToDoDetail WHERE id LIKE ?1',
        mapper: (Map<String, Object?> row) => ToDoDetail(
            id: row['id'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            priority: row['priority'] as String,
            dueDate: row['dueDate'] as String,
            createdDate: row['createdDate'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertDetail(ToDoDetail transactions) async {
    await _toDoDetailInsertionAdapter.insert(
        transactions, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateDetail(ToDoDetail transactions) async {
    await _toDoDetailUpdateAdapter.update(
        transactions, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteDetail(ToDoDetail transactions) async {
    await _toDoDetailDeletionAdapter.delete(transactions);
  }
}
