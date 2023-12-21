import 'package:biersommelier/components/ConfirmationDialog.dart';
import 'package:biersommelier/components/Popup.dart';
import 'package:biersommelier/components/Post/RateBar.dart';
import 'package:biersommelier/components/Toast.dart';
import 'package:flutter/material.dart';

import 'package:biersommelier/database/entities/Post.dart' as dbPost;

import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/RutPath.dart';

/// Ein Beitrag mit dem Aussehen nach Lastenheft Screen `a102`
///
/// - [image] Das Hauptbild in der Mitte
/// - [bar] Das Lokal
/// - [created] Der Zeitstempel wann der Post erstellt wurde
/// - [beer] Der Biername
/// - [rating] Eine Integerzahl von 1 bis 5 wie gut es bewertet wurde
class Post extends StatelessWidget {
  final Image image;
  final String description;
  final String bar;
  final DateTime created;
  final String beer;
  final int rating;
  final String id;

  const Post({
    super.key,
    required this.id,
    required this.image,
    required this.description,
    required this.bar,
    required this.created,
    required this.beer,
    required this.rating,
  });

  String _getVocalTime(DateTime time) {
    Duration duration = time.difference(DateTime.now()).abs();

    if (duration.inDays > 0) {
      int days = duration.inDays;
      return '$days Tage${days > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      int hours = duration.inHours;
      return '$hours Stunde${hours > 1 ? 'n' : ''}';
    } else if (duration.inMinutes > 0) {
      int minutes = duration.inMinutes;
      return '$minutes Minute${minutes > 1 ? 'n' : ''}';
    } else {
      return 'jetzt gerade';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey[800],
                        size: 22,
                      ),
                    ),
                    Text(
                      bar,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.fiber_manual_record,
                        size: 5,
                        color: Color(0xFF946C00),
                      ),
                    ),
                    Text(
                      _getVocalTime(created),
                      style: const TextStyle(
                        color: Color(0xFF946C00),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.more_horiz),
                  color: Colors.grey[800],
                  onPressed: () {
                    Rut.of(context).showDialog(Popup.editLogbook(
                      pressEdit: () {
                        Rut.of(context).showDialog(null);
                        dbPost.Post.get(id).then((post) {
                          Rut.of(context).jump(RutPage.addPost, arguments: {
                            'post': post!,
                          });
                        });
                      },
                      pressDelete: () {
                        // show confirmation dialog
                        Rut.of(context).showDialog(ConfirmationDialog(
                          description: 'Bist du sicher, dass du\ndiesen Beitrag löschen\nmöchtest?',
                          onConfirm: () {
                            dbPost.Post.delete(id).then((_) {
                              // show toast
                              showToast(context, "Beitrag gelöscht!", ToastLevel.success);

                              Rut.of(context).showDialog(null);

                              // TODO: reload of page not working
                              Rut.of(context).rebase(RutPath(page: RutPage.log));
                            });
                          },
                          onCancel: () {
                            Rut.of(context).showDialog(null);
                          },
                        ));
                      },
                      onAbort: () {
                        Rut.of(context).showDialog(null);
                      },
                    ));
                  },
                ),
              ],
            ),
          ),
          image,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RateBar(rating: rating),
                    Text(beer),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '"$description"',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
