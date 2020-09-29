import 'package:flutter/material.dart';

import '../functions/Ingredientes.dart';
import '../models/Ingredientes.dart';

class AdicaoNoEstoque extends StatefulWidget{
  Map<String, dynamic> estoque;
  String name;
  AdicaoNoEstoque({this.estoque, this.name});
  @override
  _AdicaoNoEstoqueState createState() => _AdicaoNoEstoqueState();
}

class _AdicaoNoEstoqueState extends State<AdicaoNoEstoque> {

  DateTime dateTime;
  String kgL = " ";
  TextEditingController nomeController;
  TextEditingController marcaController;
  TextEditingController qtdController;
  TextEditingController precoController;

  @override
  void initState() {
    nomeController = TextEditingController();
    marcaController = TextEditingController();
    qtdController = TextEditingController();
    precoController = TextEditingController();
    if(this.widget.name!=null){
      nomeController = TextEditingController(text: this.widget.name);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Ingrediente: ", style: TextStyle(fontSize: 16.0),),
                              SizedBox(
                                width: 235.0,
                                height: 50.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0),
                                  child: new TextField(
                                    controller: nomeController,
                                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Marca: ", style: TextStyle(fontSize: 16.0),),
                              SizedBox(
                                width: 270.0,
                                height: 50.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0),
                                  child: new TextField(
                                    controller: marcaController,
                                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Quantidade: ", style: TextStyle(fontSize: 16.0),),
                              SizedBox(
                                width: 200.0,
                                height: 50.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0, right: 6.0),
                                  child: new TextField(
                                    controller: qtdController,
                                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
                                )
                                )
                              ),
                              DropdownButton(
                                items: <String>[" ", 'kg', 'g', 'l', 'ml'].map((String value){
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Preço: ", style: TextStyle(fontSize: 16.0),),
                              SizedBox(
                                width: 270.0,
                                height: 50.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0),
                                  child: new TextField(
                                    controller: precoController,
                                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Validade: ", style: TextStyle(fontSize: 16.0),),
                              SizedBox(
                                width: 260.0,
                                height: 50.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0, bottom: 12.0, left: 3.0),
                                  child: RaisedButton(
                                    child: Text(dateTime == null ? "Escolha uma data" : "${dateTime.day}/${dateTime.month}/${dateTime.year}"),
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
                    bool ehPeso;
                    bool ehVolume;
                    double volume;
                    double peso;
                    int quantidade;
                    if(kgL == 'kg'){
                      ehPeso = true;
                      ehVolume = false;
                      peso = 1000*double.parse(qtdController.text.replaceAll(',', '.'));
                    }
                    if(kgL == "g"){
                      ehPeso = true;
                      ehVolume = false;
                      peso = double.parse(qtdController.text.replaceAll(',', '.'));
                    }
                    else if(kgL == 'l'){
                      ehPeso = false;
                      ehVolume = true;
                      volume = 1000*double.parse(qtdController.text.replaceAll(',', '.'));
                    }
                    else if(kgL == "ml"){
                      ehPeso = false;
                      ehVolume = true;
                      volume = double.parse(qtdController.text.replaceAll(',', '.'));
                    }
                    else{
                      ehPeso = false;
                      ehVolume = false;
                      quantidade = int.parse(qtdController.text);
                    }
                    print("ehPeso");
                    print(ehPeso);
                    print("ehVolume");
                    print(ehVolume);
                    ingrediente = new Ingrediente(
                      nome: this.nomeController.text,
                      ehVolume: ehVolume,
                      ehPeso: ehPeso,
                      pesoIngrediente: peso,
                      volumeIngrediente: volume,
                      quantidade: quantidade,
                      horarioAdicionado: DateTime.now().toString(),
                      validade: this.dateTime.toString(),
                      marca: this.marcaController.text,
                      preco: preco
                    );
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
