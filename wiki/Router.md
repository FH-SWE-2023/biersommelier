# Router

Die Biersommelier App hat einen eigenen Komponenten um zwischen den Pages zu wechseln. Dieser Komponent wird auch Router genannt.
Da Router in Flutter bereits als Name belegt ist heißt dieser nun Rut. Alle öffentlichen Komponenten sind also mit dem Prefix `Rut` einsehbar.

## Seite wechseln

Um auf eine andere Seite zu wechseln sollte die Methode `jump` genutzt werden. Da Rut Erweiterungen exportiert welche das Routen vereinfachen, kann direkt vom
`BuildContext` (Widgetbaum) die Methode aufgerufen werden.

```dart
// Rut muss für das routen IMMER importiert werden
import 'package:biersommelier/router/Rut.dart';
// RutPath ist dafür da um mit dem Router über Seiten kommunizieren zu können
import 'package:biersommelier/router/rut/RutPath.dart';

class Component extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: ElevatedButton(child: Text('Klick mich'), onPressed: () {
            context.jump(RutPage.home);
        }),
    );
  }
}
```

### Erweiterter Seitenwechsel

Es ist ebenfalls möglich außerhalb einen Seitenwechsel zu blockieren. Ein Block kann so initiiert werden.

```dart
context.blockRouting();
```

Es ist möglich an diese Methode Parameter zu vergeben um das Prompt Fenster für den Block zu individualisieren.
Alle Parameter sind optional und können entfallen. In dem Fall wird ein Standardtext verwendet.

```dart
context.blockRouting(
    title: 'Block',
    description: 'Da wurde wohl der Sprung blockiert. Wenn du auf "Weiter" klickst, kommst du trotzdem zum neuen Fenster',
    buttonSuccessText: 'Weiter',
    buttonCancelText: 'Abbrechen',
);
```

Eine Blockierung wird nach jedem Seitenwechsel wieder automatisch aufgehoben. Falls gewünscht, kann dieser auch schon früher mit der Methode `context.unblockRouting()`
entfernt werden.

#### Sprung

Falls ein Widget versucht im geblockten Modus zu springen ist ein Seitenwechsel nicht garantiert. Um zu überprüfen ob nun die Seite gewechselt wurde oder nicht kann deswegen mit einem optionalen Callback überprüft werden.

```dart
context.jump(RutPage.home, change: (changed) {
    if (changed) {
        print('Seite wurde gewechselt');
    } else {
        print('Jump wurde abgebrochen');
    }
});
```

## Seiteninformationen

Der Router speichert Informationen zu jeder Seite ab auf welcher er sich befindet. Um diese zu lesen kann die Eigenschaft `path` abgefragt werden.

```dart
if (context.path.page == RutPage.home) {
    print('Zuhause!!');
}
```