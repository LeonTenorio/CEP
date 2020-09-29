import 'package:flutter/material.dart';
import 'package:my_warehouse/functions/Ingredientes.dart';
import 'package:my_warehouse/screens/AdicaoNoEstoque.dart';
import 'package:my_warehouse/widgets/loadingWidget.dart';
import '../functions/Ingredientes.dart';
import '../main.dart';
import '../models/Ingredientes.dart';

class Estoque extends StatefulWidget {
  @override
  _EstoqueState createState() => _EstoqueState();
}

class _EstoqueState extends State<Estoque> {
  bool isLoading = true;

  Map<String, dynamic> estoque;

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
    this.estoque = await getIngredientesEstoque();
    setState(() {
      this.isLoading = false;
    });
  }

  String _textViewTipoIngrediente(double quantidade, bool ehPeso, bool ehVolume){
    if(ehPeso){
      if(quantidade>=1000){
        return (quantidade/1000).toStringAsFixed(1).replaceAll(".", ",")+" Kg";
      }
      else{
        return quantidade.toInt().toString()+" g";
      }
    }
    else if(ehVolume){
      if(quantidade>=1000){
        return (quantidade/1000).toStringAsFixed(1).replaceAll(".", ",")+" l";
      }
      else{
        return quantidade.toInt().toString()+" ml";
      }
    }
    else{
      return quantidade.toInt().toString();
    }
  }

  Widget buildIngredienteEstoque(String tipo, Map<String, dynamic> ingredientes){
    double quantidadeEstoque = 0.0;
    List<String> idsEstoque = ingredientes.keys.toList();
    bool ehPeso = false;
    bool ehVolume = false;
    for(int i=0;i<idsEstoque.length;i++){
      Ingrediente ingrediente = ingredientes[idsEstoque[i]];
      if(ingrediente.ehPeso){
        ehPeso = true;
        ehVolume = false;
        quantidadeEstoque = quantidadeEstoque + ingrediente.pesoIngrediente;
      }
      else if(ingrediente.ehVolume){
        ehPeso = false;
        ehVolume = true;
        quantidadeEstoque = quantidadeEstoque + ingrediente.volumeIngrediente;
      }
      else{
        ehPeso = false;
        ehVolume = false;
        quantidadeEstoque = quantidadeEstoque + ingrediente.quantidade;
      }
      print(ingrediente.toJson());
    }
    return Card(
        color: laranja,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(tipo, style: TextStyle(fontSize: 16.0),),
                  SizedBox(width: 10.0,),
                  Text("Quantidade: "+_textViewTipoIngrediente(quantidadeEstoque, ehPeso, ehVolume), style: TextStyle(fontSize: 16.0),),
                ],
              ),
              GestureDetector(
                child: Icon(Icons.add, color: Colors.white, size: 25.0,),
                onTap: () async{
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => AdicaoNoEstoque(name: tipo,)));
                  setState(() {

                  });
                },
              )
            ],
          ),
        )
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
                        Icon(Icons.storage, color: Colors.black, size: 25.0,),
                        Text("Seu estoque", style: TextStyle(fontSize: 18.0),),
                        IconButton(
                          icon: Icon(Icons.add),
                          iconSize: 18.0,
                          padding: EdgeInsets.all(0.5),
                          color: Colors.green,
                          onPressed: () async{
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => AdicaoNoEstoque(estoque: estoque)));
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
                        Text("Veja seu estoque", style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center,),
                        SizedBox(height: 10.0,),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: this.estoque.keys.toList().length,
                          itemBuilder: (BuildContext context, int index){
                            return buildIngredienteEstoque(this.estoque.keys.toList()[index],this.estoque[this.estoque.keys.toList()[index]]);
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
