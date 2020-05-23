import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CartaEscolhida extends StatefulWidget {
  final String carta;
  final Color corEscolhida;
  final Color corDaFonte;

  CartaEscolhida({Key key, @required this.carta, @required  this.corEscolhida, @required this.corDaFonte})
      : super(key: key);

  @override
  _CartaEscolhidaState createState() => _CartaEscolhidaState();
}

class _CartaEscolhidaState extends State<CartaEscolhida> {
  @override
  Widget build(BuildContext context) {
    return FlipCard(
        speed: 500,
        direction: FlipDirection.HORIZONTAL,
        front: mostrarCarta(' ', context, widget.corEscolhida, widget.corDaFonte),
        back: mostrarCarta(widget.carta, context, widget.corEscolhida, widget.corDaFonte),
      );
  }

  Widget mostrarCarta(String carta, BuildContext context, Color cor, Color corDafonte) {
    return Card(
        shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10,
        color: cor,
        child: Center(child: textoOuIcone(carta, 200, corDafonte, context)),
      );
  }

  Widget textoOuIcone(String texto, double tamanhoFonte, Color corDafonte, BuildContext context) {
    if (texto == 'assets/cafe.png') {
      var imagemCafe = AssetImage(texto);
      return Image(
        color: corDafonte,
        image: imagemCafe,
        height: (MediaQuery.of(context).size.height * 0.35),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: AutoSizeText(
          texto,
          style: TextStyle(
            fontSize: 300,
            color: corDafonte,
          ),
          maxLines: 1,
        ),
      );
    }
  }
}
