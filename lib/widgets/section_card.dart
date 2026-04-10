import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'syntax_highlighter.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color iconColor;
  final bool isCode;
  final Color cardBg;
  final Color textColor;
  final Color subTextColor;
  final Color borderColor;

  const SectionCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.iconColor,
    required this.cardBg,
    required this.textColor,
    required this.subTextColor,
    required this.borderColor,
    this.isCode = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cleaned = isCode
        ? content.replaceAll('```java', '').replaceAll('```', '').trim()
        : content;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: iconColor,
                    letterSpacing: 0.8,
                  ),
                ),
                if (isCode) ...[
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: cleaned));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Code copied to clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.copy_rounded, size: 12, color: iconColor),
                          const SizedBox(width: 4),
                          Text('Copy', style: TextStyle(fontSize: 11, color: iconColor, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: borderColor),

          // Content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isCode
                  ? (isDark ? const Color(0xFF13131C) : const Color(0xFF1E1E2E))
                  : Colors.transparent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: isCode
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: JavaSyntaxHighlighter(code: cleaned),
                  )
                : Text(
                    cleaned,
                    style: TextStyle(
                      fontSize: 14,
                      color: subTextColor,
                      height: 1.7,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
