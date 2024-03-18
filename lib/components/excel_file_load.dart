
import 'dart:io';

import 'package:cuc_result_processing/layout/custom_appbar.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class ExcelFileLoad extends StatefulWidget {
  const ExcelFileLoad({Key? key}) : super(key: key);

  @override
  State<ExcelFileLoad> createState() => _ExcelFileLoadState();
}

class _ExcelFileLoadState extends State<ExcelFileLoad> {
  pickFile() async {
    print("File Load successfully") ;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile fileItem = result.files.first;
      // print(fileItem.name);
      // print(fileItem.bytes);
      // print(fileItem.size);
      // print(fileItem.extension);
      print(fileItem.path);


      var file = fileItem.path;
      var bytes = File(file!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        // print(table); //sheet Name
        // print(excel.tables[table]?.maxColumns);
        // print(excel.tables[table]?.maxRows);
        for (var row in excel.tables[table]!.rows) {
          print("==============================") ;
          for (var cell in row) {
            // print('cell ${cell!.rowIndex}/${cell.columnIndex}');
            final value = cell!.value;
            print(value);
          }
        }
      }



    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppbar(title: "Table Layout and CSV",),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: GestureDetector(
                  onTap: (){
                    pickFile();
                  },
                  child: Text("File Load")),
            ),
          ),
        ),
      ),
    );
  }
}
