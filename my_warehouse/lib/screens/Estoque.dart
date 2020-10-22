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
              Row(
                children: [
                  GestureDetector(
                    child: Icon(Icons.add, color: Colors.white, size: 25.0,),
                    onTap: () async{
                      if(this.estoque==null){
                        this.estoque = new Map<String, dynamic>();
                      }
                      await Navigator.push(context, MaterialPageRoute(builder: (context) => AdicaoNoEstoque(name: tipo, estoque: estoque,)));
                      setState(() {

                      });
                    },
                  ),
                  SizedBox(width: 10.0,),
                  GestureDetector(
                    child: Icon(Icons.remove, color: Colors.white, size: 25.0,),
                    onTap: () async{
                      await showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return RemocaoEstoque(tipo: tipo, ehPeso: ehPeso, ehVolume: ehVolume,);
                        }
                      );
                      this.isLoading = true;
                      load();
                    },
                  )
                ],
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
                            if(this.estoque==null){
                              this.estoque = new Map<String, dynamic>();
                            }
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

class RemocaoEstoque extends StatefulWidget {
  String tipo;
  bool ehPeso, ehVolume;
  RemocaoEstoque({this.tipo, this.ehPeso, this.ehVolume});

  @override
  _RemocaoEstoqueState createState() => _RemocaoEstoqueState();
}

class _RemocaoEstoqueState extends State<RemocaoEstoque> {
  TextEditingController qtdController;
  String kgL = " ";
  bool isLoading = false;

  @override
  void initState() {
    this.qtdController = new TextEditingController();
    this.isLoading = false;
    if(this.widget.ehVolume){
      kgL = "l";
    }
    else if(this.widget.ehPeso){
      kgL = "kg";
    }
    else{
      kgL = " ";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Retirada do estoque ", style: TextStyle(fontSize: 18.0),),
      content: Container(
        width: MediaQuery.of(context).size.width*0.7,
        height: 150.0,
        child: this.isLoading?Center(
          child: loadingWidget(height: MediaQuery.of(context).size.height*0.5),
        )
        :Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Retirada do ingrediente: "+this.widget.tipo, style: TextStyle(fontSize: 16.0),),
            SizedBox(height: 5.0,),
            Text("Insira a quantidade", style: TextStyle(fontSize: 16.0),),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.7-100,
                  child: Material(
                    child: TextFormField(
                      controller: qtdController,
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 18.0),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                        hintText: "quantidade",
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
                      });
                    },
                    value: kgL
                )
              ],
            ),
          ],
        )
      ),
      actions: [
        FlatButton(
          child: Text("Cancelar"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("Retirar"),
          onPressed: () async{
            try{
              setState(() {
                this.isLoading = true;
              });
              double quantidade;
              if(kgL == 'kg' || kgL == 'l'){
                quantidade = 1000*double.tryParse(qtdController.text.replaceAll(',', '.'));
              }
              else{
                quantidade = double.tryParse(qtdController.text.replaceAll(',', '.'));
              }
              await removerIngredienteEstoqueQuantidade(tipo: this.widget.tipo, quantidade: quantidade);
              setState(() {
                this.isLoading = false;
              });
              Navigator.pop(context);
            }
            catch(e){
              setState(() {
                this.isLoading = false;
              });
            }
          },
        )
      ],
    );
  }
}
