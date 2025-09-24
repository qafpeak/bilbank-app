// widgets/remember_me_checkbox.dart
import 'package:flutter/material.dart';

class RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RememberMeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.white.withOpacity(0.7),
          ),
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: Colors.white,
            checkColor: const Color(0xFF4F46E5),
            side: BorderSide(color: Colors.white.withOpacity(0.7), width: 2),
          ),
        ),
        Text('Beni Hatırla', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
      ],
    );
  }
}
