import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.onBack,
    this.scaffoldActions,
    this.appBar,
    this.hasAppBar = true,
    this.extendBodyBehindAppBar = false,
  });

  final Widget body;
  final void Function()? onBack;
  final List<Widget>? scaffoldActions;
  final Widget? title;
  final PreferredSizeWidget? appBar;
  final bool hasAppBar;
  final bool extendBodyBehindAppBar;

  static const _surfaceRadius = Radius.circular(28);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(appScaffoldBackgroundColorProvider);
    final surfaceColor = ref.watch(appScaffoldScaffoldColorProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: _surfaceRadius,
          ),
          child: Scaffold(
            backgroundColor: surfaceColor,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            appBar: hasAppBar
                ? (appBar ??
                    (title != null || onBack != null || scaffoldActions != null
                        ? AppBar(
                            title: title,
                            leading: onBack != null
                                ? IconButton(
                                    onPressed: onBack,
                                    icon: const Icon(Icons.arrow_back),
                                  )
                                : null,
                            backgroundColor: surfaceColor,
                            elevation: 0,
                            actions: scaffoldActions,
                          )
                        : null))
                : null,
            body: body,
          ),
        ),
      ),
    );
  }
}
