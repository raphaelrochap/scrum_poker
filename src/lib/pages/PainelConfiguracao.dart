import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:scrum_manager_lite/pages/arquivo_configuracao.dart' as arquivo_configuracao;

class PainelConfiguracao extends StatefulWidget {
  final Function setStateClasseChamadora;

  PainelConfiguracao(
    {Key key,
    @required this.setStateClasseChamadora})
    : super(key: key);

  @override
  _PainelConfiguracaoState createState() => _PainelConfiguracaoState();
}

class _PainelConfiguracaoState extends State<PainelConfiguracao> {
  void corAlterada(Color cor) {
    setState(() {
      arquivo_configuracao.listaConfiguracoes['corTema'] = cor.value;
      arquivo_configuracao.saveData(arquivo_configuracao.listaConfiguracoes);
      widget.setStateClasseChamadora();
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
              padding:
                  const EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
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
                                if (arquivo_configuracao.listaConfiguracoes['tamanhoFonte'] != 14)
                                  arquivo_configuracao.listaConfiguracoes['tamanhoFonte'] -= 4;

                                  arquivo_configuracao.saveData(arquivo_configuracao.listaConfiguracoes);
                                  widget.setStateClasseChamadora();
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
                                if (arquivo_configuracao.listaConfiguracoes['tamanhoFonte'] != 46)
                                  arquivo_configuracao.listaConfiguracoes['tamanhoFonte'] += 4;

                                  arquivo_configuracao.saveData(arquivo_configuracao.listaConfiguracoes);
                                  widget.setStateClasseChamadora();
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
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              if (!(arquivo_configuracao.fonteNecessaria() ==
                                  Colors.black)) {
                                arquivo_configuracao.listaConfiguracoes['corFonte'] =
                                    Colors.black.value;
                                arquivo_configuracao
                                        .listaConfiguracoes['usuarioEscolheu'] =
                                    !arquivo_configuracao
                                        .listaConfiguracoes['usuarioEscolheu'];
                                arquivo_configuracao
                                    .saveData(arquivo_configuracao.listaConfiguracoes);
                                widget.setStateClasseChamadora();
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
                              if (!(arquivo_configuracao.fonteNecessaria() == Colors.white)) {
                                arquivo_configuracao.listaConfiguracoes['corFonte'] = Colors.white.value;
                                arquivo_configuracao.listaConfiguracoes['usuarioEscolheu'] = !arquivo_configuracao.listaConfiguracoes['usuarioEscolheu'];
                                arquivo_configuracao.saveData(arquivo_configuracao.listaConfiguracoes);
                                widget.setStateClasseChamadora();
                              }
                            });
                          },
                          elevation: 0,
                          fillColor: Colors.white,
                          shape: CircleBorder(
                              side: BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          )),
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
                                      pickerColor: Color(arquivo_configuracao.listaConfiguracoes['corTema']),
                                      onColorChanged: corAlterada,
                                    ),
                                  ),
                                );
                              },
                            );
                            arquivo_configuracao.listaConfiguracoes['usuarioEscolheu'] = false;
                          },
                          elevation: 0,
                          fillColor: Color(arquivo_configuracao.listaConfiguracoes['corTema']),
                          shape: CircleBorder(
                              side: BorderSide(
                            width: 1.5,
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 15),
              height: 35,
              child: RaisedButton(
                color: Color(arquivo_configuracao.listaConfiguracoes['corTema']),
                elevation: 0,
                disabledElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'Restaurar padrão',
                  style: TextStyle(color: arquivo_configuracao.fonteNecessaria()),
                ),
                onPressed: () {
                  setState(() {
                    arquivo_configuracao.restaurarPadrao();
                    widget.setStateClasseChamadora();
                  });
                },
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
