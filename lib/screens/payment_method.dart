import 'package:flutter/material.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();

  String cardNumber = "";
  String expiryDate = "";
  String cvv = "";
  String cardHolder = "";
  String zipCode = "";
  bool saveCard = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Payment Method"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Info Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.lock, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Your payment information is encrypted and secure.\nWe never store your CVV.",
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Card Number
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Card Number",
                  prefixIcon: Icon(Icons.credit_card),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.length < 16
                    ? "Enter valid card number"
                    : null,
                onSaved: (val) => cardNumber = val!,
              ),
              const SizedBox(height: 16),

              // 🔹 Expiry + CVV
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Expiry Date",
                        hintText: "MM/YY",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                      validator: (val) => val == null || val.isEmpty
                          ? "Enter expiry date"
                          : null,
                      onSaved: (val) => expiryDate = val!,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "CVV",
                        hintText: "123",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      validator: (val) => val == null || val.length < 3
                          ? "Enter valid CVV"
                          : null,
                      onSaved: (val) => cvv = val!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🔹 Cardholder Name
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Cardholder Name",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter cardholder name" : null,
                onSaved: (val) => cardHolder = val!,
              ),
              const SizedBox(height: 16),

              // 🔹 ZIP Code
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "ZIP Code",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter ZIP code" : null,
                onSaved: (val) => zipCode = val!,
              ),
              const SizedBox(height: 16),

              // 🔹 Save Card Checkbox
              Row(
                children: [
                  Checkbox(
                    value: saveCard,
                    onChanged: (val) {
                      setState(() {
                        saveCard = val ?? true;
                      });
                    },
                  ),
                  const Text("Save this card for future payments"),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Add Payment Method Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Payment method added successfully!"),
                        ),
                      );

                      Navigator.pop(context, {
                        "method": "Credit Card",
                        "details":
                            "**** **** **** ${cardNumber.substring(cardNumber.length - 4)}",
                      });
                    }
                  },
                  child: const Text(
                    "Add Payment Method",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Security & Privacy Info
              _securityInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _securityInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Security & Privacy",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("• 256-bit SSL encryption"),
          Text("• PCI DSS compliant"),
          Text("• CVV never stored"),
          Text("• Fraud protection included"),
        ],
      ),
    );
  }
}
