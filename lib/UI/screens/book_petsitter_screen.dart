import 'package:flutter/material.dart';

class BookPetsitterScreen extends StatefulWidget {
  const BookPetsitterScreen({super.key});

  @override
  State<BookPetsitterScreen> createState() => _BookPetsitterScreen();
}

class _BookPetsitterScreen extends State<BookPetsitterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Parent / guardian 1
  final _p1NameController = TextEditingController();
  final _p1MobileController = TextEditingController();
  final _p1EmailController = TextEditingController();
  final _p1AddressController = TextEditingController();

  // Parent / guardian 2 (optional)
  final _p2NameController = TextEditingController();
  final _p2MobileController = TextEditingController();
  final _p2EmailController = TextEditingController();
  String _sitterGenderPreference = 'Female';

  // Children forms (dynamic list)
  final List<_ChildFormData> _children = [];

  // Booking request
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _notesController = TextEditingController();
  bool _parkingAvailable = false;

  @override
  void initState() {
    super.initState();
    // Start with 1 child block
    _children.add(_ChildFormData());
  }

  @override
  void dispose() {
    // Dispose all controllers
    _p1NameController.dispose();
    _p1MobileController.dispose();
    _p1EmailController.dispose();
    _p1AddressController.dispose();

    _p2NameController.dispose();
    _p2MobileController.dispose();
    _p2EmailController.dispose();

    for (final c in _children) {
      c.dispose();
    }
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (result != null) {
      setState(() => _selectedDate = result);
    }
  }

  Future<void> _pickTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 18, minute: 0),
    );
    if (result != null) {
      setState(() => _selectedTime = result);
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return '';
    return t.format(context);
  }

  void _addChild() {
    if (_children.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 5 pets can be added.')),
      );
      return;
    }
    setState(() {
      _children.add(_ChildFormData());
    });
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select booking date and time.')),
      );
      return;
    }

    // At this point, the form is valid. Here you would normally send to backend.
    // For now, we just show a confirmation dialog.
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Booking submitted'),
        content: const Text(
          'Thank you! Your booking details have been captured in this prototype.\n\n'
          'In a real app, this is where we would send the request to the server or email.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // dialog
              Navigator.of(context).pop(); // back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Booking a Baby Sitter')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + intro
                Center(
                  child: Text(
                    'Booking a Baby Sitter',
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Our babysitting service offers flexible, short-term care for children from newborns '
                  'through to primary ages. The more detail you provide here, the better we can match '
                  'your family with the right sitter.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                // Container around form (like white card on the website)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Complete the form below',
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // PARENTS SECTION
                        Text(
                          'Parent / Guardian 1',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(
                          label: 'Full Name *',
                          controller: _p1NameController,
                          validatorMsg: 'Please enter full name',
                        ),
                        _buildTextField(
                          label: 'Mobile Number *',
                          controller: _p1MobileController,
                          keyboardType: TextInputType.phone,
                          validatorMsg: 'Please enter mobile number',
                        ),
                        _buildTextField(
                          label: 'Email *',
                          controller: _p1EmailController,
                          keyboardType: TextInputType.emailAddress,
                          validatorMsg: 'Please enter email',
                        ),
                        _buildTextField(
                          label: 'Address of the job *',
                          controller: _p1AddressController,
                          validatorMsg: 'Please enter job address',
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Parent / Guardian 2 (optional)',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(
                          label: 'Full Name',
                          controller: _p2NameController,
                        ),
                        _buildTextField(
                          label: 'Mobile Number',
                          controller: _p2MobileController,
                          keyboardType: TextInputType.phone,
                        ),
                        _buildTextField(
                          label: 'Email',
                          controller: _p2EmailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Do you have a preference for a female or male sitter? *',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Row(
                          children: [
                            _buildGenderRadio('Female'),
                            _buildGenderRadio('Male'),
                            _buildGenderRadio('Male or Female'),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // CHILDREN SECTION
                        Text(
                          'Pets to be looked after',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Please complete with as much information as possible on the children being cared for.',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: List.generate(
                            _children.length,
                            (index) => _ChildForm(
                              index: index,
                              data: _children[index],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: ElevatedButton(
                            onPressed: _addChild,
                            child: const Text('Add More Pets'),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // BOOKING REQUEST
                        Text(
                          'Booking Request',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(child: _buildDateField()),
                            const SizedBox(width: 12),
                            Expanded(child: _buildTimeField()),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Checkbox(
                              value: _parkingAvailable,
                              onChanged: (v) {
                                setState(() => _parkingAvailable = v ?? false);
                              },
                            ),
                            Expanded(
                              child: Text(
                                'Is there parking available for the sitter? '
                                'If it is a hotel job, please check with concierge if visitor parking is available.',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildMultilineField(
                          label: 'Notes (anything else we should know?)',
                          controller: _notesController,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '* Please be advised you will have to pay the booking fee before we can start the search for a sitter for you.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // SUBMIT
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: const Text('SUBMIT'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- UI helper widgets ----

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? validatorMsg,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (validatorMsg != null && (value == null || value.trim().isEmpty)) {
            return validatorMsg;
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildMultilineField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      readOnly: true,
      onTap: _pickDate,
      validator: (value) {
        if (_selectedDate == null) {
          return 'Pick a date';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Pick your date *',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: _pickDate,
        ),
        isDense: true,
        hintText: 'dd/mm/yyyy',
        hintStyle: const TextStyle(fontSize: 13),
        helperText: _formatDate(_selectedDate).isEmpty
            ? null
            : _formatDate(_selectedDate),
      ),
    );
  }

  Widget _buildTimeField() {
    return TextFormField(
      readOnly: true,
      onTap: _pickTime,
      validator: (value) {
        if (_selectedTime == null) {
          return 'Pick a time';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Pick your time *',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.access_time),
          onPressed: _pickTime,
        ),
        isDense: true,
        helperText: _formatTime(_selectedTime).isEmpty
            ? null
            : _formatTime(_selectedTime),
      ),
    );
  }

  Widget _buildGenderRadio(String value) {
    return Expanded(
      child: RadioListTile<String>(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(value, style: const TextStyle(fontSize: 13)),
        value: value,
        groupValue: _sitterGenderPreference,
        onChanged: (v) {
          if (v != null) {
            setState(() => _sitterGenderPreference = v);
          }
        },
      ),
    );
  }
}

// ---------- CHILD FORM DATA & WIDGET ----------

class _ChildFormData {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final likesController = TextEditingController();
  final specialController = TextEditingController();

  void dispose() {
    nameController.dispose();
    ageController.dispose();
    likesController.dispose();
    specialController.dispose();
  }
}

class _ChildForm extends StatelessWidget {
  final int index;
  final _ChildFormData data;

  const _ChildForm({required this.index, required this.data});

  @override
  Widget build(BuildContext context) {
    final labelPrefix = 'Pet ${index + 1} - ';

    Widget _field({
      required String label,
      required TextEditingController controller,
      String? validatorMsg,
      int maxLines = 1,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (value) {
            if (validatorMsg != null &&
                (value == null || value.trim().isEmpty)) {
              return validatorMsg;
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            isDense: true,
            alignLabelWithHint: maxLines > 1,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$labelPrefix details',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _field(
                label: 'Pet Name *',
                controller: data.nameController,
                validatorMsg: 'Enter pet name',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _field(
                label: 'Pet Age *',
                controller: data.ageController,
                validatorMsg: 'Enter pet age',
              ),
            ),
          ],
        ),
        _field(
          label:
              'Please tell us about your pet/child likes, dislikes and interests *',
          controller: data.likesController,
          validatorMsg: 'Please provide some information',
          maxLines: 2,
        ),
        _field(
          label:
              'Please describe any special requests important for the sitter (food / inside / outside / allowed on furniture etc.) *',
          controller: data.specialController,
          validatorMsg: 'Please provide special requests / notes',
          maxLines: 3,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
