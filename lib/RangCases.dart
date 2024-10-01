import 'package:flutter/material.dart';

Color caseColor = const Color.fromRGBO(255, 162, 224, 1.0);
Color emptyColor = const Color.fromRGBO(220, 191, 217, 1.0);

class Case extends StatelessWidget {
  final num value;
  final int idx;
  final int idy;

  const Case({super.key, required this.value, required this.idx, required this.idy});

  int getIdx(){ return idx;}
  int getIdy(){ return idy;}

  num getValue() => value;

  @override
  Widget build(BuildContext context) {
    if(value == 0){
      return Container(
        padding: EdgeInsets.all(10),
        child:
        Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: emptyColor,
              borderRadius: BorderRadius.circular(10)
          ),
        )
      );
    }
    else {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Container(
            decoration: BoxDecoration(
              color: caseColor,
              border: Border.all(
                color: caseColor
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Center(
                child: Text(value.toString(),
                  style: const TextStyle(fontSize: 34,color: Colors.white),)
            )
        ),
      );
    }

  }

}