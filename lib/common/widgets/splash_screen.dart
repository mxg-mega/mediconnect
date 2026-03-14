import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/animated_logo.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/splash_screen/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _polygonScale;
  late final Animation<double> _polygonPosYAnim;
  late final Animation<double> _logoTextConst;
  late final Animation<double> _logoTranslateX;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ref.read(splashFinishedProvider.notifier).state = true;
      }
    });
  }

  void _setupAnimations(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final offsetY = screenSize.height / 20;

    _polygonPosYAnim = Tween<double>(begin: -offsetY, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.bounceIn),
      ),
    );

    _polygonScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.0,
              end: 0.75,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.75,
              end: 30.0,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.linear)),
        );


    _logoTextConst =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 0.75),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.75, end: 0.75),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4)),
        );

    _logoTranslateX = Tween<double>(begin: 0.0, end: -context.figmaWidth(4))
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 0.6, curve: Curves.easeInOut),
          ),
        );

    // _appNameFadeInAnim = 


    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupAnimations(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: colors.neutral.buttonTextWhite),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return Transform.translate(
                    offset: Offset(0, _polygonPosYAnim.value),
                    child: AnimatedLogo(
                      scale: _polygonScale.value,
                      logoTextScale: _logoTextConst.value,
                      textTranslateX: _logoTranslateX.value,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
