import 'package:biersommelier/components/NavBar.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/InheritedRut.dart';
import 'package:biersommelier/router/rut/JumpAuthorizer.dart';
import 'package:biersommelier/router/rut/RutPath.dart';
import 'package:biersommelier/router/rut/toast/Toast.dart';
import 'package:biersommelier/router/rut/toast/ToastController.dart';
import 'package:biersommelier/router/rut/toast/ToastDisplay.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';

class RutDelegate extends RouterDelegate<RutPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RutPath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Rut rut;

  RutDelegate(this.rut);

  RutPath path = RutPath(
    page: RutPage.logoScreen,
    hideStatusBar: true,
    dialog: null,
  );

  JumpAuthorizer authorizer = JumpAuthorizer(
    defaultDescription: 'Willst du diese Seite wirklich verlassen?',
    defaultButtonSuccessText: 'Bestätigen',
    defaultButtonCancelText: 'Abbrechen',
  );

  ToastController toastController = ToastController();

  @override
  Widget build(BuildContext context) {
    return InheritedRut(
      rut: rut,
      child: Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(
            key: const ValueKey('page'),
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.white,
                  bottomNavigationBar: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1200),
                    switchInCurve: Curves.bounceOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      final inAnimation = Tween<Offset>(
                        begin: const Offset(0, 1.2),
                        end: const Offset(0, 0),
                      ).animate(animation);

                      return SlideTransition(
                        position: inAnimation,
                        child: child,
                      );
                    },
                    child: path.hideStatusBar
                        ? const SizedBox(height: 0, width: 0)
                        : const NavBar(),
                  ),
                  body: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: RutPath.findPage(path.page),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: path.dialog,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: ToastDisplay(toastController),
                )
              ],
            ),
          ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }

          path.dialog = null;

          notifyListeners();

          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(RutPath configuration) async {
    path = configuration;
  }

  Future<bool> backButtonPressed() async {
    return true;
  }

  void blockRouting({
    String? description,
    String? buttonSuccessText,
    String? buttonCancelText,
  }) {
    authorizer.userRequestMode();
    authorizer.setPrompt(
      description: description,
      buttonSuccessText: buttonSuccessText,
      buttonCancelText: buttonCancelText,
    );
  }

  void unblockRouting() {
    authorizer.grantMode();
  }

  void reload() {
    notifyListeners();
  }

  void changePage(RutPage page) {
    path.page = page;
    reload();
  }

  void showToast(Toast toast) {
    toastController.addToast(toast);
  }

  void jump(
    RutPage page, {
    Function(bool)? change,
    Map<String, Object> arguments = const {},
  }) async {
    authorizer.authorizeJump(rut, (authorized) {
      if (authorized) {
        path.arguments = arguments;
        changePage(page);
      }

      change?.call(authorized);
    });
  }
}
