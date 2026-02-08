import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediconnect/common/widgets/providers/app_scaffold_provider.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';

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
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.removeBodyPadding = false,
    this.titleText,
    this.titleTextStyle, 
  });

  final Widget body;
  final void Function()? onBack;
  final List<Widget>? scaffoldActions;
  final Widget? title;
  final PreferredSizeWidget? appBar;
  final bool hasAppBar;
  final bool extendBodyBehindAppBar;
  final Widget? bottomNavigationBar;
  final bool removeBodyPadding;
  final Widget? floatingActionButton;
  final String? titleText;
  final TextStyle? titleTextStyle;

  static const _surfaceRadius = Radius.circular(28);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(appScaffoldBackgroundColorProvider);
    final surfaceColor = ref.watch(appScaffoldScaffoldColorProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        // TODO: fix this later on to match the design and find a way to change the color of the default phone status bar icons to white when the background is dark and vice versa
        // minimum: EdgeInsets.only(top: context.figmaHeight(10)),
        bottom: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topRight: _surfaceRadius),
          child: Scaffold(
            backgroundColor: surfaceColor,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            appBar: hasAppBar
                ? (appBar ??
                      (title != null ||
                              onBack != null ||
                              scaffoldActions != null
                          ? AppBar(
                              title:
                                  title ??
                                  Text(
                                    titleText ?? '',
                                    style:
                                        titleTextStyle ??
                                        AppTextStyles.interP18M,
                                  ),
                              toolbarHeight: context.figmaHeight(87),
                              centerTitle: true,
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
            body: removeBodyPadding
                ? body
                : Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: context.figmaHeight(20),
                      horizontal: context.figmaWidth(24),
                    ),
                    child: body,
                  ),
            floatingActionButton: floatingActionButton,
          ),
        ),
      ),
    );
  }
}
