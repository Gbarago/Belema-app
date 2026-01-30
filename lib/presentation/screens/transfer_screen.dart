import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/bank/bank_bloc.dart';
import '../blocs/bank/bank_event.dart';
import '../blocs/bank/bank_state.dart';
import '../widgets/shared_button.dart';
import '../widgets/shared_text_field.dart';
import '../../core/utils/thousands_formatter.dart';

import '../../core/constants/app_colors.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _amountController = TextEditingController();
  final _accountController = TextEditingController();
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPinVisible = false;

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Send Money',
          style: GoogleFonts.outfit(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<BankBloc, BankState>(
        listener: (context, state) {
          if (state is ActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
            context.read<BankBloc>().add(FetchBankData());
          } else if (state is BankDataLoaded) {
            if (state.actionSuccess != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionSuccess!),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pop(context);
            } else if (state.actionError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.actionError!),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          } else if (state is BankError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SharedTextField(
                  controller: _accountController,
                  label: 'Destination Account Number',
                  icon: Icons.account_balance_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                SharedTextField(
                  controller: _amountController,
                  label: 'Amount',
                  prefixText: '₦ ',
                  icon: null,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [ThousandsFormatter(allowFraction: true)],
                ),
                const SizedBox(height: 20),
                SharedTextField(
                  controller: _pinController,
                  label: 'Transaction PIN',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isVisible: _isPinVisible,
                  onVisibilityChanged: () {
                    setState(() {
                      _isPinVisible = !_isPinVisible;
                    });
                  },
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'PIN required';
                    if (value.length != 4) return 'PIN must be 4 digits';
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                BlocBuilder<BankBloc, BankState>(
                  builder: (context, state) {
                    final isLoading =
                        state is BankLoading ||
                        (state is BankDataLoaded && state.isLoading);

                    return SharedButton(
                      label: 'Confirm Transfer',
                      isLoading: isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<BankBloc>().add(
                            TransferSubmitted(
                              amount: double.parse(
                                _amountController.text.replaceAll(',', ''),
                              ),
                              destinationAccount: _accountController.text,
                              pin: _pinController.text,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
