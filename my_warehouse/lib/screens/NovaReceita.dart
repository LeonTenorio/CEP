import 'package:flutter/material.dart';
import 'package:my_warehouse/functions/Ingredientes.dart';
import 'package:my_warehouse/functions/Receitas.dart';
import 'package:my_warehouse/models/Ingredientes.dart';
import 'package:my_warehouse/models/Receitas.dart';
import 'package:my_warehouse/widgets/loadingWidget.dart';
import '../functions/Ingredientes.dart';
import '../functions/Ingredientes.dart';
import '../main.dart';
import '../models/Ingredientes.dart';


//Chamem o metodo "createReceita"

class NovaReceita extends StatefulWidget {
  List<Receita> receitas;
  List<int> quantidadeFeita;
  NovaReceita({this.receitas, this.quantidadeFeita});

  @override
  _NovaReceitaState createState() => _NovaReceitaState();
}

class _NovaReceitaState extends State<NovaReceita> {
  List<String> ingredientes = ['Mariola','Cu de curioso'];
  List<String> kglList = [];
  TextEditingController nomeController = TextEditingController();
  TextEditingController precoController = TextEditingController();
  List<TextEditingController> qtdControllers = [];

  createReceita(String nome, double precoReceita, List<String> nomesIngredientes, List<double> quantidadeIngredientes){
    Receita receita = Receita(
      nome: nome,
      horarioAdicionado: DateTime.now().toString(),
      precoReceita: precoReceita,
      horarioAtualizado: DateTime.now().toString(),
      nomesIngredientes: nomesIngredientes,
      quantidadesIngredientes: quantidadeIngredientes,
    );
    if(!this.widget.receitas.contains(receita.nome)){
      this.widget.receitas.add(receita);
      this.widget.quantidadeFeita.add(0);
    }
    addNovaReceita(receita: receita);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    qtdControllers.add(TextEditingController());
    qtdControllers.add(TextEditingController());
    kglList.add(" ");
    kglList.add(" ");
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
                      Text("Adicione sua nova receita", style: TextStyle(fontSize: 18.0),),
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
                      SizedBox(height: 10.0,),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          //ADICIONAR OS CAMPOS
                          //ACHO QUE UMA LIST DE WIDGETS PARA VER OS INGREDIENTES E QUANTIDADES DELES
                          Text("Nome da receita: ", style: TextStyle(fontSize: 16.0),),
                          SizedBox(
                            width: 200.0,
                            height: 50.0,
                            child: Container(
                              margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0, right: 6.0),
                              child: new TextField(
                                controller: nomeController,
                                style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                            )
                            )
                          ),
                          Text("Preco da receita: ", style: TextStyle(fontSize: 16.0),),
                          SizedBox(
                            width: 200.0,
                            height: 50.0,
                            child: Container(
                              margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0, right: 6.0),
                              child: new TextField(
                                controller: precoController,
                                style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                            )
                            )
                          ),
                          Text("Lista de ingredientes: ", style: TextStyle(fontSize: 16.0),),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: this.ingredientes.length,
                            itemBuilder: (BuildContext context, int index){
                              return Card(
                                child: Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${ingredientes[index]}",style: TextStyle(fontSize: 16.0)),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 50.0,
                                            height: 50.0,
                                            child: Container(
                                              margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0, right: 6.0),
                                              child: new TextField(
                                                controller: qtdControllers[index],
                                                style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                                              )
                                            )
                                          ),
                                          SizedBox(width: 5.0),
                                          DropdownButton(
                                            items: <String>[" ", 'kg', 'g', 'l', 'ml'].map((String value){
                                              return new DropdownMenuItem(
                                                value:value,
                                                child: new Text(value)
                                              );
                                            }).toList(), 
                                            onChanged: (String data){
                                              setState(() {
                                                kglList[index] = data;
                                              });
                                            },
                                            value: kglList[index]
                                          )
                                        ],
                                      )
                                      
                                    ],
                                  )
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 5.0,),
                          //UM BOTAO DE ADD TAMBEM
                          //AI NO ADD UM POPUP (pesquisar showDialog em flutter muito util) COM A LISTAGEM DE INGREDIENTES JA CADASTRADOS
                          //SE UM ADD PARA CADASTRAR UM NOVO INGREDIENTE
                          Card(
                            color: laranja,
                            child: Padding(
                              padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                padding: EdgeInsets.all(0.0),
                                onPressed: () async{
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return AdicionarIngrediente(ingredientes: this.ingredientes,);
                                    }
                                  );
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                          )
                        ],
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

class AdicionarIngrediente extends StatefulWidget {
  List<String> ingredientes;
  AdicionarIngrediente({this.ingredientes});

  @override
  _AdicionarIngredienteState createState() => _AdicionarIngredienteState();
}

class _AdicionarIngredienteState extends State<AdicionarIngrediente> {
  List<Ingrediente> ingredientes;
  Ingrediente ingrediente;
  bool isLoading = true;

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  load() async{
    this.ingredientes = await getListTiposIngredientes();
    setState(() {
      this.isLoading = false;
    });
  }

  //Coloquei o alertDialog e as configuracoes que geralmente uso nele que sei que ficam OK
  @override
  Widget build(BuildContext context) {
    if(this.isLoading){
      return AlertDialog(
        title: Text("Selecione o ingrediente", style: TextStyle(fontSize: 18.0),),
        content: Container(
          height: MediaQuery.of(context).size.height*0.8,
          width: MediaQuery.of(context).size.width*0.7,
          child: loadingWidget(height: MediaQuery.of(context).size.height*0.5)
        ),
        actions: [

        ],
      );
    }
    else{
      print("///////////////////////////////////////${ingredientes.length}");
      return AlertDialog(
        title: Text("Selecione o ingrediente", style: TextStyle(fontSize: 18.0),),
        content: Container(
          height: MediaQuery.of(context).size.height*0.8,
          width: MediaQuery.of(context).size.width*0.7,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                ListView.builder(
                  itemCount: ingredientes.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Text("${ingredientes[index].nome}"),
                    );
                  },
                )
              ],
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text("Cancelar", style: TextStyle(fontSize: 16.0),),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("Adicionar", style: TextStyle(fontSize: 16.0),),
            onPressed: (){
              if(this.ingrediente!=null){
                this.widget.ingredientes.add(ingrediente.nome);
              }
              Navigator.pop(context);
            },
          )
        ],
      );
    }
  }
}

