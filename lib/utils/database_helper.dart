import 'package:intl/intl.dart';
import 'package:u_diary/models/day_data.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // ! Статическая переменная instance, которая содержит единственный экземпляр 
  // класса. Это позволяет использовать единственный экземпляр класса для работы 
  // c базой данных во всем приложении.
  // ! Такой архитектурный подход называется Singletone
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  // Приватный конструктор используется для создания единственного экземпляра 
  // класса DatabaseHelper.
  DatabaseHelper._instance();

  // Имя таблицы для работы с данными товаров
  String table = 'days';

  // Если база данных создана то работаем с ней, если нет то создаем базу данных
  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  // Инициализируем базу данных, создаем файл базы с названием my_database.db
  // Создаем в базе таблицу products с полями id, title, imageUrl, date
  Future<Database> _initDb() async {
    String path = await getDatabasesPath();
    path = '$path/udairy.db';
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $table(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, content TEXT)',
        );
      },
    );
    return database;
  }

  Future<List<DateTime>> getList() async {
    final db = await instance.db;
    final List<Map<String, dynamic>> all = await db.query(table);
    final List<DateTime> res = all.map((Map<String, dynamic> e) => DateTime.parse(e['date'])).toList();
    res.sort((DateTime a, DateTime b) => a.isAfter(b)?1:0);

    return res;
  }

  // Вставляем данные в БД
  Future<int> insertData(DayData data) async {
    final db = await instance.db;
    return await db.insert(instance.table, data.toMap());
  }

  // Получаем данные из БД
  Future<DayData> getData(DateTime selectedDate) async {
    final db = await instance.db;
    final List<Map<String, dynamic>> maps = await db.query(
      instance.table,
      where: 'date LIKE ?',
      whereArgs: ['${DateFormat('yyyy-MM-dd').format(selectedDate)}%'],
    );
    if (maps.isEmpty) {
      return DayData(date: selectedDate, content: "Нет записей...");
    }

    return DayData.fromMap(maps[0]);
  }

  // (PRACTIC) Удаляем данные из БД
  Future<void> removeData(int id) async {
    final db = await instance.db;
    await db.delete(instance.table, where: 'id LIKE ?', whereArgs: [id]);
  }

  // (PRACTIC) Изменить данные в БД
  Future<void> editData(int id, Map<String, dynamic> newData) async {
    final db = await instance.db;
    await db.update(instance.table, newData, where: 'id LIKE ?', whereArgs: [id]);
  }

}