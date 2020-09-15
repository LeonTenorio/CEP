import 'package:flutter/material.dart';
import 'package:my_warehouse/functions/Color.dart';

final Color laranja = HexColor.fromHex("#CA5C2F");

class CozinharScreen extends StatelessWidget {
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
                    Icon(Icons.kitchen, color: Colors.black, size: 25.0,),
                    Text("Suas receitas", style: TextStyle(fontSize: 18.0),),
                    IconButton(
                      icon: Icon(Icons.add),
                      iconSize: 18.0,
                      padding: EdgeInsets.all(0.5),
                      color: Colors.green,
                      onPressed: (){

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
