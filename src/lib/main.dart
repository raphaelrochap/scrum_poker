import 'package:flutter/material.dart';
import 'package:scrum_manager_lite/pages/CartasScrumPoker.dart';
import 'package:scrum_manager_lite/pages/arquivo_configuracao.dart' as arquivo_configuracao;


import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();//Necessário para realizar as verificações em arquivos.
//Retire os comentários abaixo para deletar o arquivo na entrada do sistema.

  // final diretorio = await getApplicationDocumentsDirectory();
  // await File("${diretorio.path}/data.json").delete();

  await arquivo_configuracao.abrirArquivo();
  await arquivo_configuracao.lerArquivo();

  runApp(ScrumManagerLite());
}

class ScrumManagerLite extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Scrum Manager',
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        builder: (BuildContext context, Widget child){
          return Padding(
            child: child,
            padding: EdgeInsets.only(
            )
          );
        },
        home: CartasScrumPoker(),        
        );
  }
}
