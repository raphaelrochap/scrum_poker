import 'package:flutter/material.dart';
import 'package:scrum_manager_lite/pages/ScrumPokerCards.dart';

void main() => runApp(ScrumManagerLite());

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
        home: ScrumPokerCards(),        
        );
  }
}
