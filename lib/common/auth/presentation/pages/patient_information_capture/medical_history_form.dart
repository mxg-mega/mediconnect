import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mediconnect/common/auth/data/models/medical_history_model.dart';
import 'package:mediconnect/common/auth/presentation/pages/capture_models.dart';
import 'package:mediconnect/common/widgets/k_elevated_button.dart';
import 'package:mediconnect/common/widgets/k_form_field.dart';
import 'package:mediconnect/common/widgets/k_input_field.dart';
import 'package:mediconnect/common/widgets/labeled_input.dart';
import 'package:mediconnect/common/auth/presentation/pages/patient_information_capture/widgets/form_section.dart';
import 'package:mediconnect/common/auth/presentation/pages/patient_information_capture/models/medication_item.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/features/patient_app/domain/entities/medical_history.dart' hide AllergySeverity;

class MedicalHistoryForm extends StatefulWidget {
  const MedicalHistoryForm({
    super.key,
    required this.formKey,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;

  final void Function(MedicalHistoryInput input) onSubmit;

  @override
  State<MedicalHistoryForm> createState() => _MedicalHistoryFormState();
}

class _MedicalHistoryFormState extends State<MedicalHistoryForm> {
  final conditionNameController = TextEditingController();
  final locationController = TextEditingController();
  final diagnosisDetailsController = TextEditingController();
  ConditionStatus? selectedConditionStatus;
  DateTime? diagnosisDate;

  final dateOfPrescriptionController = TextEditingController();
  RecoveryStatus? selectedRecoveryStatus;

  // Form controllers for current medications
  final currentMedicationNameController = TextEditingController();
  final currentStrengthController = TextEditingController();
  final currentFormController = TextEditingController();
  final currentPrescribedByController = TextEditingController();

  // Form controllers for past medications
  final pastMedicationNameController = TextEditingController();
  final pastStrengthController = TextEditingController();
  final pastFormController = TextEditingController();
  final pastPrescribedByController = TextEditingController();

  DateTime? dateOfPrescription;

  // Lists to store medication items
  List<MedicationItem> currentMedications = [];
  List<MedicationItem> pastMedications = [];

  bool hasCheckedBox = false;

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }

  @override
  void dispose() {
    conditionNameController.dispose();
    locationController.dispose();
    diagnosisDetailsController.dispose();
    dateOfPrescriptionController.dispose();
    currentMedicationNameController.dispose();
    currentStrengthController.dispose();
    currentFormController.dispose();
    currentPrescribedByController.dispose();
    pastMedicationNameController.dispose();
    pastStrengthController.dispose();
    pastFormController.dispose();
    pastPrescribedByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Text('Medical History', style: AppTextStyles.inter24M),
          const SizedBox(height: 16),
          Text(
            'Complete your profile to get started.',
            style: AppTextStyles.interP16M.copyWith(
              color: AppTheme.colors(context).neutral.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          LabeledInput(
            label: 'Condition Name',
            required: true,
            child: KFormField(
              hintText: 'Diabetes, HyperTension, etc',
              controller: conditionNameController,
              validator: _requiredValidator,
            ),
          ),
          const SizedBox(height: 16),
          LabeledInput(
            label: 'Current Status',
            child: KInputField(
              child: DropdownButtonFormField(
                value: selectedConditionStatus,
                hint: const Text('Select'),
                items: [
                  DropdownMenuItem(
                    value: ConditionStatus.active,
                    child: Text(ConditionStatus.active.name),
                  ),
                  DropdownMenuItem(
                    value: ConditionStatus.resolved,
                    child: Text(ConditionStatus.resolved.name),
                  ),
                  DropdownMenuItem(
                    value: ConditionStatus.chronic,
                    child: Text(ConditionStatus.chronic.name),
                  ),
                ],
                validator: (value) {
                  if (value == null) return 'Select a status';
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    selectedConditionStatus = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          LabeledInput(
            label: 'Diagnosis Date',
            required: true,
            child: KInputField(
              child: TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: diagnosisDate == null
                      ? ''
                      : '${diagnosisDate!.day}/${diagnosisDate!.month}/${diagnosisDate!.year}',
                ),
                decoration: const InputDecoration(
                  hintText: 'DD / MM / YYYY',
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (diagnosisDate == null) {
                    return 'Select diagnosis date';
                  }
                  return null;
                },
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: diagnosisDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365 * 100),
                    ),
                  );
                  if (picked != null) {
                    setState(() {
                      diagnosisDate = picked;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          LabeledInput(
            label: 'Location',
            child: KFormField(
              hintText: 'Abuja',
              controller: locationController,
              validator: _requiredValidator,
            ),
          ),
          const SizedBox(height: 16),
          LabeledInput(
            label: 'Diagnosis Details',
            required: true,
            child: KFormField(
              hintText: 'Diagnosis details here',
              maxLines: 5,
              controller: diagnosisDetailsController,
              validator: _requiredValidator,
            ),
          ),
          const SizedBox(height: 32),

          FormSection<MedicationItem>(
            title: 'Current Medications',
            subtitle: '',
            items: currentMedications,
            onAddItem: () {},
            buildForm: () => _buildCurrentMedicationForm(),
            buildListItem: (item, index) => MedicationListItem(
              medicationName: item.medicationName,
              strength: item.strength,
              form: item.form,
              prescribedBy: item.prescribedBy,
              prescriptionDate: item.prescriptionDate,
              onEdit: () {},
              onDelete: () {},
            ),
          ),

          const SizedBox(height: 32),

          FormSection<MedicationItem>(
            title: 'Prescription Medications',
            subtitle: '(Past & Present)',
            items: pastMedications,
            onAddItem: () {},
            buildForm: () => _buildPastMedicationForm(),
            buildListItem: (item, index) => MedicationListItem(
              medicationName: item.medicationName,
              strength: item.strength,
              form: item.form,
              prescribedBy: item.prescribedBy,
              prescriptionDate: item.prescriptionDate,
              recoveryStatus: item.recoveryStatus?.displayName,
              onEdit: () {},
              onDelete: () {},
            ),
          ),

          const SizedBox(height: 32),

          FormSection(
            title: 'Allergy',
            subtitle: '',
            items: [],
            onAddItem: () {},
            buildForm: () {
              return Column(
                children: [
                  LabeledInput(
                    label: 'Symptoms Experienced',
                    child: KFormField(hintText: 'Skin rash'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      LabeledInput(
                        label: 'Type',
                        child: KFormField(
                          hintText: 'Penicillin, Food, Drug etc',
                        ),
                      ),
                      const SizedBox(width: 16),
                      LabeledInput(
                        label: 'Severity',
                        child: DropdownButtonFormField(
                          items: [
                            DropdownMenuItem(
                              value: AllergySeverity.mild,
                              child: Text('Mild'),
                            ),
                            DropdownMenuItem(
                              value: AllergySeverity.moderate,
                              child: Text('Moderate'),
                            ),
                            DropdownMenuItem(
                              value: AllergySeverity.severe,
                              child: Text('Severe'),
                            ),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            buildListItem: (item, index) => const SizedBox(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                activeColor: AppTheme.colors(context).patient.bg,
                value: hasCheckedBox,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    hasCheckedBox = value;
                  });
                },
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'I confirm that the medical information I provided is accurate and agree to the ',
                      style: AppTextStyles.interP14R.copyWith(
                        color: AppTheme.colors(context).neutral.secondaryText,
                      ),
                    ),
                    TextSpan(
                      text: 'Term of Service',
                      style: AppTextStyles.interP14R.copyWith(
                        color: AppTheme.colors(context).support.red,
                      ),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: AppTextStyles.interP14R.copyWith(
                        color: AppTheme.colors(context).neutral.secondaryText,
                      ),
                    ),
                    TextSpan(
                      text: 'Privacy Policy.',
                      style: AppTextStyles.interP14R.copyWith(
                        color: AppTheme.colors(context).support.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset(
                AppIcons.lock,
                colorFilter: ColorFilter.mode(
                  AppTheme.colors(context).patient.bg,
                  BlendMode.color,
                ),
              ),
              Text(
                'All Information are encrypted and securely stored',
                style: AppTextStyles.interP12R.copyWith(
                  color: AppTheme.colors(context).neutral.secondaryText,
                ),
              ),
            ],
          ),

          KElevatedButton(onPressed: _submit, child: const Text('Next')),
          const SizedBox(height: 16),

          Text(
            'ⓘ You can add more conditions later in your profile settings.',
            style: AppTextStyles.interP14R.copyWith(
              color: AppTheme.colors(context).neutral.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentMedicationForm() {
    return Column(
      children: [
        LabeledInput(
          label: 'Medication Name',
          child: KFormField(
            controller: currentMedicationNameController,
            hintText: 'Amoxicillin, IbuProfen',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: LabeledInput(
                label: 'Strength',
                child: KFormField(
                  controller: currentStrengthController,
                  hintText: '500mg, 200mg, etc',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: LabeledInput(
                label: 'Form',
                child: KFormField(
                  controller: currentFormController,
                  hintText: 'Liquid, Tablet, Capsule, etc',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: LabeledInput(
                label: 'Prescribed by',
                child: KFormField(
                  controller: currentPrescribedByController,
                  hintText: 'Dr. John Smith, Dr. Jane Doe',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: LabeledInput(
                label: 'Prescription Date',
                required: true,
                child: KInputField(
                  child: TextFormField(
                    readOnly: true,
                    controller: dateOfPrescriptionController,
                    decoration: const InputDecoration(
                      hintText: 'DD / MM / YYYY',
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: dateOfPrescription ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 100),
                        ),
                      );
                      if (picked != null && picked != dateOfPrescription) {
                        setState(() {
                          dateOfPrescription = picked;
                          dateOfPrescriptionController.text =
                              "${picked.day}/${picked.month}/${picked.year}";
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Clear form fields
                  currentMedicationNameController.clear();
                  currentStrengthController.clear();
                  currentFormController.clear();
                  currentPrescribedByController.clear();
                  dateOfPrescriptionController.clear();
                  setState(() {
                    dateOfPrescription = null;
                  });
                },
                child: const Text('Clear'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (currentMedicationNameController.text.isNotEmpty &&
                      currentStrengthController.text.isNotEmpty &&
                      currentFormController.text.isNotEmpty &&
                      currentPrescribedByController.text.isNotEmpty &&
                      dateOfPrescription != null) {
                    setState(() {
                      currentMedications.add(
                        MedicationItem(
                          id: DateTime.now().toString(),
                          medicationName: currentMedicationNameController.text,
                          strength: currentStrengthController.text,
                          form: currentFormController.text,
                          prescribedBy: currentPrescribedByController.text,
                          prescriptionDate: dateOfPrescriptionController.text,
                        ),
                      );

                      // Clear form after adding
                      currentMedicationNameController.clear();
                      currentStrengthController.clear();
                      currentFormController.clear();
                      currentPrescribedByController.clear();
                      dateOfPrescriptionController.clear();
                      dateOfPrescription = null;
                    });
                  }
                },
                child: const Text('Add Medication'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPastMedicationForm() {
    return Column(
      children: [
        LabeledInput(
          label: 'Medication Name',
          child: KFormField(
            controller: pastMedicationNameController,
            hintText: 'Amoxicillin, IbuProfen',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: LabeledInput(
                label: 'Strength',
                child: KFormField(
                  controller: pastStrengthController,
                  hintText: '500mg, 200mg, etc',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: LabeledInput(
                label: 'Form',
                child: KFormField(
                  controller: pastFormController,
                  hintText: 'Liquid, Tablet, Capsule, etc',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: LabeledInput(
                label: 'Prescribed by',
                child: KFormField(
                  controller: pastPrescribedByController,
                  hintText: 'Dr. John Smith, Dr. Jane Doe',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: LabeledInput(
                label: 'Prescription Date',
                required: true,
                child: KInputField(
                  child: TextFormField(
                    readOnly: true,
                    controller: dateOfPrescriptionController,
                    decoration: const InputDecoration(
                      hintText: 'DD / MM / YYYY',
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: dateOfPrescription ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 100),
                        ),
                      );
                      if (picked != null && picked != dateOfPrescription) {
                        setState(() {
                          dateOfPrescription = picked;
                          dateOfPrescriptionController.text =
                              "${picked.day}/${picked.month}/${picked.year}";
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LabeledInput(
          label: 'Recovery Status',
          child: DropdownButtonFormField<RecoveryStatus>(
            hint: const Text('Select'),
            value: selectedRecoveryStatus,
            items: RecoveryStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.displayName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedRecoveryStatus = value;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Clear form fields
                  pastMedicationNameController.clear();
                  pastStrengthController.clear();
                  pastFormController.clear();
                  pastPrescribedByController.clear();
                  dateOfPrescriptionController.clear();
                  setState(() {
                    dateOfPrescription = null;
                    selectedRecoveryStatus = null;
                  });
                },
                child: const Text('Clear'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (pastMedicationNameController.text.isNotEmpty &&
                      pastStrengthController.text.isNotEmpty &&
                      pastFormController.text.isNotEmpty &&
                      pastPrescribedByController.text.isNotEmpty &&
                      dateOfPrescription != null &&
                      selectedRecoveryStatus != null) {
                    setState(() {
                      pastMedications.add(
                        MedicationItem(
                          id: DateTime.now().toString(),
                          medicationName: pastMedicationNameController.text,
                          strength: pastStrengthController.text,
                          form: pastFormController.text,
                          prescribedBy: pastPrescribedByController.text,
                          prescriptionDate: dateOfPrescriptionController.text,
                          recoveryStatus: selectedRecoveryStatus,
                        ),
                      );

                      // Clear form after adding
                      pastMedicationNameController.clear();
                      pastStrengthController.clear();
                      pastFormController.clear();
                      pastPrescribedByController.clear();
                      dateOfPrescriptionController.clear();
                      dateOfPrescription = null;
                      selectedRecoveryStatus = null;
                    });
                  }
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _submit() {
    if (widget.formKey.currentState?.validate() != true) return;
    if (!hasCheckedBox) return;

    final input = MedicalHistoryInput(
      conditionName: conditionNameController.text.trim(),
      currentStatus: selectedConditionStatus ?? ConditionStatus.active,
      diagnosisDate: diagnosisDate,
      location: locationController.text.trim(),
      diagnosisDetails: diagnosisDetailsController.text.trim(),
      currentMedications: currentMedications
          .map(
            (e) => MedicationInput(
              id: e.id,
              name: e.medicationName,
              strength: e.strength,
              form: e.form,
              prescribedBy: e.prescribedBy,
              prescriptionDate: DateTime.tryParse(e.prescriptionDate),
            ),
          )
          .toList(),
      pastMedications: pastMedications
          .map(
            (e) => MedicationInput(
              id: e.id,
              name: e.medicationName,
              strength: e.strength,
              form: e.form,
              prescribedBy: e.prescribedBy,
              prescriptionDate: DateTime.tryParse(e.prescriptionDate),
              recoveryStatus: e.recoveryStatus,
            ),
          )
          .toList(),
      allergies: [],
      consentAccepted: hasCheckedBox,
    );

    widget.onSubmit(input);
  }
}
