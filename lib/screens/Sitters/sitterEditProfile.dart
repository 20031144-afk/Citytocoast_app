import 'dart:async';
import 'package:citytocoast_app/services/location_service.dart';
import 'package:flutter/material.dart';

class SitterEditProfile extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String? uid;

  const SitterEditProfile({super.key, this.userData, this.uid});

  @override
  State<SitterEditProfile> createState() => _SitterEditProfileState();
}

class _SitterEditProfileState extends State<SitterEditProfile> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  final TextEditingController _addressController = TextEditingController();

  // Address variables
  double? _lat;
  double? _lng;
  List<dynamic> _placeSuggestions = [];
  final LocationService _locationService = LocationService();
  Timer? _debounce;

  // Minimum Booking Hours
  int _minHours = 2;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.userData ?? {};
    _firstNameController = TextEditingController(text: data['firstName'] ?? '');
    _lastNameController = TextEditingController(text: data['lastName'] ?? '');
    _phoneController = TextEditingController(text: data['phoneNumber'] ?? '');
    _bioController = TextEditingController(text: data['bio'] ?? '');

    // Address initialization if available
    if (data.containsKey('address')) {
      _addressController.text = data['address'];
    }
    if (data.containsKey('location')) {
      // Assuming location is stored as a map or GeoPoint, logic to extract lat/lng would be needed here
      // For now, ignoring complex location parsing as per current simple implementation
    }

    _addressController.addListener(_onAddressChanged);
  }

  @override
  void dispose() {
    _addressController.removeListener(_onAddressChanged);
    _addressController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Debouce for 1 second for Nominatim API
  _onAddressChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (_addressController.text.isNotEmpty) {
        _locationService.getPlaceSuggestions(_addressController.text).then((
          suggestions,
        ) {
          if (mounted) {
            setState(() {
              _placeSuggestions = suggestions;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Image Placeholder
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFEAF2FF),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF6A5AE0),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6A5AE0),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Personal Details Section
              const Text(
                "Personal Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField("First Name", _firstNameController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField("Last Name", _lastNameController),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                "Phone Number",
                _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Address",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF6A5AE0)),
                      ),
                    ),
                  ),
                  if (_placeSuggestions.isNotEmpty)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: _placeSuggestions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              _placeSuggestions[index]['display_name'],
                            ),
                            onTap: () {
                              final suggestion = _placeSuggestions[index];

                              // Stop listener to prevent re-fetching suggestions
                              _addressController.removeListener(
                                _onAddressChanged,
                              );

                              setState(() {
                                _addressController.text =
                                    suggestion['display_name'];
                                _lat = double.parse(suggestion['lat']);
                                _lng = double.parse(suggestion['lon']);
                                _placeSuggestions = [];
                              });

                              // Re-add listener
                              _addressController.addListener(_onAddressChanged);

                              print(
                                "Selected Location: Lat: $_lat, Lng: $_lng",
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),
              _buildTextField("About Me", _bioController, maxLines: 4),

              const SizedBox(height: 24),

              // Booking Preferences Section
              const Text(
                "Booking Preferences",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Minimum Booking Duration",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Set the minimum number of hours for a booking request.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _hourSelector(2),
                        const SizedBox(width: 12),
                        _hourSelector(3),
                        const SizedBox(width: 12),
                        _hourSelector(4),
                        const SizedBox(width: 12),
                        _hourSelector(5),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: (val) => val == null || val.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6A5AE0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _hourSelector(int hours) {
    bool isSelected = _minHours == hours;
    return GestureDetector(
      onTap: () => setState(() => _minHours = hours),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6A5AE0)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFF6A5AE0))
              : null,
        ),
        child: Center(
          child: Text(
            "${hours}h",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A5AE0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Save Changes",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate backend save
    print("Saving Profile...");
    print("Name: ${_firstNameController.text} ${_lastNameController.text}");
    print("Address: ${_addressController.text}");
    if (_lat != null && _lng != null) {
      print("Location: Lat: $_lat, Lng: $_lng");
    }

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated successfully"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
