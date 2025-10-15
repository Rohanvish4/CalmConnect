import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../component/calm_connect_logo.dart';
import '../../controller/auth_controller.dart';
import '../../model/user_model.dart';
import '../../routes/routes.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _c = {
    'email': TextEditingController(),
    'password': TextEditingController(),
    'name': TextEditingController(),
    'specialization': TextEditingController(),
    'experience': TextEditingController(),
  };
  bool _isSignUp = false, _isLoading = false, _obscure = true;
  UserType _userType = UserType.peer;
  DateTime? _lastClickTime;

  @override
  void dispose() { for (final t in _c.values) t.dispose(); super.dispose(); }

  Future<void> _auth() async {
    // Prevent multiple rapid clicks
    if (_isLoading) return;
    
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final a = Get.find<AuthController>();
      final email = _c['email']!.text.trim();
      final pass = _c['password']!.text;
      
      bool ok;
      if (_isSignUp) {
        // Additional validation for sign up
        final name = _c['name']!.text.trim();
        if (name.isEmpty) {
          Get.snackbar(
            'Error',
            'Name is required for registration',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );
          return;
        }
        
        // Validate counselor-specific fields
        if (_userType == UserType.counsellor) {
          final specialization = _c['specialization']!.text.trim();
          final experienceText = _c['experience']!.text.trim();
          
          if (specialization.isEmpty) {
            Get.snackbar(
              'Error',
              'Specialization is required for counselors',
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16),
            );
            return;
          }
          
          if (experienceText.isEmpty || (int.tryParse(experienceText) ?? -1) < 0) {
            Get.snackbar(
              'Error',
              'Valid years of experience is required for counselors',
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16),
            );
            return;
          }
        }
        
        ok = await a.signUp(
          email: email,
          password: pass,
          name: name,
          userType: _userType,
          specialization: _userType == UserType.counsellor ? _c['specialization']!.text.trim() : '',
          experienceYears: _userType == UserType.counsellor ? int.tryParse(_c['experience']!.text) ?? 0 : 0,
        );
      } else {
        ok = await a.signIn(email: email, password: pass);
      }
      
      if (ok) {
        Get.snackbar(
          'Success',
          _isSignUp ? 'Account created successfully!' : 'Welcome back!',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        Get.offAllNamed(Routes.homePageRoute);
      } else {
        Get.snackbar(
          'Error',
          _isSignUp ? 'Registration failed. Please try again.' : 'Login failed. Please check your credentials.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _field({
    required String id,
    required String label,
    String? hint,
    TextInputType? type,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? v,
  }) => TextFormField(
        controller: _c[id],
        decoration: InputDecoration(
          labelText: label, hintText: hint, border: const OutlineInputBorder(), filled: true, suffixIcon: suffix),
        keyboardType: type, obscureText: obscure, validator: v,
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          // Soft calming gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primaryContainer.withOpacity(.35), cs.surface],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
          ),
          // Subtle top accent
          Positioned(
            right: -60, top: -60,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary.withOpacity(.08),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Brand + subtle motion
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1), duration: const Duration(milliseconds: 600),
                              builder: (_, v, child) => Opacity(opacity: v, child: Transform.translate(offset: Offset(0, (1 - v) * 12), child: child)),
                              child: Column(
                                children: [
                                  const CalmConnectLogo(
                                    size: 68,
                                  ),
                                  const SizedBox(height: 10),
                                  Text('CalmConnect',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w700, color: cs.primary)),
                                  const SizedBox(height: 4),
                                  Text('Share safely. Support 24/7. Heal together.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: cs.onSurfaceVariant)),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8, runSpacing: 8,
                                    alignment: WrapAlignment.center,
                                    children: const [
                                      _Badge(icon: Icons.verified_user_rounded, label: 'Judgment‑free'),
                                      _Badge(icon: Icons.support_agent_rounded, label: '24/7 Support'),
                                      _Badge(icon: Icons.groups_rounded, label: 'Peers + Counselors'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            if (_isSignUp) ...[
                              _field(
                                id: 'name', label: 'Full Name',
                                v: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Name is required';
                                  if (v.trim().length < 2) return 'Name must be at least 2 characters';
                                  return null;
                                }),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<UserType>(
                                value: _userType,
                                decoration: const InputDecoration(
                                  labelText: 'I am a...', border: OutlineInputBorder(), filled: true),
                                items: const [
                                  DropdownMenuItem(value: UserType.peer, child: Text('🤝 Peer')),
                                  DropdownMenuItem(value: UserType.counsellor, child: Text('🩺 Counselor')),
                                ],
                                onChanged: (v) => setState(() => _userType = v!),
                              ),
                              const SizedBox(height: 12),
                              AnimatedCrossFade(
                                firstChild: const SizedBox.shrink(),
                                secondChild: Column(children: [
                                  _field(
                                    id: 'specialization', label: 'Specialization',
                                    hint: 'e.g., Anxiety, Depression, Trauma, CBT',
                                    v: (v) {
                                      if (_userType == UserType.counsellor) {
                                        if (v == null || v.trim().isEmpty) {
                                          return 'Specialization is required for counselors';
                                        }
                                        if (v.trim().length < 3) {
                                          return 'Please provide a valid specialization';
                                        }
                                      }
                                      return null;
                                    }),
                                  const SizedBox(height: 12),
                                  _field(
                                    id: 'experience', label: 'Years of Experience',
                                    type: TextInputType.number,
                                    hint: 'e.g., 5',
                                    v: (v) {
                                      if (_userType == UserType.counsellor) {
                                        if (v == null || v.trim().isEmpty) {
                                          return 'Experience is required for counselors';
                                        }
                                        final n = int.tryParse(v.trim());
                                        if (n == null || n < 0) {
                                          return 'Please enter a valid number of years';
                                        }
                                        if (n > 50) {
                                          return 'Please enter a reasonable number of years';
                                        }
                                      }
                                      return null;
                                    }),
                                ]),
                                crossFadeState: _userType == UserType.counsellor
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 250),
                              ),
                            ],

                            _field(
                              id: 'email', label: 'Email', type: TextInputType.emailAddress,
                              v: (v) {
                                if (v == null || v.trim().isEmpty) return 'Email is required';
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              }),
                            const SizedBox(height: 12),
                            _field(
                              id: 'password', label: 'Password', obscure: _obscure,
                              v: (v) {
                                if (v == null || v.isEmpty) return 'Password is required';
                                if (v.length < 6) return 'Password must be at least 6 characters';
                                return null;
                              },
                              suffix: IconButton(
                                onPressed: () => setState(() => _obscure = !_obscure),
                                icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded)),
                            ),
                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity, height: 48,
                              child: FilledButton.icon(
                                onPressed: _isLoading ? null : () async {
                                  // Prevent rapid multiple clicks (debounce)
                                  final now = DateTime.now();
                                  if (_lastClickTime != null && 
                                      now.difference(_lastClickTime!) < const Duration(seconds: 2)) {
                                    return;
                                  }
                                  _lastClickTime = now;
                                  
                                  // Dismiss keyboard before auth
                                  FocusScope.of(context).unfocus();
                                  await _auth();
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: _isLoading 
                                    ? Theme.of(context).colorScheme.primary.withOpacity(0.6)
                                    : Theme.of(context).colorScheme.primary,
                                ),
                                icon: _isLoading
                                    ? SizedBox(
                                        width: 18, height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2, 
                                          color: Colors.white,
                                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Icon(_isSignUp ? Icons.person_add_rounded : Icons.login_rounded),
                                label: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Text(
                                    _isLoading 
                                      ? (_isSignUp ? 'Creating Account...' : 'Signing In...')
                                      : (_isSignUp ? 'Create Account' : 'Sign In'),
                                    key: ValueKey('${_isSignUp}_$_isLoading'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isSignUp = !_isSignUp;
                                  _userType = UserType.peer;
                                  _isLoading = false; // Reset loading state
                                });
                                // Reset form validation
                                _formKey.currentState?.reset();
                                // Clear counselor-specific fields when switching
                                if (!_isSignUp) {
                                  _c['specialization']?.clear();
                                  _c['experience']?.clear();
                                }
                              },
                              child: Text(_isSignUp
                                  ? 'Already have an account? Sign In'
                                  : 'New here? Create an account'),
                            ),

                            if (_isSignUp) ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shield_rounded, size: 18, color: cs.primary),
                                  const SizedBox(width: 6),
                                  Text('Private, anonymous, and secure',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: cs.onSurfaceVariant)),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}

class _Badge extends StatelessWidget {
  final IconData icon; final String label;
  const _Badge({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(icon, size: 16, color: cs.primary),
      label: Text(label),
      side: BorderSide(color: cs.primary.withOpacity(.25)),
      backgroundColor: cs.primaryContainer.withOpacity(.18),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}