import 'dart:io';

import 'package:flutter/material.dart';

class JoinOurTeam extends StatefulWidget {
  const JoinOurTeam({super.key});

  @override
  State<JoinOurTeam> createState() => _JoinOurTeamState();
}

class _JoinOurTeamState extends State<JoinOurTeam> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers (one variable/controller per field)
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController contactCtrl = TextEditingController();
  final TextEditingController streetCtrl = TextEditingController();
  final TextEditingController suburbCtrl = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController postalCtrl = TextEditingController();
  final TextEditingController experienceCtrl = TextEditingController();
  final TextEditingController areaPreferCtrl = TextEditingController();
  final TextEditingController availableStartCtrl = TextEditingController();

  // Gender radio
  String? genderSelected;

  // Work types checkboxes
  final Map<String, bool> workTypes = {
    'Pet Sitting': false,
    'Babysitting': false,
  };

  // Car and licence radios
  String? carOption; // 'Yes'/'No'/'About to get'
  String? licenceOption; // same options

  // Years working with children (radio)
  String? yearsWorking;

  // Youngest age worked with (radio)
  String? youngestAge;

  // Preferred areas (checkboxes)
  final Map<String, bool> areas = {
    'Brisbane': false,
    'Southside': false,
    'Northside': false,
    'Sunshine Coast': false,
    'Northern Gold Coast': false,
    'Southern Gold Coast': false,
  };

  // Requirements (checkboxes)
  final Map<String, bool> requirements = {
    'HLTAID012 – Childcare First Aid & CPR': false,
    'Valid Blue Card – Working with Children': false,
    'Police Check': false,
    'ABN – All staff are contractors': false,
  };

  // How did you hear about us? (checkboxes)
  final Map<String, bool> hearAbout = {
    'Friend/Recommendation': false,
    "Someone's Instagram story": false,
    'Instagram': false,
    'Google Search': false,
    'Flyer': false,
    'Other': false,
  };

  // Local image path (uploaded file). Using uploaded path from conversation.
  // final String _localImagePath = '/mnt/data/Screenshot 2025-11-22 at 11.06.30 am.png';

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    dobCtrl.dispose();
    contactCtrl.dispose();
    streetCtrl.dispose();
    suburbCtrl.dispose();
    stateCtrl.dispose();
    postalCtrl.dispose();
    experienceCtrl.dispose();
    areaPreferCtrl.dispose();
    availableStartCtrl.dispose();
    super.dispose();
  }

  // Helper: format date as dd/mm/yyyy
  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) controller.text = _fmtDate(picked);
  }

  void _submit() {
    final formValid = _formKey.currentState?.validate() ?? false;

    // Additional validations: required radios/checkbox groups
    final workTypesSelected = workTypes.values.any((v) => v);
    final areasSelected = areas.values.any((v) => v);
    final requirementsSelected = requirements.values.any((v) => v);
    final hearSelected = hearAbout.values.any((v) => v);

    if (!formValid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fix errors in the form.')));
      return;
    }

    if (genderSelected == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select Gender.')));
      return;
    }
    if (!workTypesSelected) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least one Work Type.')));
      return;
    }
    if (carOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please answer the Car question.')));
      return;
    }
    if (licenceOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please answer the Licence question.')));
      return;
    }
    if (yearsWorking == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select Years working with children.')));
      return;
    }
    if (youngestAge == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select the youngest age you worked with.')));
      return;
    }
    if (!areasSelected) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least one preferred area.')));
      return;
    }
    if (availableStartCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please provide available start date.')));
      return;
    }
    if (!requirementsSelected) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please confirm at least one requirement option.')));
      return;
    }
    if (!hearSelected) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please tell us how you heard about us.')));
      return;
    }

    // If all validations passed: print everything
    print('--- APPLICATION SUBMISSION ---');
    print('First Name: ${firstNameCtrl.text}');
    print('Last Name: ${lastNameCtrl.text}');
    print('Email: ${emailCtrl.text}');
    print('DOB: ${dobCtrl.text}');
    print('Contact Number: ${contactCtrl.text}');
    print('Street Address: ${streetCtrl.text}');
    print('Suburb: ${suburbCtrl.text}');
    print('State: ${stateCtrl.text}');
    print('Postal Code: ${postalCtrl.text}');
    print('Gender: $genderSelected');

    final selectedWorkTypes = workTypes.entries.where((e) => e.value).map((e) => e.key).join(', ');
    print('Work Types: $selectedWorkTypes');

    print('Has Car: $carOption');
    print('Has Licence: $licenceOption');

    print('Years working with children: $yearsWorking');
    print('Youngest age worked with: $youngestAge');

    print('Experience (short): ${experienceCtrl.text}');

    final selectedAreas = areas.entries.where((e) => e.value).map((e) => e.key).join(', ');
    print('Preferred Areas: $selectedAreas');
    print('Area prefer notes: ${areaPreferCtrl.text}');

    print('Available Start Date: ${availableStartCtrl.text}');

    final selectedRequirements = requirements.entries.where((e) => e.value).map((e) => e.key).join(', ');
    print('Requirements: $selectedRequirements');

    final selectedHear = hearAbout.entries.where((e) => e.value).map((e) => e.key).join(', ');
    print('Heard About Us: $selectedHear');

    print('--- END SUBMISSION ---');

    // Show a success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Application Submitted'),
        content: const Text('Thank you — your application has been submitted.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );

    // Optionally you can clear the form afterwards or keep values
    // _formKey.currentState?.reset(); // Not used to preserve state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Text(
                  'Join Our Trusted Team of Carers',
                  textAlign: TextAlign.center,
style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),                ),
              ),

              const SizedBox(height: 18),

              // Banner image using the uploaded local path
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(16),
              //   child: SizedBox(
              //     width: double.infinity,
              //     height: 180,
              //     child: _buildLocalImage(),
              //   ),
              // ),

              const SizedBox(height: 20),

              // Ideal for + Requirements - stacked on mobile
              _idealForWidget(context),
              const SizedBox(height: 10),
              _requirementsWidget(context),

              const SizedBox(height: 18),

              Text(
                'Application Form', 
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),             
              const SizedBox(height: 12),

              // Personal Details
              _textField(label: 'First Name *', controller: firstNameCtrl, validator: _requiredValidator),
              _textField(label: 'Last Name *', controller: lastNameCtrl, validator: _requiredValidator),
              _textField(label: 'Email Address *', controller: emailCtrl, keyboard: TextInputType.emailAddress, validator: _emailValidator),

              // DOB with date picker
              _textField(
                label: 'DOB *',
                controller: dobCtrl,
                readOnly: true,
                hint: 'dd/mm/yyyy',
                suffix: IconButton(icon: const Icon(Icons.calendar_today, size: 20), onPressed: () => _pickDate(dobCtrl)),
                validator: _requiredValidator,
              ),

              _textField(label: 'Contact Number *', controller: contactCtrl, keyboard: TextInputType.phone, validator: _requiredValidator),
              _textField(label: 'Street Address *', controller: streetCtrl, validator: _requiredValidator),
              _textField(label: 'Suburb *', controller: suburbCtrl, validator: _requiredValidator),
              _textField(label: 'State *', controller: stateCtrl, validator: _requiredValidator),
              _textField(label: 'Postal Code *', controller: postalCtrl, keyboard: TextInputType.number, validator: _requiredValidator),

              const SizedBox(height: 12),

              // Gender
              const Text('Gender *', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Row(children: [
                Radio<String>(value: 'Female', groupValue: genderSelected, onChanged: (v) => setState(() => genderSelected = v)),
                const Text('Female'),
                const SizedBox(width: 12),
                Radio<String>(value: 'Male', groupValue: genderSelected, onChanged: (v) => setState(() => genderSelected = v)),
                const Text('Male'),
                const SizedBox(width: 12),
                Radio<String>(value: 'Other', groupValue: genderSelected, onChanged: (v) => setState(() => genderSelected = v)),
                const Text('Other'),
              ]),

              const SizedBox(height: 18),

              // ---------------------------
              // Application Details (functional)
              // ---------------------------
              const Divider(),
              const SizedBox(height: 12),
                Text(
                  'APPLICATION DETAILS', 
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    
                  ),
              ),              
              const SizedBox(height: 10),

              // What type of work (checkboxes) - required at least one
              
              const Text('What type of work are you after? *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: workTypes.keys.map((k) {
                  return Row(mainAxisSize: MainAxisSize.min, children: [
                    Checkbox(value: workTypes[k], onChanged: (v) => setState(() => workTypes[k] = v ?? false)),
                    Text(k),
                    const SizedBox(width: 8),
                  ]);
                }).toList(),
              ),

              const SizedBox(height: 12),

              // Do you have a car? - VERTICAL LAYOUT
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Do you have a car? *'),
                  const SizedBox(height: 8),
                  Row(children: [
                    Radio<String>(value: 'Yes', groupValue: carOption, onChanged: (v) => setState(() => carOption = v)),
                    const Text('Yes'),
                    const SizedBox(width: 8),
                    Radio<String>(value: 'No', groupValue: carOption, onChanged: (v) => setState(() => carOption = v)),
                    const Text('No'),
                    const SizedBox(width: 8),
                    Radio<String>(value: 'About to get', groupValue: carOption, onChanged: (v) => setState(() => carOption = v)),
                    const Text('About to get'),
                  ]),
                ],
              ),

              const SizedBox(height: 16),

              // Do you have a licence? - VERTICAL LAYOUT
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Do you have a licence? *'),
                  const SizedBox(height: 8),
                  Row(children: [
                    Radio<String>(value: 'Yes', groupValue: licenceOption, onChanged: (v) => setState(() => licenceOption = v)),
                    const Text('Yes'),
                    const SizedBox(width: 8),
                    Radio<String>(value: 'No', groupValue: licenceOption, onChanged: (v) => setState(() => licenceOption = v)),
                    const Text('No'),
                    const SizedBox(width: 8),
                    Radio<String>(value: 'About to get', groupValue: licenceOption, onChanged: (v) => setState(() => licenceOption = v)),
                    const Text('About to get'),
                  ]),
                ],
              ),

              const SizedBox(height: 12),

              const Text('How many years have you been working with children? *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _smallRadioOption('Less than a year', yearsWorking, (v) => setState(() => yearsWorking = v)),
                  _smallRadioOption('1 year', yearsWorking, (v) => setState(() => yearsWorking = v)),
                  _smallRadioOption('2 years', yearsWorking, (v) => setState(() => yearsWorking = v)),
                  _smallRadioOption('3 years', yearsWorking, (v) => setState(() => yearsWorking = v)),
                  _smallRadioOption('4 years', yearsWorking, (v) => setState(() => yearsWorking = v)),
                  _smallRadioOption('5+ years', yearsWorking, (v) => setState(() => yearsWorking = v)),
                ],
              ),

              const SizedBox(height: 12),

              const Text("What is the youngest age you've worked with? *"),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _smallRadioOption('Newborn', youngestAge, (v) => setState(() => youngestAge = v)),
                  _smallRadioOption('6 months+', youngestAge, (v) => setState(() => youngestAge = v)),
                  _smallRadioOption('1 year old+', youngestAge, (v) => setState(() => youngestAge = v)),
                  _smallRadioOption('2 year old+', youngestAge, (v) => setState(() => youngestAge = v)),
                  _smallRadioOption('3 year old+', youngestAge, (v) => setState(() => youngestAge = v)),
                  _smallRadioOption('4 year old+', youngestAge, (v) => setState(() => youngestAge = v)),
                  _smallRadioOption('5 year old+', youngestAge, (v) => setState(() => youngestAge = v)),
                ],
              ),

              const SizedBox(height: 12),

              const Text('Please provide 3–4 sentences explaining your experience and why you want to work for City to Coast *'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(color: const Color(0xFFF6F8FF), borderRadius: BorderRadius.circular(8)),
                child: TextFormField(
                  controller: experienceCtrl,
                  maxLines: 6,
                  decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(12)),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please provide some details';
                    if (v.trim().split(RegExp(r'\s+')).length < 6) return 'Please write at least a few words';
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 12),

              const Text('What areas do you prefer to work in? (select at least one) *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: areas.keys.map((k) {
                  return Row(mainAxisSize: MainAxisSize.min, children: [
                    Checkbox(value: areas[k], onChanged: (v) => setState(() => areas[k] = v ?? false)),
                    Text(k),
                    const SizedBox(width: 8),
                  ]);
                }).toList(),
              ),

              const SizedBox(height: 8),
              _textField(label: 'Area prefer (extra notes)', controller: areaPreferCtrl),

              const SizedBox(height: 8),
              // Available start date picker
              _textField(
                label: 'Available Start Date *',
                controller: availableStartCtrl,
                readOnly: true,
                hint: 'dd/mm/yyyy',
                suffix: IconButton(icon: const Icon(Icons.calendar_today, size: 20), onPressed: () => _pickDate(availableStartCtrl)),
                validator: _requiredValidator,
              ),

              const SizedBox(height: 12),

              // Requirements checkboxes
              const Text('Do you have the below requirements or are you in the process of obtaining? *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: requirements.keys.map((k) {
                  return Row(mainAxisSize: MainAxisSize.min, children: [
                    Checkbox(value: requirements[k], onChanged: (v) => setState(() => requirements[k] = v ?? false)),
                    SizedBox(width: 220, child: Text(k)),
                    const SizedBox(width: 8),
                  ]);
                }).toList(),
              ),

              const SizedBox(height: 18),
              const Divider(),
              const SizedBox(height: 12),

              // OTHER INFORMATION
                Text(
                  'OTHER INFORMATION', 
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue.shade700,
                  ),
                ),                     
              const SizedBox(height: 12),

              const Text('How did you hear about us? *'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: hearAbout.keys.map((k) {
                  return Row(mainAxisSize: MainAxisSize.min, children: [
                    Checkbox(value: hearAbout[k], onChanged: (v) => setState(() => hearAbout[k] = v ?? false)),
                    SizedBox(width: 8),
                    Text(k),
                    const SizedBox(width: 12),
                  ]);
                }).toList(),
              ),

              const SizedBox(height: 20),

              // FINAL SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Submit Application'),
                ),
              ),

              const SizedBox(height: 36),
            ]),
          ),
        ),
      ),
    );
  }

  // Build image from local path; if not found, show placeholder
  // Widget _buildLocalImage() {
  //   try {
  //     final file = File(_localImagePath);
  //     if (file.existsSync()) {
  //       return Image.file(file, fit: BoxFit.cover);
  //     } else {
  //       return Container(
  //         color: Colors.grey.shade200,
  //         child: const Center(child: Text('Banner image not found')),
  //       );
  //     }
  //   } catch (e) {
  //     return Container(
  //       color: Colors.grey.shade200,
  //       child: const Center(child: Text('Banner image error')),
  //     );
  //   }
  // }

 Widget _idealForWidget(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Ideal for', 
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 8),
      const BulletPoint('Early childhood educators and support staff'),
      const BulletPoint('Health, Education, Veterinary and care professionals'),
      const BulletPoint('Support Workers'),
      const BulletPoint('People passionate about helping families'),
    ],
  );
}
  Widget _requirementsWidget(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Requirements', 
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 8),
      const BulletPoint('Current ABN (or willingness to get one)'),
      const BulletPoint('Current Police Check'),
      const BulletPoint('Working With Children Check'),
      const BulletPoint('Experience with children or pets'),
    ],
  );
}

  // Validators
  String? _requiredValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    return null;
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (!v.contains('@') || v.length < 5) return 'Enter a valid email';
    return null;
  }
}

// small radio helper used in Wraps
Widget _smallRadioOption(String value, String? groupValue, ValueChanged<String?> onChanged) {
  return Row(mainAxisSize: MainAxisSize.min, children: [
    Radio<String>(value: value, groupValue: groupValue, onChanged: onChanged),
    Text(value),
    const SizedBox(width: 6),
  ]);
}

// WIDGET: BulletPoint
class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('•  ', style: TextStyle(fontSize: 12)),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
      ]),
    );
  }
}

// Reusable text field widget used in the main form
Widget _textField({
  required String label,
  TextEditingController? controller,
  TextInputType keyboard = TextInputType.text,
  String? hint,
  Widget? suffix,
  bool readOnly = false,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(color: const Color(0xFFF6F8FF), borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboard,
          readOnly: readOnly,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            suffixIcon: suffix,
          ),
        ),
      ),
    ]),
  );
}