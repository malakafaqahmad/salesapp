import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mobileapp/models/customer.dart';
import 'package:mobileapp/models/partner.dart';
import 'package:mobileapp/models/phone.dart';
import 'package:mobileapp/models/installment.dart';
import 'package:mobileapp/models/sale.dart';
import 'package:mobileapp/models/transaction_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'installment_tracker.db');
    Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE phones ADD COLUMN sold INTEGER NOT NULL DEFAULT 0');
      }
    }

    return await openDatabase(
      path,
      version: 2, // <-- bump version from 1 to 2
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // <-- add this
    );

  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phoneNumber TEXT,
        address TEXT,
        cnic TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE partners(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        investment int NOT NULL,
        phoneNumber TEXT,
        address TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE phones(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        imei TEXT UNIQUE NOT NULL,
        costPrice REAL NOT NULL,
        salePrice REAL NOT NULL,
        partnerId INTEGER,
        FOREIGN KEY (partnerId) REFERENCES partners(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE sales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerId INTEGER NOT NULL,
        phoneId INTEGER NOT NULL,
        saleDate TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        downPayment REAL NOT NULL,
        installmentsover INTEGER NOT NULL DEFAULT 0,
        installmentsCount INTEGER NOT NULL,
        FOREIGN KEY (customerId) REFERENCES customers(id),
        FOREIGN KEY (phoneId) REFERENCES phones(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE installments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        saleId INTEGER NOT NULL,
        dueDate TEXT NOT NULL,
        amount REAL NOT NULL,
        status TEXT NOT NULL,
        paidDate TEXT,
        FOREIGN KEY (saleId) REFERENCES sales(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        relatedSaleId INTEGER,
        relatedPhoneId INTEGER,
        FOREIGN KEY (relatedSaleId) REFERENCES sales(id),
        FOREIGN KEY (relatedPhoneId) REFERENCES phones(id)
      )
    ''');


  }

  // funcntions to perform database operations

  //customers functions

  Future<int> insertCustomerTyped(Customer customer) async {
    final db = await database;
    return await db.insert('customers', customer.toMap());
  }

  Future<List<Customer>> getAllCustomersTyped() async {
    final db = await database;
    final result = await db.query('customers');
    return result.map((e) => Customer.fromMap(e)).toList();
  }

  Future<int> updateCustomerTyped(Customer customer) async {
    final db = await database;
    return await db.update('customers', customer.toMap(), where: 'id = ?', whereArgs: [customer.id]);
  }

  Future<int> deleteCustomerTyped(int id) async {
    final db = await database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }



  // for partners

  Future<int> insertPartnerTyped(Partner partner) async {
    final db = await database;
    return await db.insert('partners', partner.toMap());
  }

  Future<List<Partner>> getAllPartnersTyped() async {
    final db = await database;
    final result = await db.query('partners');
    return result.map((e) => Partner.fromMap(e)).toList();
  }

  Future<int> updatePartnerTyped(Partner partner) async {
    final db = await database;
    return await db.update('partners', partner.toMap(), where: 'id = ?', whereArgs: [partner.id]);
  }

  Future<int> deletePartnerTyped(int id) async {
    final db = await database;
    return await db.delete('partners', where: 'id = ?', whereArgs: [id]);
  }


// for phones
  Future<int> insertPhoneTyped(Phone phone) async {
    final db = await database;
    return await db.insert('phones', phone.toMap());
  }

  Future<Phone?> getPhoneById(int id) async {
    final db = await database;
    final result = await db.query(
      'phones',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Phone.fromMap(result.first);
    }
    return null;
  }


  Future<List<Phone>> getAllPhonesTyped() async {
    final db = await database;
    final result = await db.query('phones');
    return result.map((e) => Phone.fromMap(e)).toList();
  }

  Future<List<Phone>> getUnsoldPhones() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT * FROM phones
    WHERE id NOT IN (SELECT phoneId FROM sales)
  ''');
    return result.map((e) => Phone.fromMap(e)).toList();
  }

  Future<int> updatePhoneTyped(Phone phone) async {
    final db = await database;
    return await db.update('phones', phone.toMap(), where: 'id = ?', whereArgs: [phone.id]);
  }

  Future<int> deletePhoneTyped(int id) async {
    final db = await database;
    return await db.delete('phones', where: 'id = ?', whereArgs: [id]);
  }


  // for sale
  Future<int> insertSaleTyped(Sale sale) async {
    final db = await database;
    return await db.insert('sales', sale.toMap());
  }

  Future<List<Map<String, dynamic>>> getSalesWithDetails() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT sales.*, customers.name AS customerName, phones.name AS phoneName
    FROM sales
    JOIN customers ON sales.customerId = customers.id
    JOIN phones ON sales.phoneId = phones.id
  ''');
  }

  Future<List<Sale>> getAllSalesTyped() async {
    final db = await database;
    final result = await db.query('sales');
    return result.map((e) => Sale.fromMap(e)).toList();
  }

  Future<int> updateSaleTyped(Sale sale) async {
    final db = await database;
    return await db.update('sales', sale.toMap(), where: 'id = ?', whereArgs: [sale.id]);
  }

  Future<int> deleteSaleTyped(int id) async {
    final db = await database;
    return await db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }

  // for transaction model

  Future<int> insertTransactionTyped(TransactionModel transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getAllTransactionsTyped() async {
    final db = await database;
    final result = await db.query('transactions');
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<int> updateTransactionTyped(TransactionModel transaction) async {
    final db = await database;
    return await db.update('transactions', transaction.toMap(), where: 'id = ?', whereArgs: [transaction.id]);
  }

  Future<int> deleteTransactionTyped(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }


  // for installments

  Future<int> insertInstallmentTyped(Installment installment) async {
    final db = await database;
    return await db.insert('installments', installment.toMap());
  }

  Future<List<Installment>> getAllInstallmentsTyped() async {
    final db = await database;
    final result = await db.query('installments');
    return result.map((e) => Installment.fromMap(e)).toList();
  }

  Future<List<Installment>> getInstallmentsBySaleIdTyped(int saleId) async {
    final db = await database;
    final result = await db.query('installments', where: 'saleId = ?', whereArgs: [saleId]);
    return result.map((e) => Installment.fromMap(e)).toList();
  }

  Future<int> updateInstallmentTyped(Installment installment) async {
    final db = await database;
    return await db.update('installments', installment.toMap(), where: 'id = ?', whereArgs: [installment.id]);
  }

  Future<int> deleteInstallmentTyped(int id) async {
    final db = await database;
    return await db.delete('installments', where: 'id = ?', whereArgs: [id]);

  }



}