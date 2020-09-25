class AbaCarta {
  const AbaCarta({this.nomeDaAba, this.listaDeCartas, this.tamanhoFonteAbas});
  final String nomeDaAba;
  final List<String> listaDeCartas;
  final double tamanhoFonteAbas;
}

const List<String> cartasFibonacci = [
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

const List<String> cartasStandart = [
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

const List<String> cartasTShirtEN = [
  "XS",
  "S",
  "M",
  "L",
  "XL",
  "∞",
  "?",
  "assets/cafe.png"
];

const List<AbaCarta> listaTipoCarta = [
  AbaCarta(nomeDaAba: 'Fibonacci', listaDeCartas: cartasFibonacci, tamanhoFonteAbas: 38),
  AbaCarta(nomeDaAba: 'Standard', listaDeCartas: cartasStandart, tamanhoFonteAbas: 20),
  AbaCarta(nomeDaAba: 'T-Shirt', listaDeCartas: cartasTShirtEN, tamanhoFonteAbas: 35),
];