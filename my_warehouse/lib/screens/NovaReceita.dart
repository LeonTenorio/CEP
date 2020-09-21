import 'package:flutter/material.dart';
import 'package:my_warehouse/functions/Ingredientes.dart';
import 'package:my_warehouse/models/Ingredientes.dart';
import 'package:my_warehouse/widgets/loadingWidget.dart';
import '../main.dart';


//Diria que vai ser uma STATEFUL por precisar adicionar receita a partir de ingredientes jah existentes entao teria alguma pesquisa de ingredientes
//Criou nova receita nao esquecer de dar receitas.add(receita)

class NovaReceita extends StatefulWidget {
  List<dynamic> receitas;
  NovaReceita({this.receitas});

  @override
  _NovaReceitaState createState() => _NovaReceitaState();
}

class _NovaReceitaState extends State<NovaReceita> {
  List<Ingrediente> ingredientes = new List<Ingrediente>();

  @override
  Widget build(BuildContext context) {
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
                      Text("Preencha esses campos", style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center,),
                      SizedBox(height: 10.0,),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          //ADICIONAR OS CAMPOS
                          //ACHO QUE UMA LIST DE WIDGETS PARA VER OS INGREDIENTES E QUANTIDADES DELES
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: this.ingredientes.length,
                            itemBuilder: (BuildContext context, int index){
                              return Container();
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
  List<Ingrediente> ingredientes;
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
                Container()
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
                this.widget.ingredientes.add(ingrediente);
              }
              Navigator.pop(context);
            },
          )
        ],
      );
    }
  }
}

