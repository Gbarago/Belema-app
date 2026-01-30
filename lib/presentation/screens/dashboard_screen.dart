import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../blocs/bank/bank_bloc.dart';
import '../blocs/bank/bank_event.dart';
import '../blocs/bank/bank_state.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isBalanceVisible = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<BankBloc>().add(FetchBankData());

    // Check PIN status after frame build to show dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPinStatus();
    });
  }

  void _checkPinStatus() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      if (!authState.user.hasPin) {
        _showCreatePinDialog();
      }
    }
  }

  void _showCreatePinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Create Transaction PIN',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'You need a transaction PIN to perform secure transactions. Would you like to create one now?',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Skip
            child: Text('Later', style: GoogleFonts.outfit(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/set-pin');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1CB954),
              foregroundColor: Colors.white,
            ),
            child: Text('Create PIN', style: GoogleFonts.outfit()),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Green Theme Color
    const kPrimaryGreen = Color(0xFF005831); // Adjusted for the dark green look
    const kAccentGreen = Color(0xFF1CB954);
    const kYellow = Color(0xFFFFC107);

    return Scaffold(
      backgroundColor: Colors.white, // Main body background
      body: BlocBuilder<BankBloc, BankState>(
        builder: (context, state) {
          if (state is BankLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryGreen),
            );
          } else if (state is BankDataLoaded) {
            final account = state.account;
            final transactions = state.transactions;
            final formatter = NumberFormat.currency(symbol: '');

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Stack for Green Header + Floating Shortcuts
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Green Background & Top Content
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              kPrimaryGreen,
                              Color(0xFF107A3B),
                            ], // Darker accent green, but still lighter than primary (005831)
                          ),
                        ),
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 60,
                          bottom: 90, // Increased by 10px as requested (was 80)
                        ), // Extra bottom padding for overlap
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        'https://i.pravatar.cc/150?u=a042581f4e29026704d',
                                      ),
                                      backgroundColor: Colors.grey,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hello,',
                                          style: GoogleFonts.outfit(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          account.accountName,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Account Tags
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Tier 1',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text: account.accountNumber,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Account number copied!'),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          account.accountNumber,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 18),
                                        const Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Main Balance
                            Row(
                              children: [
                                if (_isBalanceVisible)
                                  Text(
                                    '₦ ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                const SizedBox(width: 7),
                                Text(
                                  _isBalanceVisible
                                      ? formatter.format(account.balance)
                                      : '****',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 32,
                                    height: 1.6,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isBalanceVisible = !_isBalanceVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isBalanceVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            // const SizedBox(height: 1),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Book balance ',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '₦', // Naira symbol with system font
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '1,500,000.34',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final authState = context
                                          .read<AuthBloc>()
                                          .state;
                                      if (authState is Authenticated) {
                                        if (!authState.user.hasPin) {
                                          _showCreatePinDialog();
                                        } else {
                                          Navigator.of(
                                            context,
                                          ).pushNamed('/transfer');
                                        }
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                    label: Text(
                                      'Send Money',
                                      style: GoogleFonts.outfit(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kYellow,
                                      foregroundColor: Colors.black87,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 0,
                                      iconAlignment: IconAlignment.end,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),

                                      //  color: Colors.white.withOpacity(0.15),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Top Up',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,

                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),

                                      iconAlignment: IconAlignment.end,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Floating Shortcuts Section
                      Positioned(
                        bottom: -55, // Float halfway out
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shortcuts',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 3),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,

                                child: Row(
                                  spacing: 8,
                                  children: [
                                    _buildShortcutItem(
                                      Icons.credit_card,
                                      'Cards',
                                      kAccentGreen,
                                    ),

                                    _buildShortcutItem(
                                      Icons.receipt_long,
                                      'Bills Payment',
                                      kAccentGreen,
                                    ),

                                    _buildShortcutItem(
                                      Icons.account_balance_wallet,
                                      'Expenses',
                                      kAccentGreen,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Spacer for the floating element overlap
                  const SizedBox(height: 60),

                  // Transactions List Layout
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Transactions',
                              style: GoogleFonts.outfit(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'See more >',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        const SizedBox(height: 16),
                        transactions.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 40,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.history_toggle_off,
                                        size: 48,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'You have no transactions yet',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: transactions.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final tx = transactions[index];
                                  return _buildTransactionItem(tx, index);
                                },
                              ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is BankError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<BankBloc>().add(FetchBankData()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("Initializing..."));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryGreen,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync_alt),
            label: 'Payments',
          ), // payments icon
          BottomNavigationBarItem(
            icon: Icon(Icons.savings_outlined),
            label: 'Saving',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.percent), label: 'Loans'),
        ],
      ),
    );
  }

  Widget _buildShortcutItem(IconData icon, String label, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50], // Very light grey bg
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(dynamic tx, int index) {
    // Determine credit/debit mainly for color, though design shows all same icon style usually
    // We'll stick to simple logic: Credit = Green Text, Debit = Black/Red Text
    final isCredit = tx.type.toString().toLowerCase() == 'credit';
    final formatter = NumberFormat.currency(
      symbol: '',
    ); // Remove default symbol

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.send_outlined,
              color: Colors.black54,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Transfer', // Static subtitle per design or tx.type
                  style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: isCredit ? '+' : '-',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isCredit ? Colors.blue : Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: '₦', // Safe system font
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isCredit ? Colors.blue : Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: formatter.format(tx.amount),
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isCredit ? Colors.blue : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '20 Mins ago', // Mock time or use tx.date relative time
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
