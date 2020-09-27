import 'package:flutter/material.dart';
import 'package:my_warehouse/functions/Receitas.dart';
import 'package:my_warehouse/models/Receitas.dart';
import 'package:my_warehouse/screens/NovaReceita.dart';
import 'package:my_warehouse/widgets/loadingWidget.dart';
import '../main.dart';

class Cozinhar extends StatefulWidget {
  @override
  _CozinharState createState() => _CozinharState();
}

class _CozinharState extends State<Cozinhar> {
  bool isLoading = true;
  List<Receita> receitas = new List<Receita>();
  List<int> quantidadeFeita = new List<int>();

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
    this.quantidadeFeita = new List<int>();
    for(int i=0;i<receitas.length;i++){
      this.quantidadeFeita.add(_getQuantidadeFeita(nomeReceita: receitas[i].nome, receitasFeitas: receitasFeitas));
    }
    setState(() {
      this.isLoading = false;
    });
  }

  AlertDialog venderReceitaWidget({Receita receita, int quantidade}){
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
          child: Text("Vender", style: TextStyle(fontSize: 15.0),),
          color: laranja,
          onPressed: (){
            if(precoVenda.text.length>0){
              try{
                double preco = double.tryParse(precoVenda.text);
                venderReceita(receita: receita, preco: preco);
                quantidade--;
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
              iconSize: 25.0,
              color: laranja,
              onPressed: function,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 5.0, right: 5.0),
              child: Text(number.toString(), style: TextStyle(fontSize: 10.0, color: Colors.blue),),
            ),
          )
        ],
      ),
    );
  }

  Widget buildReceita({Receita receita, int quantidadeFeita}){
    return FutureBuilder(
      future: checkEstoqueReceita(receita: receita),
      builder: (context, snapshot){
        if(snapshot.hasData){
          int quantidadePossoFazer = snapshot.data;
          return Card(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(receita.nome, style: TextStyle(fontSize: 18.0),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildIconWithNumberAndFunction(icon: Icon(Icons.build), number: quantidadePossoFazer, function: (){
                        if(quantidadePossoFazer>0){
                          fazerReceita(receita: receita);
                          setState(() {
                            quantidadeFeita++;
                          });
                        }
                      },),
                      SizedBox(width: 10.0,),
                      buildIconWithNumberAndFunction(icon: Icon(Icons.assignment_turned_in), number: quantidadeFeita, function: () {
                        if(quantidadeFeita>0){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return venderReceitaWidget(receita: receita, quantidade: quantidadeFeita);
                              }
                          );
                        }
                      },),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        else{
          return loadingWidget(height: 18.0, width: MediaQuery.of(context).size.width*0.7);
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
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => NovaReceita(receitas: this.receitas, quantidadeFeita: this.quantidadeFeita,)));
                            setState(() {

                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Text("Veja suas receitas", style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center,),
                        SizedBox(height: 10.0,),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: this.receitas.length,
                          itemBuilder: (BuildContext context, int index){
                            return buildReceita(
                              receita: this.receitas[index],
                              quantidadeFeita: this.quantidadeFeita[index],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
      );
    }
  }
}
