import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:scrum_manager_lite/pages/CartaEscolhida.dart';
import 'package:scrum_manager_lite/pages/PainelConfiguracao.dart';
import 'package:scrum_manager_lite/pages/arquivo_configuracao.dart'
    as arquivo_configuracao;
import 'package:scrum_manager_lite/pages/AbaCarta.dart' as aba_carta;

class CartasScrumPoker extends StatefulWidget {
  CartasScrumPokerState createState() => CartasScrumPokerState();
}

class CartasScrumPokerState extends State<CartasScrumPoker>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  PersistentBottomSheetController<void> painelRodapeController;
  bool painelAtivo = false;

  @override
  void initState() {
    super.initState();

    controllerAnimacao = new AnimationController(
        duration: const Duration(milliseconds: 100), value: 100.0, vsync: this);
  }

  void setStateClasseChamadora() {
    setState(() {});
  }

  void _mostrarPainelConfiguracao() {
    if (!painelAtivo) {
      final PersistentBottomSheetController<void> bottomSheet = scaffoldKey
          .currentState
          .showBottomSheet<void>((BuildContext bottomSheetContext) {
        return PainelConfiguracao(
          setStateClasseChamadora: this.setStateClasseChamadora,
        );
      });

      setState(() {
        painelRodapeController = bottomSheet;
        painelAtivo = true;
      });
    } else {
      setState(() {
        if (painelRodapeController != null) painelRodapeController.close();
        painelAtivo = false;
      });
    }

    painelRodapeController.closed.whenComplete(() {
      if (mounted) {
        setState(() {
          painelRodapeController = null;
          painelAtivo = false;
        });
      }
    });
  }

  AnimationController controllerAnimacao;
  aba_carta.AbaCarta abaVisivel = aba_carta.listaTipoCarta[0];

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double height = constraints.biggest.height;
    final double top = height - 32.0;
    final double bottom = -32.0;
    return new RelativeRectTween(
      begin: new RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(
        new CurvedAnimation(parent: controllerAnimacao, curve: Curves.linear));
  }

  @override
  void dispose() {
    controllerAnimacao.dispose();
    super.dispose();
  }

  bool get painelVisivel {
    final AnimationStatus status = controllerAnimacao.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  bool get backdropPanelVisible {
    final AnimationStatus status = controllerAnimacao.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  final GlobalKey backdropKey = GlobalKey(debugLabel: 'Backdrop');

  void mostrarEsconderPainelNoClique() {
    controllerAnimacao.fling(velocity: backdropPanelVisible ? -0.1 : 0.1);
  }

  double get backdropHeight {
    final RenderBox renderBox =
        backdropKey.currentContext.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  void controlaAtualizacaoDeslizePainel(DragUpdateDetails details) {
    controllerAnimacao.value -=
        details.primaryDelta / (backdropHeight ?? details.primaryDelta);
  }

  void controlaDeslizeParaIrInicioOuFim(DragEndDetails details) {
    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / backdropHeight;

    if (flingVelocity < 0.0)
      controllerAnimacao.fling(velocity: math.max(0.1, flingVelocity));
    else if (flingVelocity > 0.0)
      controllerAnimacao.fling(velocity: math.min(-0.1, -flingVelocity));
    else
      controllerAnimacao.fling(
          velocity: controllerAnimacao.value < 1.5 ? -0.1 : 0.1);
  }

  void changeColor(Color cor) {
    setState(() {
      arquivo_configuracao.listaConfiguracoes['corTema'] = cor.value;
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
            controllerAnimacao.fling(velocity: painelVisivel ? -0.1 : 0.1);
          },
          icon: new AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: controllerAnimacao.view,
            color: arquivo_configuracao.fonteNecessaria(),
          ),
        ),
        title: Text(
          'Scrum Manager',
          style: TextStyle(
            color: arquivo_configuracao.fonteNecessaria(),
          ),
        ),
        backgroundColor:
            Color(arquivo_configuracao.listaConfiguracoes['corTema']),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            color: arquivo_configuracao.fonteNecessaria(),
            onPressed: _mostrarPainelConfiguracao,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<RelativeRect> animacao = _getPanelAnimation(constraints);
    final ThemeData theme = Theme.of(context);

    void _changeCategory(aba_carta.AbaCarta category) {
      setState(() {
        abaVisivel = category;
        controllerAnimacao.fling(velocity: 0.1);
      });
    }

    final List<Widget> backdropItems =
        aba_carta.listaTipoCarta.map<Widget>((aba_carta.AbaCarta category) {
      final bool selected = category == abaVisivel;
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
              style: TextStyle(color: arquivo_configuracao.fonteNecessaria()),
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
      key: backdropKey,
      color: Color(arquivo_configuracao.listaConfiguracoes['corTema']),
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
                      children: backdropItems),
                ),
              ),
            ),
          ),
          PositionedTransition(
            rect: animacao,
            child: BackdropPanel(
              onTap: mostrarEsconderPainelNoClique,
              onVerticalDragUpdate: controlaAtualizacaoDeslizePainel,
              onVerticalDragEnd: controlaDeslizeParaIrInicioOuFim,
              title: Text(
                abaVisivel.nomeDaAba,
                style: TextStyle(fontSize: 20),
              ),
              child: OrientationBuilder(builder: (context, orientation) {
                return listaCartas(
                    abaVisivel.listaDeCartas,
                    orientation == Orientation.portrait ? 3 : 6,
                    Color(arquivo_configuracao.listaConfiguracoes['corTema']),
                    context);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

Widget listaCartas(
    List<String> lista, int qtcolunas, Color cor, BuildContext context) {
  return GridView.count(
    crossAxisCount: qtcolunas,
    padding: EdgeInsets.all(5.0),
    children: lista
        .map(
          (data) => Card(
            elevation: 0,
            child: RaisedButton(
              color: cor,
              elevation: 0,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => Center(
                            child: Container(
                          width: (MediaQuery.of(context).size.width * 0.80),
                          height: (MediaQuery.of(context).size.height * 0.7),
                          child: CartaEscolhida(
                            carta: data,
                            corEscolhida: cor,
                            corDaFonte: arquivo_configuracao.fonteNecessaria(),
                          ),
                        )));
              },
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: textoOuIcone(data, context, cor),
              )),
            ),
          ),
        )
        .toList(),
  );
}

Widget textoOuIcone(String texto, BuildContext context, Color cor) {
  if (texto == 'assets/cafe.png') {
    var iconeCafe = AssetImage(texto);
    return Image(
      color: arquivo_configuracao.fonteNecessaria(),
      image: iconeCafe,
      height: (MediaQuery.of(context).size.height * 0.1),
    );
  } else {
    return AutoSizeText(
      texto,
      style: TextStyle(
        fontSize: arquivo_configuracao.listaConfiguracoes['tamanhoFonte'],
        color: arquivo_configuracao.fonteNecessaria(),
      ),
      maxLines: 1,
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({Key key, this.category}) : super(key: key);

  final aba_carta.AbaCarta category;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        key: PageStorageKey<aba_carta.AbaCarta>(category),
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
