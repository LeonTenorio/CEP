import 'package:flutter/material.dart';
import 'package:my_warehouse/functions/Receitas.dart';
import 'package:my_warehouse/models/Receitas.dart';
import 'package:my_warehouse/widgets/loadingWidget.dart';

import '../main.dart';

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
    double precoComercializado = 0.0;
    if(vendidas[i].precoComercializado!=null){
      precoComercializado = vendidas[i].precoComercializado;
    }
    else{
      precoComercializado = vendidas[i].precoReceita;
    }
    receitaVenda = receitaVenda + precoComercializado;
    custoVenda = custoVenda + vendidas[i].getCusto();
  }
  return [vendidas.length, receitaVenda, custoVenda, 100*receitaVenda/custoVenda, receitaVenda/vendidas.length, custoVenda/vendidas.length, (receitaVenda-custoVenda)/vendidas.length];
}

class Relatorio extends StatefulWidget {
  @override
  _RelatorioState createState() => _RelatorioState();
}

class _RelatorioState extends State<Relatorio> {
  bool isLoading = true;

  Map<String, dynamic> receitasVendidas = new Map<String, dynamic>();

  @override
  void initState() {
    this.isLoading = true;
    super.initState();
    load();
  }

  @override
  void dispose() {
    super.dispose();
  }


  load() async{
    this.receitasVendidas = await getReceitasVendidas();
    setState(() {
      this.isLoading = false;
    });
  }

  Widget buildReceita_Relatorio(String nome, List<Receita> receitasVendidas){
    List<dynamic> infos = getQuantidadePrecoCustoLucroMedias(receitasVendidas);
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Receita: "+ nome, style: TextStyle(fontSize: 18.0),),
                  ],
                ),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Ganho/Custo: " + infos[3].toStringAsFixed(2).replaceAll(".", ",") + "%", style: TextStyle(fontSize: 18.0),),
                  ],
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Vendidos: " + infos[0].toString(), style: TextStyle(fontSize: 18.0),),
                    //Text("BRL/unid: " + infos[4].toStringAsFixed(2).replaceAll(".", ","), style: TextStyle(fontSize: 18.0),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Receita total: R\$ " + infos[1].toStringAsFixed(2).replaceAll(".", ","), style: TextStyle(fontSize: 18.0),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Custo total: R\$" + infos[2].toStringAsFixed(2).replaceAll(".", ","), style: TextStyle(fontSize: 18.0),),
                  ],
                ),
              ],
            )
        ),
      ),
      onTap: (){
        showDialog(context: context, builder: (BuildContext context){
          return buildPopUpRelatorio(receitasVendidas, nome, infos);
        });
        //NAO SEI COMO FICOU, MAS ACHO QUE AQUI SERIA A PAGINA DO ALE
        //Navigator.push(context, MaterialPageRoute(builder: (context) => VisualizarReceitasVendidas(nome: nome, receitasVendias: receitasVendias)));
      },
    );
  }


  Widget buildPopUpRelatorio(List<Receita> receitas, String nome,List<dynamic> infos){
    Widget sizedBox = SizedBox(height: 3.0,);
    return AlertDialog(
      title: Text("INFORMAÇÕES DA VENDA: "+nome, style: TextStyle(fontSize: 18.0),),
      content: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: MediaQuery.of(context).size.height*0.7,
        child: ListView(
          shrinkWrap: true,
          children: [
            Card(
              color: laranja,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ganho/Custo: ", style: TextStyle(fontSize: 18.0),),
                        sizedBox,
                        Text(infos[3].toStringAsFixed(2).replaceAll(".", ",") + "%", style: TextStyle(fontSize: 18.0),),
                        sizedBox,
                        Text("Receita total: R\$ " + infos[1].toStringAsFixed(2).replaceAll(".", ","), style: TextStyle(fontSize: 18.0),),
                        sizedBox,
                        Text("Lucro/unid: R\$ " + infos[6].toStringAsFixed(2).replaceAll(".", ","), style: TextStyle(fontSize: 18.0),),
                        sizedBox,
                        Text("Preço/unid vendida:", style: TextStyle(fontSize: 18.0),),
                        sizedBox,
                        Text(infos[4].toStringAsFixed(2).replaceAll(".", ","), style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.0, right: 5.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Center(
                          child: Text(infos[0].toString()),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ),
            SizedBox(height: 10.0,),
            Card(
              color: Colors.black,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("Vendas", style: TextStyle(fontSize: 18.0, color: Colors.white), textAlign: TextAlign.center,),
              ),
            ),
            SizedBox(height: 10.0,),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: receitas.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  color: Colors.white70,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Valor vendido: R\$ "+receitas[index].precoComercializado.toStringAsFixed(2).replaceAll(".", ","), style: TextStyle(fontSize: 16.0),),
                        sizedBox,
                        Text("Horario de venda: ", style: TextStyle(fontSize: 16.0),),
                        sizedBox,
                        Text(dateToPdfFormat(receitas[index].horarioComercializado)+" "+timeToPdfFormat(receitas[index].horarioComercializado), style: TextStyle(fontSize: 16.0),),
                        sizedBox,
                        Text("Horario feito: ", style: TextStyle(fontSize: 16.0),),
                        sizedBox,
                        Text(dateToPdfFormat(receitas[index].horarioFeito)+" "+timeToPdfFormat(receitas[index].horarioFeito), style: TextStyle(fontSize: 16.0),),
                        sizedBox,
                        Text("Custo: R\$"+receitas[index].getCusto().toStringAsFixed(2).replaceAll(".", ","), style: TextStyle(fontSize: 16.0),),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        )
      ),
      actions: [
        FlatButton(
          child: Text("Ok"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  String dateToPdfFormat(String date){
    DateTime time = DateTime.parse(date);
    String dia = time.day.toString();
    if(dia.length<2)
      dia = '0' + dia;
    String mes = time.month.toString();
    if(mes.length<2)
      mes = '0' + mes;
    String ano = time.year.toString();
    if(ano.length<2)
      ano = '0' + ano;
    return dia + '/' + mes + '/' + ano;
  }

  String timeToPdfFormat(String date){
    DateTime time = DateTime.parse(date);
    String hrs = time.hour.toString();
    if(hrs.length<2)     hrs = '0' + hrs;
      String min = time.minute.toString();
    if(min.length<2)
      min = '0' + min;
    return hrs + ':' + min;
  }


  @override
  Widget build(BuildContext context) {
    if(this.isLoading){
      return Scaffold(
        body: Center(
          child: loadingWidget(height: MediaQuery.of(context).size.height*0.5),
        ),
      );
    }
    else {
      List<String> nomeReceitas = this.receitasVendidas.keys.toList();
      return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: 10.0, right: 5.0, left: 5.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Card(
                  color: laranja,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.insert_drive_file_sharp, color: Colors.black, size: 25.0,),
                        SizedBox(width: 50.0,),
                        Text("Relatório", style: TextStyle(fontSize: 18.0),)
                      ],
                    ),

                  ),

                ),
                Card(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                    child: Text("Informações das suas vendas", style: TextStyle(fontSize: 18.0, color: Colors.white), textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(height: 10.0,),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: nomeReceitas.length,
                  itemBuilder: (BuildContext context, int index){
                    return buildReceita_Relatorio(nomeReceitas[index], this.receitasVendidas[nomeReceitas[index]]);
                  },
                )
              ],

            ),

          )

      );
    }
  }

}
