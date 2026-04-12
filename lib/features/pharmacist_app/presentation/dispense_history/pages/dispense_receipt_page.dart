import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mediconnect/common/widgets/app_scaffold.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/domain/models/dispense_record.dart';

class DispenseReceiptPage extends StatelessWidget {
  final DispenseRecord? record;

  const DispenseReceiptPage({super.key, this.record});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);

    // In a real app, we might fetch the record if it's null using an ID from the route.
    // For this prototype, we'll use dummy data if null.
    final data = record ?? _getDummyRecord();

    return AppScaffold(
      removeBodyPadding: true,
      hasAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppIcons.export,
              width: 24,
              colorFilter: ColorFilter.mode(
                theme.neutral.primaryText,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.figmaWidth(20)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.figmaWidth(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Green Border
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: theme.pharmacist.bg.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(context.figmaWidth(12)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(context.figmaWidth(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DISPENSE RECEIPT',
                      style: AppTextStyles.interP14M.copyWith(
                        color: theme.neutral.tertiaryText,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: context.figmaHeight(8)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.figmaWidth(12),
                        vertical: context.figmaHeight(6),
                      ),
                      decoration: BoxDecoration(
                        color: theme.neutral.bgTint,
                        borderRadius: BorderRadius.circular(
                          context.figmaWidth(20),
                        ),
                      ),
                      child: Text(
                        'Sale ID: ${data.saleId}',
                        style: AppTextStyles.interP14M.copyWith(
                          color: theme.neutral.primaryText,
                        ),
                      ),
                    ),
                    SizedBox(height: context.figmaHeight(24)),

                    // Recorded By Section
                    Text(
                      'RECORDED BY',
                      style: AppTextStyles.interP12M.copyWith(
                        color: theme.pharmacist.bg.withValues(alpha: 0.7),
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: context.figmaHeight(12)),
                    Row(
                      children: [
                        _InfoColumn(
                          label: 'Title / Role:',
                          value: data.recordedByRole,
                        ),
                        SizedBox(width: context.figmaWidth(40)),
                        _InfoColumn(label: 'Name:', value: data.recordedByName),
                      ],
                    ),
                    SizedBox(height: context.figmaHeight(24)),

                    // Recorded Section
                    Text(
                      'RECORDED',
                      style: AppTextStyles.interP12M.copyWith(
                        color: theme.pharmacist.bg.withValues(alpha: 0.7),
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: context.figmaHeight(12)),
                    _InfoColumn(
                      label: 'Date - Time',
                      value: _formatDateTime(data.recordedAt),
                    ),

                    SizedBox(height: context.figmaHeight(24)),
                    const Divider(
                      height: 1,
                      color: Color(0xFFE0E0E0),
                      thickness: 1,
                    ),
                    SizedBox(height: context.figmaHeight(24)),

                    // Items
                    ...data.items.map((item) => _buildItemRow(context, item)),

                    SizedBox(height: context.figmaHeight(24)),
                    const Divider(
                      height: 1,
                      color: Color(0xFFE0E0E0),
                      thickness: 1,
                    ),
                    SizedBox(height: context.figmaHeight(24)),

                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: AppTextStyles.interP18M.copyWith(
                            color: theme.neutral.primaryText,
                          ),
                        ),
                        Text(
                          '₦${NumberFormat('#,###').format(data.totalAmount)}',
                          style: AppTextStyles.interP18M.copyWith(
                            color: theme.pharmacist.bg,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, DispensedItem item) {
    final theme = AppTheme.colors(context);
    return Padding(
      padding: EdgeInsets.only(bottom: context.figmaHeight(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.medicationName,
                style: AppTextStyles.interP16M.copyWith(
                  color: theme.neutral.primaryText,
                ),
              ),
              Text(
                'Qty ${item.quantity} / ₦${NumberFormat('#,###').format(item.unitPrice)}',
                style: AppTextStyles.interP12R.copyWith(
                  color: theme.neutral.tertiaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: context.figmaHeight(4)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${item.brandName} by ${item.manufacturer} • ${item.isBrand ? 'Brand' : 'Generic'}',
                style: AppTextStyles.interP12R.copyWith(
                  color: theme.neutral.secondaryText,
                ),
              ),
              Text(
                '₦${NumberFormat('#,###').format(item.totalPrice)}',
                style: AppTextStyles.interP16M.copyWith(
                  color: theme.neutral.primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    // Jan 6th, 2026 • 20:47:10
    final day = dt.day;
    String suffix = 'th';
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }
    return '${DateFormat('MMM').format(dt)} $day$suffix, ${dt.year} • ${DateFormat('HH:mm:ss').format(dt)}';
  }

  DispenseRecord _getDummyRecord() {
    return DispenseRecord(
      id: '1',
      saleId: '-S-20260106-0001',
      recordedByRole: 'Staff',
      recordedByName: 'Yusuf A.',
      recordedAt: DateTime(2026, 1, 6, 20, 47, 10),
      totalAmount: 33500,
      items: [
        DispensedItem(
          medicationName: 'Amoxicillin 500mg',
          brandName: 'Amoxil',
          manufacturer: 'GSK',
          isBrand: true,
          quantity: 2,
          unitPrice: 2500,
          totalPrice: 5000,
        ),
        DispensedItem(
          medicationName: 'Ibuprofen 200mg',
          brandName: 'Advil',
          manufacturer: 'Pfizer',
          isBrand: true,
          quantity: 1,
          unitPrice: 22500,
          totalPrice: 22500,
        ),
        DispensedItem(
          medicationName: 'Metformin 500mg',
          brandName: 'Prinivil',
          manufacturer: 'Merck',
          isBrand: true,
          quantity: 1,
          unitPrice: 22500,
          totalPrice: 22500,
        ),
      ],
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.interP12R.copyWith(
            color: theme.neutral.tertiaryText,
          ),
        ),
        SizedBox(height: context.figmaHeight(4)),
        Text(
          value,
          style: AppTextStyles.interP16M.copyWith(
            color: theme.neutral.primaryText,
          ),
        ),
      ],
    );
  }
}
