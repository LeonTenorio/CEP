import 'package:flutter/material.dart';
import 'package:my_warehouse/models/Receitas.dart';

/*
* CONSTRUAM ESSA PAGINA AQUI, VOU DEIXAR UNS PRESENTES AQUI
* NO ARQUIVO DE RECEITAS TEMOS UMA getReceitasVendidas usem ela
* fora isso temos algumas funcoes para serem chamadas pra cada uma das receitas
* */

List<dynamic> getQuantidadePrecoCustoLucroMedias(List<Receita> vendidas){
  /*retorno vai ser uma lista
  * [quantidade vendida, receita de venda, custo da venda, lucro da venda em porcentagem, preco medio, custo medio]*/
  double receitaVenda = 0.0;
  double custoVenda = 0.0;
  for(int i=0;i<vendidas.length;i++){
    receitaVenda = receitaVenda + vendidas[i].precoComercializado;
    custoVenda = custoVenda + vendidas[i].getCusto();
  }
  return [vendidas.length, receitaVenda, custoVenda, 100*receitaVenda/custoVenda, receitaVenda/vendidas.length, custoVenda/vendidas.length];
}

class Relatorio extends StatefulWidget {
  @override
  _RelatorioState createState() => _RelatorioState();
}

class _RelatorioState extends State<Relatorio> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
