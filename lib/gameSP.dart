import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

var randomGenerator = Random();
List<List<String>> gridSP = [
  ['','',''],
  ['','',''],
  ['','','']
];
List<List<bool>> elementWinSP = [
  [false, false, false],
  [false, false, false],
  [false, false, false]
];
int countOSP, countXPC, difficulty, tempDifficulty;
String turnSP, startElementSP, nameSP, tempPlayerNameSP;
bool isValidSP;

void initNewGameSP () {
  gridSP = [
    ['','',''],
    ['','',''],
    ['','','']
  ];
  elementWinSP = [
    [false, false, false],
    [false, false, false],
    [false, false, false]
  ];
}

class GameSP extends StatefulWidget {
  @override
  _GameSPState createState() => _GameSPState();
}
class _GameSPState extends State<GameSP> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape
            ? GameSPL()
            : GameSPP();
      },
    );
  }
}

// Portrait Mode
class GameSPP extends StatefulWidget {
  @override
  _GameSPPState createState() => _GameSPPState();
}
class _GameSPPState extends State<GameSPP> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    tempPlayerNameSP = nameSP;
    isValidSP=true;
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
                                      child: PlayerNameBox()
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
                        'O\n$nameSP : $countOSP',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize:20.0, fontWeight: FontWeight.w400,
                            color: returnColorOSP())
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () async{
                      showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionBuilder: (context, a1, a2, widget) {
                            return Transform.scale(
                                scale: a1.value,
                                child: Opacity(
                                    opacity: a1.value,
                                    child: AlertDialog(
                                      shape: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0)),
                                      title: Center(child: Text('Difficulty Level', style: TextStyle(fontFamily: 'Monserrat', fontSize: 24.0, fontWeight: FontWeight.w300))),
                                      content: SizedBox(
                                          height: 160.0,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              DifficultySlider(),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  GestureDetector(
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                                                        child: Card(
                                                          child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                'Set Difficulty',
                                                                textAlign: TextAlign.center,
                                                              )
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () async{setState(() {
                                                        difficulty = tempDifficulty;
                                                        Navigator.of(context).pop();
                                                      }); saveSPdifficulty(); }
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                      ),
                                      //content: ,
                                    )
                                )
                            );
                          },
                          transitionDuration: Duration(milliseconds: 200),
                          barrierDismissible: true,
                          barrierLabel: '',
                          context: context,
                          pageBuilder: (context, animation1, animation2) {});
                    },
                    child: Text(
                        'X\nComputer : $countXPC',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize:20.0, fontWeight: FontWeight.w400,
                            color: returnColorXSP())
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
                                int gridStateLength = gridSP.length;
                                int x, y = 0;
                                x = (index / gridStateLength).floor();
                                y = (index % gridStateLength);
                                String thisElement = gridSP[x][y];
                                Color thisElementColor;
                                if (true==elementWinSP[x][y]) {thisElementColor=Colors.green;}
                                return GestureDetector(
                                    onTap: () async{
                                      if (!(counterSP('X')>=counterSP('O'))) { return; }
                                      setState(() {
                                        if (gridSP[x][y]=='' && checkWinOSP()==false && checkWinXSP()==false) {
                                          gridSP[x][y]=turnSP='O';
                                          saveSPgame();
                                          if (checkWinOSP()==true) {
                                            countOSP++;
                                            saveSPgame();
                                          }
                                          else if (checkFullSP()==false) {
                                            turnSP='X';
                                            Future.delayed(const Duration(milliseconds: 500), () {
                                              setState(() {
                                                seedElementX();
                                                if (checkWinXSP()==true) {
                                                  countXPC++;
                                                }
                                                saveSPgame();
                                              });
                                              if (checkWinXSP()==true || checkWinOSP()==true || checkFullSP()==true) {
                                                Future.delayed(const Duration(milliseconds: 1000), () {
                                                  setState(() {
                                                    startElementSP=turnSP=(startElementSP=='O')?'X':'O';
                                                    initNewGameSP(); saveSPgame();
                                                    if (startElementSP=='X') { seedElementX(); saveSPgame(); }
                                                  });
                                                });
                                              }
                                            });
                                          }
                                          if (checkWinXSP()==true || checkWinOSP()==true || checkFullSP()==true) {
                                            Future.delayed(const Duration(milliseconds: 1000), () {
                                              setState(() {
                                                startElementSP=turnSP=(startElementSP=='O')?'X':'O';
                                                initNewGameSP(); saveSPgame();
                                                if (startElementSP=='X') { seedElementX(); saveSPgame(); }
                                              });
                                            });
                                          }
                                        }
                                      });
                                      saveSPgame();
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
  Widget PlayerNameBox ()
  {
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
              SizedBox(child: InputNameSP(), width: 240.0),
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
                  if (isValidSP) {
                    nameSP=tempPlayerNameSP;
                    Navigator.of(context).pop();
                  }
                }); saveSPname(); },
              )
            ],
          ),
          //content: ,
        )
            : AlertDialog(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0)),
          title: Center(child: Text('Player Name', style: TextStyle(fontFamily: 'Monserrat', fontSize: 24.0, fontWeight: FontWeight.w300))),
          content: SizedBox(
              height: 160.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InputNameSP(),
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
                          if (isValidSP) {
                            nameSP=tempPlayerNameSP;
                            Navigator.of(context).pop();
                          }
                        }); saveSPname(); },
                      )
                    ],
                  )
                ],
              )
          ),
          //content: ,
        );
      },
    );
  }
  Color returnColorOSP () {
    bool checkedWin = checkWinOSP();
    if (checkedWin==false && checkWinXSP()==false) {return Colors.blue;}
    else if (checkedWin==true) {return Colors.green;}
  }
  Color returnColorXSP () {
    if (checkWinXSP()==true) {return Colors.green;}
  }
  Future saveSPgame () async{
    int countO;
    int countX;
    String turn;
    String startElement;
    String playerName;
    List<String> gridSP1;
    List<String> gridSP2;
    List<String> gridSP3;
    setState(() {
      countO = countOSP;
      countX = countXPC;
      turn = turnSP;
      startElement = startElementSP;
      playerName = nameSP;
      gridSP1 = gridSP[0];
      gridSP2 = gridSP[1];
      gridSP3 = gridSP[2];
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setStringList('firstLineSP', gridSP1);
    await pref.setStringList('secondLineSP', gridSP2);
    await pref.setStringList('thirdLineSP', gridSP3);
    await pref.setString('turnSP', turn);
    await pref.setString('startElementSP', startElement);
    await pref.setString('nameSP', playerName);
    await pref.setInt('countOSP', countO);
    await pref.setInt('countXPC', countX);
  }
  Future saveSPdifficulty () async{
    int diffSave;
    setState(() {
      diffSave = difficulty;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('savedDifficulty', diffSave);
  }
  Future saveSPname () async{
    String playerName;
    setState(() {
      playerName = nameSP;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('nameSP', playerName);
  }
}

// Landscape Mode
class GameSPL extends StatefulWidget {
  @override
  _GameSPLState createState() => _GameSPLState();
}
class _GameSPLState extends State<GameSPL> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    tempPlayerNameSP = nameSP;
    isValidSP=true;
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
                                      child: PlayerNameBox()
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
                        'O\n$nameSP : $countOSP',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.w400,
                            color: returnColorOSP())
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () async{
                      showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionBuilder: (context, a1, a2, widget) {
                            return Transform.scale(
                                scale: a1.value,
                                child: Opacity(
                                    opacity: a1.value,
                                    child: AlertDialog(
                                      shape: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0)),
                                      title: Center(child: Text('Difficulty Level', style: TextStyle(fontFamily: 'Monserrat', fontSize: 24.0, fontWeight: FontWeight.w300))),
                                      content: SizedBox(
                                          height: 160.0,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              DifficultySlider(),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  GestureDetector(
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                                                        child: Card(
                                                          child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text(
                                                                'Set Difficulty',
                                                                textAlign: TextAlign.center,
                                                              )
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () async{setState(() {
                                                        difficulty = tempDifficulty;
                                                        Navigator.of(context).pop();
                                                      }); saveSPdifficulty(); }
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                      ),
                                      //content: ,
                                    )
                                )
                            );
                          },
                          transitionDuration: Duration(milliseconds: 200),
                          barrierDismissible: true,
                          barrierLabel: '',
                          context: context,
                          pageBuilder: (context, animation1, animation2) {});
                    },
                    child: Text(
                        'X\nComputer : $countXPC',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.w400,
                            color: returnColorXSP())
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
                                int gridStateLength = gridSP.length;
                                int x, y = 0;
                                x = (index / gridStateLength).floor();
                                y = (index % gridStateLength);
                                String thisElement = gridSP[x][y];
                                Color thisElementColor;
                                if (true==elementWinSP[x][y]) {thisElementColor=Colors.green;}
                                return GestureDetector(
                                    onTap: () async{
                                      if (!(counterSP('X')>=counterSP('O'))) { return; }
                                      setState(() {
                                        if (gridSP[x][y]=='' && checkWinOSP()==false && checkWinXSP()==false) {
                                          gridSP[x][y]=turnSP='O';
                                          saveSPgame();
                                          if (checkWinOSP()==true) {
                                            countOSP++;
                                            saveSPgame();
                                          }
                                          else if (checkFullSP()==false) {
                                            turnSP='X';
                                            Future.delayed(const Duration(milliseconds: 500), () {
                                              setState(() {
                                                seedElementX();
                                                if (checkWinXSP()==true) {
                                                  countXPC++;
                                                }
                                                saveSPgame();
                                              });
                                              if (checkWinXSP()==true || checkWinOSP()==true || checkFullSP()==true) {
                                                Future.delayed(const Duration(milliseconds: 1000), () {
                                                  setState(() {
                                                    startElementSP=turnSP=(startElementSP=='O')?'X':'O';
                                                    initNewGameSP(); saveSPgame();
                                                    if (startElementSP=='X') { seedElementX(); saveSPgame(); }
                                                  });
                                                });
                                              }
                                            });
                                          }
                                          if (checkWinXSP()==true || checkWinOSP()==true || checkFullSP()==true) {
                                            Future.delayed(const Duration(milliseconds: 1000), () {
                                              setState(() {
                                                startElementSP=turnSP=(startElementSP=='O')?'X':'O';
                                                initNewGameSP(); saveSPgame();
                                                if (startElementSP=='X') { seedElementX(); saveSPgame(); }
                                              });
                                            });
                                          }
                                        }
                                      });
                                      saveSPgame();
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
  Widget PlayerNameBox ()
  {
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
                      SizedBox(child: InputNameSP(), width: 240.0),
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
                          if (isValidSP) {
                            nameSP=tempPlayerNameSP;
                            Navigator.of(context).pop();
                          }
                        }); saveSPname(); },
                      )
                    ],
                  ),
                  //content: ,
        )
            : AlertDialog(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)),
                  title: Center(child: Text('Player Name', style: TextStyle(fontFamily: 'Monserrat', fontSize: 24.0, fontWeight: FontWeight.w300))),
                  content: SizedBox(
                      height: 160.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InputNameSP(),
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
                                  if (isValidSP) {
                                    nameSP=tempPlayerNameSP;
                                    Navigator.of(context).pop();
                                  }
                                }); saveSPname(); },
                              )
                            ],
                          )
                        ],
                      )
                  ),
              //content: ,
            );
          },
    );
  }
  Color returnColorOSP () {
    bool checkedWin = checkWinOSP();
    if (checkedWin==false && checkWinXSP()==false) {return Colors.blue;}
    else if (checkedWin==true) {return Colors.green;}
  }
  Color returnColorXSP () {
    if (checkWinXSP()==true) {return Colors.green;}
  }
  Future saveSPgame () async{
    int countO;
    int countX;
    String turn;
    String startElement;
    String playerName;
    List<String> gridSP1;
    List<String> gridSP2;
    List<String> gridSP3;
    setState(() {
      countO = countOSP;
      countX = countXPC;
      turn = turnSP;
      startElement = startElementSP;
      playerName = nameSP;
      gridSP1 = gridSP[0];
      gridSP2 = gridSP[1];
      gridSP3 = gridSP[2];
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setStringList('firstLineSP', gridSP1);
    await pref.setStringList('secondLineSP', gridSP2);
    await pref.setStringList('thirdLineSP', gridSP3);
    await pref.setString('turnSP', turn);
    await pref.setString('startElementSP', startElement);
    await pref.setString('nameSP', playerName);
    await pref.setInt('countOSP', countO);
    await pref.setInt('countXPC', countX);
  }
  Future saveSPdifficulty () async{
    int diffSave;
    setState(() {
      diffSave = difficulty;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('savedDifficulty', diffSave);
  }
  Future saveSPname () async{
    String playerName;
    setState(() {
      playerName = nameSP;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('nameSP', playerName);
  }
}

class InputNameSP extends StatefulWidget {
  @override
  _InputNameSPState createState() => _InputNameSPState();
}
class _InputNameSPState extends State<InputNameSP> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        maxLines: 1,
        maxLength: 10,
        maxLengthEnforced: true,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.done,
        onSubmitted: (textSP) async{
          setState(() {
            isValidSP=textCheck(textSP);
            if (isValidSP) {
              nameSP=textSP;
              Navigator.of(context).pop();
            }
          });
          saveSPname();
        },
        onChanged: (textSP) {
          setState(() {
            isValidSP=textCheck(textSP);
            if (isValidSP) {
              tempPlayerNameSP=textSP;
            }
          });
        },
        decoration: InputDecoration(
            hintText: nameSP,
            errorText: (isValidSP==false)?'Invalid Name':null,
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
  Future saveSPname () async{
    String playerName;
    setState(() {
      playerName = nameSP;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('nameSP', playerName);
  }
}
class DifficultySlider extends StatefulWidget {
  @override
  _DifficultySliderState createState() => _DifficultySliderState();
}
class _DifficultySliderState extends State<DifficultySlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Easy',
          style: TextStyle(color: Colors.grey[500]),
        ),
        Slider(
          value: tempDifficulty.toDouble(),
          onChanged: (newDiffVal) {
            setState(() {
              tempDifficulty=newDiffVal.toInt();
            });
          },
          label: '$tempDifficulty',
          divisions: 4,
          min: 1,
          max: 5,
        ),
        Text(
          'Hard',
          style: TextStyle(color: Colors.grey[500]),
        )
      ],
    );
  }
}

bool textCheck (String inputText) {
  for (int i=0; i<inputText.length; i++) {
    if ((inputText[i]!='A') && (inputText[i]!='B') && (inputText[i]!='C') && (inputText[i]!='D') && (inputText[i]!='E') && (inputText[i]!='F') &&
        (inputText[i]!='G') && (inputText[i]!='H') && (inputText[i]!='I') && (inputText[i]!='J') && (inputText[i]!='K') && (inputText[i]!='L') &&
        (inputText[i]!='M') && (inputText[i]!='N') && (inputText[i]!='O') && (inputText[i]!='P') && (inputText[i]!='Q') && (inputText[i]!='R') &&
        (inputText[i]!='S') && (inputText[i]!='T') && (inputText[i]!='U') && (inputText[i]!='V') && (inputText[i]!='W') && (inputText[i]!='X') &&
        (inputText[i]!='Y') && (inputText[i]!='Z') && (inputText[i]!='a') && (inputText[i]!='b') && (inputText[i]!='c') && (inputText[i]!='d') &&
        (inputText[i]!='e') && (inputText[i]!='f') && (inputText[i]!='g') && (inputText[i]!='h') && (inputText[i]!='i') && (inputText[i]!='j') &&
        (inputText[i]!='k') && (inputText[i]!='l') && (inputText[i]!='m') && (inputText[i]!='n') && (inputText[i]!='o') && (inputText[i]!='p') &&
        (inputText[i]!='q') && (inputText[i]!='r') && (inputText[i]!='s') && (inputText[i]!='t') && (inputText[i]!='u') && (inputText[i]!='v') &&
        (inputText[i]!='w') && (inputText[i]!='x') && (inputText[i]!='y') && (inputText[i]!='z') && (inputText!=null)) {
      return false;
    }
  }
  return true;
}

bool checkFullSP () {
  for (int i = 0 ; i < 3 ; i++) {
    for (int j = 0 ; j < 3 ; j++) {
      if (gridSP[i][j]=='') { return false; }
    }
  }
  return true;
}
int counterSP (String element) {
  int t=0;
  for (int i=0; i<3; i++) {
    for (int j=0; j<3; j++) {
      if (element==gridSP[i][j]) { t++; }
    }
  }
  return t;
}
bool checkWinOSP () {
  if (gridSP[0][0]=='O' && gridSP[0][1]=='O' && gridSP[0][2]=='O') {
    elementWinSP[0][0]=true; elementWinSP[0][1]=true; elementWinSP[0][2]=true;
    return true; // Row1
  }
  else if (gridSP[1][0]=='O' && gridSP[1][1]=='O' && gridSP[1][2]=='O') {
    elementWinSP[1][0]=true; elementWinSP[1][1]=true; elementWinSP[1][2]=true;
    return true; // Row 2
  }
  else if (gridSP[2][0]=='O' && gridSP[2][1]=='O' && gridSP[2][2]=='O') {
    elementWinSP[2][0]=true; elementWinSP[2][1]=true; elementWinSP[2][2]=true;
    return true; // Row 3
  }
  else if (gridSP[0][0]=='O' && gridSP[1][0]=='O' && gridSP[2][0]=='O') {
    elementWinSP[0][0]=true; elementWinSP[1][0]=true; elementWinSP[2][0]=true;
    return true; // Column 1
  }
  else if (gridSP[0][1]=='O' && gridSP[1][1]=='O' && gridSP[2][1]=='O') {
    elementWinSP[0][1]=true; elementWinSP[1][1]=true; elementWinSP[2][1]=true;
    return true; // Column 2
  }
  else if (gridSP[0][2]=='O' && gridSP[1][2]=='O' && gridSP[2][2]=='O') {
    elementWinSP[0][2]=true; elementWinSP[1][2]=true; elementWinSP[2][2]=true;
    return true; // Column 3
  }
  else if (gridSP[0][0]=='O' && gridSP[1][1]=='O' && gridSP[2][2]=='O') {
    elementWinSP[0][0]=true; elementWinSP[1][1]=true; elementWinSP[2][2]=true;
    return true; // Left Diagonal
  }
  else if (gridSP[2][0]=='O' && gridSP[1][1]=='O' && gridSP[0][2]=='O') {
    elementWinSP[2][0]=true; elementWinSP[1][1]=true; elementWinSP[0][2]=true;
    return true; // Right Diagonal
  }
  else { return false; }
}

bool checkWinXSP () {
  if (gridSP[0][0]=='X' && gridSP[0][1]=='X' && gridSP[0][2]=='X') {
    elementWinSP[0][0]=true; elementWinSP[0][1]=true; elementWinSP[0][2]=true;
    return true; // Row1
  }
  else if (gridSP[1][0]=='X' && gridSP[1][1]=='X' && gridSP[1][2]=='X') {
    elementWinSP[1][0]=true; elementWinSP[1][1]=true; elementWinSP[1][2]=true;
    return true; // Row 2
  }
  else if (gridSP[2][0]=='X' && gridSP[2][1]=='X' && gridSP[2][2]=='X') {
    elementWinSP[2][0]=true; elementWinSP[2][1]=true; elementWinSP[2][2]=true;
    return true; // Row 3
  }
  else if (gridSP[0][0]=='X' && gridSP[1][0]=='X' && gridSP[2][0]=='X') {
    elementWinSP[0][0]=true; elementWinSP[1][0]=true; elementWinSP[2][0]=true;
    return true; // Column 1
  }
  else if (gridSP[0][1]=='X' && gridSP[1][1]=='X' && gridSP[2][1]=='X') {
    elementWinSP[0][1]=true; elementWinSP[1][1]=true; elementWinSP[2][1]=true;
    return true; // Column 2
  }
  else if (gridSP[0][2]=='X' && gridSP[1][2]=='X' && gridSP[2][2]=='X') {
    elementWinSP[0][2]=true; elementWinSP[1][2]=true; elementWinSP[2][2]=true;
    return true; // Column 3
  }
  else if (gridSP[0][0]=='X' && gridSP[1][1]=='X' && gridSP[2][2]=='X') {
    elementWinSP[0][0]=true; elementWinSP[1][1]=true; elementWinSP[2][2]=true;
    return true; // Left Diagonal
  }
  else if (gridSP[2][0]=='X' && gridSP[1][1]=='X' && gridSP[0][2]=='X') {
    elementWinSP[2][0]=true; elementWinSP[1][1]=true; elementWinSP[0][2]=true;
    return true; // Right Diagonal
  }
  else { return false; }
}

void seedElementRandomly ()
{
  int emptyElements = 0;
  int seedPosition = 0;
  int counter = 0;
  for (int i = 0 ; i < 3 ; i++) {
    for (int j = 0 ; j < 3 ; j++) {
      if (gridSP[i][j]=='') { emptyElements++; }
    }
  }
  seedPosition = randomGenerator.nextInt(emptyElements);
  for (int i = 0 ; i < 3 ; i++) {
    for (int j = 0 ; j < 3 ; j++) {
      if (gridSP[i][j]=='' && seedPosition==counter++) {
        gridSP[i][j]=turnSP;
      }
    }
  }
}
void seedElementX () {
  if (randomGenerator.nextInt(5)+1<(difficulty==5?6:difficulty)) { seedElement(); }
  else {
    if (gridSP[0][0]=='X' && gridSP[1][1]=='X' && gridSP[2][2]=='') {
      gridSP[2][2]=turnSP; return; // Left Diagonal
    }
    else if (gridSP[0][0]=='X' && gridSP[1][1]=='' && gridSP[2][2]=='X') {
      gridSP[1][1]=turnSP; return; // Left Diagonal
    }
    else if (gridSP[0][0]=='' && gridSP[1][1]=='X' && gridSP[2][2]=='X') {
      gridSP[0][0]=turnSP; return; // Left Diagonal
    }
    else if (gridSP[2][0]=='X' && gridSP[1][1]=='X' && gridSP[0][2]=='') {
      gridSP[0][2]=turnSP; return; // Right Diagonal
    }
    else if (gridSP[2][0]=='X' && gridSP[1][1]=='' && gridSP[0][2]=='X') {
      gridSP[1][1]=turnSP; return; // Right Diagonal
    }
    else if (gridSP[2][0]=='' && gridSP[1][1]=='X' && gridSP[0][2]=='X') {
      gridSP[2][0]=turnSP; return; // Right Diagonal
    }
    else if (gridSP[0][0]=='X' && gridSP[1][1]=='X' && gridSP[2][2]=='') {
      gridSP[2][2]=turnSP; return; // Left Diagonal
    }
    else if (gridSP[0][0]=='X' && gridSP[1][1]=='' && gridSP[2][2]=='X') {
      gridSP[1][1]=turnSP; return; // Left Diagonal
    }
    else if (gridSP[0][0]=='' && gridSP[1][1]=='X' && gridSP[2][2]=='X') {
      gridSP[0][0]=turnSP; return; // Left Diagonal
    }
    else if (gridSP[2][0]=='X' && gridSP[1][1]=='X' && gridSP[0][2]=='') {
      gridSP[0][2]=turnSP; return; // Right Diagonal
    }
    else if (gridSP[2][0]=='X' && gridSP[1][1]=='' && gridSP[0][2]=='X') {
      gridSP[1][1]=turnSP; return; // Right Diagonal
    }
    else if (gridSP[2][0]=='' && gridSP[1][1]=='X' && gridSP[0][2]=='X') {
      gridSP[2][0]=turnSP; return; // Right Diagonal
    }
    else if (gridSP[0][0]=='X' && gridSP[0][1]=='X' && gridSP[0][2]=='') {
      gridSP[0][2]=turnSP; return; // Row 1
    }
    else if (gridSP[0][0]=='X' && gridSP[0][1]=='' && gridSP[0][2]=='X') {
      gridSP[0][1]=turnSP; return; // Row 1
    }
    else if (gridSP[0][0]=='' && gridSP[0][1]=='X' && gridSP[0][2]=='X') {
      gridSP[0][0]=turnSP; return; // Row 1
    }
    else if (gridSP[1][0]=='X' && gridSP[1][1]=='X' && gridSP[1][2]=='') {
      gridSP[1][2]=turnSP; return; // Row 2
    }
    else if (gridSP[1][0]=='X' && gridSP[1][1]=='' && gridSP[1][2]=='X') {
      gridSP[1][1]=turnSP; return; // Row 2
    }
    else if (gridSP[1][0]=='' && gridSP[1][1]=='X' && gridSP[1][2]=='X') {
      gridSP[1][0]=turnSP; return; // Row 2
    }
    else if (gridSP[2][0]=='X' && gridSP[2][1]=='X' && gridSP[2][2]=='') {
      gridSP[2][2]=turnSP; return; // Row 3
    }
    else if (gridSP[2][0]=='X' && gridSP[2][1]=='' && gridSP[2][2]=='X') {
      gridSP[2][1]=turnSP; return; // Row 3
    }
    else if (gridSP[2][0]=='' && gridSP[2][1]=='X' && gridSP[2][2]=='X') {
      gridSP[2][0] = turnSP; return; // Row 3
    }
    else if (gridSP[0][0]=='X' && gridSP[1][0]=='X' && gridSP[2][0]=='') {
      gridSP[2][0]=turnSP; return; // Column 1
    }
    else if (gridSP[0][0]=='X' && gridSP[1][0]=='' && gridSP[2][0]=='X') {
      gridSP[1][0]=turnSP; return; // Column 1
    }
    else if (gridSP[0][0]=='' && gridSP[1][0]=='X' && gridSP[2][0]=='X') {
      gridSP[0][0]=turnSP; return; // Column 1
    }
    else if (gridSP[0][1]=='X' && gridSP[1][1]=='X' && gridSP[2][1]=='') {
      gridSP[2][1]=turnSP; return; // Column 2
    }
    else if (gridSP[0][1]=='X' && gridSP[1][1]=='' && gridSP[2][1]=='X') {
      gridSP[1][1]=turnSP; return; // Column 2
    }
    else if (gridSP[0][1]=='' && gridSP[1][1]=='X' && gridSP[2][1]=='X') {
      gridSP[0][1]=turnSP; return; // Column 2
    }
    else if (gridSP[0][2]=='X' && gridSP[1][2]=='X' && gridSP[2][2]=='') {
      gridSP[2][2]=turnSP; return; // Column 3
    }
    else if (gridSP[0][2]=='X' && gridSP[1][2]=='' && gridSP[2][2]=='X') {
      gridSP[1][2]=turnSP; return; // Column 3
    }
    else if (gridSP[0][2]=='' && gridSP[1][2]=='X' && gridSP[2][2]=='X') {
      gridSP[0][2]=turnSP; return; // Column 3
    }
    else if (gridSP[0][0]=='O' && gridSP[1][1]=='O' && gridSP[2][2]=='') {
      gridSP[2][2]=turnSP; return; // Left Diagonal
    }
    else if (gridSP[0][0]=='O' && gridSP[1][1]=='' && gridSP[2][2]=='O') {
      gridSP[1][1]=turnSP; return; // Left Diagonal
    }
    else if (gridSP[0][0]=='' && gridSP[1][1]=='O' && gridSP[2][2]=='O') {
      gridSP[0][0]=turnSP; return; // Left Diagonal
    }
    else if (gridSP[2][0]=='O' && gridSP[1][1]=='O' && gridSP[0][2]=='') {
      gridSP[0][2]=turnSP; return; // Right Diagonal
    }
    else if (gridSP[2][0]=='O' && gridSP[1][1]=='' && gridSP[0][2]=='O') {
      gridSP[1][1]=turnSP; return; // Right Diagonal
    }
    else if (gridSP[2][0]=='' && gridSP[1][1]=='O' && gridSP[0][2]=='O') {
      gridSP[2][0]=turnSP; return; // Right Diagonal
    }
    else if (gridSP[0][0]=='O' && gridSP[0][1]=='O' && gridSP[0][2]=='') {
      gridSP[0][2]=turnSP; return; // Row 1
    }
    else if (gridSP[0][0]=='O' && gridSP[0][1]=='' && gridSP[0][2]=='O') {
      gridSP[0][1]=turnSP; return; // Row 1
    }
    else if (gridSP[0][0]=='' && gridSP[0][1]=='O' && gridSP[0][2]=='O') {
      gridSP[0][0]=turnSP; return; // Row 1
    }
    else if (gridSP[1][0]=='O' && gridSP[1][1]=='O' && gridSP[1][2]=='') {
      gridSP[1][2]=turnSP; return; // Row 2
    }
    else if (gridSP[1][0]=='O' && gridSP[1][1]=='' && gridSP[1][2]=='O') {
      gridSP[1][1]=turnSP; return; // Row 2
    }
    else if (gridSP[1][0]=='' && gridSP[1][1]=='O' && gridSP[1][2]=='O') {
      gridSP[1][0]=turnSP; return; // Row 2
    }
    else if (gridSP[2][0]=='O' && gridSP[2][1]=='O' && gridSP[2][2]=='') {
      gridSP[2][2]=turnSP; return; // Row 3
    }
    else if (gridSP[2][0]=='O' && gridSP[2][1]=='' && gridSP[2][2]=='O') {
      gridSP[2][1]=turnSP; return; // Row 3
    }
    else if (gridSP[2][0]=='' && gridSP[2][1]=='O' && gridSP[2][2]=='O') {
      gridSP[2][0] = turnSP; return; // Row 3
    }
    else if (gridSP[0][0]=='O' && gridSP[1][0]=='O' && gridSP[2][0]=='') {
      gridSP[2][0]=turnSP; return; // Column 1
    }
    else if (gridSP[0][0]=='O' && gridSP[1][0]=='' && gridSP[2][0]=='O') {
      gridSP[1][0]=turnSP; return; // Column 1
    }
    else if (gridSP[0][0]=='' && gridSP[1][0]=='O' && gridSP[2][0]=='O') {
      gridSP[0][0]=turnSP; return; // Column 1
    }
    else if (gridSP[0][1]=='O' && gridSP[1][1]=='O' && gridSP[2][1]=='') {
      gridSP[2][1]=turnSP; return; // Column 2
    }
    else if (gridSP[0][1]=='O' && gridSP[1][1]=='' && gridSP[2][1]=='O') {
      gridSP[1][1]=turnSP; return; // Column 2
    }
    else if (gridSP[0][1]=='' && gridSP[1][1]=='O' && gridSP[2][1]=='O') {
      gridSP[0][1]=turnSP; return; // Column 2
    }
    else if (gridSP[0][2]=='O' && gridSP[1][2]=='O' && gridSP[2][2]=='') {
      gridSP[2][2]=turnSP; return; // Column 3
    }
    else if (gridSP[0][2]=='O' && gridSP[1][2]=='' && gridSP[2][2]=='O') {
      gridSP[1][2]=turnSP; return; // Column 3
    }
    else if (gridSP[0][2]=='' && gridSP[1][2]=='O' && gridSP[2][2]=='O') {
      gridSP[0][2]=turnSP; return; // Column 3
    }
    seedElementRandomly();
  }
}
void seedElement ()
{
  if (gridSP[0][0]=='X' && gridSP[1][1]=='X' && gridSP[2][2]=='') {
    gridSP[2][2]=turnSP; return; // Left Diagonal
  }
  else if (gridSP[0][0]=='X' && gridSP[1][1]=='' && gridSP[2][2]=='X') {
    gridSP[1][1]=turnSP; return; // Left Diagonal
  }
  else if (gridSP[0][0]=='' && gridSP[1][1]=='X' && gridSP[2][2]=='X') {
    gridSP[0][0]=turnSP; return; // Left Diagonal
  }
  else if (gridSP[2][0]=='X' && gridSP[1][1]=='X' && gridSP[0][2]=='') {
    gridSP[0][2]=turnSP; return; // Right Diagonal
  }
  else if (gridSP[2][0]=='X' && gridSP[1][1]=='' && gridSP[0][2]=='X') {
    gridSP[1][1]=turnSP; return; // Right Diagonal
  }
  else if (gridSP[2][0]=='' && gridSP[1][1]=='X' && gridSP[0][2]=='X') {
    gridSP[2][0]=turnSP; return; // Right Diagonal
  }
  else if (gridSP[0][0]=='X' && gridSP[1][1]=='X' && gridSP[2][2]=='') {
    gridSP[2][2]=turnSP; return; // Left Diagonal
  }
  else if (gridSP[0][0]=='X' && gridSP[1][1]=='' && gridSP[2][2]=='X') {
    gridSP[1][1]=turnSP; return; // Left Diagonal
  }
  else if (gridSP[0][0]=='' && gridSP[1][1]=='X' && gridSP[2][2]=='X') {
    gridSP[0][0]=turnSP; return; // Left Diagonal
  }
  else if (gridSP[2][0]=='X' && gridSP[1][1]=='X' && gridSP[0][2]=='') {
    gridSP[0][2]=turnSP; return; // Right Diagonal
  }
  else if (gridSP[2][0]=='X' && gridSP[1][1]=='' && gridSP[0][2]=='X') {
    gridSP[1][1]=turnSP; return; // Right Diagonal
  }
  else if (gridSP[2][0]=='' && gridSP[1][1]=='X' && gridSP[0][2]=='X') {
    gridSP[2][0]=turnSP; return; // Right Diagonal
  }
  else if (gridSP[0][0]=='X' && gridSP[0][1]=='X' && gridSP[0][2]=='') {
    gridSP[0][2]=turnSP; return; // Row 1
  }
  else if (gridSP[0][0]=='X' && gridSP[0][1]=='' && gridSP[0][2]=='X') {
    gridSP[0][1]=turnSP; return; // Row 1
  }
  else if (gridSP[0][0]=='' && gridSP[0][1]=='X' && gridSP[0][2]=='X') {
    gridSP[0][0]=turnSP; return; // Row 1
  }
  else if (gridSP[1][0]=='X' && gridSP[1][1]=='X' && gridSP[1][2]=='') {
    gridSP[1][2]=turnSP; return; // Row 2
  }
  else if (gridSP[1][0]=='X' && gridSP[1][1]=='' && gridSP[1][2]=='X') {
    gridSP[1][1]=turnSP; return; // Row 2
  }
  else if (gridSP[1][0]=='' && gridSP[1][1]=='X' && gridSP[1][2]=='X') {
    gridSP[1][0]=turnSP; return; // Row 2
  }
  else if (gridSP[2][0]=='X' && gridSP[2][1]=='X' && gridSP[2][2]=='') {
    gridSP[2][2]=turnSP; return; // Row 3
  }
  else if (gridSP[2][0]=='X' && gridSP[2][1]=='' && gridSP[2][2]=='X') {
    gridSP[2][1]=turnSP; return; // Row 3
  }
  else if (gridSP[2][0]=='' && gridSP[2][1]=='X' && gridSP[2][2]=='X') {
    gridSP[2][0] = turnSP; return; // Row 3
  }
  else if (gridSP[0][0]=='X' && gridSP[1][0]=='X' && gridSP[2][0]=='') {
    gridSP[2][0]=turnSP; return; // Column 1
  }
  else if (gridSP[0][0]=='X' && gridSP[1][0]=='' && gridSP[2][0]=='X') {
    gridSP[1][0]=turnSP; return; // Column 1
  }
  else if (gridSP[0][0]=='' && gridSP[1][0]=='X' && gridSP[2][0]=='X') {
    gridSP[0][0]=turnSP; return; // Column 1
  }
  else if (gridSP[0][1]=='X' && gridSP[1][1]=='X' && gridSP[2][1]=='') {
    gridSP[2][1]=turnSP; return; // Column 2
  }
  else if (gridSP[0][1]=='X' && gridSP[1][1]=='' && gridSP[2][1]=='X') {
    gridSP[1][1]=turnSP; return; // Column 2
  }
  else if (gridSP[0][1]=='' && gridSP[1][1]=='X' && gridSP[2][1]=='X') {
    gridSP[0][1]=turnSP; return; // Column 2
  }
  else if (gridSP[0][2]=='X' && gridSP[1][2]=='X' && gridSP[2][2]=='') {
    gridSP[2][2]=turnSP; return; // Column 3
  }
  else if (gridSP[0][2]=='X' && gridSP[1][2]=='' && gridSP[2][2]=='X') {
    gridSP[1][2]=turnSP; return; // Column 3
  }
  else if (gridSP[0][2]=='' && gridSP[1][2]=='X' && gridSP[2][2]=='X') {
    gridSP[0][2]=turnSP; return; // Column 3
  }
  else if (gridSP[0][0]=='O' && gridSP[1][1]=='O' && gridSP[2][2]=='') {
    gridSP[2][2]=turnSP; return; // Left Diagonal
  }
  else if (gridSP[0][0]=='O' && gridSP[1][1]=='' && gridSP[2][2]=='O') {
    gridSP[1][1]=turnSP; return; // Left Diagonal
  }
  else if (gridSP[0][0]=='' && gridSP[1][1]=='O' && gridSP[2][2]=='O') {
    gridSP[0][0]=turnSP; return; // Left Diagonal
  }
  else if (gridSP[2][0]=='O' && gridSP[1][1]=='O' && gridSP[0][2]=='') {
    gridSP[0][2]=turnSP; return; // Right Diagonal
  }
  else if (gridSP[2][0]=='O' && gridSP[1][1]=='' && gridSP[0][2]=='O') {
    gridSP[1][1]=turnSP; return; // Right Diagonal
  }
  else if (gridSP[2][0]=='' && gridSP[1][1]=='O' && gridSP[0][2]=='O') {
    gridSP[2][0]=turnSP; return; // Right Diagonal
  }
  else if (gridSP[0][0]=='O' && gridSP[0][1]=='O' && gridSP[0][2]=='') {
    gridSP[0][2]=turnSP; return; // Row 1
  }
  else if (gridSP[0][0]=='O' && gridSP[0][1]=='' && gridSP[0][2]=='O') {
    gridSP[0][1]=turnSP; return; // Row 1
  }
  else if (gridSP[0][0]=='' && gridSP[0][1]=='O' && gridSP[0][2]=='O') {
    gridSP[0][0]=turnSP; return; // Row 1
  }
  else if (gridSP[1][0]=='O' && gridSP[1][1]=='O' && gridSP[1][2]=='') {
    gridSP[1][2]=turnSP; return; // Row 2
  }
  else if (gridSP[1][0]=='O' && gridSP[1][1]=='' && gridSP[1][2]=='O') {
    gridSP[1][1]=turnSP; return; // Row 2
  }
  else if (gridSP[1][0]=='' && gridSP[1][1]=='O' && gridSP[1][2]=='O') {
    gridSP[1][0]=turnSP; return; // Row 2
  }
  else if (gridSP[2][0]=='O' && gridSP[2][1]=='O' && gridSP[2][2]=='') {
    gridSP[2][2]=turnSP; return; // Row 3
  }
  else if (gridSP[2][0]=='O' && gridSP[2][1]=='' && gridSP[2][2]=='O') {
    gridSP[2][1]=turnSP; return; // Row 3
  }
  else if (gridSP[2][0]=='' && gridSP[2][1]=='O' && gridSP[2][2]=='O') {
    gridSP[2][0] = turnSP; return; // Row 3
  }
  else if (gridSP[0][0]=='O' && gridSP[1][0]=='O' && gridSP[2][0]=='') {
    gridSP[2][0]=turnSP; return; // Column 1
  }
  else if (gridSP[0][0]=='O' && gridSP[1][0]=='' && gridSP[2][0]=='O') {
    gridSP[1][0]=turnSP; return; // Column 1
  }
  else if (gridSP[0][0]=='' && gridSP[1][0]=='O' && gridSP[2][0]=='O') {
    gridSP[0][0]=turnSP; return; // Column 1
  }
  else if (gridSP[0][1]=='O' && gridSP[1][1]=='O' && gridSP[2][1]=='') {
    gridSP[2][1]=turnSP; return; // Column 2
  }
  else if (gridSP[0][1]=='O' && gridSP[1][1]=='' && gridSP[2][1]=='O') {
    gridSP[1][1]=turnSP; return; // Column 2
  }
  else if (gridSP[0][1]=='' && gridSP[1][1]=='O' && gridSP[2][1]=='O') {
    gridSP[0][1]=turnSP; return; // Column 2
  }
  else if (gridSP[0][2]=='O' && gridSP[1][2]=='O' && gridSP[2][2]=='') {
    gridSP[2][2]=turnSP; return; // Column 3
  }
  else if (gridSP[0][2]=='O' && gridSP[1][2]=='' && gridSP[2][2]=='O') {
    gridSP[1][2]=turnSP; return; // Column 3
  }
  else if (gridSP[0][2]=='' && gridSP[1][2]=='O' && gridSP[2][2]=='O') {
    gridSP[0][2]=turnSP; return; // Column 3
  }

  else if (gridSP[0][0]=='' && gridSP[0][1]=='' && gridSP[0][2]=='' && gridSP[1][0]=='' && gridSP[1][1]=='O' && gridSP[1][2]=='' && gridSP[2][0]=='' && gridSP[2][1]=='' && gridSP[2][2]=='') {
    int seedCount = randomGenerator.nextInt(4); // Corner Priority Defence
    if (seedCount==0) { gridSP[0][0]=turnSP; return; }
    else if (seedCount==1) { gridSP[0][2]=turnSP; return; }
    else if (seedCount==2) { gridSP[2][2]=turnSP; return; }
    else if (seedCount==3) { gridSP[2][2]=turnSP; return; }
  }
  else if (
  (gridSP[0][0]=='' && gridSP[0][1]=='O' && gridSP[0][2]=='' && gridSP[1][0]=='' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[2][0]=='' && gridSP[2][1]=='' && gridSP[2][2]=='') ||
      (gridSP[0][0]=='' && gridSP[0][1]=='' && gridSP[0][2]=='' && gridSP[1][0]=='O' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[2][0]=='' && gridSP[2][1]=='' && gridSP[2][2]=='') ||
      (gridSP[0][0]=='' && gridSP[0][1]=='' && gridSP[0][2]=='' && gridSP[1][0]=='' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[2][0]=='' && gridSP[2][1]=='O' && gridSP[2][2]=='') ||
      (gridSP[0][0]=='' && gridSP[0][1]=='' && gridSP[0][2]=='' && gridSP[1][0]=='' && gridSP[1][1]=='' && gridSP[1][2]=='O' && gridSP[2][0]=='' && gridSP[2][1]=='' && gridSP[2][2]=='')
  ) {
    gridSP[1][1]=turnSP; return;
  }
  else if (gridSP[0][0]=='O' && gridSP[0][1]=='' && gridSP[0][2]=='' && gridSP[1][0]=='' && gridSP[1][1]=='X' && gridSP[1][2]=='' && gridSP[2][0]=='' && gridSP[2][1]=='' && gridSP[2][2]=='O') {
    int seedCount = randomGenerator.nextInt(4); // Left Diagonal Defence
    if (seedCount==0) { gridSP[0][1]=turnSP; return; }
    else if (seedCount==1) { gridSP[1][0]=turnSP; return; }
    else if (seedCount==2) { gridSP[1][2]=turnSP; return; }
    else if (seedCount==3) { gridSP[2][1]=turnSP; return; }
  }
  else if (gridSP[0][0]=='' && gridSP[0][1]=='' && gridSP[0][2]=='O' && gridSP[1][0]=='' && gridSP[1][1]=='X' && gridSP[1][2]=='' && gridSP[2][0]=='O' && gridSP[2][1]=='' && gridSP[2][2]=='') {
    int seedCount = randomGenerator.nextInt(4); // Right Diagonal Defence
    if (seedCount==0) { gridSP[0][1]=turnSP; return; }
    else if (seedCount==1) { gridSP[1][0]=turnSP; return; }
    else if (seedCount==2) { gridSP[1][2]=turnSP; return; }
    else if (seedCount==3) { gridSP[2][1]=turnSP; return; }
  }
  else if (gridSP[1][1]=='O' && gridSP[2][1]=='O' && gridSP[0][1]=='' && gridSP[1][0]=='' && gridSP[1][2]=='') {
    int seedCount = randomGenerator.nextInt(3); // Middle Down Defence
    if (seedCount==0) { gridSP[0][1]=turnSP; return; }
    else if (seedCount==1) { gridSP[1][0]=turnSP; return; }
    else if (seedCount==2) { gridSP[1][2]=turnSP; return; }
  }
  else if (gridSP[1][1]=='O' && gridSP[2][1]=='' && gridSP[0][1]=='O' && gridSP[1][0]=='' && gridSP[1][2]=='') {
    int seedCount = randomGenerator.nextInt(3); // Middle Up Defence
    if (seedCount==0) { gridSP[2][1]=turnSP; return; }
    else if (seedCount==1) { gridSP[1][0]=turnSP; return; }
    else if (seedCount==2) { gridSP[1][2]=turnSP; return; }
  }
  else if (gridSP[1][1]=='O' && gridSP[2][1]=='' && gridSP[0][1]=='' && gridSP[1][0]=='O' && gridSP[1][2]=='') {
    int seedCount = randomGenerator.nextInt(3); // Middle Left Defence
    if (seedCount==0) { gridSP[2][1]=turnSP; return; }
    else if (seedCount==1) { gridSP[0][1]=turnSP; return; }
    else if (seedCount==2) { gridSP[1][2]=turnSP; return; }
  }
  else if (gridSP[1][1]=='O' && gridSP[2][1]=='' && gridSP[0][1]=='' && gridSP[1][0]=='' && gridSP[1][2]=='O') {
    int seedCount = randomGenerator.nextInt(3); // Middle Right Defence
    if (seedCount==0) { gridSP[2][1]=turnSP; return; }
    else if (seedCount==1) { gridSP[0][1]=turnSP; return; }
    else if (seedCount==2) { gridSP[1][0]=turnSP; return; }
  }
  else if (gridSP[0][0]=='O' && gridSP[0][1]=='' && gridSP[0][2]=='' && gridSP[1][0]=='' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[2][0]=='' && gridSP[2][1]=='' && gridSP[2][2]=='') {
    gridSP[1][1]=turnSP; return; // Middle Priority Defence
  }
  else if (gridSP[0][0]=='' && gridSP[0][1]=='' && gridSP[0][2]=='O' && gridSP[1][0]=='' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[2][0]=='' && gridSP[2][1]=='' && gridSP[2][2]=='') {
    gridSP[1][1]=turnSP; return; // Middle Priority Defence
  }
  else if (gridSP[0][0]=='' && gridSP[0][1]=='' && gridSP[0][2]=='' && gridSP[1][0]=='' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[2][0]=='O' && gridSP[2][1]=='' && gridSP[2][2]=='') {
    gridSP[1][1]=turnSP; return; // Middle Priority Defence
  }
  else if (gridSP[0][0]=='' && gridSP[0][1]=='' && gridSP[0][2]=='' && gridSP[1][0]=='' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[2][0]=='' && gridSP[2][1]=='' && gridSP[2][2]=='O') {
    gridSP[1][1]=turnSP; return; // Middle Priority Defence
  }
  else if (gridSP[0][0]=='O' && gridSP[2][0]=='' && gridSP[2][2]=='O' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[1][0]=='' && gridSP[2][1]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Left Diagonal Left Defence
  else if (gridSP[0][0]=='O' && gridSP[2][0]=='O' && gridSP[2][2]=='' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[1][0]=='' && gridSP[2][1]==''))) {
    gridSP[2][2]=turnSP; return;
  } // Left Diagonal Left Defence
  else if (gridSP[0][0]=='' && gridSP[2][0]=='O' && gridSP[2][2]=='O' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[1][0]=='' && gridSP[2][1]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Left Diagonal Left Defence
  else if (gridSP[0][0]=='O' && gridSP[0][2]=='' && gridSP[2][2]=='O' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][2]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Left Diagonal Right Defence
  else if (gridSP[0][0]=='O' && gridSP[0][2]=='O' && gridSP[2][2]=='' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][2]==''))) {
    gridSP[2][2]=turnSP; return;
  } // Left Diagonal Right Defence
  else if (gridSP[0][0]=='' && gridSP[0][2]=='O' && gridSP[2][2]=='O' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][2]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Left Diagonal Right Defence
  else if (gridSP[0][2]=='O' && gridSP[0][0]=='' && gridSP[2][0]=='O' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][0]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Right Diagonal Left Defence
  else if (gridSP[0][2]=='O' && gridSP[0][0]=='O' && gridSP[2][0]=='' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][0]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Right Diagonal Left Defence
  else if (gridSP[0][2]=='' && gridSP[0][0]=='O' && gridSP[2][0]=='O' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][0]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Right Diagonal Left Defence
  else if (gridSP[0][2]=='O' && gridSP[2][2]=='' && gridSP[2][0]=='O' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[2][1]=='' && gridSP[1][2]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Right Diagonal Right Defence
  else if (gridSP[0][2]=='O' && gridSP[2][2]=='O' && gridSP[2][0]=='' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[2][1]=='' && gridSP[1][2]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Right Diagonal Right Defence
  else if (gridSP[0][2]=='' && gridSP[2][2]=='O' && gridSP[2][0]=='O' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[2][1]=='' && gridSP[1][2]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Right Diagonal Right Defence
  else if (gridSP[1][0]=='O' && gridSP[2][1]=='O' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[0][1]=='') {
    gridSP[1][1]=turnSP; return;
  } // Bottom Left Corner Out Defence
  else if (gridSP[1][0]=='O' && gridSP[2][1]=='' && gridSP[1][1]=='O' && gridSP[1][2]=='' && gridSP[0][1]=='') {
    gridSP[2][1]=turnSP; return;
  } // Bottom Left Corner Out Defence
  else if (gridSP[1][0]=='' && gridSP[2][1]=='O' && gridSP[1][1]=='O' && gridSP[1][2]=='' && gridSP[0][1]=='') {
    gridSP[1][0]=turnSP; return;
  } // Bottom Left Corner Out Defence
  else if (gridSP[1][2]=='O' && gridSP[2][1]=='O' && gridSP[1][1]=='' && gridSP[1][0]=='' && gridSP[0][1]=='') {
    gridSP[1][1]=turnSP; return;
  } // Bottom Right Corner Out Defence
  else if (gridSP[1][2]=='O' && gridSP[2][1]=='' && gridSP[1][1]=='O' && gridSP[1][0]=='' && gridSP[0][1]=='') {
    gridSP[2][1]=turnSP; return;
  } // Bottom Right Corner Out Defence
  else if (gridSP[1][2]=='' && gridSP[2][1]=='O' && gridSP[1][1]=='O' && gridSP[1][0]=='' && gridSP[0][1]=='') {
    gridSP[1][2]=turnSP; return;
  } // Bottom Right Corner Out Defence
  else if (gridSP[1][2]=='O' && gridSP[0][1]=='O' && gridSP[1][1]=='' && gridSP[1][0]=='' && gridSP[2][1]=='') {
    gridSP[1][1]=turnSP; return;
  } // Top Right Corner Out Defence
  else if (gridSP[1][2]=='O' && gridSP[0][1]=='' && gridSP[1][1]=='O' && gridSP[1][0]=='' && gridSP[2][1]=='') {
    gridSP[0][1]=turnSP; return;
  } // Top Right Corner Out Defence
  else if (gridSP[1][2]=='' && gridSP[0][1]=='O' && gridSP[1][1]=='O' && gridSP[1][0]=='' && gridSP[2][1]=='') {
    gridSP[1][2]=turnSP; return;
  } // Top Right Corner Out Defence
  else if (gridSP[1][0]=='O' && gridSP[0][1]=='O' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[2][1]=='') {
    gridSP[1][1]=turnSP; return;
  } // Top Left Corner Out Defence
  else if (gridSP[1][0]=='O' && gridSP[0][1]=='' && gridSP[1][1]=='O' && gridSP[1][2]=='' && gridSP[2][1]=='') {
    gridSP[0][1]=turnSP; return;
  } // Top Left Corner Out Defence
  else if (gridSP[1][0]=='' && gridSP[0][1]=='O' && gridSP[1][1]=='O' && gridSP[1][2]=='' && gridSP[2][1]=='') {
    gridSP[1][0]=turnSP; return;
  } // Top Left Corner Out Defence
  else if (gridSP[1][0]=='O' && gridSP[2][1]=='O' && gridSP[2][0]=='' && gridSP[0][0]=='' && gridSP[2][2]=='') {
    gridSP[2][0]=turnSP; return;
  } // Bottom Left Corner In Defence
  else if (gridSP[1][0]=='O' && gridSP[2][1]=='' && gridSP[2][0]=='O' && gridSP[0][0]=='' && gridSP[2][2]=='') {
    gridSP[2][1]=turnSP; return;
  } // Bottom Left Corner In Defence
  else if (gridSP[1][0]=='' && gridSP[2][1]=='O' && gridSP[2][0]=='O' && gridSP[0][0]=='' && gridSP[2][2]=='') {
    gridSP[1][0]=turnSP; return;
  } // Bottom Left Corner In Defence
  else if (gridSP[1][2]=='O' && gridSP[2][1]=='O' && gridSP[2][2]=='' && gridSP[0][2]=='' && gridSP[2][0]=='') {
    gridSP[2][2]=turnSP; return;
  } // Bottom Right Corner In Defence
  else if (gridSP[1][2]=='O' && gridSP[2][1]=='' && gridSP[2][2]=='O' && gridSP[0][2]=='' && gridSP[2][0]=='') {
    gridSP[2][1]=turnSP; return;
  } // Bottom Right Corner In Defence
  else if (gridSP[1][2]=='' && gridSP[2][1]=='O' && gridSP[2][2]=='O' && gridSP[0][2]=='' && gridSP[2][0]=='') {
    gridSP[1][0]=turnSP; return;
  } // Bottom Right Corner In Defence
  else if (gridSP[1][2]=='O' && gridSP[0][1]=='O' && gridSP[0][2]=='' && gridSP[0][0]=='' && gridSP[2][2]=='') {
    gridSP[0][2]=turnSP; return;
  } // Top Right Corner In Defence
  else if (gridSP[1][2]=='O' && gridSP[0][1]=='' && gridSP[0][2]=='O' && gridSP[0][0]=='' && gridSP[2][2]=='') {
    gridSP[0][1]=turnSP; return;
  } // Top Right Corner In Defence
  else if (gridSP[1][2]=='' && gridSP[0][1]=='O' && gridSP[0][2]=='O' && gridSP[0][0]=='' && gridSP[2][2]=='') {
    gridSP[1][2]=turnSP; return;
  } // Top Right Corner In Defence
  else if (gridSP[1][0]=='O' && gridSP[0][1]=='O' && gridSP[0][0]=='' && gridSP[0][2]=='' && gridSP[2][0]=='') {
    gridSP[0][2]=turnSP; return;
  } // Top Left Corner In Defence
  else if (gridSP[1][0]=='O' && gridSP[0][1]=='' && gridSP[0][0]=='O' && gridSP[0][2]=='' && gridSP[2][0]=='') {
    gridSP[0][1]=turnSP; return;
  } // Top Left Corner In Defence
  else if (gridSP[1][0]=='' && gridSP[0][1]=='O' && gridSP[0][0]=='O' && gridSP[0][2]=='' && gridSP[2][0]=='') {
    gridSP[1][0]=turnSP; return;
  } // Top Left Corner In Defence
  else if (gridSP[0][0]=='O' && gridSP[1][1]=='' && gridSP[2][0]=='O' && ((gridSP[0][2]=='' && gridSP[2][2]=='') || (gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[1][0]=='' && gridSP[2][2]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Left Arrow Defence
  else if (gridSP[0][0]=='O' && gridSP[1][1]=='O' && gridSP[2][0]=='' && ((gridSP[0][2]=='' && gridSP[2][2]=='') || (gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[1][0]=='' && gridSP[2][2]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Left Arrow Defence
  else if (gridSP[0][0]=='' && gridSP[1][1]=='O' && gridSP[2][0]=='O' && ((gridSP[0][2]=='' && gridSP[2][2]=='') || (gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[1][0]=='' && gridSP[2][2]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Left Arrow Defence
  else if (gridSP[2][2]=='O' && gridSP[1][1]=='' && gridSP[2][0]=='O' && ((gridSP[0][2]=='' && gridSP[0][0]=='') || (gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][1]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Down Arrow Defence
  else if (gridSP[2][2]=='O' && gridSP[1][1]=='O' && gridSP[2][0]=='' && ((gridSP[0][2]=='' && gridSP[0][0]=='') || (gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][1]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Down Arrow Defence
  else if (gridSP[2][2]=='' && gridSP[1][1]=='O' && gridSP[2][0]=='O' && ((gridSP[0][2]=='' && gridSP[0][0]=='') || (gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][1]==''))) {
    gridSP[2][2]=turnSP; return;
  } // Down Arrow Defence
  else if (gridSP[2][2]=='O' && gridSP[1][1]=='' && gridSP[0][2]=='O' && ((gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[1][2]=='' && gridSP[0][0]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Right Arrow Defence
  else if (gridSP[2][2]=='O' && gridSP[1][1]=='O' && gridSP[0][2]=='' && ((gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[1][2]=='' && gridSP[0][0]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Right Arrow Defence
  else if (gridSP[2][2]=='' && gridSP[1][1]=='O' && gridSP[0][2]=='O' && ((gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[1][2]=='' && gridSP[0][0]==''))) {
    gridSP[2][2]=turnSP; return;
  } // Right Arrow Defence
  else if (gridSP[0][0]=='O' && gridSP[1][1]=='' && gridSP[0][2]=='O' && ((gridSP[2][0]=='' && gridSP[2][2]=='') || (gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[2][2]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Up Arrow Defence
  else if (gridSP[0][0]=='O' && gridSP[1][1]=='O' && gridSP[0][2]=='' && ((gridSP[2][0]=='' && gridSP[2][2]=='') || (gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[2][2]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Up Arrow Defence
  else if (gridSP[0][0]=='' && gridSP[1][1]=='O' && gridSP[0][2]=='O' && ((gridSP[2][0]=='' && gridSP[2][2]=='') || (gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[2][2]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Up Arrow Defence
  else if (gridSP[0][0]=='O' && gridSP[0][1]=='' && gridSP[1][1]=='O' && ((gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[2][2]=='' && gridSP[2][1]=='') || (gridSP[0][2]=='' && gridSP[2][2]==''))) {
    gridSP[0][1]=turnSP; return;
  } // Top Left T Defence
  else if (gridSP[0][0]=='O' && gridSP[0][1]=='O' && gridSP[1][1]=='' && ((gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[2][2]=='' && gridSP[2][1]=='') || (gridSP[0][2]=='' && gridSP[2][2]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Top Left T Defence
  else if (gridSP[0][0]=='' && gridSP[0][1]=='O' && gridSP[1][1]=='O' && ((gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[2][2]=='' && gridSP[2][1]=='') || (gridSP[0][2]=='' && gridSP[2][2]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Top Left T Defence
  else if (gridSP[0][2]=='O' && gridSP[0][1]=='' && gridSP[1][1]=='O' && ((gridSP[0][0]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][0]=='') || (gridSP[2][0]=='' && gridSP[2][1]==''))) {
    gridSP[0][1]=turnSP; return;
  } // Top Right T Defence
  else if (gridSP[0][2]=='O' && gridSP[0][1]=='O' && gridSP[1][1]=='' && ((gridSP[0][0]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][0]=='') || (gridSP[2][0]=='' && gridSP[2][1]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Top Right T Defence
  else if (gridSP[0][2]=='' && gridSP[0][1]=='O' && gridSP[1][1]=='O' && ((gridSP[0][0]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][0]=='') || (gridSP[2][0]=='' && gridSP[2][1]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Top Right T Defence
  else if (gridSP[0][2]=='O' && gridSP[1][2]=='' && gridSP[1][1]=='O' && ((gridSP[2][2]=='' && gridSP[1][0]=='') || (gridSP[2][0]=='' && gridSP[1][0]=='') || (gridSP[2][2]=='' && gridSP[2][0]==''))) {
    gridSP[1][2]=turnSP; return;
  } // Right Top T Defence
  else if (gridSP[0][2]=='O' && gridSP[1][2]=='O' && gridSP[1][1]=='' && ((gridSP[2][2]=='' && gridSP[1][0]=='') || (gridSP[2][0]=='' && gridSP[1][0]=='') || (gridSP[2][2]=='' && gridSP[2][0]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Right Top T Defence
  else if (gridSP[0][2]=='' && gridSP[1][2]=='O' && gridSP[1][1]=='O' && ((gridSP[2][2]=='' && gridSP[1][0]=='') || (gridSP[2][0]=='' && gridSP[1][0]=='') || (gridSP[2][2]=='' && gridSP[2][0]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Right Top T Defence
  else if (gridSP[2][2]=='O' && gridSP[1][2]=='' && gridSP[1][1]=='O' && ((gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[0][0]=='' && gridSP[1][0]=='') || (gridSP[0][2]=='' && gridSP[0][0]==''))) {
    gridSP[1][2]=turnSP; return;
  } // Right Bottom T Defence
  else if (gridSP[2][2]=='O' && gridSP[1][2]=='O' && gridSP[1][1]=='' && ((gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[0][0]=='' && gridSP[1][0]=='') || (gridSP[0][2]=='' && gridSP[0][0]==''))) {
    gridSP[1][2]=turnSP; return;
  } // Right Bottom T Defence
  else if (gridSP[2][2]=='O' && gridSP[2][1]=='' && gridSP[1][1]=='O' && ((gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[0][0]=='' && gridSP[1][0]=='') || (gridSP[0][2]=='' && gridSP[0][0]==''))) {
    gridSP[2][1]=turnSP; return;
  } // Bottom Right T Defence
  else if (gridSP[2][2]=='O' && gridSP[2][1]=='O' && gridSP[1][1]=='' && ((gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[0][0]=='' && gridSP[0][1]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Bottom Right T Defence
  else if (gridSP[2][2]=='' && gridSP[2][1]=='O' && gridSP[1][1]=='O' && ((gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[0][0]=='' && gridSP[0][1]==''))) {
    gridSP[2][2]=turnSP; return;
  } // Bottom Right T Defence
  else if (gridSP[2][0]=='O' && gridSP[2][1]=='' && gridSP[1][1]=='O' && ((gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[0][0]=='' && gridSP[0][1]==''))) {
    gridSP[2][1]=turnSP; return;
  } // Bottom Left T Defence
  else if (gridSP[2][0]=='O' && gridSP[2][1]=='O' && gridSP[1][1]=='' && ((gridSP[2][2]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[2][2]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Bottom Left T Defence
  else if (gridSP[2][0]=='' && gridSP[2][1]=='O' && gridSP[1][1]=='O' && ((gridSP[2][2]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[2][2]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Bottom Left T Defence
  else if (gridSP[2][0]=='' && gridSP[2][1]=='O' && gridSP[1][1]=='O' && ((gridSP[2][2]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[2][2]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Bottom Left T Defence
  else if (gridSP[2][0]=='O' && gridSP[1][0]=='' && gridSP[1][1]=='O' && ((gridSP[0][0]=='' && gridSP[1][2]=='') || (gridSP[0][0]=='' && gridSP[0][2]=='') || (gridSP[0][2]=='' && gridSP[1][2]==''))) {
    gridSP[1][0]=turnSP; return;
  } // Left Bottom T Defence
  else if (gridSP[2][0]=='O' && gridSP[1][0]=='O' && gridSP[1][1]=='' && ((gridSP[0][0]=='' && gridSP[1][2]=='') || (gridSP[0][0]=='' && gridSP[0][2]=='') || (gridSP[0][2]=='' && gridSP[1][2]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Left Bottom T Defence
  else if (gridSP[2][0]=='' && gridSP[1][0]=='O' && gridSP[1][1]=='O' && ((gridSP[0][0]=='' && gridSP[1][2]=='') || (gridSP[0][0]=='' && gridSP[0][2]=='') || (gridSP[0][2]=='' && gridSP[1][2]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Left Bottom T Defence
  else if (gridSP[0][0]=='O' && gridSP[1][0]=='' && gridSP[1][1]=='O' && ((gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[2][2]=='' && gridSP[2][0]=='') || (gridSP[2][2]=='' && gridSP[1][2]==''))) {
    gridSP[1][0]=turnSP; return;
  } // Left Top T Defence
  else if (gridSP[0][0]=='O' && gridSP[1][0]=='O' && gridSP[1][1]=='' && ((gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[2][2]=='' && gridSP[2][0]=='') || (gridSP[2][2]=='' && gridSP[1][2]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Left Top T Defence
  else if (gridSP[0][0]=='' && gridSP[1][0]=='O' && gridSP[1][1]=='O' && ((gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[2][2]=='' && gridSP[2][0]=='') || (gridSP[2][2]=='' && gridSP[1][2]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Left Top T Defence
  else if (gridSP[0][0]=='O' && gridSP[0][1]=='' && gridSP[2][1]=='O' && gridSP[0][2]=='' && gridSP[1][1]=='') {
    gridSP[0][1]=turnSP; return;
  } // Top Left L Defence
  else if (gridSP[0][0]=='O' && gridSP[0][1]=='O' && gridSP[2][1]=='' && gridSP[0][2]=='' && gridSP[1][1]=='') {
    gridSP[0][1]=turnSP; return;
  } // Top Left L Defence
  else if (gridSP[0][0]=='' && gridSP[0][1]=='O' && gridSP[2][1]=='O' && gridSP[0][2]=='' && gridSP[1][1]=='') {
    gridSP[0][0]=turnSP; return;
  } // Top Left L Defence
  else if (gridSP[0][2]=='O' && gridSP[0][1]=='' && gridSP[2][1]=='O' && gridSP[0][0]=='' && gridSP[1][1]=='') {
    gridSP[0][1]=turnSP; return;
  } // Top Right L Defence
  else if (gridSP[0][2]=='O' && gridSP[0][1]=='O' && gridSP[2][1]=='' && gridSP[0][0]=='' && gridSP[1][1]=='') {
    gridSP[2][1]=turnSP; return;
  } // Top Right L Defence
  else if (gridSP[0][2]=='' && gridSP[0][1]=='O' && gridSP[2][1]=='O' && gridSP[0][0]=='' && gridSP[1][1]=='') {
    gridSP[0][1]=turnSP; return;
  } // Top Right L Defence
  else if (gridSP[0][2]=='O' && gridSP[1][2]=='' && gridSP[1][0]=='O' && gridSP[2][2]=='' && gridSP[1][1]=='') {
    gridSP[1][2]=turnSP; return;
  } // Right Top L Defence
  else if (gridSP[0][2]=='O' && gridSP[1][2]=='O' && gridSP[1][0]=='' && gridSP[2][2]=='' && gridSP[1][1]=='') {
    gridSP[1][0]=turnSP; return;
  } // Right Top L Defence
  else if (gridSP[0][2]=='' && gridSP[1][2]=='O' && gridSP[1][0]=='O' && gridSP[2][2]=='' && gridSP[1][1]=='') {
    gridSP[0][2]=turnSP; return;
  } // Right Top L Defence
  else if (gridSP[2][2]=='O' && gridSP[1][2]=='' && gridSP[1][0]=='O' && gridSP[0][2]=='' && gridSP[1][1]=='') {
    gridSP[1][2]=turnSP; return;
  } // Right Bottom L Defence
  else if (gridSP[2][2]=='O' && gridSP[1][2]=='O' && gridSP[1][0]=='' && gridSP[0][2]=='' && gridSP[1][1]=='') {
    gridSP[1][0]=turnSP; return;
  } // Right Bottom L Defence
  else if (gridSP[2][2]=='' && gridSP[1][2]=='O' && gridSP[1][0]=='O' && gridSP[0][2]=='' && gridSP[1][1]=='') {
    gridSP[2][2]=turnSP; return;
  } // Right Bottom L Defence
  else if (gridSP[0][1]=='O' && gridSP[2][1]=='' && gridSP[2][2]=='O' && gridSP[2][0]=='' && gridSP[1][1]=='') {
    gridSP[2][1]=turnSP; return;
  } // Bottom Right L Defence
  else if (gridSP[0][1]=='O' && gridSP[2][1]=='O' && gridSP[2][2]=='' && gridSP[2][0]=='' && gridSP[1][1]=='') {
    gridSP[2][2]=turnSP; return;
  } // Bottom Right L Defence
  else if (gridSP[0][1]=='' && gridSP[2][1]=='O' && gridSP[2][2]=='O' && gridSP[2][0]=='' && gridSP[1][1]=='') {
    gridSP[0][1]=turnSP; return;
  } // Bottom Right L Defence
  else if (gridSP[0][1]=='O' && gridSP[2][1]=='' && gridSP[2][0]=='O' && gridSP[2][2]=='' && gridSP[1][1]=='') {
    gridSP[2][1]=turnSP; return;
  } // Bottom Left L Defence
  else if (gridSP[0][1]=='O' && gridSP[2][1]=='O' && gridSP[2][0]=='' && gridSP[2][2]=='' && gridSP[1][1]=='') {
    gridSP[2][0]=turnSP; return;
  } // Bottom Left L Defence
  else if (gridSP[0][1]=='' && gridSP[2][1]=='O' && gridSP[2][0]=='O' && gridSP[2][2]=='' && gridSP[1][1]=='') {
    gridSP[0][1]=turnSP; return;
  } // Bottom Left L Defence
  else if (gridSP[2][0]=='O' && gridSP[1][0]=='' && gridSP[1][2]=='O' && gridSP[0][0]=='' && gridSP[1][1]=='') {
    gridSP[1][0]=turnSP; return;
  } // Left Bottom L Defence
  else if (gridSP[2][0]=='O' && gridSP[1][0]=='O' && gridSP[1][2]=='' && gridSP[0][0]=='' && gridSP[1][1]=='') {
    gridSP[1][2]=turnSP; return;
  } // Left Bottom L Defence
  else if (gridSP[2][0]=='' && gridSP[1][0]=='O' && gridSP[1][2]=='O' && gridSP[0][0]=='' && gridSP[1][1]=='') {
    gridSP[2][0]=turnSP; return;
  } // Left Bottom L Defence
  else if (gridSP[0][0]=='O' && gridSP[1][0]=='' && gridSP[1][2]=='O' && gridSP[2][0]=='' && gridSP[1][1]=='') {
    gridSP[1][0]=turnSP; return;
  } // Left Top L Defence
  else if (gridSP[0][0]=='O' && gridSP[1][0]=='O' && gridSP[1][2]=='' && gridSP[2][0]=='' && gridSP[1][1]=='') {
    gridSP[1][2]=turnSP; return;
  } // Left Top L Defence
  else if (gridSP[0][0]=='' && gridSP[1][0]=='O' && gridSP[1][2]=='O' && gridSP[2][0]=='' && gridSP[1][1]=='') {
    gridSP[0][0]=turnSP; return;
  } // Left Top L Defence

  else if (gridSP[0][0]=='X' && gridSP[2][0]=='' && gridSP[2][2]=='X' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[1][0]=='' && gridSP[2][1]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Left Diagonal Left Attack
  else if (gridSP[0][0]=='X' && gridSP[2][0]=='X' && gridSP[2][2]=='' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[1][0]=='' && gridSP[2][1]==''))) {
    gridSP[2][2]=turnSP; return;
  } // Left Diagonal Left Attack
  else if (gridSP[0][0]=='' && gridSP[2][0]=='X' && gridSP[2][2]=='X' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[1][0]=='' && gridSP[2][1]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Left Diagonal Left Attack
  else if (gridSP[0][0]=='X' && gridSP[0][2]=='' && gridSP[2][2]=='X' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][2]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Left Diagonal Right Attack
  else if (gridSP[0][0]=='X' && gridSP[0][2]=='X' && gridSP[2][2]=='' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][2]==''))) {
    gridSP[2][2]=turnSP; return;
  } // Left Diagonal Right Attack
  else if (gridSP[0][0]=='' && gridSP[0][2]=='X' && gridSP[2][2]=='X' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][2]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Left Diagonal Right Attack
  else if (gridSP[0][2]=='X' && gridSP[0][0]=='' && gridSP[2][0]=='X' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][0]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Right Diagonal Left Attack
  else if (gridSP[0][2]=='X' && gridSP[0][0]=='X' && gridSP[2][0]=='' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][0]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Right Diagonal Left Attack
  else if (gridSP[0][2]=='' && gridSP[0][0]=='X' && gridSP[2][0]=='X' && ((gridSP[1][1]=='' && gridSP[1][0]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[1][0]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Right Diagonal Left Attack
  else if (gridSP[0][2]=='X' && gridSP[2][2]=='' && gridSP[2][0]=='X' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[2][1]=='' && gridSP[1][2]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Right Diagonal Right Attack
  else if (gridSP[0][2]=='X' && gridSP[2][2]=='X' && gridSP[2][0]=='' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[2][1]=='' && gridSP[1][2]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Right Diagonal Right Attack
  else if (gridSP[0][2]=='' && gridSP[2][2]=='X' && gridSP[2][0]=='X' && ((gridSP[1][1]=='' && gridSP[1][2]=='') || (gridSP[1][1]=='' && gridSP[2][1]=='') || (gridSP[2][1]=='' && gridSP[1][2]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Right Diagonal Right Attack
  else if (gridSP[0][0]=='X' && gridSP[1][1]=='' && gridSP[2][0]=='X' && ((gridSP[0][2]=='' && gridSP[2][2]=='') || (gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[1][0]=='' && gridSP[2][2]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Left Arrow Attack
  else if (gridSP[0][0]=='X' && gridSP[1][1]=='X' && gridSP[2][0]=='' && ((gridSP[0][2]=='' && gridSP[2][2]=='') || (gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[1][0]=='' && gridSP[2][2]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Left Arrow Attack
  else if (gridSP[0][0]=='' && gridSP[1][1]=='X' && gridSP[2][0]=='X' && ((gridSP[0][2]=='' && gridSP[2][2]=='') || (gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[1][0]=='' && gridSP[2][2]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Left Arrow Attack
  else if (gridSP[2][2]=='X' && gridSP[1][1]=='' && gridSP[2][0]=='X' && ((gridSP[0][2]=='' && gridSP[0][0]=='') || (gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][1]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Down Arrow Attack
  else if (gridSP[2][2]=='X' && gridSP[1][1]=='X' && gridSP[2][0]=='' && ((gridSP[0][2]=='' && gridSP[0][0]=='') || (gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][1]==''))) {
    gridSP[2][0]=turnSP; return;
  } // Down Arrow Attack
  else if (gridSP[2][2]=='' && gridSP[1][1]=='X' && gridSP[2][0]=='X' && ((gridSP[0][2]=='' && gridSP[0][0]=='') || (gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][1]==''))) {
    gridSP[2][2]=turnSP; return;
  } // Down Arrow Attack
  else if (gridSP[2][2]=='X' && gridSP[1][1]=='' && gridSP[0][2]=='X' && ((gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[1][2]=='' && gridSP[0][0]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Right Arrow Attack
  else if (gridSP[2][2]=='X' && gridSP[1][1]=='X' && gridSP[0][2]=='' && ((gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[1][2]=='' && gridSP[0][0]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Right Arrow Attack
  else if (gridSP[2][2]=='' && gridSP[1][1]=='X' && gridSP[0][2]=='X' && ((gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[1][2]=='' && gridSP[0][0]==''))) {
    gridSP[2][2]=turnSP; return;
  } // Right Arrow Attack
  else if (gridSP[0][0]=='X' && gridSP[1][1]=='' && gridSP[0][2]=='X' && ((gridSP[2][0]=='' && gridSP[2][2]=='') || (gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[2][2]==''))) {
    gridSP[1][1]=turnSP; return;
  } // Up Arrow Attack
  else if (gridSP[0][0]=='X' && gridSP[1][1]=='X' && gridSP[0][2]=='' && ((gridSP[2][0]=='' && gridSP[2][2]=='') || (gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[2][2]==''))) {
    gridSP[0][2]=turnSP; return;
  } // Up Arrow Attack
  else if (gridSP[0][0]=='' && gridSP[1][1]=='X' && gridSP[0][2]=='X' && ((gridSP[2][0]=='' && gridSP[2][2]=='') || (gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[0][1]=='' && gridSP[2][2]==''))) {
    gridSP[0][0]=turnSP; return;
  } // Up Arrow Attack
  else if (gridSP[1][0]=='X' && gridSP[2][1]=='X' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[0][1]=='') {
    gridSP[1][1]=turnSP; return;
  } // Bottom Left Corner Out Attack
  else if (gridSP[1][0]=='X' && gridSP[2][1]=='' && gridSP[1][1]=='X' && gridSP[1][2]=='' && gridSP[0][1]=='') {
    gridSP[2][1]=turnSP; return;
  } // Bottom Left Corner Out Attack
  else if (gridSP[1][0]=='' && gridSP[2][1]=='X' && gridSP[1][1]=='X' && gridSP[1][2]=='' && gridSP[0][1]=='') {
    gridSP[1][0]=turnSP; return;
  } // Bottom Left Corner Out Attack
  else if (gridSP[1][2]=='X' && gridSP[2][1]=='X' && gridSP[1][1]=='' && gridSP[1][0]=='' && gridSP[0][1]=='') {
    gridSP[1][1]=turnSP; return;
  } // Bottom Right Corner Out Attack
  else if (gridSP[1][2]=='X' && gridSP[2][1]=='' && gridSP[1][1]=='X' && gridSP[1][0]=='' && gridSP[0][1]=='') {
    gridSP[2][1]=turnSP; return;
  } // Bottom Right Corner Out Attack
  else if (gridSP[1][2]=='' && gridSP[2][1]=='X' && gridSP[1][1]=='X' && gridSP[1][0]=='' && gridSP[0][1]=='') {
    gridSP[1][2]=turnSP; return;
} // Bottom Right Corner Out Attack
else if (gridSP[1][2]=='X' && gridSP[0][1]=='X' && gridSP[1][1]=='' && gridSP[1][0]=='' && gridSP[2][1]=='') {
gridSP[1][1]=turnSP; return;
} // Top Right Corner Out Attack
else if (gridSP[1][2]=='X' && gridSP[0][1]=='' && gridSP[1][1]=='X' && gridSP[1][0]=='' && gridSP[2][1]=='') {
gridSP[0][1]=turnSP; return;
} // Top Right Corner Out Attack
else if (gridSP[1][2]=='' && gridSP[0][1]=='X' && gridSP[1][1]=='X' && gridSP[1][0]=='' && gridSP[2][1]=='') {
gridSP[1][2]=turnSP; return;
} // Top Right Corner Out Attack
else if (gridSP[1][0]=='X' && gridSP[0][1]=='X' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[2][1]=='') {
gridSP[1][1]=turnSP; return;
} // Top Left Corner Out Attack
else if (gridSP[1][0]=='X' && gridSP[0][1]=='' && gridSP[1][1]=='X' && gridSP[1][2]=='' && gridSP[2][1]=='') {
gridSP[0][1]=turnSP; return;
} // Top Left Corner Out Attack
else if (gridSP[1][0]=='' && gridSP[0][1]=='X' && gridSP[1][1]=='X' && gridSP[1][2]=='' && gridSP[2][1]=='') {
gridSP[1][0]=turnSP; return;
} // Top Left Corner Out Attack
else if (gridSP[1][0]=='X' && gridSP[2][1]=='X' && gridSP[2][0]=='' && gridSP[0][0]=='' && gridSP[2][2]=='') {
gridSP[2][0]=turnSP; return;
} // Bottom Left Corner In Attack
else if (gridSP[1][0]=='X' && gridSP[2][1]=='' && gridSP[2][0]=='X' && gridSP[0][0]=='' && gridSP[2][2]=='') {
gridSP[2][1]=turnSP; return;
} // Bottom Left Corner In Attack
else if (gridSP[1][0]=='' && gridSP[2][1]=='X' && gridSP[2][0]=='X' && gridSP[0][0]=='' && gridSP[2][2]=='') {
gridSP[1][0]=turnSP; return;
} // Bottom Left Corner In Attack
else if (gridSP[1][2]=='X' && gridSP[2][1]=='X' && gridSP[2][2]=='' && gridSP[0][2]=='' && gridSP[2][0]=='') {
gridSP[2][2]=turnSP; return;
} // Bottom Right Corner In Attack
else if (gridSP[1][2]=='X' && gridSP[2][1]=='' && gridSP[2][2]=='X' && gridSP[0][2]=='' && gridSP[2][0]=='') {
gridSP[2][1]=turnSP; return;
} // Bottom Right Corner In Attack
else if (gridSP[1][2]=='' && gridSP[2][1]=='X' && gridSP[2][2]=='X' && gridSP[0][2]=='' && gridSP[2][0]=='') {
gridSP[1][0]=turnSP; return;
} // Bottom Right Corner In Attack
else if (gridSP[1][2]=='X' && gridSP[0][1]=='X' && gridSP[0][2]=='' && gridSP[0][0]=='' && gridSP[2][2]=='') {
gridSP[0][2]=turnSP; return;
} // Top Right Corner In Attack
else if (gridSP[1][2]=='X' && gridSP[0][1]=='' && gridSP[0][2]=='X' && gridSP[0][0]=='' && gridSP[2][2]=='') {
gridSP[0][1]=turnSP; return;
} // Top Right Corner In Attack
else if (gridSP[1][2]=='' && gridSP[0][1]=='X' && gridSP[0][2]=='X' && gridSP[0][0]=='' && gridSP[2][2]=='') {
gridSP[1][2]=turnSP; return;
} // Top Right Corner In Attack
else if (gridSP[1][0]=='X' && gridSP[0][1]=='X' && gridSP[0][0]=='' && gridSP[0][2]=='' && gridSP[2][0]=='') {
gridSP[0][2]=turnSP; return;
} // Top Left Corner In Attack
else if (gridSP[1][0]=='X' && gridSP[0][1]=='' && gridSP[0][0]=='X' && gridSP[0][2]=='' && gridSP[2][0]=='') {
gridSP[0][1]=turnSP; return;
} // Top Left Corner In Attack
else if (gridSP[1][0]=='' && gridSP[0][1]=='X' && gridSP[0][0]=='X' && gridSP[0][2]=='' && gridSP[2][0]=='') {
gridSP[1][0]=turnSP; return;
} // Top Left Corner In Attack
else if (gridSP[0][0]=='' && gridSP[0][1]=='' && gridSP[0][2]=='' && gridSP[1][0]=='' && gridSP[1][1]=='' && gridSP[1][2]=='' && gridSP[2][0]=='' && gridSP[2][1]=='' && gridSP[2][2]=='') {
int seedCount = randomGenerator.nextInt(5); // Middle Down Attack
if (seedCount==0) { gridSP[0][0]=turnSP; return; }
else if (seedCount==1) { gridSP[0][2]=turnSP; return; }
else if (seedCount==2) { gridSP[1][1]=turnSP; return; }
else if (seedCount==3) { gridSP[2][0]=turnSP; return; }
else if (seedCount==4) { gridSP[2][2]=turnSP; return; }
}
else if (gridSP[1][1]=='X' && gridSP[2][1]=='X' && gridSP[0][1]=='' && gridSP[1][0]=='' && gridSP[1][2]=='') {
int seedCount = randomGenerator.nextInt(3); // Middle Down Attack
if (seedCount==0) { gridSP[0][1]=turnSP; return; }
else if (seedCount==1) { gridSP[1][0]=turnSP; return; }
else if (seedCount==2) { gridSP[1][2]=turnSP; return; }
}
else if (gridSP[1][1]=='X' && gridSP[2][1]=='' && gridSP[0][1]=='X' && gridSP[1][0]=='' && gridSP[1][2]=='') {
int seedCount = randomGenerator.nextInt(3); // Middle Up Attack
if (seedCount==0) { gridSP[2][1]=turnSP; return; }
else if (seedCount==1) { gridSP[1][0]=turnSP; return; }
else if (seedCount==2) { gridSP[1][2]=turnSP; return; }
}
else if (gridSP[1][1]=='X' && gridSP[2][1]=='' && gridSP[0][1]=='' && gridSP[1][0]=='X' && gridSP[1][2]=='') {
int seedCount = randomGenerator.nextInt(3); // Middle Left Attack
if (seedCount==0) { gridSP[2][1]=turnSP; return; }
else if (seedCount==1) { gridSP[0][1]=turnSP; return; }
else if (seedCount==2) { gridSP[1][2]=turnSP; return; }
}
else if (gridSP[1][1]=='X' && gridSP[2][1]=='' && gridSP[0][1]=='' && gridSP[1][0]=='' && gridSP[1][2]=='X') {
int seedCount = randomGenerator.nextInt(3); // Middle Right Attack
if (seedCount==0) { gridSP[2][1]=turnSP; return; }
else if (seedCount==1) { gridSP[0][1]=turnSP; return; }
else if (seedCount==2) { gridSP[1][0]=turnSP; return; }
}
else if (gridSP[0][0]=='X' && gridSP[0][1]=='' && gridSP[1][1]=='X' && ((gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[2][2]=='' && gridSP[2][1]=='') || (gridSP[0][2]=='' && gridSP[2][2]==''))) {
gridSP[0][1]=turnSP; return;
} // Top Left T Attack
else if (gridSP[0][0]=='X' && gridSP[0][1]=='X' && gridSP[1][1]=='' && ((gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[2][2]=='' && gridSP[2][1]=='') || (gridSP[0][2]=='' && gridSP[2][2]==''))) {
gridSP[1][1]=turnSP; return;
} // Top Left T Attack
else if (gridSP[0][0]=='' && gridSP[0][1]=='X' && gridSP[1][1]=='X' && ((gridSP[0][2]=='' && gridSP[2][1]=='') || (gridSP[2][2]=='' && gridSP[2][1]=='') || (gridSP[0][2]=='' && gridSP[2][2]==''))) {
gridSP[0][0]=turnSP; return;
} // Top Left T Attack
else if (gridSP[0][2]=='X' && gridSP[0][1]=='' && gridSP[1][1]=='X' && ((gridSP[0][0]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][0]=='') || (gridSP[2][0]=='' && gridSP[2][1]==''))) {
gridSP[0][1]=turnSP; return;
} // Top Right T Attack
else if (gridSP[0][2]=='X' && gridSP[0][1]=='X' && gridSP[1][1]=='' && ((gridSP[0][0]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][0]=='') || (gridSP[2][0]=='' && gridSP[2][1]==''))) {
gridSP[1][1]=turnSP; return;
} // Top Right T Attack
else if (gridSP[0][2]=='' && gridSP[0][1]=='X' && gridSP[1][1]=='X' && ((gridSP[0][0]=='' && gridSP[2][1]=='') || (gridSP[0][0]=='' && gridSP[2][0]=='') || (gridSP[2][0]=='' && gridSP[2][1]==''))) {
gridSP[0][2]=turnSP; return;
} // Top Right T Attack
else if (gridSP[0][2]=='X' && gridSP[1][2]=='' && gridSP[1][1]=='X' && ((gridSP[2][2]=='' && gridSP[1][0]=='') || (gridSP[2][0]=='' && gridSP[1][0]=='') || (gridSP[2][2]=='' && gridSP[2][0]==''))) {
gridSP[1][2]=turnSP; return;
} // Right Top T Attack
else if (gridSP[0][2]=='X' && gridSP[1][2]=='X' && gridSP[1][1]=='' && ((gridSP[2][2]=='' && gridSP[1][0]=='') || (gridSP[2][0]=='' && gridSP[1][0]=='') || (gridSP[2][2]=='' && gridSP[2][0]==''))) {
gridSP[1][1]=turnSP; return;
} // Right Top T Attack
else if (gridSP[0][2]=='' && gridSP[1][2]=='X' && gridSP[1][1]=='X' && ((gridSP[2][2]=='' && gridSP[1][0]=='') || (gridSP[2][0]=='' && gridSP[1][0]=='') || (gridSP[2][2]=='' && gridSP[2][0]==''))) {
gridSP[0][2]=turnSP; return;
} // Right Top T Attack
else if (gridSP[2][2]=='X' && gridSP[1][2]=='' && gridSP[1][1]=='X' && ((gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[0][0]=='' && gridSP[1][0]=='') || (gridSP[0][2]=='' && gridSP[0][0]==''))) {
gridSP[1][2]=turnSP; return;
} // Right Bottom T Attack
else if (gridSP[2][2]=='X' && gridSP[1][2]=='X' && gridSP[1][1]=='' && ((gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[0][0]=='' && gridSP[1][0]=='') || (gridSP[0][2]=='' && gridSP[0][0]==''))) {
gridSP[1][2]=turnSP; return;
} // Right Bottom T Attack
else if (gridSP[2][2]=='X' && gridSP[2][1]=='' && gridSP[1][1]=='X' && ((gridSP[0][2]=='' && gridSP[1][0]=='') || (gridSP[0][0]=='' && gridSP[1][0]=='') || (gridSP[0][2]=='' && gridSP[0][0]==''))) {
gridSP[2][1]=turnSP; return;
} // Bottom Right T Attack
else if (gridSP[2][2]=='X' && gridSP[2][1]=='X' && gridSP[1][1]=='' && ((gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[0][0]=='' && gridSP[0][1]==''))) {
gridSP[1][1]=turnSP; return;
} // Bottom Right T Attack
else if (gridSP[2][2]=='' && gridSP[2][1]=='X' && gridSP[1][1]=='X' && ((gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[0][0]=='' && gridSP[0][1]==''))) {
gridSP[2][2]=turnSP; return;
} // Bottom Right T Attack
else if (gridSP[2][0]=='X' && gridSP[2][1]=='' && gridSP[1][1]=='X' && ((gridSP[2][0]=='' && gridSP[0][1]=='') || (gridSP[2][0]=='' && gridSP[0][0]=='') || (gridSP[0][0]=='' && gridSP[0][1]==''))) {
gridSP[2][1]=turnSP; return;
} // Bottom Left T Attack
else if (gridSP[2][0]=='X' && gridSP[2][1]=='X' && gridSP[1][1]=='' && ((gridSP[2][2]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[2][2]==''))) {
gridSP[1][1]=turnSP; return;
} // Bottom Left T Attack
else if (gridSP[2][0]=='' && gridSP[2][1]=='X' && gridSP[1][1]=='X' && ((gridSP[2][2]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[2][2]==''))) {
gridSP[2][0]=turnSP; return;
} // Bottom Left T Attack
else if (gridSP[2][0]=='' && gridSP[2][1]=='X' && gridSP[1][1]=='X' && ((gridSP[2][2]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[0][1]=='') || (gridSP[1][1]=='' && gridSP[2][2]==''))) {
gridSP[2][0]=turnSP; return;
} // Bottom Left T Attack
else if (gridSP[2][0]=='X' && gridSP[1][0]=='' && gridSP[1][1]=='X' && ((gridSP[0][0]=='' && gridSP[1][2]=='') || (gridSP[0][0]=='' && gridSP[0][2]=='') || (gridSP[0][2]=='' && gridSP[1][2]==''))) {
gridSP[1][0]=turnSP; return;
} // Left Bottom T Attack
else if (gridSP[2][0]=='X' && gridSP[1][0]=='X' && gridSP[1][1]=='' && ((gridSP[0][0]=='' && gridSP[1][2]=='') || (gridSP[0][0]=='' && gridSP[0][2]=='') || (gridSP[0][2]=='' && gridSP[1][2]==''))) {
gridSP[1][1]=turnSP; return;
} // Left Bottom T Attack
else if (gridSP[2][0]=='' && gridSP[1][0]=='X' && gridSP[1][1]=='X' && ((gridSP[0][0]=='' && gridSP[1][2]=='') || (gridSP[0][0]=='' && gridSP[0][2]=='') || (gridSP[0][2]=='' && gridSP[1][2]==''))) {
gridSP[2][0]=turnSP; return;
} // Left Bottom T Attack
else if (gridSP[0][0]=='X' && gridSP[1][0]=='' && gridSP[1][1]=='X' && ((gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[2][2]=='' && gridSP[2][0]=='') || (gridSP[2][2]=='' && gridSP[1][2]==''))) {
gridSP[1][0]=turnSP; return;
} // Left Top T Attack
else if (gridSP[0][0]=='X' && gridSP[1][0]=='X' && gridSP[1][1]=='' && ((gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[2][2]=='' && gridSP[2][0]=='') || (gridSP[2][2]=='' && gridSP[1][2]==''))) {
gridSP[1][1]=turnSP; return;
} // Left Top T Attack
else if (gridSP[0][0]=='' && gridSP[1][0]=='X' && gridSP[1][1]=='X' && ((gridSP[2][0]=='' && gridSP[1][2]=='') || (gridSP[2][2]=='' && gridSP[2][0]=='') || (gridSP[2][2]=='' && gridSP[1][2]==''))) {
gridSP[0][0]=turnSP; return;
} // Left Top T Attack
else if (gridSP[0][0]=='X' && gridSP[0][1]=='' && gridSP[2][1]=='X' && gridSP[0][2]=='' && gridSP[1][1]=='') {
gridSP[0][1]=turnSP; return;
} // Top Left L Attack
else if (gridSP[0][0]=='X' && gridSP[0][1]=='X' && gridSP[2][1]=='' && gridSP[0][2]=='' && gridSP[1][1]=='') {
gridSP[0][1]=turnSP; return;
} // Top Left L Attack
else if (gridSP[0][0]=='' && gridSP[0][1]=='X' && gridSP[2][1]=='X' && gridSP[0][2]=='' && gridSP[1][1]=='') {
gridSP[0][0]=turnSP; return;
} // Top Left L Attack
else if (gridSP[0][2]=='X' && gridSP[0][1]=='' && gridSP[2][1]=='X' && gridSP[0][0]=='' && gridSP[1][1]=='') {
gridSP[0][1]=turnSP; return;
} // Top Right L Attack
else if (gridSP[0][2]=='X' && gridSP[0][1]=='X' && gridSP[2][1]=='' && gridSP[0][0]=='' && gridSP[1][1]=='') {
gridSP[2][1]=turnSP; return;
} // Top Right L Attack
else if (gridSP[0][2]=='' && gridSP[0][1]=='X' && gridSP[2][1]=='X' && gridSP[0][0]=='' && gridSP[1][1]=='') {
gridSP[0][1]=turnSP; return;
} // Top Right L Attack
else if (gridSP[0][2]=='X' && gridSP[1][2]=='' && gridSP[1][0]=='X' && gridSP[2][2]=='' && gridSP[1][1]=='') {
gridSP[1][2]=turnSP; return;
} // Right Top L Attack
else if (gridSP[0][2]=='X' && gridSP[1][2]=='X' && gridSP[1][0]=='' && gridSP[2][2]=='' && gridSP[1][1]=='') {
gridSP[1][0]=turnSP; return;
} // Right Top L Attack
else if (gridSP[0][2]=='' && gridSP[1][2]=='X' && gridSP[1][0]=='X' && gridSP[2][2]=='' && gridSP[1][1]=='') {
gridSP[0][2]=turnSP; return;
} // Right Top L Attack
else if (gridSP[2][2]=='X' && gridSP[1][2]=='' && gridSP[1][0]=='X' && gridSP[0][2]=='' && gridSP[1][1]=='') {
gridSP[1][2]=turnSP; return;
} // Right Bottom L Attack
else if (gridSP[2][2]=='X' && gridSP[1][2]=='X' && gridSP[1][0]=='' && gridSP[0][2]=='' && gridSP[1][1]=='') {
gridSP[1][0]=turnSP; return;
} // Right Bottom L Attack
else if (gridSP[2][2]=='' && gridSP[1][2]=='X' && gridSP[1][0]=='X' && gridSP[0][2]=='' && gridSP[1][1]=='') {
gridSP[2][2]=turnSP; return;
} // Right Bottom L Attack
else if (gridSP[0][1]=='X' && gridSP[2][1]=='' && gridSP[2][2]=='X' && gridSP[2][0]=='' && gridSP[1][1]=='') {
gridSP[2][1]=turnSP; return;
} // Bottom Right L Attack
else if (gridSP[0][1]=='X' && gridSP[2][1]=='X' && gridSP[2][2]=='' && gridSP[2][0]=='' && gridSP[1][1]=='') {
gridSP[2][2]=turnSP; return;
} // Bottom Right L Attack
else if (gridSP[0][1]=='' && gridSP[2][1]=='X' && gridSP[2][2]=='X' && gridSP[2][0]=='' && gridSP[1][1]=='') {
gridSP[0][1]=turnSP; return;
} // Bottom Right L Attack
else if (gridSP[0][1]=='X' && gridSP[2][1]=='' && gridSP[2][0]=='X' && gridSP[2][2]=='' && gridSP[1][1]=='') {
gridSP[2][1]=turnSP; return;
} // Bottom Left L Attack
else if (gridSP[0][1]=='X' && gridSP[2][1]=='X' && gridSP[2][0]=='' && gridSP[2][2]=='' && gridSP[1][1]=='') {
gridSP[2][0]=turnSP; return;
} // Bottom Left L Attack
else if (gridSP[0][1]=='' && gridSP[2][1]=='X' && gridSP[2][0]=='X' && gridSP[2][2]=='' && gridSP[1][1]=='') {
gridSP[0][1]=turnSP; return;
} // Bottom Left L Attack
else if (gridSP[2][0]=='X' && gridSP[1][0]=='' && gridSP[1][2]=='X' && gridSP[0][0]=='' && gridSP[1][1]=='') {
gridSP[1][0]=turnSP; return;
} // Left Bottom L Attack
else if (gridSP[2][0]=='X' && gridSP[1][0]=='X' && gridSP[1][2]=='' && gridSP[0][0]=='' && gridSP[1][1]=='') {
gridSP[1][2]=turnSP; return;
} // Left Bottom L Attack
else if (gridSP[2][0]=='' && gridSP[1][0]=='X' && gridSP[1][2]=='X' && gridSP[0][0]=='' && gridSP[1][1]=='') {
gridSP[2][0]=turnSP; return;
} // Left Bottom L Attack
else if (gridSP[0][0]=='X' && gridSP[1][0]=='' && gridSP[1][2]=='X' && gridSP[2][0]=='' && gridSP[1][1]=='') {
gridSP[1][0]=turnSP; return;
} // Left Top L Attack
else if (gridSP[0][0]=='X' && gridSP[1][0]=='X' && gridSP[1][2]=='' && gridSP[2][0]=='' && gridSP[1][1]=='') {
gridSP[1][2]=turnSP; return;
} // Left Top L Attack
else if (gridSP[0][0]=='' && gridSP[1][0]=='X' && gridSP[1][2]=='X' && gridSP[2][0]=='' && gridSP[1][1]=='') {
gridSP[0][0]=turnSP; return;
} // Left Top L Attack

  seedElementRandomly();
}