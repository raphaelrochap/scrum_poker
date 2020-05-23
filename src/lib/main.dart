import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrum_manager_lite/pages/ScrumPokerCards.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:scrum_manager_lite/pages/app_settings.dart';

void main() async{  
  WidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration().loadFromMap(appSettings);
  runApp(ScrumManagerLite());
}

class ScrumManagerLite extends StatelessWidget {

  ScrumManagerLite(){
    print('aaaaasdw');
    gdsfd();
  }


  void gdsfd() async {
  final diretorio = await getApplicationDocumentsDirectory();
    bool arquivoExiste;
    arquivoExiste = await io.File(diretorio.path + '/').exists();

    if (!arquivoExiste){
      print('no');
    // final file = File("${diretorio.path}/data.json");
    // file.writeAsString(data);    
    }
    else 
      print('sí' + diretorio.path);
  }

  
  void initState() {
    print('aaaaa');
    gdsfd();
  }


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
        home: ScrumPokerCards(),        
        );
  }
}
