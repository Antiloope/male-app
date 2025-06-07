import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<InfoCardField> fields;
  final VoidCallback? onTap;
  final Widget? trailing;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.fields = const [],
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            if (fields.isNotEmpty) ...[
              SizedBox(height: 8),
              ...fields.map((field) => Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    if (field.icon != null) ...[
                      Icon(field.icon, size: 16, color: field.iconColor ?? Theme.of(context).colorScheme.primary),
                      SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        field.value,
                        style: TextStyle(
                          fontSize: field.fontSize ?? 12,
                          color: field.textColor ?? Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.8),
                          fontWeight: field.fontWeight,
                        ),
                      ),
                    ),
                    if (field.trailing != null) field.trailing!,
                  ],
                ),
              )).toList(),
            ],
          ],
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

class InfoCardField {
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Widget? trailing;

  const InfoCardField({
    required this.value,
    this.icon,
    this.iconColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.trailing,
  });
} 