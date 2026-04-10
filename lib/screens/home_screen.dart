import 'package:flutter/material.dart';
import '../main.dart';
import '../services/ai_service.dart';
import '../widgets/app_logo.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _loading = false;
  bool _isFocused = false;

  late AnimationController _btnAnim;
  late Animation<double> _btnScale;

  static const _hints = [
    'Two Sum',
    'Binary Search',
    'BFS vs DFS',
    'Dynamic Programming',
    'Merge Sort',
    'Sliding Window',
    'Linked List Cycle',
  ];

  @override
  void initState() {
    super.initState();
    _btnAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _btnScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _btnAnim, curve: Curves.easeInOut),
    );
    _focusNode.addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _btnAnim.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a DSA problem or topic.')),
      );
      return;
    }
    _focusNode.unfocus();
    setState(() => _loading = true);
    try {
      final explanation = await AiService.explain(input);
      if (!mounted) return;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => ResultScreen(query: input, explanation: explanation),
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 380),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Top bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLogo(size: 38, showText: false),
                  const SizedBox(width: 10),
                  Text(
                    'Logicly',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  // Dark mode toggle
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeNotifier,
                    builder: (_, mode, __) => GestureDetector(
                      onTap: () => themeNotifier.value =
                          mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 52,
                        height: 28,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: mode == ThemeMode.dark ? primary : borderColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          alignment: mode == ThemeMode.dark
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Icon(
                              mode == ThemeMode.dark
                                  ? Icons.dark_mode_rounded
                                  : Icons.light_mode_rounded,
                              size: 13,
                              color: mode == ThemeMode.dark ? primary : Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 44),

              // Hero text
              Text(
                'What DSA topic\nconfuses you?',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                  height: 1.2,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Type any problem or concept — get a clear,\nstep-by-step breakdown instantly.',
                style: TextStyle(fontSize: 14, color: textSecondary, height: 1.6),
              ),

              const SizedBox(height: 30),

              // Input card
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isFocused ? primary.withOpacity(0.6) : borderColor,
                    width: _isFocused ? 1.5 : 1,
                  ),
                  boxShadow: _isFocused
                      ? [BoxShadow(color: primary.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 6))]
                      : [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.06), blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLines: 6,
                      minLines: 4,
                      textInputAction: TextInputAction.newline,
                      style: TextStyle(fontSize: 15, color: textPrimary, height: 1.65),
                      decoration: InputDecoration(
                        hintText: 'e.g. "Two Sum", "How does BFS work?", "Explain DP with examples"',
                        hintStyle: TextStyle(color: textSecondary.withOpacity(0.7), fontSize: 14, height: 1.5),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _controller,
                            builder: (_, __, ___) => Text(
                              '${_controller.text.length} chars',
                              style: TextStyle(fontSize: 11, color: textSecondary.withOpacity(0.5)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _controller.clear();
                              _focusNode.requestFocus();
                            },
                            child: Text(
                              'Clear',
                              style: TextStyle(fontSize: 12, color: primary.withOpacity(0.7), fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Submit button
              ScaleTransition(
                scale: _btnScale,
                child: GestureDetector(
                  onTapDown: (_) => _btnAnim.forward(),
                  onTapUp: (_) => _btnAnim.reverse(),
                  onTapCancel: () => _btnAnim.reverse(),
                  onTap: _loading ? null : _submit,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primary, Color.lerp(primary, Colors.purpleAccent, 0.4)!],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 19),
                                SizedBox(width: 9),
                                Text(
                                  'Explain Simply',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Try these
              Text(
                'Try these',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textSecondary),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _hints.map((hint) {
                  return GestureDetector(
                    onTap: () {
                      _controller.text = hint;
                      _controller.selection = TextSelection.fromPosition(TextPosition(offset: hint.length));
                      _focusNode.requestFocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.north_east_rounded, size: 12, color: primary),
                          const SizedBox(width: 5),
                          Text(
                            hint,
                            style: TextStyle(fontSize: 13, color: textPrimary, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
