import 'package:flutter/material.dart';
import 'package:u_diary/models/day_data.dart';
import 'package:u_diary/utils/database_helper.dart';

class MyDataProvider extends ChangeNotifier {
  DayData _dayData = DayData(date: DateTime.now(), content: "Нет записей...");
  List<DateTime> _list = [];

  DayData get dayData => _dayData;
  List<DateTime> get getList => _list;

  // ! Получить товар из базы данных и обновить список на экране
  void getData(DateTime selectedDate) async {
    final data = await DatabaseHelper.instance.getData(selectedDate);
    _dayData = data;
    _getList();
    notifyListeners();
  }

  Future<void> _getList() async {
    _list = await DatabaseHelper.instance.getList();
  }

  // ! Добавить товар в базу данных и обновить список на экране
  void _addData(DayData data) async {
    await DatabaseHelper.instance.insertData(data);
    
  }

  void _editData(Map<String, dynamic> data) async {
    await DatabaseHelper.instance.editData(_dayData.id!, data);
  }

  // ! (PRACTIC) Удалить товар из базы данных и обновить список на экране
  void removeData() async {
    await DatabaseHelper.instance.removeData(_dayData.id!);

    _dayData = await DatabaseHelper.instance.getData(_dayData.date);
    _getList();

    notifyListeners();
  }

  // ! (PRACTIC) Изменить данные в базе данных и обновить список на экране
  void editData(Map<String, dynamic> newData) async {
    if (_dayData.id==null) {
      _addData(DayData(date: _dayData.date, content: newData['content']));
    } else {
      _editData(newData);
    }
    getData(_dayData.date);
  }
}