import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:developer';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ReadWriteFile',
      home: ReadWriteFile(),
    );
  }
}

class ReadWriteFile extends StatefulWidget {
  const ReadWriteFile({Key? key}) : super(key: key);

  @override
  State<ReadWriteFile> createState() => _ReadWriteFileState();
}

class _ReadWriteFileState extends State<ReadWriteFile> {
  final TextEditingController _textController = TextEditingController();
  static const String KLocalFileName = 'demo_localfile.txt';
  String _localFileContent = '';
  String _localFilePath = KLocalFileName;

  @override
  void initState() {
    super.initState();
    this._readTextFromLocalFile();
    this
        ._getLocalFile
        .then((file) => setState(() => this._localFilePath = file.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ReadWriteFile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Text('Write to local file:', style: TextStyle(fontSize: 20)),
          TextField(
            // focusNode: textFieldFocusNode,
            controller: _textController,
            maxLines: null,
            style: TextStyle(fontSize: 20),
          ),
          ButtonBar(
            children: [
              MaterialButton(
                child: Text('Load', style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  this._readTextFromLocalFile();
                  this._textController.text = this._localFileContent;
                  //FocusScope.of(context).requestFocus(textFieldFocusNode);
                  log('Successfully loaded');
                },
              ),
              MaterialButton(
                child: Text('Save', style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  await this._writeTextToLocalFile(this._textController.text);
                  this._readTextFromLocalFile();
                  log('Successfully written');
                },
              ),
            ],
          ),
          Divider(
            height: 20.0,
          ),
          Text(
            'Local file path:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(this._localFilePath),
          Divider(
            height: 20.0,
          ),
          Text(
            'Local file content',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(this._localFileContent),
        ],
      ),
    );
  }

  Future<String> get _getLocalPath async {
    // получим путь к каталогу документов
    final directory =
        await getApplicationDocumentsDirectory(); //что бы получить путь к
    // каталогу документов
    return directory.path; // возваращаем путь до нашего каталога
  }

  Future<File> get _getLocalFile async {
    // получаем ссылку до нашего каталога
    final path = await _getLocalPath;
    return File('$path/$KLocalFileName'); // путь к файлу
  }

  Future<File> _writeTextToLocalFile(String text) async {
    // метод который будет записывать в файл некоторою информацию
    final file = await _getLocalFile;
    return file.writeAsString(text); // метод записи информации
  }

  Future _readTextFromLocalFile() async {
    //метод для чтения информации
    String content;
    try {
      final file = await _getLocalFile;
      content = await file.readAsString();
      // пробуем прочитать наш фаил
    } catch (e) {
      content =
          'Error : $e'; // если не удалось прочитать файл то запишем ошибку
    }
    setState(() {
      this._localFileContent = content;
    });
  }
}
