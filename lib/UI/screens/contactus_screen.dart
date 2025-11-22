import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Form field controllers
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController messageCtrl = TextEditingController();

  // Dropdown values
  String? enquiryType;
  String? hearAboutUs;

  // Dropdown options
  final List<String> enquiryTypes = [
    'General Enquiry',
    'Babysitting',
    'Pet Sitting',
    'Booking Assistance',
    'Other'
  ];

  final List<String> hearAboutOptions = [
    'Friend/Recommendation',
    'Instagram',
    'Google Search',
    'Flyer',
    'Facebook',
    'Other Social Media',
    'Previous Customer',
    'Other'
  ];

  // Launch phone call
  void _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '1800282277');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone app')),
      );
    }
  }

  // Launch email
  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@citytocoastsitting.com.au',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email app')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Print all values
      print('=== CONTACT FORM SUBMISSION ===');
      print('First Name: ${firstNameCtrl.text}');
      print('Email: ${emailCtrl.text}');
      print('Enquiry Type: $enquiryType');
      print('Location: ${locationCtrl.text}');
      print('Message: ${messageCtrl.text}');
      print('Heard About Us: $hearAboutUs');
      print('=== END SUBMISSION ===');

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Thank you for reaching out!',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('# Annual 2023',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Home: 7 am',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Optionally clear the form
                // _clearForm();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  void _clearForm() {
    firstNameCtrl.clear();
    emailCtrl.clear();
    locationCtrl.clear();
    messageCtrl.clear();
    setState(() {
      enquiryType = null;
      hearAboutUs = null;
    });
  }

  // Validators
  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    emailCtrl.dispose();
    locationCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(),
              const SizedBox(height: 32),

              // Contact Methods
              _buildContactMethods(),
              const SizedBox(height: 32),

              // Contact Form
              _buildContactForm(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Questions? We're only a message away!",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
        ),
        const SizedBox(height: 16),
        Text(
          "We'd love to hear from you! Whether you're booking care, have a question, or just want to learn more about our services, our team is here to help. Simply reach out and we'll get back to you as soon as possible — because peace of mind starts with a conversation.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContactMethods() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phone - now clickable
          GestureDetector(
            onTap: _makePhoneCall,
            child: _buildContactItem(
              icon: Icons.phone,
              title: 'Phone us',
              subtitle: '1800 282 277',
            ),
          ),
          const SizedBox(height: 16),
          // Email - now clickable
          GestureDetector(
            onTap: _sendEmail,
            child: _buildContactItem(
              icon: Icons.email,
              title: 'Email Address',
              subtitle: 'info@citytocoastsitting.com.au',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: Colors.blue.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Form',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),

          // First Name
          _buildFormField(
            label: 'First Name*',
            controller: firstNameCtrl,
            validator: _requiredValidator,
            hintText: 'Type your first name',
          ),
          const SizedBox(height: 16),

          // Email
          _buildFormField(
            label: 'Email*',
            controller: emailCtrl,
            validator: _emailValidator,
            hintText: 'Your email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // Enquiry Type Dropdown
          _buildDropdownField(
            label: 'What are you enquiring about?*',
            value: enquiryType,
            items: enquiryTypes,
            onChanged: (value) => setState(() => enquiryType = value),
            hintText: 'General Enquiry',
          ),
          const SizedBox(height: 16),

          // Location
          _buildFormField(
            label: 'Location*',
            controller: locationCtrl,
            validator: _requiredValidator,
            hintText: 'Brisbane',
          ),
          const SizedBox(height: 16),

          // Message
          _buildFormField(
            label: 'Message*',
            controller: messageCtrl,
            validator: _requiredValidator,
            hintText: 'Type your message',
            maxLines: 5,
          ),
          const SizedBox(height: 16),

          // How did you hear about us Dropdown
          _buildDropdownField(
            label: 'How did you hear about us?*',
            value: hearAboutUs,
            items: hearAboutOptions,
            onChanged: (value) => setState(() => hearAboutUs = value),
            hintText: 'Friend/Recommendation',
          ),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'SUBMIT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              errorStyle: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              hintText: hintText,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an option';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}