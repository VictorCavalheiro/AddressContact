import 'package:sqflite/sqflite.dart';

final String tableName = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class Helper {
  static final Helper _singleton = new Helper._internal();

  //Database _db;
  Database _db;

  factory Helper() {
    return Helper.getHelper();
  }

  Helper._internal();

  static Helper getHelper() {
    if (_singleton == null) {
      return _singleton;
    } else {
      return _singleton;
    }
  }

  get db async {
    if (_db != null) {
      return _db;
    } else {
      final directory = await getDatabasesPath();
      final path = directory + "/contatu.db";
      _db = await openDatabase(
        // Set the path to the database.
        path,
        // When the database is first created, create a table to store dogs.
        onCreate: (base, version) async {
          // Run the CREATE TABLE statement on the database.
          return await base.execute(
            "CREATE TABLE $tableName($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn INTEGER, $phoneColumn TEXT,$imgColumn TEXT)",
          );
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
    }
  }

  /*Future<Database> initDb() async {
    final directoryDatabase = await getDatabasesPath();
    final path = directoryDatabase + "/contacts.db";
    openDatabase(path, version: 1, onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE $tableName($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)",
      );
    });
  }*/

  Future<ModelOfContact> saveContact(ModelOfContact contact) async {
    Database database = await db;
    database = _db;
    contact.id = await database.insert(tableName, contact.toMap());
    return contact;
  }

  Future<ModelOfContact> getContact(int id) async {
    Database database = await db;
    database = _db;
    List<Map> maps = await database.query(tableName,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn=?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return ModelOfContact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database database = await db;
    database = _db;
    int num = await database.delete(tableName, where: "$idColumn=?", whereArgs: [id]);
    return num;
  }

  Future<int> updateContact(ModelOfContact contact) async {
    Database database = await db;
    database = _db;
    Map contactInMap = contact.toMap();
    await database.update(tableName, contactInMap,
        where: "$idColumn=?", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    Database database = await db;
    database = _db;
    List list = await database.rawQuery("SELECT * FROM $tableName");
    List<ModelOfContact> listOfContacts = List();
    for (Map instance in list) {
      listOfContacts.add(ModelOfContact.fromMap(instance));
    }

    return listOfContacts;
  }

  Future<int> getNumberOfRecords() async {
    Database database = await db;
    database = _db;
    return Sqflite.firstIntValue(
        await database.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  Future closeDatabase() async {
    Database database = await db;
    database = _db;
    database.close();
  }
}

class ModelOfContact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  ModelOfContact();

  ModelOfContact.fromMap(Map map) {
    String nameValueString = map[nameColumn].toString();
    String emailValueString = map[emailColumn].toString();
    String phoneValueString = map[phoneColumn].toString();

    id = map[idColumn];
    name = nameValueString != null ? nameValueString : "";
    email = emailValueString != null ? emailValueString : "";
    phone = phoneValueString != null ? phoneValueString : "";
    img = map[imgColumn] != null ? map[imgColumn] : "";
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (idColumn != null) {
      map[idColumn] = id;
    }
    return map;
  }

  static displayContacts(List list) {
    for (ModelOfContact contact in list) {
      print(
          "Contact(id:${contact.id}, name: ${contact.name}, email:${contact.email}, phone:${contact.phone},image:${contact.img} ) ");
    }
  }
}
