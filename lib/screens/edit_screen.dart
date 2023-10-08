import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u_diary/models/day_data.dart';
import 'package:u_diary/providers/my_data_provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _textController = TextEditingController();

  // Очищаем контроллеры когда они не нужны, чтобы не занимать лищнюю память
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DayData day = Provider.of<MyDataProvider>(context, listen: false).dayData;
    _textController.text = day.id!=null ? day.content : "";
    return WillPopScope(
      onWillPop: () async {
        if ( _textController.text != "" ) {
          Provider.of<MyDataProvider>(context, listen: false).editData({
            'content': _textController.text      
          });
        } else {
          Provider.of<MyDataProvider>(context, listen: false).removeData();
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Редактирование'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Введите текст',
                border: InputBorder.none
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
        )
      )
    );
  }
}