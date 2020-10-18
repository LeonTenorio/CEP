import 'package:flutter/material.dart';

Widget loadingWidget({double height, double width}) {
  return Container(
    height: height,
    width: width,
    child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            SizedBox(height: 20.0,),
            Text(
              "Carregando",
              style: TextStyle(
                color: Colors.red,
                fontSize: 22.0,
                fontFamily: 'OpenSans',
              ),
            )
          ],
        )
    ),
  );
}

Widget loading({double height, double width}) {
  return Container(
    height: height,
    width: width,
    child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
    ),
  );
}