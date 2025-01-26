import 'package:flutter/material.dart';

class HomeworkTitleSelector extends StatelessWidget {
  final TextEditingController titleController;
  final Function(String) onChange;

  const HomeworkTitleSelector(
      {super.key, required this.titleController, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.lightBlue,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Align(
              alignment: Alignment.center,
              child: TextField(
                controller: titleController,
                onChanged: onChange,
                cursorColor: Colors.white,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Title (i.e. Book p. 5)",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: () {
                      // Looks complicated, but is just a workaround because hintText doesn't accept a FittedBox widget
                      final textPainter = TextPainter(
                          text: const TextSpan(
                              text: "Enter Title (i.e. Book p. 5)",
                              style: TextStyle(fontSize: 22)),
                          maxLines: 1,
                          textScaler: MediaQuery.of(context).textScaler,
                          textDirection: TextDirection.ltr)
                        ..layout();
                      final maxWidth = MediaQuery.of(context).size.width - 32;
                      if (textPainter.width > maxWidth) {
                        return 22 * (maxWidth / textPainter.width);
                      }
                      return 22.0;
                    }(),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  fillColor: Colors.transparent,
                ),
                textCapitalization: TextCapitalization.sentences,
              )),
        ),
        const Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            child: BackButton(color: Colors.white),
          ),
        )
      ],
    );
  }
}
