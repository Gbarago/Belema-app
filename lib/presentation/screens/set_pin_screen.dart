import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/bank/bank_bloc.dart';
import '../blocs/bank/bank_event.dart';
import '../blocs/bank/bank_state.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPinVisible = false;
  bool _isConfirmPinVisible = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Setup Transaction PIN',
          style: GoogleFonts.outfit(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<BankBloc, BankState>(
        listener: (context, state) {
          if (state is ActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is BankDataLoaded) {
            if (state.actionSuccess != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionSuccess!),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state.actionError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionError!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else if (state is BankError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crucial for Security',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create a 4-digit PIN for authorizing transactions.',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                _buildPinField(
                  controller: _pinController,
                  label: 'Transaction PIN',
                  isVisible: _isPinVisible,
                  onVisibilityChanged: () {
                    setState(() {
                      _isPinVisible = !_isPinVisible;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildPinField(
                  controller: _confirmPinController,
                  label: 'Confirm PIN',
                  isConfirm: true,
                  isVisible: _isConfirmPinVisible,
                  onVisibilityChanged: () {
                    setState(() {
                      _isConfirmPinVisible = !_isConfirmPinVisible;
                    });
                  },
                ),
                const SizedBox(height: 40),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinField({
    required TextEditingController controller,
    required String label,
    bool isConfirm = false,
    bool isVisible = false,
    VoidCallback? onVisibilityChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: !isVisible,
      maxLength: 4,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 24,
        letterSpacing: 20,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 16,
          letterSpacing: 0,
        ),
        counterText: '',
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onVisibilityChanged,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1CB954), width: 1),
        ),
      ),
      validator: (value) {
        if (value == null || value.length != 4) return 'PIN must be 4 digits';

        if (isConfirm) {
          if (value != _pinController.text) {
            return 'PINs do not match';
          }
        } else {
          // Strength checks for the main PIN field
          if (RegExp(r'^(\d)\1{3}$').hasMatch(value)) {
            return 'Use a stronger PIN (no repeats)';
          }

          // Check sequential
          bool isSeqAsc = true;
          bool isSeqDesc = true;
          for (int i = 0; i < 3; i++) {
            int current = int.parse(value[i]);
            int next = int.parse(value[i + 1]);
            if (next != current + 1) isSeqAsc = false;
            if (next != current - 1) isSeqDesc = false;
          }
          if (isSeqAsc || isSeqDesc) {
            return 'Use a stronger PIN (no sequences)';
          }
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<BankBloc, BankState>(
      builder: (context, state) {
        // Also check boolean loading flag
        final isLoading =
            state is BankLoading ||
            (state is BankDataLoaded && state.isLoading);

        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      context.read<BankBloc>().add(
                        SetPinSubmitted(_pinController.text),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1CB954),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    'Set PIN',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
