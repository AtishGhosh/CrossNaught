import 'package:flutter/material.dart';

// Future changelog : Preselect or listen to system
ThemeMode systemThemeMode;
bool darkModeEnabled;

IconData appThemeIcon () {
  if (systemThemeMode == ThemeMode.dark) { return Icons.brightness_4; }
  else if (systemThemeMode == ThemeMode.light) { return Icons.brightness_high; }
  else { return Icons.brightness_auto; }
}
ThemeMode getThemeMode (int value) {
  if (value == 2) { return ThemeMode.dark; }
  else if (value == 1) { return ThemeMode.light; }
  else { return ThemeMode.system; }
}
void switchTheme (int value) {
  if (value == 2) { systemThemeMode = ThemeMode.dark; }
  else if (value == 1) { systemThemeMode = ThemeMode.light; }
  else { systemThemeMode = ThemeMode.system; }
}
int getThemeValue () {
  if ( systemThemeMode == ThemeMode.dark ) { return 2; }
  else if ( systemThemeMode == ThemeMode.light ) { return 1; }
  else { return 0; }
}
Color getIconColorAccordingToTheme (ThemeMode testThemeMode) {
  if (testThemeMode==systemThemeMode) return Colors.blue;
}
ThemeMode appThemeMode (int appThemeModeValue)
{
  if (appThemeModeValue==2) {systemThemeMode=ThemeMode.dark;}
  else if (appThemeModeValue==1) {systemThemeMode=ThemeMode.light;}
  else {systemThemeMode=ThemeMode.system;}
  return systemThemeMode;
}
TextStyle titleTextStyle () {
  return TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      letterSpacing: 8.0,
      fontSize: 24.0
  );
}
TextStyle bodyTextStyle () {
  return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 32.0,
      fontWeight: FontWeight.bold
  );
}
