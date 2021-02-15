import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<List<String>> gridMP = [
  ['','',''],
  ['','',''],
  ['','','']
];
List<List<bool>> elementWinMP = [
  [false, false, false],
  [false, false, false],
  [false, false, false]
];
int countOMP, countXMP;
String turnMP, startElementMP, nameMP1, nameMP2, tempPlayerNameMP;
bool isValidMP;

void initNewGameMP () {
  turnMP=startElementMP;
  gridMP = [
    ['','',''],
    ['','',''],
    ['','','']
  ];
  elementWinMP = [
    [false, false, false],
    [false, false, false],
    [false, false, false]
  ];
}

class GameMP extends StatefulWidget {
  @override
  _GameMPState createState() => _GameMPState();
}
class _GameMPState extends State<GameMP> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape
            ? GameMPL()
            : GameMPP();
      },
    );
  }
}

// Portrait Mode
class GameMPP extends StatefulWidget {
  @override
  _GameMPPState createState() => _GameMPPState();
}
class _GameMPPState extends State<GameMPP> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    tempPlayerNameMP = '';
    isValidMP=true;
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onLongPress: () async{
                      setState(() {
                        showGeneralDialog(
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionBuilder: (context, a1, a2, widget) {
                              return Transform.scale(
                                  scale: a1.value,
                                  child: Opacity(
                                      opacity: a1.value,
                                      child: PlayerNameBox1()
                                  )
                              );
                            },
                            transitionDuration: Duration(milliseconds: 200),
                            barrierDismissible: true,
                            barrierLabel: '',
                            context: context,
                            pageBuilder: (context, animation1, animation2) {});
                      });
                    },
                    child: Text(
                        'O\n$nameMP1 : $countOMP',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 22.0, fontWeight: FontWeight.w400,
                            color: returnColorOMP())
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () async{
                      setState(() {
                        showGeneralDialog(
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionBuilder: (context, a1, a2, widget) {
                              return Transform.scale(
                                  scale: a1.value,
                                  child: Opacity(
                                      opacity: a1.value,
                                      child: PlayerNameBox2()
                                  )
                              );
                            },
                            transitionDuration: Duration(milliseconds: 200),
                            barrierDismissible: true,
                            barrierLabel: '',
                            context: context,
                            pageBuilder: (context, animation1, animation2) {});
                      });
                    },
                    child: Text(
                        'X\n$nameMP2 : $countXMP',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 22.0, fontWeight: FontWeight.w400,
                            color: returnColorXMP())
                    ),
                  )
                ],
              ),
              Container(
                  child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                          padding: EdgeInsets.all(32.0),
                          margin: EdgeInsets.all(0.0),
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                int gridStateLength = gridMP.length;
                                int x, y = 0;
                                x = (index / gridStateLength).floor();
                                y = (index % gridStateLength);
                                String thisElement = gridMP[x][y];
                                Color thisElementColor;
                                if (true==elementWinMP[x][y]) {thisElementColor=Colors.green;}
                                return GestureDetector(
                                    onTap: () async{
                                      setState(() {
                                        if (gridMP[x][y]=='' && checkWinOMP()==false && checkWinXMP()==false) {
                                          gridMP[x][y]=turnMP;
                                          if (checkWinXMP()==true) { countXMP++; }
                                          else if (checkWinOMP()==true) { countOMP++; }
                                          if (checkWinXMP()==true || checkWinOMP()==true || checkFullMP()==true) {
                                            Future.delayed(const Duration(milliseconds: 1000), () {
                                              setState(() {
                                                startElementMP=turnMP=(startElementMP=='O')?'X':'O';
                                                initNewGameMP(); saveMPgame();
                                              });
                                            });
                                          }
                                          turnMP=(turnMP=='O')?'X':'O';
                                        }
                                      }); saveMPgame();
                                    },
                                    child: GridTile(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: (darkModeEnabled==true)?Colors.white:Colors.black
                                                )
                                            ),
                                            child: Center(
                                                child: Text(thisElement, style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.normal, fontSize: 54.0, color: thisElementColor))
                                            )
                                        )
                                    )
                                );
                              },
                              itemCount: 3*3
                          )
                      )
                  )
              )
            ]
        )
    );
  }
  Widget PlayerNameBox1 () {
    return OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.landscape
              ? AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(child: InputNameMP1(), width: 240.0),
                GestureDetector(
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Set Name',
                          textAlign: TextAlign.center,
                        )
                    ),
                  ),
                  onTap: () async{setState(() {
                    if (isValidMP && tempPlayerNameMP!='' && tempPlayerNameMP!=null) {
                      nameMP1=tempPlayerNameMP;
                      Navigator.of(context).pop();
                    }
                  }); saveMP1name(); },
                )
              ],
            ),
            //content: ,
          )
              : AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Center(child: Text('Player Name', style: TextStyle(fontFamily: 'Monserrat', fontSize: 20.0, fontWeight: FontWeight.w300))),
            content: SizedBox(
                height: 160.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InputNameMP1(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Set Name',
                                  textAlign: TextAlign.center,
                                )
                            ),
                          ),
                          onTap: () async{setState(() {
                            if (isValidMP && tempPlayerNameMP!='' && tempPlayerNameMP!=null) {
                              nameMP1=tempPlayerNameMP;
                              Navigator.of(context).pop();
                            }
                          }); saveMP1name(); },
                        )
                      ],
                    )
                  ],
                )
            ),
            //content: ,
          );
        }
    );
  }
  Widget PlayerNameBox2 () {
    return OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.landscape
              ? AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(child: InputNameMP2(), width: 240.0),
                GestureDetector(
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Set Name',
                          textAlign: TextAlign.center,
                        )
                    ),
                  ),
                  onTap: () async{setState(() {
                    if (isValidMP && tempPlayerNameMP!='' && tempPlayerNameMP!=null) {
                      nameMP2=tempPlayerNameMP;
                      Navigator.of(context).pop();
                    }
                  }); saveMP2name(); },
                )
              ],
            ),
            //content: ,
          )
              : AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Center(child: Text('Player Name', style: TextStyle(fontFamily: 'Monserrat', fontSize: 20.0, fontWeight: FontWeight.w300))),
            content: SizedBox(
                height: 160.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InputNameMP2(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Set Name',
                                  textAlign: TextAlign.center,
                                )
                            ),
                          ),
                          onTap: () async{setState(() {
                            if (isValidMP && tempPlayerNameMP!='' && tempPlayerNameMP!=null) {
                              nameMP2=tempPlayerNameMP;
                              Navigator.of(context).pop();
                            }
                          }); saveMP2name(); },
                        )
                      ],
                    )
                  ],
                )
            ),
            //content: ,
          );
        }
    );
  }
  Color returnColorOMP () {
    if (checkWinOMP()==true) {return Colors.green;}
    else if (turnMP=='O'&&checkWinXMP()==false) {return Colors.blue;}
  }
  Color returnColorXMP () {
    if (checkWinXMP()==true) {return Colors.green;}
    else if (turnMP=='X'&&checkWinOMP()==false) {return Colors.blue;}
  }
  Future saveMPgame () async{
    int countO;
    int countX;
    String turn;
    String startElement;
    String playerName1;
    String playerName2;
    List<String> gridMP1;
    List<String> gridMP2;
    List<String> gridMP3;
    setState(() {
      countO = countOMP;
      countX = countXMP;
      turn = turnMP;
      startElement = startElementMP;
      playerName1 = nameMP1;
      playerName2 = nameMP2;
      gridMP1 = gridMP[0];
      gridMP2 = gridMP[1];
      gridMP3 = gridMP[2];
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setStringList('firstLineMP', gridMP1);
    await pref.setStringList('secondLineMP', gridMP2);
    await pref.setStringList('thirdLineMP', gridMP3);
    await pref.setString('turnMP', turn);
    await pref.setString('startElementMP', startElement);
    await pref.setString('nameMP1', playerName1);
    await pref.setString('nameMP2', playerName2);
    await pref.setInt('countOMP', countO);
    await pref.setInt('countXPC', countX);
  }
  Future saveMP1name () async{
    String playerName;
    setState(() {
      playerName = nameMP1;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('nameMP1', playerName);
  }
  Future saveMP2name () async{
    String playerName;
    setState(() {
      playerName = nameMP2;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('nameMP2', playerName);
  }
}

// Landscape Mode
class GameMPL extends StatefulWidget {
  @override
  _GameMPLState createState() => _GameMPLState();
}
class _GameMPLState extends State<GameMPL> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    tempPlayerNameMP = '';
    isValidMP=true;
    return Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onLongPress: () async{
                      setState(() {
                        showGeneralDialog(
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionBuilder: (context, a1, a2, widget) {
                              return Transform.scale(
                                  scale: a1.value,
                                  child: Opacity(
                                      opacity: a1.value,
                                      child: PlayerNameBox1()
                                  )
                              );
                            },
                            transitionDuration: Duration(milliseconds: 200),
                            barrierDismissible: true,
                            barrierLabel: '',
                            context: context,
                            pageBuilder: (context, animation1, animation2) {});
                      });
                    },
                    child: Text(
                        'O\n$nameMP1 : $countOMP',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 22.0, fontWeight: FontWeight.w400,
                            color: returnColorOMP())
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () async{
                      setState(() {
                        showGeneralDialog(
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionBuilder: (context, a1, a2, widget) {
                              return Transform.scale(
                                  scale: a1.value,
                                  child: Opacity(
                                      opacity: a1.value,
                                      child: PlayerNameBox2()
                                  )
                              );
                            },
                            transitionDuration: Duration(milliseconds: 200),
                            barrierDismissible: true,
                            barrierLabel: '',
                            context: context,
                            pageBuilder: (context, animation1, animation2) {});
                      });
                    },
                    child: Text(
                        'X\n$nameMP2 : $countXMP',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 22.0, fontWeight: FontWeight.w400,
                            color: returnColorXMP())
                    ),
                  )
                ],
              ),
              Container(
                  child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                          padding: EdgeInsets.all(32.0),
                          margin: EdgeInsets.all(0.0),
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                int gridStateLength = gridMP.length;
                                int x, y = 0;
                                x = (index / gridStateLength).floor();
                                y = (index % gridStateLength);
                                String thisElement = gridMP[x][y];
                                Color thisElementColor;
                                if (true==elementWinMP[x][y]) {thisElementColor=Colors.green;}
                                return GestureDetector(
                                    onTap: () async{
                                      setState(() {
                                        if (gridMP[x][y]=='' && checkWinOMP()==false && checkWinXMP()==false) {
                                          gridMP[x][y]=turnMP;
                                          if (checkWinXMP()==true) { countXMP++; }
                                          else if (checkWinOMP()==true) { countOMP++; }
                                          if (checkWinXMP()==true || checkWinOMP()==true || checkFullMP()==true) {
                                            Future.delayed(const Duration(milliseconds: 1000), () {
                                              setState(() {
                                                startElementMP=turnMP=(startElementMP=='O')?'X':'O';
                                                initNewGameMP(); saveMPgame();
                                              });
                                            });
                                          }
                                          turnMP=(turnMP=='O')?'X':'O';
                                        }
                                      }); saveMPgame();
                                    },
                                    child: GridTile(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: (darkModeEnabled==true)?Colors.white:Colors.black
                                                )
                                            ),
                                            child: Center(
                                                child: Text(thisElement, style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.normal, fontSize: 54.0, color: thisElementColor))
                                            )
                                        )
                                    )
                                );
                              },
                              itemCount: 3*3
                          )
                      )
                  )
              )
            ]
        )
    );
  }
  Widget PlayerNameBox1 () {
    return OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.landscape
              ? AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(child: InputNameMP1(), width: 240.0),
                GestureDetector(
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Set Name',
                          textAlign: TextAlign.center,
                        )
                    ),
                  ),
                  onTap: () async{setState(() {
                    if (isValidMP && tempPlayerNameMP!='' && tempPlayerNameMP!=null) {
                      nameMP1=tempPlayerNameMP;
                      Navigator.of(context).pop();
                    }
                  }); saveMP1name(); },
                )
              ],
            ),
            //content: ,
          )
          : AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Center(child: Text('Player Name', style: TextStyle(fontFamily: 'Monserrat', fontSize: 20.0, fontWeight: FontWeight.w300))),
            content: SizedBox(
                height: 160.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InputNameMP1(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Set Name',
                                  textAlign: TextAlign.center,
                                )
                            ),
                          ),
                          onTap: () async{setState(() {
                            if (isValidMP && tempPlayerNameMP!='' && tempPlayerNameMP!=null) {
                              nameMP1=tempPlayerNameMP;
                              Navigator.of(context).pop();
                            }
                          }); saveMP1name(); },
                        )
                      ],
                    )
                  ],
                )
            ),
            //content: ,
          );
        }
    );
  }
  Widget PlayerNameBox2 () {
    return OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.landscape
              ? AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(child: InputNameMP2(), width: 240.0),
                GestureDetector(
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Set Name',
                          textAlign: TextAlign.center,
                        )
                    ),
                  ),
                  onTap: () async{setState(() {
                    if (isValidMP && tempPlayerNameMP!='' && tempPlayerNameMP!=null) {
                      nameMP2=tempPlayerNameMP;
                      Navigator.of(context).pop();
                    }
                  }); saveMP2name(); },
                )
              ],
            ),
            //content: ,
          )
              : AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)),
            title: Center(child: Text('Player Name', style: TextStyle(fontFamily: 'Monserrat', fontSize: 20.0, fontWeight: FontWeight.w300))),
            content: SizedBox(
                height: 160.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InputNameMP2(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Set Name',
                                  textAlign: TextAlign.center,
                                )
                            ),
                          ),
                          onTap: () async{setState(() {
                            if (isValidMP && tempPlayerNameMP!='' && tempPlayerNameMP!=null) {
                              nameMP2=tempPlayerNameMP;
                              Navigator.of(context).pop();
                            }
                          }); saveMP2name(); },
                        )
                      ],
                    )
                  ],
                )
            ),
            //content: ,
          );
        }
    );
  }
  Color returnColorOMP () {
    if (checkWinOMP()==true) {return Colors.green;}
    else if (turnMP=='O'&&checkWinXMP()==false) {return Colors.blue;}
  }
  Color returnColorXMP () {
    if (checkWinXMP()==true) {return Colors.green;}
    else if (turnMP=='X'&&checkWinOMP()==false) {return Colors.blue;}
  }
  Future saveMPgame () async{
    int countO;
    int countX;
    String turn;
    String startElement;
    String playerName1;
    String playerName2;
    List<String> gridMP1;
    List<String> gridMP2;
    List<String> gridMP3;
    setState(() {
      countO = countOMP;
      countX = countXMP;
      turn = turnMP;
      startElement = startElementMP;
      playerName1 = nameMP1;
      playerName2 = nameMP2;
      gridMP1 = gridMP[0];
      gridMP2 = gridMP[1];
      gridMP3 = gridMP[2];
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setStringList('firstLineMP', gridMP1);
    await pref.setStringList('secondLineMP', gridMP2);
    await pref.setStringList('thirdLineMP', gridMP3);
    await pref.setString('turnMP', turn);
    await pref.setString('startElementMP', startElement);
    await pref.setString('nameMP1', playerName1);
    await pref.setString('nameMP2', playerName2);
    await pref.setInt('countOMP', countO);
    await pref.setInt('countXPC', countX);
  }
  Future saveMP1name () async{
    String playerName;
    setState(() {
      playerName = nameMP1;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('nameMP1', playerName);
  }
  Future saveMP2name () async{
    String playerName;
    setState(() {
      playerName = nameMP2;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('nameMP2', playerName);
  }
}

class InputNameMP1 extends StatefulWidget {
  @override
  _InputNameMP1State createState() => _InputNameMP1State();
}
class _InputNameMP1State extends State<InputNameMP1> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        maxLines: 1,
        maxLength: 10,
        maxLengthEnforced: true,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.done,
        onSubmitted: (textMP) async{
          setState(() {
            isValidMP=textCheck(textMP);
            if (isValidMP && tempPlayerNameMP!='' && tempPlayerNameMP!=null) {
              nameMP1=textMP;
              Navigator.of(context).pop();
            }
          });
          saveMP1name();
        },
        onChanged: (textMP) {
          setState(() {
            isValidMP=textCheck(textMP);
            if (isValidMP) {
              tempPlayerNameMP=textMP;
            }
          });
        },
        decoration: InputDecoration(
            hintText: nameMP1,
            errorText: (isValidMP==false)?'Invalid Name':null,
            helperText: 'Enter your name',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.blue,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.blue,
                style: BorderStyle.solid,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.red,
                style: BorderStyle.solid,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.red,
                style: BorderStyle.solid,
              ),
            )
        )
    );
  }
  Future saveMP1name () async{
    String playerName;
    setState(() {
      playerName = nameMP1;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('nameMP1', playerName);
  }
}
class InputNameMP2 extends StatefulWidget {
  @override
  _InputNameMP2State createState() => _InputNameMP2State();
}
class _InputNameMP2State extends State<InputNameMP2> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        maxLines: 1,
        maxLength: 10,
        maxLengthEnforced: true,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.done,
        onSubmitted: (textMP) async{
          setState(() {
            isValidMP=textCheck(textMP);
            if (isValidMP && tempPlayerNameMP!='' && tempPlayerNameMP!=null) {
              nameMP2=textMP;
              Navigator.of(context).pop();
            }
          });
          saveMP2name();
        },
        onChanged: (textMP) {
          setState(() {
            isValidMP=textCheck(textMP);
            if (isValidMP) {
              tempPlayerNameMP=textMP;
            }
          });
        },
        decoration: InputDecoration(
            hintText: nameMP2,
            errorText: (isValidMP==false)?'Invalid Name':null,
            helperText: 'Enter your name',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.blue,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.blue,
                style: BorderStyle.solid,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.red,
                style: BorderStyle.solid,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.red,
                style: BorderStyle.solid,
              ),
            )
        )
    );
  }
  Future saveMP2name () async{
    String playerName;
    setState(() {
      playerName = nameMP2;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('nameMP2', playerName);
  }
}
bool textCheck (String inputText) {
  return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(inputText);
}
bool checkFullMP () {
  for (int i = 0 ; i < 3 ; i++) {
    for (int j = 0 ; j < 3 ; j++) {
      if (gridMP[i][j]=='') { return false; }
    }
  }
  return true;
}
int counterMP (String element) {
  int t=0;
  for (int i=0; i<3; i++) {
    for (int j=0; j<3; j++) {
      if (element==gridMP[i][j]) { t++; }
    }
  }
  return t;
}
bool checkWinOMP () {
  if (gridMP[0][0]=='O' && gridMP[0][1]=='O' && gridMP[0][2]=='O') {
    elementWinMP[0][0]=true; elementWinMP[0][1]=true; elementWinMP[0][2]=true;
    return true; // Row1
  }
  else if (gridMP[1][0]=='O' && gridMP[1][1]=='O' && gridMP[1][2]=='O') {
    elementWinMP[1][0]=true; elementWinMP[1][1]=true; elementWinMP[1][2]=true;
    return true; // Row 2
  }
  else if (gridMP[2][0]=='O' && gridMP[2][1]=='O' && gridMP[2][2]=='O') {
    elementWinMP[2][0]=true; elementWinMP[2][1]=true; elementWinMP[2][2]=true;
    return true; // Row 3
  }
  else if (gridMP[0][0]=='O' && gridMP[1][0]=='O' && gridMP[2][0]=='O') {
    elementWinMP[0][0]=true; elementWinMP[1][0]=true; elementWinMP[2][0]=true;
    return true; // Column 1
  }
  else if (gridMP[0][1]=='O' && gridMP[1][1]=='O' && gridMP[2][1]=='O') {
    elementWinMP[0][1]=true; elementWinMP[1][1]=true; elementWinMP[2][1]=true;
    return true; // Column 2
  }
  else if (gridMP[0][2]=='O' && gridMP[1][2]=='O' && gridMP[2][2]=='O') {
    elementWinMP[0][2]=true; elementWinMP[1][2]=true; elementWinMP[2][2]=true;
    return true; // Column 3
  }
  else if (gridMP[0][0]=='O' && gridMP[1][1]=='O' && gridMP[2][2]=='O') {
    elementWinMP[0][0]=true; elementWinMP[1][1]=true; elementWinMP[2][2]=true;
    return true; // Left Diagonal
  }
  else if (gridMP[2][0]=='O' && gridMP[1][1]=='O' && gridMP[0][2]=='O') {
    elementWinMP[2][0]=true; elementWinMP[1][1]=true; elementWinMP[0][2]=true;
    return true; // Right Diagonal
  }
  else { return false; }
}
bool checkWinXMP () {
  if (gridMP[0][0]=='X' && gridMP[0][1]=='X' && gridMP[0][2]=='X') {
    elementWinMP[0][0]=true; elementWinMP[0][1]=true; elementWinMP[0][2]=true;
    return true; // Row1
  }
  else if (gridMP[1][0]=='X' && gridMP[1][1]=='X' && gridMP[1][2]=='X') {
    elementWinMP[1][0]=true; elementWinMP[1][1]=true; elementWinMP[1][2]=true;
    return true; // Row 2
  }
  else if (gridMP[2][0]=='X' && gridMP[2][1]=='X' && gridMP[2][2]=='X') {
    elementWinMP[2][0]=true; elementWinMP[2][1]=true; elementWinMP[2][2]=true;
    return true; // Row 3
  }
  else if (gridMP[0][0]=='X' && gridMP[1][0]=='X' && gridMP[2][0]=='X') {
    elementWinMP[0][0]=true; elementWinMP[1][0]=true; elementWinMP[2][0]=true;
    return true; // Column 1
  }
  else if (gridMP[0][1]=='X' && gridMP[1][1]=='X' && gridMP[2][1]=='X') {
    elementWinMP[0][1]=true; elementWinMP[1][1]=true; elementWinMP[2][1]=true;
    return true; // Column 2
  }
  else if (gridMP[0][2]=='X' && gridMP[1][2]=='X' && gridMP[2][2]=='X') {
    elementWinMP[0][2]=true; elementWinMP[1][2]=true; elementWinMP[2][2]=true;
    return true; // Column 3
  }
  else if (gridMP[0][0]=='X' && gridMP[1][1]=='X' && gridMP[2][2]=='X') {
    elementWinMP[0][0]=true; elementWinMP[1][1]=true; elementWinMP[2][2]=true;
    return true; // Left Diagonal
  }
  else if (gridMP[2][0]=='X' && gridMP[1][1]=='X' && gridMP[0][2]=='X') {
    elementWinMP[2][0]=true; elementWinMP[1][1]=true; elementWinMP[0][2]=true;
    return true; // Right Diagonal
  }
  else { return false; }
}