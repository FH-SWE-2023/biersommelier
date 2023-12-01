import 'package:biersommelier/router/rut/RutPath.dart';
import 'package:flutter/material.dart';

class RutParser extends RouteInformationParser<RutPath> {
  @override
  Future<RutPath> parseRouteInformation(RouteInformation information) async {
    final uri = Uri.parse(information.uri.toString());

    if (uri.pathSegments.isEmpty) {
      return RutPath(page: RutPage.log);
    }

    return RutPath(page: RutPage.explore);
  }

  @override
  RouteInformation restoreRouteInformation(RutPath path) {
    String first = path.page.toString();
    return RouteInformation(uri: Uri(path: '/$first'));
  }
}
