import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:u_diary/providers/my_data_provider.dart';
import 'package:u_diary/screens/edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  void _setDate(DateTime day) {
    if (DateTime.now().isAfter(day)) {
      setState(() {
        selectedDate = day;
      });
      Provider.of<MyDataProvider>(context, listen: false).getData(day);
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      _setDate(picked);
    }
  }

  void _clearFilter() {
    _setDate(DateTime.now());
  }

  void _showList() async {
    final List<DateTime> filteredList = Provider.of<MyDataProvider>(context, listen: false).getList;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Список записей"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Выйти"),
          )
        ],
        content: ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text( DateFormat('dd.MM.yyyy').format(filteredList[index]) ),
                )
              ),
              onTap: () {
                Navigator.of(context).pop();
                _setDate(filteredList[index]);
              }
            );
          }
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Дневник'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                ElevatedButton(onPressed: _clearFilter, child: const Text("Вернуться к сегодня")),
                ElevatedButton(onPressed: _showList, child: const Text("Список записей"))
              ]
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _setDate(selectedDate.subtract(const Duration(days: 1))),
                  icon: const Icon(Icons.arrow_back_rounded)
                ),
                GestureDetector(
                  child: Text(
                    DateFormat('dd.MM.yyyy').format(selectedDate),
                  ),
                  onTap: () => _selectDate(context),
                ),
                IconButton(
                  onPressed: () => _setDate(selectedDate.add(const Duration(days: 1))),
                  icon: const Icon(Icons.arrow_forward_rounded)
                )
              ],
            )
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Text(
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  maxLines: null,
                  Provider.of<MyDataProvider>(context).dayData.content,
                ),
              ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditScreen()),
        ),
        child: const Icon(Icons.edit_note_rounded),
      ),
    );
  }
}