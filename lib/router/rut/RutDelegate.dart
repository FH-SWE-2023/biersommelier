import 'package:biersommelier/components/NavBar.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/InheritedRut.dart';
import 'package:biersommelier/router/rut/JumpAuthorizer.dart';
import 'package:biersommelier/router/rut/RutPath.dart';
import 'package:flutter/material.dart';

class RutDelegate extends RouterDelegate<RutPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RutPath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Rut rut;

  RutDelegate(this.rut);

  RutPath path = RutPath(page: RutPage.log);
  JumpAuthorizer authorizer = JumpAuthorizer(
    defaultDescription: 'Willst du diese Seite wirklich verlassen?',
    defaultButtonSuccessText: 'Bestätigen',
    defaultButtonCancelText: 'Abbrechen',
  );

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
                  bottomNavigationBar: const NavBar(),
                  body: RutPath.findPage(path.page),
                ),
                if (path.dialog != null) path.dialog!,
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

  void jump(RutPage page, {Function(bool)? change}) async {
    authorizer.authorizeJump(rut, (authorized) {
      if (authorized) {
        changePage(page);
      }

      change?.call(authorized);
    });
  }
}
