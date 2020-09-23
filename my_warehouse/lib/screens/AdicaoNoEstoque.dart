import 'package:flutter/material.dart';

import '../functions/Ingredientes.dart';
import '../models/Ingredientes.dart';

class AdicaoNoEstoque extends StatefulWidget{
  Map<String, dynamic> estoque;
  AdicaoNoEstoque({this.estoque});
  @override
  _AdicaoNoEstoqueState createState() => _AdicaoNoEstoqueState();
}

class _AdicaoNoEstoqueState extends State<AdicaoNoEstoque> {

  DateTime dateTime;
  String kgL;
  final nomeController = TextEditingController();
  final marcaController = TextEditingController();
  final qtdController = TextEditingController();
  final precoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30.0, right: 5.0, left: 5.0),
        child:
          Column(
            children:[
              Expanded( 
                child: 
                  ListView(
                    children: [
                      Card(
                        child: Container(
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          child:Row(
                            children: [
                              Text("Ingrediente: "),
                              SizedBox(
                                width: 250.0,
                                height: 50.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0),
                                  child: new TextField(
                                    controller: nomeController,
                                )
                                )
                              )
                            ],
                          )
                        )
                      ),
                      Card(
                        child: Container(
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          child:Row(
                            children: [
                              Text("Marca: "),
                              SizedBox(
                                width: 280.0,
                                height: 50.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0),
                                  child: new TextField(
                                    controller: marcaController,
                                )
                                )
                              )
                            ],
                          )
                        )
                      ),
                      Card(
                        child: Container(
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          child:Row(
                            children: [
                              Text("Quantidade: "),
                              SizedBox(
                                width: 200.0,
                                height: 50.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0, right: 6.0),
                                  child: new TextField(
                                    controller: qtdController,
                                )
                                )
                              ),
                              DropdownButton(
                                items: <String>['kg', 'g', 'l', 'ml'].map((String value){
                                  return new DropdownMenuItem(
                                    value:value,
                                    child: new Text(value)
                                  );
                                }).toList(), 
                                onChanged: (String data){
                                  setState(() {
                                    kgL = data;
                                    print(kgL);
                                  });
                                },
                                value: kgL
                              )
                            ],
                          )
                        )
                      ),
                      Card(
                        child: Container(
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          child:Row(
                            children: [
                              Text("Preço: "),
                              SizedBox(
                                width: 280.0,
                                height: 50.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0),
                                  child: new TextField(
                                    controller: precoController,
                                  )
                                )
                              )
                            ],
                          )
                        )
                      ),
                      Card(
                        child: Container(
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          child:Row(
                            children: [
                              Text("Validade: "),
                              SizedBox(
                                width: 260.0,
                                height: 50.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0),
                                  child: RaisedButton(
                                    child: Text(dateTime == null ? "Escolha uma data" : "${dateTime.day}-${dateTime.month}-${dateTime.year}"),
                                    onPressed: (){
                                      showDatePicker(
                                        context: context, 
                                        initialDate: DateTime.now(), 
                                        firstDate: DateTime.now(), 
                                        lastDate: DateTime(2222)
                                        ).then((date){
                                          setState(() {
                                            dateTime = date;
                                          });
                                        });
                                    },
                                  )
                                )
                              )
                            ],
                          )
                        )
                      ),
                    ],)
              ),
              Container(
                margin: EdgeInsets.only(bottom:10.0),
                child: RaisedButton(
                  child: Text("Adicionar ingrediente"),
                  onPressed: () async{
                    Ingrediente ingrediente;
                    double preco = double.parse(precoController.text.replaceAll(",", "."));
                    if(kgL == 'kg'){
                      ingrediente = new Ingrediente(nome: nomeController.text, ehPeso: true, ehVolume: false, pesoIngrediente: double.parse(qtdController.text)*1000, preco: preco,horarioAdicionado: DateTime.now().toString(), validade: dateTime.toString(), marca: marcaController.text);
                    }
                    if(kgL == "g"){
                      ingrediente = new Ingrediente(nome: nomeController.text, ehPeso: true, ehVolume: false, pesoIngrediente: double.parse(qtdController.text), preco: preco,horarioAdicionado: DateTime.now().toString(), validade: dateTime.toString(), marca: marcaController.text);
                    }
                    else if(kgL == 'l'){
                      ingrediente = new Ingrediente(nome: nomeController.text, ehPeso: false, ehVolume: true, volumeIngrediente: 1000*double.parse(qtdController.text), preco: preco,horarioAdicionado: DateTime.now().toString(), validade: dateTime.toString(), marca: marcaController.text);
                    }
                    else{
                      ingrediente = new Ingrediente(nome: nomeController.text, ehPeso: false, ehVolume: true, volumeIngrediente: double.parse(qtdController.text), preco: preco,horarioAdicionado: DateTime.now().toString(), validade: dateTime.toString(), marca: marcaController.text);
                    }
                    print(ingrediente.toJson());
                    //Trecho para parecer que as coisas foram instantaneas
                    if(!this.widget.estoque.containsKey(ingrediente.nome)){
                      this.widget.estoque[ingrediente.nome] = new Map<String, dynamic>();
                    }
                    this.widget.estoque[ingrediente.nome][ingrediente.id] = ingrediente;
                    //Trecho assincrono
                    addIngredienteEstoque(ingrediente);
                    Navigator.pop(context);
                  },
                ),
              ),
            ]
          ),
      )
    );
  }
}
