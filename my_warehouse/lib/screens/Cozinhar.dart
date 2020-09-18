import 'package:flutter/material.dart';
import 'package:my_warehouse/screens/NovaReceita.dart';
import 'package:my_warehouse/widgets/loadingWidget.dart';
import '../main.dart';

class Cozinhar extends StatefulWidget {
  @override
  _CozinharState createState() => _CozinharState();
}

class _CozinharState extends State<Cozinhar> {
  bool isLoading = true;
  List<dynamic> receitas = new List<dynamic>();

  @override
  void initState() {
    this.isLoading = true;
    load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  load() async{
    //this.receitas = await loadReceitas();
    //Coloquei esse future.delayed soh para ver o carregando por 5 segundos, desativar e usar soh o await da linha anterior
    await Future.delayed(Duration(seconds: 5), (){

    });
    setState(() {
      this.isLoading = false;
    });
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
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index){
                            return Container(
                              height: 50.0,
                              child: Center(
                                child: Text(index.toString(), style: TextStyle(fontSize: 18.0),),
                              ),
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
