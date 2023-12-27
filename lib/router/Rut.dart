import 'package:biersommelier/database/entities/Post.dart';
import 'package:biersommelier/router/rut/InheritedRut.dart';
import 'package:biersommelier/router/rut/RutDelegate.dart';
import 'package:biersommelier/router/rut/RutParser.dart';
import 'package:biersommelier/router/rut/RutPath.dart';
import 'package:biersommelier/router/rut/toast/Toast.dart';
import 'package:flutter/material.dart';

export 'rut/RutExtension.dart';

/// Eine eigene Router Config für Biersommelier
/// Diese ermöglicht und Eingaben des Nutzers abzufangen und
/// individuell bearbeiten zu können.
class Rut implements RouterConfig<RutPath> {
  late final RutDelegate _delegate = RutDelegate(this);

  Rut();

  @override
  BackButtonDispatcher? get backButtonDispatcher {
    RootBackButtonDispatcher dispatcher = RootBackButtonDispatcher();
    dispatcher.addCallback(_delegate.backButtonPressed);
    return dispatcher;
  }

  @override
  RouteInformationParser<RutPath>? get routeInformationParser => RutParser();

  @override
  RouterDelegate<RutPath> get routerDelegate {
    return _delegate;
  }

  @override
  RouteInformationProvider? get routeInformationProvider => null;

  static Rut of(BuildContext context) {
    Rut? rut = InheritedRut.of(context)?.rut;

    assert(rut != null, 'Router not found');

    return rut!;
  }

  void blockRouting({
    String? description,
    String? buttonSuccessText,
    String? buttonCancelText,
  }) {
    _delegate.blockRouting(
      description: description,
      buttonSuccessText: buttonSuccessText,
      buttonCancelText: buttonCancelText,
    );
  }

  void unblockRouting() {
    _delegate.unblockRouting();
  }

  void jump(
    RutPage page, {
    Function(bool)? change,
    Map<String, Object> arguments = const {},
  }) async {
    return _delegate.jump(page, change: change, arguments: arguments);
  }

  void rebase(RutPath path) {
    _delegate.path = path;
    _delegate.reload();
  }

  void showDialog(Widget? dialog) {
    _delegate.path.dialog = dialog;
    _delegate.reload();
  }

  void showToast(Toast toast) {
    _delegate.showToast(toast);
  }

  RutPath get path {
    return _delegate.path;
  }
}
