import 'dart:async';

import 'package:flux_state/app_constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const createComponentsTable = '''
  CREATE TABLE components (
    id TEXT PRIMARY KEY,
    category TEXT NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 0,
    attrs TEXT NOT NULL DEFAULT '{}'
  )
''';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _db;
  bool _ffiInitialized = false;

  Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    if (!_ffiInitialized) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      _ffiInitialized = true;
    }

    // var db = await openDatabase('my_db.db');
    return openDatabase(
      inMemoryDatabasePath, // TEST only
      // singleInstance: false, // TEST only
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) {
    db.execute(createComponentsTable);
  }

  // /// Call this between tests to get a clean slate.
  // Future<void> close() async {
  //   final db = _db;
  //   if (db != null) {
  //     await db.close();
  //     _db = null;
  //   }
  // }
}
