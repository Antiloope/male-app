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
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(60),
                blurRadius: 5,
                offset: Offset(2,2),
              )
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}