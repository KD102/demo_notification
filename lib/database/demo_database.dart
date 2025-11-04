import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'customer_model.dart';

class DemoHelper {
  static final DemoHelper _instance = DemoHelper._internal();
  factory DemoHelper() => _instance;
  static Database? _database;

  DemoHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getApplicationDocumentsDirectory();
    String path = join(dbPath.path, 'customer.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customer(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerType TEXT,
        firstName TEXT,
        lastName TEXT,
        createdDate INTEGER
      )
    ''');
  }

  // Insert a customer
  Future<int> insertCustomer(CustomerModel customer) async {
    Database db = await database;
    return await db.insert('customer', customer.toMap());
  }

  // Get all customers
  Future<List<CustomerModel>> getCustomers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('customer');
    return List.generate(maps.length, (i) => CustomerModel.fromMap(maps[i]));
  }

  // Update a customer
  Future<int> updateCustomer(CustomerModel customer) async {
    Database db = await database;
    return await db.update(
      'customer',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  // Delete a customer
  Future<int> deleteCustomer(int id) async {
    Database db = await database;
    return await db.delete(
      'customer',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


class DatabaseHelper {
  static final _databaseName = "myDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'myTable';
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnAge = 'age';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) {
          db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAge INTEGER NOT NULL
          )
          ''');
        });
  }

  Future<void> insertData() async {
    final db = await database;
    await db.insert(
      table,
      {
        'column1': 'value1',
        'column2': 42,
      },
    );
  }

  Future<List<Map<String,dynamic>>> getData() async {
    final db = await database;
    final rows = await db.query('my_table');
    return rows;
  }

  Future<void> updateData(int id) async {
    final db = await database;
    await db.update(
      'my_table',
      {
        'column1': 'new_value1',
        'column2': 43,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteData(int id) async {
    final db = await database;
    await db.delete(
      'my_table',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}