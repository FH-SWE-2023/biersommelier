import 'package:biersommelier/components/ConfirmationDialog.dart';
import 'package:biersommelier/router/Rut.dart';

class JumpAuthorizer {
  bool _active = false;
  String? customDescription;
  String? customButtonSuccessText;
  String? customButtonCancelText;
  String defaultDescription;
  String defaultButtonSuccessText;
  String defaultButtonCancelText;

  JumpAuthorizer({
    required this.defaultDescription,
    required this.defaultButtonSuccessText,
    required this.defaultButtonCancelText,
  });

  void userRequestMode() {
    _active = true;
  }

  void grantMode() {
    _active = false;
  }

  void setPrompt({
    String? description,
    String? buttonSuccessText,
    String? buttonCancelText,
  }) {
    customDescription = description;
    customButtonSuccessText = buttonSuccessText;
    customButtonCancelText = buttonCancelText;
  }

  void _clearCustomMessages() {
    customDescription = null;
    customButtonSuccessText = null;
    customButtonCancelText = null;
  }

  void authorizeJump(Rut rut, Function(bool) authorized) {
    if (_active) {
      rut.showDialog(
        ConfirmationDialog(
          description: customDescription ?? defaultDescription,
          confirmButtonText:
              customButtonSuccessText ?? defaultButtonSuccessText,
          cancelButtonText: customButtonCancelText ?? defaultButtonCancelText,
          onCancel: () {
            rut.showDialog(null);
            authorized.call(false);
          },
          onConfirm: () {
            rut.showDialog(null);
            grantMode();
            _clearCustomMessages();
            authorized.call(true);
          },
        ),
      );
    } else {
      _clearCustomMessages();
      authorized.call(true);
    }
  }
}
