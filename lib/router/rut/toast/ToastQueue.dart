import 'dart:collection';

import 'package:biersommelier/router/rut/toast/Toast.dart';

class ToastQueue {
  Queue<Toast> toasts;
  Function()? displayHandler;
  Function()? removeHandler;

  ToastQueue(this.toasts);

  void add(Toast toast) {
    toasts.add(toast);
  }

  void setDisplayHandler(Function() func) {
    displayHandler = func;
  }

  void setRemoveHandler(Function() func) {
    removeHandler = func;
  }
}
