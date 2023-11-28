import 'package:biersommelier/components/Post/RateBar.dart';
import 'package:flutter/material.dart';

// TODO make dynamic

class Post extends StatelessWidget {
  final Image image;
  final String description;
  final String bar;
  final DateTime created;
  final String beer;
  final int rating;

  const Post({
    super.key,
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
      decoration: BoxDecoration(
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
                  onPressed: () {},
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
