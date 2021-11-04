import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicTacToe' ,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'TicTacToe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Utils{
  static List<Widget> modelBuilder<M>(List<M> models, Widget Function(int index, M model) builder) => models
  .asMap()
  .map<int, Widget>((index,model) => MapEntry(index, builder(index,model)))
  .values
  .toList();
}

class Player{
  static const X = 'X';
  static const O = 'O';
  static const none = '';
  
}
class _MyHomePageState extends State<MyHomePage> {
  static const countMatrix = 3;
  static const double size = 95;
  String lastMove = Player.none;
  late List<List<String>> matrix;
  int xScore = 0;
  int oScore = 0;
  
  @override
  void initState(){ 
    super.initState();
  
    setEmptyFields();
  }
  Color getBackgroundColor(){
    final thisMove = lastMove == Player.X ? Player.O : Player.X;
    return getFieldColor(thisMove).withAlpha(125);
  }
  void setEmptyFields() => setState(() => matrix = List.generate(countMatrix, (_) => List.generate(countMatrix, (_) => Player.none),));
  
  

  @override
  Widget build(BuildContext context) =>Scaffold( backgroundColor: getBackgroundColor(), appBar: AppBar(title: Text(widget.title)),
  body: Column(mainAxisAlignment: MainAxisAlignment.center, 
  children: Utils.modelBuilder(matrix, (x, value) => buildRow(x)),),);
    
  Widget buildRow(int x){
    final values = matrix[x];

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: Utils.modelBuilder(values,(y, value) => buildField(x,y),),);


  }

 //Widget scoreBoard(BuildContext context) => Scaffold(backgroundColor:getBackgroundColor(),  
  //body: Column(mainAxisAlignment:MainAxisAlignment.center, children: <Widget>[new Text('Scoreboard',), new Text('X: $xScore, O: $oScore',)]));

  Color getFieldColor(String value){
    switch(value){
      case Player.O:
        return Colors.green.withAlpha(200);
      case Player.X:
        return Colors.purple;
      default:
        return Colors.white;
    }
  }
  Widget buildField(int x, int y){
    final value = matrix [x][y];
    final color = getFieldColor(value);
    return Container(margin: EdgeInsets.all(6), child: ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: Size(size, size), primary: color,),child: Text(value, style: TextStyle(color: Colors.white, fontSize: 32)),onPressed: ()=>selectField(value,x,y),),);
    
  }

  void selectField(String value, int x, int y){
    if (value == Player.none){
      final newValue = lastMove == Player.X ? Player.O : Player.X;

      setState((){
        lastMove = newValue;
        matrix[x][y] = newValue;
      });
      if(isWinner(x,y)){
        if(newValue == 'X'){
          ++xScore;
        }
        else{
          ++oScore;
        }
        showEndDialog('Player $newValue has won! \n\nScore is X: $xScore, O: $oScore');
      }
      else if(isEnd()){
        showEndDialog('Tie!\n\nScore is X: $xScore, O: $oScore');
      }
    }
  }
  bool isEnd() => matrix.every((values) => values.every((value) => value != Player.none ));

  bool isWinner(int x, int y){
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = matrix[x][y];
    final n = countMatrix;
    for(int i = 0; i < n; i++){
      if(matrix[x][i] == player) col++;
      if(matrix[i][y] == player) row++;
      if(matrix[i][i] == player) diag++;
      if(matrix[i][n-i-1] == player) rdiag++;
    }
    return row == n || col == n || diag == n || rdiag == n;
  }


  Future showEndDialog(String title) => showDialog(context: context, barrierDismissible: false, builder: (context) => AlertDialog(title: Text(title), content: Text('Touch for the next round'), actions: [
    ElevatedButton(onPressed: () { setEmptyFields(); Navigator.of(context).pop(); }, child: Text('next round'),)],),);
  
      
      
  
}
