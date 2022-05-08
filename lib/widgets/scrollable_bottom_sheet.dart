import 'package:flutter/material.dart';

void showScrollableBottomSheet(BuildContext context, List<Widget> children) {
  var scrHeight = MediaQuery.of(context).size.height;
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    // be able to show full screen, disable 60% height limitation
    isScrollControlled: true,
    context: context,
    builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: scrHeight * 0.8),
        child: // For max height that ModalBottomSheet can get
            FractionallySizedBox(
                //heightFactor: 0.9,
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag bar
            Center(
                child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 5,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
            )),
            Flexible(child: ListView(shrinkWrap: true, children: children))
          ],
        ))),
  );
}
