import 'package:flutter/material.dart';
import 'models/user_data.dart';
import 'utils/validators.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/summary_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    ),
    home: const SignUpScreen(),
  );
}

const groups = ['IT-2401', 'IT-2402', 'IT-2403', 'IT-2404', 'IT-2405'];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthController = TextEditingController();

  final _emailFocus = FocusNode();

  String? _group;
  DateTime? _birth;
  bool _agreed = false;
  bool _done = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm, _birthController]) {
      c.dispose();
    }
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null) return;
    if (!mounted) return;

    setState(() {
      _birth = picked;
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year;
      _birthController.text = '$day.$month.$year';
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created')),
      );
      setState(() {
        _done = true;
      });
    }
  }

  void _resetForm() {
    _name.clear();
    _email.clear();
    _password.clear();
    _confirm.clear();
    _birthController.clear();

    setState(() {
      _group = null;
      _birth = null;
      _agreed = false;
      _done = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: _done
          ? SummaryCard(
        userData: UserData(
          name: _name.text,
          email: _email.text,
          group: _group ?? '',
          birthDate: _birthController.text,
        ),
        onStartOver: _resetForm,
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _name,
                labelText: 'Name',
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                validator: Validators.name,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _email,
                focusNode: _emailFocus,
                labelText: 'Email',
                hintText: 'name@kbtu.kz',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _password,
                labelText: 'Password',
                helperText: 'At least 8 characters',
                suffixText: '${_password.text.length} of 8',
                obscureText: true,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}),
                validator: Validators.password,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirm,
                labelText: 'Confirm password',
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submitForm(),
                validator: (v) => Validators.confirmPassword(
                  v,
                  _password.text,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _group,
                decoration: const InputDecoration(
                  labelText: 'Group',
                ),
                items: [
                  for (final g in groups)
                    DropdownMenuItem(
                      value: g,
                      child: Text(g),
                    ),
                ],
                onChanged: (val) {
                  setState(() {
                    _group = val;
                  });
                },
                validator: Validators.group,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of birth',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                onTap: _selectDate,
                validator: (_) => Validators.birthDate(_birth),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('I agree to the rules'),
                value: _agreed,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (val) {
                  setState(() {
                    _agreed = val ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _agreed ? _submitForm : null,
                child: const Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}