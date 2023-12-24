import 'package:flutter/material.dart';
import 'package:pichu_oreo/utils/utils.dart';

class ReplyCard extends StatefulWidget {
  final snap;
  const ReplyCard({super.key, this.snap});

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  bool showFullText = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage:
                  NetworkImage(widget.snap['poster']['authorAvatar']),
            ),
            const SizedBox(width: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.snap['poster']['username'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  getFormattedTimeCmt(widget.snap['createDate']),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 110, 110, 110),
                  ),
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 48),
          child: Text(
            widget.snap['content'],
            style: const TextStyle(fontSize: 14),
          ),
        )
      ],
    );
  }
}
