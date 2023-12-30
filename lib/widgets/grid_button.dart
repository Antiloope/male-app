import 'package:flutter/material.dart';

class GridButton extends StatelessWidget {
  const GridButton({super.key, required this.text, required this.icon, required this.page});

  final String text;
  final Icon icon;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapInside: (PointerDownEvent pointerDownEvent) async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(60),
                blurRadius: 5,
                offset: Offset(2,2),
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(text),
          ],
        ),
      ),
    );
  }

}