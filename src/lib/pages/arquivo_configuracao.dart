import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path_provider/path_provider.dart';

Map<String, dynamic> listaConfiguracoes;

Map<String, dynamic> listaConfiguracoesPadrao() {
  return {
    "tamanhoFonte": 30.0,
    "corFonte": (Colors.black).value,
    "corTema": (Colors.blueAccent[400]).value,
    "usuarioEscolheu": false
  };
}

Color fonteNecessaria() {
  if (!listaConfiguracoes['usuarioEscolheu'])
    return useWhiteForeground(Color(listaConfiguracoes['corTema']))
        ? Colors.white
        : Colors.black;
  else
    return Color(listaConfiguracoes['corFonte']);
}

Future restaurarPadrao() async {
  final diretorio = await getApplicationDocumentsDirectory();
  bool arquivoExiste;
  arquivoExiste = false;
  arquivoExiste = await File("${diretorio.path}/data.json").exists();

  if (arquivoExiste) await excluirArquivo();

  listaConfiguracoes = listaConfiguracoesPadrao();
  print('chegou aqui');
}

Future excluirArquivo() async {
  final diretorio = await getApplicationDocumentsDirectory();
  await File("${diretorio.path}/data.json").delete();
}

Future<File> retornaArquivo() async {
  final diretorio = await getApplicationDocumentsDirectory();
  return File("${diretorio.path}/data.json");
}

Future<String> lerDadosArquivo() async {
  try {
    final file = await retornaArquivo();
    return file.readAsString();
  } catch (e) {
    return null;
  }
}

Future saveData(dynamic arquivoDeConfiguracao) async {
  String data = json.encode(arquivoDeConfiguracao);

  final file = await retornaArquivo();
  return file.writeAsString(data);
}

Future lerArquivo() async {
  await lerDadosArquivo().then((data) {
    listaConfiguracoes = json.decode(data);
  });
}

Future abrirArquivo() async {
  final diretorio = await getApplicationDocumentsDirectory();
  bool arquivoExiste = await File("${diretorio.path}/data.json").exists();

  if (!arquivoExiste) saveData(listaConfiguracoesPadrao());
}
