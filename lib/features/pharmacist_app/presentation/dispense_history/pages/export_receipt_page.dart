import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:flutter_svg/svg.dart';

class ExportReceiptPage extends StatelessWidget {
  const ExportReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    return AppScaffold(
      hasAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Export Dispense Receipt',
          style: AppTextStyles.interP18M.copyWith(
            color: theme.neutral.primaryText,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.figmaWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldLabel(context, 'Sale ID', hasInfo: true),
            SizedBox(height: context.figmaHeight(8)),
            _buildTextField(context, '-S-20260106-0001'),
            SizedBox(height: context.figmaHeight(24)),

            _buildFieldLabel(context, 'End Date'),
            SizedBox(height: context.figmaHeight(8)),
            _buildTextField(context, '04 Jan,2026'),
            SizedBox(height: context.figmaHeight(24)),

            _buildFieldLabel(context, 'Email', subtitle: 'Your sales Log will be sent to this email'),
            SizedBox(height: context.figmaHeight(8)),
            _buildEmailField(context, 'm*@gmail.com'),
            SizedBox(height: context.figmaHeight(24)),

            _buildFieldLabel(context, 'File Type', subtitle: 'select the format in which you would like to receive your sales log'),
            SizedBox(height: context.figmaHeight(8)),
            _buildDropdownField(context, 'Select file type'),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label, {bool hasInfo = false, String? subtitle}) {
    final theme = AppTheme.colors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.interP16M.copyWith(
                color: theme.neutral.secondaryText,
              ),
            ),
            if (hasInfo) ...[
              SizedBox(width: context.figmaWidth(8)),
              SvgPicture.asset(
                AppIcons.info,
                width: 16,
                colorFilter: ColorFilter.mode(
                  theme.pharmacist.bg,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ],
        ),
        if (subtitle != null) ...[
          SizedBox(height: context.figmaHeight(4)),
          Text(
            subtitle,
            style: AppTextStyles.interP12R.copyWith(
              color: theme.neutral.secondaryText.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField(BuildContext context, String value) {
    final theme = AppTheme.colors(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.figmaWidth(16),
        vertical: context.figmaHeight(14),
      ),
      decoration: BoxDecoration(
        color: theme.neutral.bgTint,
        borderRadius: BorderRadius.circular(context.figmaWidth(8)),
        border: Border.all(color: theme.neutral.border.withValues(alpha: 0.5)),
      ),
      child: Text(
        value,
        style: AppTextStyles.interP14R.copyWith(
          color: theme.neutral.secondaryText,
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context, String email) {
    final theme = AppTheme.colors(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.figmaWidth(16),
        vertical: context.figmaHeight(14),
      ),
      decoration: BoxDecoration(
        color: theme.neutral.bgTint,
        borderRadius: BorderRadius.circular(context.figmaWidth(8)),
        border: Border.all(color: theme.neutral.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            email,
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.primaryText,
            ),
          ),
          Text(
            'Edit >',
            style: AppTextStyles.interP14M.copyWith(
              color: theme.pharmacist.bg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context, String hint) {
    final theme = AppTheme.colors(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.figmaWidth(16),
        vertical: context.figmaHeight(14),
      ),
      decoration: BoxDecoration(
        color: theme.neutral.bgTint,
        borderRadius: BorderRadius.circular(context.figmaWidth(8)),
        border: Border.all(color: theme.neutral.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: AppTextStyles.interP14R.copyWith(
              color: theme.neutral.secondaryText,
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black),
        ],
      ),
    );
  }
}
