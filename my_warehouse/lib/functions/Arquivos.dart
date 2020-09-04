import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

//Me desculpem por isso, mas eu sei o BO que da sobredescrever salvamento de arquivos ao mesmo tempo
//Lembrem de SO, controle de regiao critica aqui

List<String> savingDoc = new List<String>();
final int retrySaveWait = 100;

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<Map<String, dynamic>> getDocument({String docName}) async{
  Map<String, dynamic> ret = new Map<String, dynamic>();
  final path = await localPath;
  final File file = File(path+"/"+docName);
  if(await file.exists()){
    String readData = await file.readAsString();
    if(readData.length>0){
      ret = json.decode(readData.replaceAll("\n", ""));
    }
  }
  return ret;
}

Future<void> saveDocument({String docName, Map<String, dynamic> map}) async{
  if(!savingDoc.contains(docName)){
    savingDoc.add(docName);
    final path = await localPath;
    String writeString = json.encode(map);
    final File file = File(path+"/"+docName);
    await file.writeAsString(writeString);
    savingDoc.remove(docName);
  }
  else{
    await Future.delayed(Duration(milliseconds: retrySaveWait), () async{
      await saveDocument(docName: docName, map: map);
    });
  }
}
