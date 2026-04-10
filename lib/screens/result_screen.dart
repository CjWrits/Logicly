import 'package:flutter/material.dart';
import '../models/explanation.dart';
import '../widgets/section_card.dart';

class ResultScreen extends StatefulWidget {
  final String query;
  final Explanation explanation;

  const ResultScreen({super.key, required this.query, required this.explanation});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  int _selectedApproach = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectApproach(int index) {
    if (_selectedApproach == index) return;
    setState(() => _selectedApproach = index);
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F0F14) : const Color(0xFFF0F2F8);
    final cardBg = isDark ? const Color(0xFF1A1A24) : Colors.white;
    final primary = isDark ? const Color(0xFF7C6FFF) : const Color(0xFF5B4FE9);
    final textPrimary = isDark ? const Color(0xFFF0F0FF) : const Color(0xFF12121A);
    final textSecondary = isDark ? const Color(0xFF8888AA) : const Color(0xFF888899);
    final borderColor = isDark ? const Color(0xFF2A2A3A) : const Color(0xFFE4E4F0);

    final e = widget.explanation;
    final approach = e.approaches[_selectedApproach];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 19, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Explanation',
          style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        children: [
          // Query banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: primary.withOpacity(0.18)),
            ),
            child: Row(
              children: [
                Icon(Icons.tag_rounded, size: 15, color: primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.query,
                    style: TextStyle(fontSize: 13, color: primary, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Problem card
          SectionCard(
            title: 'PROBLEM',
            content: e.problem,
            icon: Icons.lightbulb_rounded,
            iconColor: const Color(0xFFFF9F0A),
            cardBg: cardBg,
            textColor: textPrimary,
            subTextColor: textSecondary,
            borderColor: borderColor,
          ),

          // Intuition card
          SectionCard(
            title: 'INTUITION',
            content: e.intuition,
            icon: Icons.psychology_alt_rounded,
            iconColor: const Color(0xFF30B0C7),
            cardBg: cardBg,
            textColor: textPrimary,
            subTextColor: textSecondary,
            borderColor: borderColor,
          ),

          const SizedBox(height: 6),

          // Approaches header
          Row(
            children: [
              Text(
                'Approaches',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${e.approaches.length}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Approach tabs
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: e.approaches.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final selected = i == _selectedApproach;
                return GestureDetector(
                  onTap: () => _selectApproach(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      color: selected ? primary : cardBg,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: selected ? primary : borderColor,
                      ),
                      boxShadow: selected
                          ? [BoxShadow(color: primary.withOpacity(0.28), blurRadius: 10, offset: const Offset(0, 4))]
                          : [],
                    ),
                    child: Text(
                      e.approaches[i].name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Approach content
          FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              children: [
                SectionCard(
                  title: 'STEP-BY-STEP LOGIC',
                  content: approach.logic,
                  icon: Icons.format_list_numbered_rounded,
                  iconColor: const Color(0xFF34C759),
                  cardBg: cardBg,
                  textColor: textPrimary,
                  subTextColor: textSecondary,
                  borderColor: borderColor,
                ),
                SectionCard(
                  title: 'JAVA CODE',
                  content: approach.code,
                  icon: Icons.code_rounded,
                  iconColor: primary,
                  isCode: true,
                  cardBg: cardBg,
                  textColor: textPrimary,
                  subTextColor: textSecondary,
                  borderColor: borderColor,
                ),
                SectionCard(
                  title: 'TIME COMPLEXITY',
                  content: approach.timeComplexity,
                  icon: Icons.speed_rounded,
                  iconColor: const Color(0xFFFF453A),
                  cardBg: cardBg,
                  textColor: textPrimary,
                  subTextColor: textSecondary,
                  borderColor: borderColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline_rounded, size: 13, color: textSecondary.withOpacity(0.5)),
              const SizedBox(width: 5),
              Text(
                'AI-generated — verify before using.',
                style: TextStyle(fontSize: 12, color: textSecondary.withOpacity(0.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
