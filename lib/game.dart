import 'dart:math';

import 'package:app_test/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


const taille = 4;

class Game extends StatelessWidget {

  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2048',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            flexibleSpace: ClipPath(
              clipper: AppBarCustomClipper(),
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.purpleAccent,
                        Colors.pinkAccent
                      ])
                ),
                  child: Center(
                    child: Text('2048',style: TextStyle(fontWeight: FontWeight.bold , fontSize: 30,color: Colors.white)),
              )
              ),
            ),
          ),
          body: Center(
              child: Column(
                children: [
                  const Score(),
                  Grille(),
                ],
              )
          )
      )
    );
  }
}



class Grille extends StatefulWidget{

  const Grille({super.key});

  @override
  State<Grille> createState() => _GrilleState();

}

class _GrilleState extends State<Grille>{
  bool gameOver = false;
  
  List<Case> cases = List.empty();
  
  bool checkGameOver(){
      for(Case c in cases){
        if(c.getValue()!=0){
          var x = c.getIdx();
          var y = c.getIdy();
          if(y>0){
            y--;
            var temp = Case.getCaseByIdxIdy(cases, y,x);
            while(temp.getValue()==0 && y>0){
              y--;
              temp = Case.getCaseByIdxIdy(cases, y,x);
            }
            if(temp.getValue()==0){
              return false;
            }
            else if(temp.getValue()==c.getValue()){
              return false;
            }
            else if(Case.getCaseByIdxIdy(cases, y+1, x).getValue()==0){
              return false;
            }
          }

      }
    }

      for(var idx = taille-1;idx>=0;idx--){
        for(var idy = 0; idy<taille;idy++ ){
          var c = Case.getCaseByIdxIdy(cases, idy, idx);
          if(c.getValue()!=0){
            var x = idx;
            if(x<taille-1){
              x++;
              var temp = Case.getCaseByIdxIdy(cases, idy, x);
              while(temp.getValue()==0 && x< taille-1){
                x++;
                temp = Case.getCaseByIdxIdy(cases, idy, x);
              }
              if(temp.getValue()==0){
                return false;
              }
              else if(temp.getValue()==c.getValue()){
                return false;
              }
              else if(Case.getCaseByIdxIdy(cases, idy, x-1).getValue()==0){
                return false;
              }
            }

        }
      }
    }

      for(var idy = 0; idy<taille; idy++ ){
        for(var idx = 0; idx<taille; idx++){
          var c = Case.getCaseByIdxIdy(cases, idy, idx);
          if(c.getValue()!=0){
            var x = idx;
            if(x>0){
              x--;
              var temp = Case.getCaseByIdxIdy(cases, idy, x);
              while(temp.getValue()==0 && x>0){
                x--;
                temp = Case.getCaseByIdxIdy(cases, idy, x);
              }
              if(temp.getValue()==0){
                return false;
              }
              else if(temp.getValue()==c.getValue()){
                return false;
              }
              else if(Case.getCaseByIdxIdy(cases, idy, x+1).getValue()==0){
                return false;
              }
            }
          }

      }

    }
      for(var idy =taille-1; idy>=0; idy--){
        for(var idx = taille-1; idx>=0 ; idx--){
          if(Case.getCaseByIdxIdy(cases, idy, idx).getValue()!=0){
            var c = Case.getCaseByIdxIdy(cases, idy, idx);
            var y = idy;
            if(y<taille-1){
              var current = c;
              var next = Case.getCaseByIdxIdy(cases, y+1, idx);
              while(next.getValue()==0 && y+1<taille){
                y++;
                current = next;
                next = Case.getCaseByIdxIdy(cases, y+1, idx);
              }

              if(y+1>=taille){
                return false;
              }

              else if (next.getValue()==c.getValue()){ //fusion
                return false;
              }
              else if (next.getIdy()!=(c.getIdy()+1)){
               return false;
              }
            }
          }
        }

    }

      return true;
  }

  @override
  void initState(){
    loadSavedGrid();
  }

  void loadSavedGrid() async {
    // var prefs = await SharedPreferences.getInstance();
    //TODO: get from shared preferences need to map object et tout
    cases = Case.generateStarterCases();
  }
  void startOver(){
    gameOver = false;
    cases = Case.generateStarterCases();
    setState(() {
      var rng = Random();
      var case1 = rng.nextInt(16);
      var case2 = rng.nextInt(16);
      while(case2 == case1){case2 = rng.nextInt(16);}

      for(Case c in cases){
        if(c.getId()==case1 || c.getId() == case2){
          if(rng.nextInt(100)>50){c.setValue(2);}
          else{c.setValue(4);}
        }
        else{
          c.setValue(0);
        }
      }
      context.read<Scorer>().resetScore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      // onSwipe: (direction, offset) {
      //   _addSwipe(direction);
      // },
      onSwipeUp: (offset) {
        _addSwipe(SwipeDirection.up);
      },
      onSwipeDown: (offset) {
        _addSwipe(SwipeDirection.down);
      },
      onSwipeLeft: (offset) {
        _addSwipe(SwipeDirection.left);
      },
      onSwipeRight: (offset) {
        _addSwipe(SwipeDirection.right);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            height: 400,
            width: 400,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: taille,
              children:
              [for(Case c in cases) CaseWidget(case_: c)],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top:10),
            child: IconButton(
                icon: const Icon(Icons.autorenew),
                onPressed: (){startOver();})
          )
        ],
      )
    );
  }

  Future<void> _dialogueBuilder(BuildContext context){
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              title: Center(child: const Text("Game Over !")),
              content: Container(
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(20)
                        
                  ),
                  margin: const EdgeInsets.only(top:10),
                  child: IconButton(
                      icon: const Icon(Icons.autorenew),
                      color: Colors.white,
                      onPressed: (){
                        startOver();
                        Navigator.pop(context);
                      })
              )
          );
        });
  }

  // Fonctions as très optimisées pour gérer la logique des déplacements
  void _addSwipe(
      SwipeDirection direction,
      ) {
    setState(() {
      var mouve = false; // variable qui permet de savoir si on a bougé une case
      if(direction ==SwipeDirection.up){
        // on parcours la grille de droite a gauche et de haut en bas
        for(Case c in cases){
          // lorsqu'on rencontre une case non vide on conserve sa position
          if(c.getValue()!=0){
            var x = c.getIdx();
            var y = c.getIdy();
            if(y>0){ // si on est pas sur le bord nord de la grille
              // parce qu'on veut décaler toutes les cases non vides vers le haut
              y--;
              var temp = Case.getCaseByIdxIdy(cases, y,x);
              while(temp.getValue()==0 && y>0){
                y--;
                temp = Case.getCaseByIdxIdy(cases, y,x);
              }
              if(temp.getValue()==0){ // si il y a de la place pour décaler la case jusqu'au bord nord
                temp.setValue(c.getValue());
                c.setValue(0);
                mouve = true;
              }
               if(temp.getValue()==c.getValue()){ // si on peut fusionner
                temp.setValue(c.getValue()*2);
                c.setValue(0);
                context.read<Scorer>().updateScore(temp.getValue());
                mouve = true;
              }
              else if(Case.getCaseByIdxIdy(cases, y+1, x).getValue()==0){ //
                Case.getCaseByIdxIdy(cases, y+1, x).setValue(c.getValue());
                c.setValue(0);
                mouve = true;
              }
            }
          }
        }
      }
      else if(direction == SwipeDirection.right){
        for(var idx = taille-1;idx>=0;idx--){
          for(var idy = 0; idy<taille;idy++ ){
            var c = Case.getCaseByIdxIdy(cases, idy, idx);
            if(c.getValue()!=0){
              var x = idx;
              if(x<taille-1){
                x++;
                var temp = Case.getCaseByIdxIdy(cases, idy, x);
                while(temp.getValue()==0 && x< taille-1){
                  x++;
                  temp = Case.getCaseByIdxIdy(cases, idy, x);
                }
                if(temp.getValue()==0){
                  temp.setValue(c.getValue());
                  c.setValue(0);
                  mouve = true;
                }
                else if(temp.getValue()==c.getValue()){
                  temp.setValue(c.getValue()*2);
                  c.setValue(0);
                  context.read<Scorer>().updateScore(temp.getValue());
                  mouve = true;
                }
                else if(Case.getCaseByIdxIdy(cases, idy, x-1).getValue()==0){
                  Case.getCaseByIdxIdy(cases, idy, x-1).setValue(c.getValue());
                  c.setValue(0);
                  mouve = true;
                }
              }
            }
          }
        }
      }
      else if(direction == SwipeDirection.left){
        for(var idy = 0; idy<taille; idy++ ){
          for(var idx = 0; idx<taille; idx++){
            var c = Case.getCaseByIdxIdy(cases, idy, idx);
            if(c.getValue()!=0){
              var x = idx;
              if(x>0){
                x--;
                var temp = Case.getCaseByIdxIdy(cases, idy, x);
                while(temp.getValue()==0 && x>0){
                  x--;
                  temp = Case.getCaseByIdxIdy(cases, idy, x);
                }
                if(temp.getValue()==0){
                  temp.setValue(c.getValue());
                  c.setValue(0);
                  mouve = true;
                }
                else if(temp.getValue()==c.getValue()){
                  temp.setValue(c.getValue()*2);
                  c.setValue(0);
                  context.read<Scorer>().updateScore(temp.getValue());
                  mouve = true;
                }
                else if(Case.getCaseByIdxIdy(cases, idy, x+1).getValue()==0){
                  Case.getCaseByIdxIdy(cases, idy, x+1).setValue(c.getValue());
                  c.setValue(0);
                  mouve = true;
                }
              }
            }
          }
        }

      }
      else if(direction == SwipeDirection.down){
        for(var idy =taille-1; idy>=0; idy--){
          for(var idx = taille-1; idx>=0 ; idx--){
            if(Case.getCaseByIdxIdy(cases, idy, idx).getValue()!=0){
              var c = Case.getCaseByIdxIdy(cases, idy, idx);
              var y = idy;
              if(y<taille-1){
                var current = c;
                var next = Case.getCaseByIdxIdy(cases, y+1, idx);
                while(next.getValue()==0 && y+1<taille){
                  y++;
                  current = next;
                  next = Case.getCaseByIdxIdy(cases, y+1, idx);
                }

                if(y+1>=taille){
                  current.setValue(c.getValue());
                  c.setValue(0);
                  mouve = true;
                }

                else if (next.getValue()==c.getValue()){ //fusion
                  next.setValue(c.getValue()*2);
                  c.setValue(0);
                  context.read<Scorer>().updateScore(next.getValue());
                  mouve = true;
                }
                else if (next.getIdy()!=(c.getIdy()+1)){
                  current.setValue(c.getValue());
                  c.setValue(0);
                  mouve = true;
                }
              }
            }
          }
        }
      }
      if(mouve){addRandom();} // on ajoute une case aléatoire seulement si on a bougé une case
      if (checkGameOver()){
        _dialogueBuilder(context);
      }

    });
  }

  void addRandom(){
    var rng = Random();
    var numCase = rng.nextInt(taille*taille);
    while(Case.getCaseById(cases, numCase).getValue()!=0){
      numCase = rng.nextInt(taille*taille);
    }
    var proba = rng.nextInt(100);
    if(proba>30){
      Case.getCaseById(cases, numCase).setValue(2);
    }
    else{
      Case.getCaseById(cases, numCase).setValue(4);
    }
  }
}



class Scorer with ChangeNotifier, DiagnosticableTreeMixin{
  num _score = 0;
  int _highscore = 0;
  num get score => _score;
  int get highscore => _highscore;

  Scorer(){
    _score = 0;
    _loadHighScore();

  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    _highscore =  prefs.getInt('highscore') ?? 0;
    notifyListeners();
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('highscore', _highscore);
  }

  void resetScore(){
    _score = 0;
    notifyListeners();
  }

  void updateScore(num points){
    _score += points;

    if(_highscore < score){
      _highscore = _score as int;
      _saveHighScore();
    }
    notifyListeners();
  }

  /// Makes `Score` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('score', score as int?));
    properties.add(IntProperty('highscore',highscore as int?));
  }
}

class Score extends StatelessWidget {
  const Score({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.pinkAccent,
            ),
            child: Text(
              /// Calls `context.watch` to make [Count] rebuild when [Counter] changes.
              'High Score : ${context.watch<Scorer>().highscore}',
              key: const Key('counterState'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white
              )
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.pinkAccent,
            ),
            child: Text(
              /// Calls `context.watch` to make [Count] rebuild when [Counter] changes.
                'Score : ${context.watch<Scorer>().score}',
                // key: const Key('counterState'),
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                )
            ),
          )
        ],
      )
    );
  }
}




class CaseWidget extends StatefulWidget {
  final Case case_;

  const CaseWidget({super.key, required this.case_});

  @override
  State<CaseWidget> createState() => CaseWidgetState();

}

class CaseWidgetState extends State<CaseWidget>{

  @override
  Widget build(BuildContext context) {
    if(widget.case_.getValue() == 0){
      return Container(
          padding: const EdgeInsets.all(10),
          child:
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: Case.getColor(widget.case_.getValue()),
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
                color: Case.getColor(widget.case_.getValue()),
                border: Border.all(
                    color: Case.getColor(widget.case_.getValue())
                ),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Center(
                child: Text(widget.case_.getValue().toString(),
                  style: const TextStyle(fontSize: 34,color: Colors.white),)
            )
        ),
      );
    }

  }
}

class Case {
  num value = 0;
  final int id;
  final int idx;
  final int idy;

  Case({required this.idx, required this.idy, required this.id});

  int getIdx(){ return idx;}
  int getIdy(){ return idy;}
  int getId(){ return id;}

  void setValue(num value){this.value = value;}


  static Case getCaseByIdxIdy(List<Case> list, int idy, int idx){
    for(Case c in list){
      if(c.getIdy() == idy && c.getIdx() == idx) return c;
    }
    return Case(idx: -1, idy: -1, id: -1);
  }

  static Case getCaseById(List<Case> list, int id){
    for(Case c in list){
      if(c.getId() == id ) return c;
    }
    return Case(idx: -1, idy: -1, id: -1);
  }

  static Color getColor(num value){
    switch(value){
      case 0:
        return const Color.fromRGBO(220, 191, 217, 1.0);
      case 2:
        return const Color.fromRGBO(255, 162, 224, 1.0);
      case 4:
        return const Color.fromRGBO(246, 125, 227, 1.0);
      case 8:
        return const Color.fromRGBO(210, 93, 236, 1.0);
      case 16:
        return const Color.fromRGBO(209, 74, 214, 1.0);
      case 32:
        return const Color.fromRGBO(184, 74, 214, 1.0);
      case 64:
        return const Color.fromRGBO(207, 39, 192, 1.0);
      case 128:
        return const Color.fromRGBO(207, 39, 134, 1.0);
      case 256:
        return const Color.fromRGBO(179, 24, 95, 1.0);
      case 512:
        return const Color.fromRGBO(236, 200, 112, 1.0);
      case 1024:
        return const Color.fromRGBO(223, 78, 100, 1.0);
      case 2048:
        return const Color.fromRGBO(151, 11, 74, 1.0);
      default:
        return Colors.white;
    }
  }


  static List<Case> generateStarterCases(){
    var rng = Random();
    var case1 = rng.nextInt(taille*taille);
    var case2 = rng.nextInt(taille*taille);
    while(case2 == case1){case2 = rng.nextInt(taille*taille);}
    return List.generate(taille*taille, (index){
      if(index == case1 || index == case2){
        var c = Case(id:index,idx: index%taille, idy: (index/taille).floor());
        if(rng.nextInt(100)>30){c.setValue(2);} //30% de chance de sortir des 2
        else{c.setValue(4);}
        return c;
      }
      else{
        var c = Case(id: index, idx: index%taille, idy: (index/taille).floor());
        c.setValue(0);
        return c;
      }
    });
  }

  num getValue() => value;
}