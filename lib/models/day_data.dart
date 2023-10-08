
import 'package:intl/intl.dart';

class DayData {
    final int? id;
    final DateTime date;

    final String content;
  
    DayData({
      this.id,
      required this.date,
      required this.content
    });
  
    // ! Методы toMap() и fromMap() нужны для более удобной работы с объектами 
    // как со словарем Map
    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'date': DateFormat('yyyy-MM-dd').format(date),
        'content': content,
      };
    }
  
    factory DayData.fromMap(Map<String, dynamic> map) {
      return DayData(
        id: map['id'],
        date: DateTime.parse(map['date']),
        content: map['content']
      );
    }
  
    // ! Метод copyWith() создает новый объект DayData на основе текущего объекта 
    // но с измененными некоторыми свойствами.
    // Например, для изменения даты или изменения текста без изменения 
    // идентификатора или URL изображения.
    DayData copyWith({
      int? id,
      DateTime? date,
      String? content
    }) {
      return DayData(
        id: id ?? this.id,
        date: date ?? this.date,
        content: content ?? this.content
      );
    }
  }