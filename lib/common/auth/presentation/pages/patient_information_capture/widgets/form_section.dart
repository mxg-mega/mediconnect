import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/common/auth/data/models/medication_model.dart';
import 'package:mediconnect/core/constants/assets.dart';

class FormSection<T> extends StatelessWidget {
  const FormSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.onAddItem,
    required this.buildForm,
    required this.buildListItem,
    this.addButtonText = 'Add',
  });

  final String title;
  final String subtitle;
  final List<T> items;
  final VoidCallback onAddItem;
  final Widget Function() buildForm;
  final Widget Function(T item, int index) buildListItem;
  final String addButtonText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
              ],
            ),
            FilledButton.icon(
              onPressed: onAddItem,
              label: SvgPicture.asset(AppIcons.add),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Show form when adding or if there are no items
        if (items.isEmpty) ...[
          buildForm(),
        ] else ...[
          // Show list of items
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: buildListItem(item, index),
            );
          }),

          // Add button to add more items
          Center(
            child: TextButton.icon(
              onPressed: onAddItem,
              icon: SvgPicture.asset(AppIcons.add),
              label: Text(addButtonText),
            ),
          ),
        ],
      ],
    );
  }
}

class MedicationListItem extends StatelessWidget {
  const MedicationListItem({
    super.key,
    required this.medicationName,
    required this.strength,
    required this.form,
    required this.prescribedBy,
    required this.prescriptionDate,
    this.recoveryStatus,
    this.onEdit,
    this.onDelete,
  });

  final String medicationName;
  final String strength;
  final String form;
  final String prescribedBy;
  final String prescriptionDate;
  final String? recoveryStatus;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  medicationName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 20),
                      tooltip: 'Edit',
                    ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      tooltip: 'Delete',
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildInfoRow('Strength:', strength)),
              const SizedBox(width: 16),
              Expanded(child: _buildInfoRow('Form:', form)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: _buildInfoRow('Prescribed by:', prescribedBy)),
              const SizedBox(width: 16),
              Expanded(child: _buildInfoRow('Date:', prescriptionDate)),
            ],
          ),
          if (recoveryStatus != null) ...[
            const SizedBox(height: 4),
            _buildInfoRow('Recovery Status:', recoveryStatus!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

class AllergyListItem extends StatelessWidget {
  const AllergyListItem({
    super.key,
    required this.allergy,
    this.onEdit,
    this.onDelete,
  });

  final Allergies allergy;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  allergy.type,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 20),
                      tooltip: 'Edit',
                    ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      tooltip: 'Delete',
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Symptoms:', allergy.allergenName),
          const SizedBox(height: 4),
          _buildSeverityRow('Severity:', allergy.severity),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityRow(String label, String severity) {
    Color severityColor;
    switch (severity.toLowerCase()) {
      case 'mild':
        severityColor = Colors.green;
        break;
      case 'moderate':
        severityColor = Colors.orange;
        break;
      case 'severe':
        severityColor = Colors.red;
        break;
      default:
        severityColor = Colors.grey;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: severityColor.withOpacity(0.1),
            border: Border.all(color: severityColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            severity.replaceFirst(severity[0], severity[0].toUpperCase()),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: severityColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
