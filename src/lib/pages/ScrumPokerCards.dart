import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:path_provider/path_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:scrum_manager_lite/pages/app_settings.dart';
import 'CartaEscolhida.dart';

class _AbaClass {
  const _AbaClass({this.nomeDaAba, this.listaDeCartas, this.tamanhoFonteAbas});
  final String nomeDaAba;
  final List<String> listaDeCartas;
  final double tamanhoFonteAbas;
}

enum Configuracao {tamanhoFonte, corFonte, corTema}

// int tamanhoFonte = 0;
// int corFonte = 1;
// int corTema = 2;

String aaa = Colors.white.toString();
bool usuarioEscolheu = false;
Color corFonteUsuario;
Color currentColor = Colors.green[400];
double tamanhoFonteCartas;
// List toDoList = [];

  // void _addToDo(String nomeconfig, String valor){
  //     Map<String, String> newToDo = Map();
  //     // newToDo["config"] = tamFonte;
  //     // newToDo["valor"] = colorFonte;
  //     toDoList.add(newToDo);
  //     _saveData();
  // }


  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    print("${diretorio.path}/data.json");
    return File("${diretorio.path}/data.json");
  }

  Future<File> _saveData() async{
    String data = json.encode(appSettings);
    
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async{
    try{
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }





enum GridDemoTileStyle { imageOnly, oneLine, twoLine }

const List<String> _standart = [
  "0",
  "1/2",
  "1",
  "2",
  "3",
  "5",
  "8",
  "13",
  "20",
  "40",
  "100",
  "∞",
  "?",
  "assets/cafe.png"
];

const List<String> _fibonacci = [
  "0",
  "1",
  "2",
  "3",
  "5",
  "8",
  "13",
  "21",
  "34",
  "55",
  "89",
  "144",
  "∞",
  "?",
  "assets/cafe.png"
];

const List<String> _tShirtEN = [
  "XS",
  "S",
  "M",
  "L",
  "XL",
  "∞",
  "?",
  "assets/cafe.png"
];

const List<_AbaClass> _allPages = [
  _AbaClass(nomeDaAba: 'Standard', listaDeCartas: _standart, tamanhoFonteAbas: 20),
  _AbaClass(nomeDaAba: 'Fibonacci', listaDeCartas: _fibonacci, tamanhoFonteAbas: 38),
  _AbaClass(nomeDaAba: 'T-Shirt(EN)', listaDeCartas: _tShirtEN, tamanhoFonteAbas: 35),
];

class ScrumPokerCards extends StatefulWidget {
  static const String routeName = '/material/scrollable-tabs';

  @override
  ScrumPokerCardsState createState() => ScrumPokerCardsState();
}

class ScrumPokerCardsState extends State<ScrumPokerCards>
    with SingleTickerProviderStateMixin {
  static const _PANEL_HEADER_HEIGHT = 32.0;

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  PersistentBottomSheetController<void> _bottomSheet;  
  bool _ativo = false;

  void nada() {
    setState(() {});
  }

  void _mostrarPainelTamanhoFonte() {  
    if (!_ativo) {
      final PersistentBottomSheetController<void> bottomSheet = scaffoldKey
          .currentState
          .showBottomSheet<void>((BuildContext bottomSheetContext) {
        // return Teste(funct: this.nada,);
        return Teste(
          fu: this.nada,
        );
      });

      setState(() {
        _bottomSheet = bottomSheet;
        _ativo = true;
      });
    } else {
      setState(() {
        if (_bottomSheet != null) _bottomSheet.close();
        _ativo = false;
      });
    }

    _bottomSheet.closed.whenComplete(() {
      if (mounted) {
        setState(() {
          _bottomSheet = null;
          _ativo = false;
        });
      }
    });
  }

  AnimationController _controller;
  _AbaClass _page = _allPages[0];

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - _PANEL_HEADER_HEIGHT;
    final double bottom = -_PANEL_HEADER_HEIGHT;
    return new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(new CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void initState() {
    super.initState();
    tamanhoFonteCartas = double.parse(GlobalConfiguration().getString("tamanhoFonte"));
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 100), value: 1.0, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  void _toggleBackdropPanelVisibility() {
    _controller.fling(velocity: _backdropPanelVisible ? -2.0 : 2.0);
  }

  double get _backdropHeight {
    final RenderBox renderBox =
        _backdropKey.currentContext.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    _controller.value -=
        details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  void changeColor(Color color) {
    setState(() {
      currentColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      primary: true,      
      appBar: AppBar(
        brightness: Brightness.dark,      
        elevation: 0,
        leading: new IconButton(
          onPressed: () {
            _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
          },
          icon: new AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _controller.view,
            color: fonteNecessaria(),
          ),
        ),
        title: Text(
          'Planning Cards',
          style: TextStyle(
            color: fonteNecessaria(),
            // color: Colors.black,
          ),
        ),
        backgroundColor: currentColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            color: fonteNecessaria(),
            onPressed: _mostrarPainelTamanhoFonte,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animation = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);
    void _changeCategory(_AbaClass category) {
      setState(() {
        _page = category;
        _controller.fling(velocity: 2.0);
      });
    }

    final List<Widget> backdropItems =
        _allPages.map<Widget>((_AbaClass category) {
      final bool selected = category == _page;
      return Padding(
        padding: const EdgeInsets.all(3),
        child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          color: selected
              ? Colors.white.withOpacity(0.25)
              : Colors.white.withOpacity(0.1),
          child: ListTile(
            title: Text(
              category.nomeDaAba,
              style: TextStyle(color: fonteNecessaria()),
            ),
            selected: selected,
            onTap: () {
              _changeCategory(category);
            },
          ),
        ),
      );
    }).toList();

    return Container(
      key: _backdropKey,
      color: currentColor,
      height: (MediaQuery.of(context).size.height),
      child: Stack(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: ListTileTheme(
                style: ListTileStyle.drawer,
                textColor:
                    theme.primaryTextTheme.headline5.color.withOpacity(0.6),
                selectedColor: theme.primaryTextTheme.headline5.color,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: backdropItems
                      ),
                ),
              ),
            ),
          ),
          PositionedTransition(
            rect: animation,
            child: BackdropPanel(
              onTap: _toggleBackdropPanelVisibility,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              title: Text(
                _page.nomeDaAba,
                style: TextStyle(fontSize: 20),
              ),
              child: OrientationBuilder(builder: (context, orientation) {
                return listaCartas(
                    _page.listaDeCartas,
                    orientation == Orientation.portrait ? 3 : 6,
                    1,
                    currentColor,
                    context);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

Widget listaCartas(List<String> lista, int qtcolunas, double tamanhofonte,
    Color cor, BuildContext context) {
  return GridView.count(
    crossAxisCount: qtcolunas,
    padding: EdgeInsets.all(5.0),
    children: lista
        .map(
          (data) => Card(
            elevation: 2,
            child: RaisedButton(
              color: cor,
              elevation: 0,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => Center(
                  child: Container(
                width: (MediaQuery.of(context).size.width * 0.85),
                height: (MediaQuery.of(context).size.height * 0.75),
                child: CartaEscolhida(
                carta: data,
                corEscolhida: cor,
                corDaFonte: fonteNecessaria(),
                  ),
              )));
              },
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: textoOuIcone(data, tamanhofonte, context, cor),
              )),
            ),
              ),
          // )
        )
        .toList(),
  );
}

Widget textoOuIcone(
    String texto, double tamanhoFonte, BuildContext context, Color cor) {
  if (texto == 'assets/cafe.png') {
    var iconeCafe = AssetImage(texto);
    return Image(
      color: fonteNecessaria(),
      image: iconeCafe,
      height: (MediaQuery.of(context).size.height * 0.1),
    );
  } else {
    return AutoSizeText(
      texto,
      style: TextStyle(
        fontSize: tamanhoFonteCartas,
        color: fonteNecessaria(),
      ),
      maxLines: 1,
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({Key key, this.category}) : super(key: key);

  final _AbaClass category;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        key: PageStorageKey<_AbaClass>(category),
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 64.0,
        ),
        children: category.listaDeCartas.map<Widget>((String asset) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                child: Container(
                  width: 144.0,
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        asset,
                        fit: BoxFit.contain,
                      ),                      
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class BackdropPanel extends StatelessWidget {
  const BackdropPanel({
    Key key,
    this.onTap,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.title,
    this.child,
  }) : super(key: key);

  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: onVerticalDragEnd,
            onTap: onTap,
            child: Container(
              height: 48.0,
              padding: const EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: DefaultTextStyle(
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                child: Tooltip(
                  message: 'Pressione para mostrar/esconder',
                  child: title,
                ),
              ),
            ),
          ),
          const Divider(height: 2.0),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class Teste extends StatefulWidget {
  Function fu;

  Teste({Key key, @required this.fu}): super(key: key);

  @override
  _TesteState createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  void changeColor2(Color color) {
    setState(() {
      currentColor = color;
      widget.fu();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black26)),
      ),
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Column(children: <Widget>[
            Container(
              height: 9,
              margin: EdgeInsets.only(top: 25, bottom: 15),
              // width: 80,
              width: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
            ),

            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          'Tamanho da fonte:',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: RaisedButton(
                            elevation: 0,
                            highlightElevation: 1,
                            color: Colors.grey[350],
                            child: Text('A-', style: TextStyle(fontSize: 14)),
                            onPressed: () {
                              setState(() {
                                if (tamanhoFonteCartas != 14)
                                  tamanhoFonteCartas -= 4;
                                widget.fu();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: RaisedButton(
                            elevation: 0,
                            highlightElevation: 1,
                            color: Colors.grey[350],
                            child: Text('A+', style: TextStyle(fontSize: 20)),
                            onPressed: () {
                              setState(() {
                                if (tamanhoFonteCartas != 46)
                                  tamanhoFonteCartas += 4;
                                widget.fu();
                              });
                            },
                          ),
                        ),
                      ])
                    ],
                  )
                ],
              )),
            ),
            Divider(
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          'Cor da fonte:',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 45,
                        child:
                        RawMaterialButton(                        
                          onPressed: () {
                            setState(() {
                              if (!(fonteNecessaria() == Colors.black)){
                                corFonteUsuario = Colors.black;
                                usuarioEscolheu = !usuarioEscolheu;
                                widget.fu();
                              }
                            });
                          },
                          elevation: 0,
                          fillColor: Colors.black,
                          shape: CircleBorder(
                              side: BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          )),
                        ),
                      ),
                      Container(
                        height: 45,
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              if (!(fonteNecessaria() == Colors.white)){
                                corFonteUsuario = Colors.white;
                                usuarioEscolheu = !usuarioEscolheu;
                                widget.fu();
                              }
                            });                          
                          },
                          elevation: 0,
                          fillColor: Colors.white,
                          shape: CircleBorder(
                            side: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            )
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          'Cor de tema:',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        height: 45,
                        child: RawMaterialButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Selecione uma cor'),
                                  content: SingleChildScrollView(
                                    child: MaterialPicker(                                      
                                      pickerColor: currentColor,
                                      onColorChanged: changeColor2,
                                    ),
                                  ),
                                );
                              },
                            );
                            usuarioEscolheu = false;
                          },
                          elevation: 0,
                          fillColor: currentColor,
                          shape: CircleBorder(                          
                              side: BorderSide(                              
                                width: 1.5,
                            )
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
            ),
          ]),
        ],
      ),
    );
  }
}

Color fonteNecessaria() {
  if (!usuarioEscolheu) 
    return useWhiteForeground(currentColor) ? Colors.white : Colors.black;
  else
    return corFonteUsuario;
}