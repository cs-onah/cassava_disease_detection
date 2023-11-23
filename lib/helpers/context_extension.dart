import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  ThemeData get themeData => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  TextTheme get primaryTextTheme => Theme.of(this).primaryTextTheme;

  Color get primaryColor => themeData.primaryColor;

  Color get cardColor => themeData.cardColor;

  Color get carouselColor => themeData.splashColor;

  Color get errorColor => themeData.colorScheme.error;

  Color get secondaryColor => themeData.colorScheme.secondary;

  Color get scaffoldBackgroundColor => themeData.scaffoldBackgroundColor;

  double get height => MediaQuery.of(this).size.height;

  EdgeInsets get screenPadding => MediaQuery.of(this).padding;

  double get width => MediaQuery.of(this).size.width;

  // AppColorExtension get colors => customTheme<AppColorExtension>();
  //
  // void showLoading() => showDialog(
  //       context: this,
  //       barrierDismissible: false,
  //       useRootNavigator: true,
  //       builder: (_) => WillPopScope(
  //         onWillPop: () async => false,
  //         child: AppLoadingIndicator(),
  //       ),
  //     );

  void showErrorSnackBar(dynamic error) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.cancel, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "$error",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: errorColor,
        ),
      );

  void showMessage(dynamic message, {Duration? duration}) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black54,
          content: Row(
            children: [
              Text("$message", style: TextStyle(color: Colors.white)),
            ],
          ),
          duration: duration ?? Duration(seconds: 1),
        ),
      );

  void showSuccessSnackBar(dynamic message) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text("$message", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );

  T customTheme<T>() => Theme.of(this).extension<T>()!;

  T arg<T>() => ModalRoute.of(this)!.settings.arguments as T;

  bool get canPop => Navigator.of(this).canPop();

  void popToFirstScreen() =>
      Navigator.of(this).popUntil((route) => route.isFirst);

  void pop<T>([T? result]) => Navigator.pop(this, result);

  void openDrawer() => Scaffold.of(this).openDrawer();

  void maybePop<T>([T? result]) => Navigator.maybePop(this, result);

  Future<T?> push<T>(Widget widget, {bool fullscreenDialog = false}) async =>
      await Navigator.push<T>(
        this,
        MaterialPageRoute(
          builder: (context) => widget,
          fullscreenDialog: fullscreenDialog,
        ),
      );

  void pushReplacement(Widget widget) => Navigator.pushReplacement(
      this, MaterialPageRoute(builder: (context) => widget));

  void pushReplacementNamed(String routeName, {Object? arguments}) =>
      Navigator.pushReplacementNamed(this, routeName, arguments: arguments);

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) async =>
      await Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) =>
      Navigator.of(this).pushNamedAndRemoveUntil(newRouteName, predicate,
          arguments: arguments);

  void closeDrawer() => Scaffold.of(this).closeDrawer();
}
