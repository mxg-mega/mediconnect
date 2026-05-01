import 'package:flutter/material.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;
  final double? width;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colors.neutral.border.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: SizedBox(
          width: width ?? 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 120,
                      color: colors.neutral.bg,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 120,
                      color: colors.neutral.bg,
                      child: const Icon(Icons.error),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  title,
                  style: AppTextStyles.interP14M.copyWith(
                    color: colors.neutral.primaryText,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
