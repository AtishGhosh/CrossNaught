import 'package:crossnaught/appicons_icons.dart';
import 'package:flutter/material.dart';
import 'package:crossnaught/gameMP.dart';
import 'package:crossnaught/gameSP.dart';
import 'themes.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main () {
  runApp(MyApp());
}

bool aiEnabled=false;
bool intro=true;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSettings();
    loadSPgame();
    loadMPgame();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
    ));
    tempDifficulty = difficulty;
    return MaterialApp(
      title: 'CrossNaught',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat'
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        applyElevationOverlayColor: true,
        fontFamily: 'Montserrat'
      ),
      themeMode: systemThemeMode,
      home: Builder(builder: (context) {
        if (systemThemeMode == ThemeMode.dark) { darkModeEnabled = true; }
        else if (systemThemeMode == ThemeMode.light) { darkModeEnabled = false; }
        else {
          if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
            darkModeEnabled = true;
          } else { darkModeEnabled = false; }
        }
        return intro?Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: GestureDetector(
              onLongPress: () {
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
                            title: Center(child: Text('Info', style: TextStyle(fontFamily: 'Monserrat', fontSize: 24.0, fontWeight: FontWeight.w300))),
                            content: SizedBox(
                              height: 160.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                verticalDirection: VerticalDirection.down,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.info_outline),
                                            Text('  About  ')
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {setState(() {
                                      Navigator.of(context).pop();
                                      showAboutDialog(
                                          context: context,
                                          applicationIcon: Icon(Appicons.appiconslight, size: 32.0),
                                          applicationName: 'CrossNaught',
                                          applicationVersion: '1.2',
                                          applicationLegalese: 'Developed by Atish Ghosh\n2020',
                                          children: <Widget> [
                                            Text(
                                              appDescription(),
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12.0,
                                                  color: Colors.grey[500]
                                              ),
                                            )
                                          ]
                                      );
                                    }); },
                                  ),
                                  GestureDetector(
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.tune),
                                            Text('Tutorial')
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {setState(() {
                                      intro=false;
                                      Navigator.of(context).pop();
                                    }); },
                                  )
                                ],
                              ),
                            ),
                            //content: ,
                          ),
                        ),
                      );
                    },
                    transitionDuration: Duration(milliseconds: 200),
                    barrierDismissible: true,
                    barrierLabel: '',
                    context: context,
                    pageBuilder: (context, animation1, animation2) {});
              },
              child: Text('CROSSNAUGHT',
                style: TextStyle(
                  fontFamily: 'Monserrat',
                  fontSize: 28.0,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            elevation: 0.0,
            centerTitle: true,
          ),
          body: aiEnabled?GameSP():GameMP(),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                    (aiEnabled==true)?Icons.android:Icons.people,
                    size: (aiEnabled==true)?28.0:32.0
                ),
                onPressed: () async{
                  setState(() {
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
                                title: Center(child: Text('PLAYER MODE', style: TextStyle(fontFamily: 'Monserrat', fontSize: 24.0, fontWeight: FontWeight.w300))),
                                content: SizedBox(
                                  height: 160.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    verticalDirection: VerticalDirection.down,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                (aiEnabled==true)?Icon(
                                                  Icons.android,
                                                  size: 28.0,
                                                  color: Colors.blue,
                                                ):Icon(Icons.android, size: 28.0),
                                                (aiEnabled==true)?Text(
                                                    'Singleplayer', style: TextStyle(color: Colors.blue)):Text('Singleplayer')
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async{setState(() {
                                          aiEnabled=true;
                                          Navigator.of(context).pop();
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
                                        }); saveAi(); },
                                      ),
                                      GestureDetector(
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                (aiEnabled==false)?Icon(
                                                  Icons.people,
                                                  size: 32.0,
                                                  color: Colors.blue,
                                                ):Icon(Icons.people, size: 32.0),
                                                (aiEnabled==false)?Text(
                                                    'Multiplayer', style: TextStyle(color: Colors.blue)):Text('Multiplayer')
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async{setState(() {
                                          aiEnabled=false;
                                          Navigator.of(context).pop();
                                        }); saveAi(); },
                                      )
                                    ],
                                  ),
                                ),
                                //content: ,
                              ),
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {});
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  appThemeIcon(),
                  size: 28.0,
                ),
                onPressed: () async{
                  setState(() {
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
                                title: Center(child: Text('THEME', style: TextStyle(fontFamily: 'Monserrat', fontSize: 24.0, fontWeight: FontWeight.w300))),
                                content: SizedBox(
                                  height: 160.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    verticalDirection: VerticalDirection.down,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                (appThemeIcon()==Icons.brightness_auto)?Icon(
                                                  Icons.brightness_auto,
                                                  size: 28.0,
                                                  color: Colors.blue,
                                                ):Icon(Icons.brightness_auto, size: 28.0),
                                                (appThemeIcon()==Icons.brightness_auto)?Text(
                                                    'System', style: TextStyle(color: Colors.blue)):Text('System')
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async{setState(() {
                                          switchTheme(0);
                                          Navigator.of(context).pop();
                                        }); saveTheme(0); },
                                      ),
                                      GestureDetector(
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                (appThemeIcon()==Icons.brightness_high)?Icon(
                                                  Icons.brightness_high,
                                                  size: 28.0,
                                                  color: Colors.blue,
                                                ):Icon(Icons.brightness_high, size: 28.0),
                                                (appThemeIcon()==Icons.brightness_high)?Text(
                                                    '  Light  ', style: TextStyle(color: Colors.blue)):Text('  Light  ')
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async{setState(() {
                                          switchTheme(1);
                                          Navigator.of(context).pop();
                                        }); saveTheme(1); },
                                      ),
                                      GestureDetector(
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                (appThemeIcon()==Icons.brightness_4)?Icon(
                                                  Icons.brightness_4,
                                                  size: 28.0,
                                                  color: Colors.blue,
                                                ):Icon(Icons.brightness_4, size: 28.0),
                                                (appThemeIcon()==Icons.brightness_4)?Text(
                                                    '  Dark  ', style: TextStyle(color: Colors.blue)):Text('  Dark  ')
                                              ],
                                            ),
                                          ),
                                        ),
                                        onTap: () async{setState(() {
                                          switchTheme(2);
                                          Navigator.of(context).pop();
                                        }); saveTheme(2); },
                                      )
                                    ],
                                  ),
                                ),
                                //content: ,
                              ),
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {});
                  });
                },
              )
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: GestureDetector(
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
                              title: Center(child: Text('Reset Score', style: TextStyle(fontFamily: 'Monserrat', fontSize: 24.0, fontWeight: FontWeight.w300))),
                              content: SizedBox(
                                  height: 120.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Are you sure you want to reset the score?'),
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
                                                        'Reset',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.red),
                                                      )
                                                  ),
                                                ),
                                              ),
                                              onTap: () async{
                                                if (aiEnabled==true) {
                                                  setState(() {
                                                    countOSP=0;
                                                    countXPC=0;
                                                    initNewGameSP();
                                                    startElementSP=turnSP='O';
                                                  });
                                                  saveSPgame();
                                                }
                                                else if (aiEnabled==false) {
                                                  setState(() {
                                                    countOMP=0;
                                                    countXMP=0;
                                                    initNewGameMP();
                                                    startElementMP=turnMP='O';
                                                  });
                                                  saveMPgame();
                                                }
                                                Navigator.of(context).pop();
                                              }
                                          ),
                                          GestureDetector(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                                                child: Card(
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        'Cancel',
                                                        textAlign: TextAlign.center,
                                                      )
                                                  ),
                                                ),
                                              ),
                                              onTap: () async{
                                                Navigator.of(context).pop();
                                              }
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
            child: FloatingActionButton(
              onPressed: () async{
                if (aiEnabled==true) {
                  setState(() {
                    initNewGameSP(); saveSPgame();
                    if (startElementSP=='X') { seedElementX(); saveSPgame(); }
                  });
                  saveSPgame();
                }
                else if (aiEnabled==false) {
                  setState(() {
                    initNewGameMP();
                  });
                  saveMPgame();
                }
              },
              elevation: 0.0,
              child: Icon(
                Icons.cached,
                size: 48.0,
              ),
            ),
          ),
        ):Introduction(); }
      ),
    );
  }
  Widget Introduction () {
    return Scaffold(
      appBar: AppBar(
        title: Text('CROSSNAUGHT',
          style: TextStyle(
              fontFamily: 'Monserrat',
              fontSize: 28.0,
              letterSpacing: 8.0,
              fontWeight: FontWeight.w400
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Tutorial',
                  style: TextStyle(fontSize: 24.0, letterSpacing: 2.0),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Player', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                      Text('Long press will let you change\nthe player\'s name.',
                          style: TextStyle(fontSize: 12.0, inherit: true))
                    ],
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Computer', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                      Text('Long press will let you set the\ndifficulty between 1 and 5.',
                          style: TextStyle(fontSize: 12.0, inherit: true))
                    ],
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.cached, color: Colors.blue),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Reset', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                      Text('Tap will set the game to rematch\nLong Press will reset the scoreboard',
                      style: TextStyle(fontSize: 12.0, inherit: true))
                    ],
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.android, color: Colors.blue),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Mode', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                      Text('Selects the game mode between\nSingleplayer and Multiplayer.',
                          style: TextStyle(fontSize: 12.0, inherit: true))
                    ],
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.brightness_auto, color: Colors.blue),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Theme', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                      Text('Selects the app theme\nbetween light and dark.',
                          style: TextStyle(fontSize: 12.0, inherit: true))
                    ],
                  ),
                ),
              ),
              FlatButton(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                onPressed: () async{
                  setState(() {
                    intro=true;
                  });
                  saveIntro();
                },
                child: Text('Done', style: TextStyle(fontSize: 20.0, color: Colors.blue))
              )
            ],
          ),
        ),
      ),
    );
  }
  Future saveTheme (int saveTheme) async{
    setState(() {
      saveTheme = getThemeValue();
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('savedTheme', saveTheme);
  }
  Future saveSPdifficulty () async{
    int diffSave;
    setState(() {
      diffSave = difficulty;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('savedDifficulty', diffSave);
  }
  Future saveIntro () async{
    bool introSave;
    setState(() {
      introSave = intro;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('intro', introSave);
  }
  Future saveAi () async{
    bool saveAi;
    int diff;
    setState(() {
      saveAi = aiEnabled;
      diff = difficulty;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool('savedAi', saveAi);
    await pref.setInt('difficulty', diff);
  }
  Future loadSettings() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    int saveTheme = pref.getInt('savedTheme');
    bool saveAi = pref.getBool('savedAi');
    int diff = pref.getInt('difficulty');
    bool introLoad = pref.getBool('intro');
    setState(() {
      systemThemeMode=getThemeMode(saveTheme);
      aiEnabled = saveAi;
      difficulty = diff;
      intro = introLoad;
      if (difficulty == null) difficulty=3;
      if (aiEnabled == null) aiEnabled=true;
      if (intro == null) intro=false;
    });
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
    await pref.setInt('countXMP', countX);
  }
  Future loadSPgame () async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    int savedDiff = pref.getInt('savedDifficulty');
    if (savedDiff == null) { savedDiff = 3; }
    int countO = pref.getInt('countOSP');
    if (countO == null) { countO = 0; }
    int countX = pref.getInt('countXPC');
    if (countX == null) { countX = 0; }
    String turn = pref.getString('turnSP');
    if (turn == null) { turn = 'O'; }
    String startElement = pref.getString('startElementSP');
    if (startElement == null) { startElement = 'O'; }
    String playerName = pref.getString('nameSP');
    if (playerName == null) { playerName = 'Player'; }
    List<String> gridSP1 = pref.getStringList('firstLineSP');
    if (gridSP1 == null) { gridSP1 = ['', '', '']; }
    List<String> gridSP2 = pref.getStringList('secondLineSP');
    if (gridSP2 == null) { gridSP2 = ['', '', '']; }
    List<String> gridSP3 = pref.getStringList('thirdLineSP');
    if (gridSP3 == null) { gridSP3 = ['', '', '']; }
    setState(() {
      difficulty = savedDiff;
      countOSP = countO;
      countXPC = countX;
      turnSP = turn;
      startElementSP = startElement;
      nameSP = playerName;
      gridSP[0] = gridSP1;
      gridSP[1] = gridSP2;
      gridSP[2] = gridSP3;
    });
  }
  Future loadMPgame () async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    int countO = pref.getInt('countOMP');
    if (countO == null) { countO = 0; }
    int countX = pref.getInt('countXMP');
    if (countX == null) { countX = 0; }
    String turn = pref.getString('turnMP');
    if (turn == null) { turn = randomGenerator.nextBool()?'O':'X'; }
    String startElement = pref.getString('startElementMP');
    if (startElement == null) { startElement = turn; }
    String playerName1 = pref.getString('nameMP1');
    if (playerName1 == null) { playerName1 = 'Player 1'; }
    String playerName2 = pref.getString('nameMP2');
    if (playerName2 == null) { playerName2 = 'Player 2'; }
    List<String> gridMP1 = pref.getStringList('firstLineMP');
    if (gridMP1 == null) { gridMP1 = ['', '', '']; }
    List<String> gridMP2 = pref.getStringList('secondLineMP');
    if (gridMP2 == null) { gridMP2 = ['', '', '']; }
    List<String> gridMP3 = pref.getStringList('thirdLineMP');
    if (gridMP3 == null) { gridMP3 = ['', '', '']; }
    setState(() {
      countOMP = countO;
      countXMP = countX;
      turnMP = turn;
      startElementMP = startElement;
      nameMP1 = playerName1;
      nameMP2 = playerName2;
      gridMP[0] = gridMP1;
      gridMP[1] = gridMP2;
      gridMP[2] = gridMP3;
    });
  }

  String appDescription () {
    return '\nA simple game of Tic Tac Toe developed using Material UI. This application uses Google\'s Flutter framework with the native Java support. It is built as an ad-free experience. For more details, head to the Google Play Store page for this application.\nContact Support: atishghosh30@gmail.com\n';
  }
}