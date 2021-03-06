import 'package:flutter/material.dart';
import 'package:my_warehouse/functions/Receitas.dart';
import 'package:my_warehouse/models/Receitas.dart';
import 'package:my_warehouse/screens/NovaReceita.dart';
import 'package:my_warehouse/widgets/loadingWidget.dart';
import '../main.dart';

List<int> quantidadeFeita = new List<int>();

class Cozinhar extends StatefulWidget {
  @override
  _CozinharState createState() => _CozinharState();
}

class _CozinharState extends State<Cozinhar> {
  bool isLoading = true;
  List<Receita> receitas = new List<Receita>();


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
  
  int _getQuantidadeFeita({String nomeReceita, List<Receita> receitasFeitas}){
    int ret = 0;
    for(int i=0;i<receitasFeitas.length;i++){
      if(receitasFeitas[i].nome==nomeReceita)
        ret++;
    }
    return ret;
  }

  load() async{
    this.receitas = await getReceitas();
    List<Receita> receitasFeitas = await getReceitasFeitas();
    quantidadeFeita = new List<int>();
    for(int i=0;i<receitas.length;i++){
      quantidadeFeita.add(_getQuantidadeFeita(nomeReceita: receitas[i].nome, receitasFeitas: receitasFeitas));
    }
    setState(() {
      this.isLoading = false;
    });
  }

  AlertDialog venderReceitaWidget({Receita receita, int index}){
    TextEditingController precoVenda = new TextEditingController();
    return AlertDialog(
      title: Text("Vender receita", style: TextStyle(fontSize: 18.0),),
      content: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: 250.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(receita.nome, style: TextStyle(fontSize: 18.0),),
            SizedBox(height: 15.0,),
            Text("Preço definido: R\$ "+receita.precoReceita.toStringAsFixed(2).replaceAll(".", ","), style: TextStyle(fontSize: 18.0),),
            SizedBox(height: 15.0,),
            Material(
              child: TextFormField(
                controller: precoVenda,
                style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                  hintText: "Insira o preço",
                  filled: true,
                  fillColor: const Color(0xFFF0F0F0),
                  hintStyle: TextStyle(
                      color: const Color(0xFFa6a6a6),
                      fontSize: 18.0
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFe6e6e6), width: 0.5),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFe6e6e6), width: 0.5),
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text("Cancelar", style: TextStyle(fontSize: 15.0),),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Consumir", style: TextStyle(fontSize: 15.0),),
          color: laranja,
          onPressed: (){
            excluirReceitaFeita(receita: receita);
            quantidadeFeita[index]--;
            Navigator.pop(context);
            setState(() {
              
            });
          },
        ),
        FlatButton(
          child: Text("Vender", style: TextStyle(fontSize: 15.0),),
          color: laranja,
          onPressed: (){
            if(precoVenda.text.length>0){
              try{
                double preco = double.tryParse(precoVenda.text.replaceAll(",", "."));
                print(preco);
                venderReceita(receita: receita, preco: preco);
                quantidadeFeita[index]--;
                Navigator.pop(context);
                setState(() {

                });
              }
              catch(e){

              }
            }
          },
        )
      ],
    );
  }

  Widget buildIconWithNumberAndFunction({Icon icon, int number, function}){
    return Container(
      width: 40.0,
      height: 40.0,
      child: Stack(
        children: [
          Center(
            child: IconButton(
              icon: icon,
              iconSize: 22.0,
              color: laranja,
              onPressed: function,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 5.0, right: 5.0),
              child: Text(number.toString(), style: TextStyle(fontSize: 12.0, color: Colors.blue, fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    );
  }

  String _numberFormat(double number){
    if(number%1==0){
      return number.toInt().toString();
    }
    else{
      return number.toStringAsFixed(2).replaceAll('.', ',');
    }
  }

  Widget buildPopUpReceita(Receita receita, function){
    return AlertDialog(
      title: Text("Ingredientes", style: TextStyle(fontSize: 18.0),),
      content: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: MediaQuery.of(context).size.height*0.7,
        child: Scrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: receita.nomesIngredientes.length,
            itemBuilder: (BuildContext context, int index){
              return Padding(
                padding: EdgeInsets.all(5.0),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(receita.nomesIngredientes[index], style: TextStyle(fontSize: 16.0),),
                        Text(_numberFormat(receita.quantidadesIngredientes[index]), style: TextStyle(fontSize: 16.0),)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        FlatButton(
          child: Text("Ok"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Fazer"),
          onPressed: function
        )
      ],
    );
  }
  
  Widget _buildViewReceita(Receita receita, int index){
    return Card(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(receita.nome, style: TextStyle(fontSize: 18.0),),
            buildIconWithNumberAndFunction(icon: Icon(Icons.assignment_turned_in), number: quantidadeFeita[index], function: () {
              if(quantidadeFeita[index]>0){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return venderReceitaWidget(receita: receita, index: index);
                    }
                );
              }
            },),
          ],
        ),
      ),
    );
  }

  Widget buildReceita({Receita receita, int index}){
    return FutureBuilder(
      future: checkEstoqueReceita(receita: receita),
      builder: (context, snapshot){
        if(snapshot.hasData){
          int quantidadePossoFazer = snapshot.data;
          if(quantidadePossoFazer>0){
            return GestureDetector(
              child: _buildViewReceita(receita, index),
              onTap: () async{
                await showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return buildPopUpReceita(receita, (){
                        if(quantidadePossoFazer>0){
                          fazerReceita(receita: receita);
                          Navigator.pop(context);
                          setState(() {
                            quantidadeFeita[index]++;
                          });
                        }
                      });
                    }
                );
              },
            );
          }
          else{
            return _buildViewReceita(receita, index);
          }
        }
        else{
          return loading(height: 18.0, width: MediaQuery.of(context).size.width*0.7);
        }
      },
    );
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
    else{
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.kitchen, color: Colors.black, size: 25.0,),
                        Text("Suas receitas", style: TextStyle(fontSize: 18.0),),
                        IconButton(
                          icon: Icon(Icons.add),
                          iconSize: 18.0,
                          padding: EdgeInsets.all(0.5),
                          color: Colors.green,
                          onPressed: () async{
                            //Nao me critiquem por async, mas isso que vou colocar aqui eh muito util
                            //Maneira mais simples da pagina de nova receita criar essa receita e depois de criar adicionar na lista de receitas
                            //Ai essa pagina espera a pagina chamada terminar a execucao e depois da um setState com essa nova receita na listagem
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => NovaReceita(receitas: this.receitas,)));
                            setState(() {

                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Card(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                    child: Text("Veja suas receitas", style: TextStyle(fontSize: 18.0, color: Colors.white), textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(height: 10.0,),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: this.receitas.length,
                  itemBuilder: (BuildContext context, int index){
                    return buildReceita(
                      receita: this.receitas[index],
                      index: index,
                    );
                  },
                )
              ],
            ),
          )
      );
    }
  }
}
