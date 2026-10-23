import 'package:flutter/material.dart';
import '../core/app_state.dart';
import '../core/theme.dart';
import '../widgets/music_widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return ListView(
      key: const PageStorageKey('settings-scroll'),
      children: [
        const PageTitle('Settings'),
        const SectionTitle('User Account'),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 22, 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  state.email,
                  style: const TextStyle(fontSize: 15, color: AppColors.muted),
                ),
              ),
              TextButton(
                onPressed: () => _editEmail(context, state),
                child: const Text(
                  'Edit',
                  style: TextStyle(color: AppColors.pale),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 22, 30),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  '••••••••',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.muted,
                    letterSpacing: 4,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Demo account'),
                    content: const Text(
                      'This is a local UI preview. No sign-in service or account password is stored.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Got it'),
                      ),
                    ],
                  ),
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(color: AppColors.pale),
                ),
              ),
            ],
          ),
        ),
        const SectionTitle('Music'),
        _SettingToggle(
          'Offline Mode',
          value: state.offline,
          onChanged: (v) => state.setPreference('offline', v),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 12, 30, 0),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Music Quality',
                  style: TextStyle(color: AppColors.muted, fontSize: 15),
                ),
              ),
              Text(
                state.quality < .34
                    ? 'Low'
                    : state.quality < .8
                    ? 'Medium'
                    : 'High',
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Slider(
            key: const ValueKey('quality'),
            value: state.quality,
            onChanged: state.setQuality,
          ),
        ),
        _SettingToggle(
          'Autoplay',
          value: state.autoplay,
          onChanged: (v) => state.setPreference('autoplay', v),
        ),
        _SettingToggle(
          'Audio Normalisation',
          value: state.normalisation,
          onChanged: (v) => state.setPreference('normalisation', v),
        ),
        _SettingToggle(
          'Dark Version',
          toggleKey: const ValueKey('dark-theme'),
          value: state.dark,
          onChanged: state.setDark,
        ),
        const SizedBox(height: 22),
      ],
    );
  }

  Future<void> _editEmail(BuildContext context, AppState state) async {
    final controller = TextEditingController(text: state.email);
    final formKey = GlobalKey<FormState>();
    final email = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit profile email'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) =>
                RegExp(
                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                ).hasMatch(value?.trim() ?? '')
                ? null
                : 'Enter a valid email',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (email != null) state.setEmail(email);
    // The dialog route finishes its closing animation after its future completes.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    controller.dispose();
  }
}

class _SettingToggle extends StatelessWidget {
  const _SettingToggle(
    this.label, {
    required this.value,
    required this.onChanged,
    this.toggleKey,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Key? toggleKey;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: SizedBox(
      height: 44,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 15),
            ),
          ),
          Transform.scale(
            scale: .72,
            alignment: Alignment.centerRight,
            child: Switch(
              key: toggleKey,
              value: value,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    ),
  );
}
