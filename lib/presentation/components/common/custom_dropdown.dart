import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final String? hint;
  final List<Map<String, String>> items;
  final Function(String?) onChanged;
  final String? errorText;

  const CustomDropdown({
    Key? key,
    required this.label,
    this.value,
    this.hint,
    required this.items,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: value?.isEmpty == true ? null : value,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: Text(hint ?? ''),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item['value'],
                child: Text(item['label']!),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
        if (errorText != null) _buildErrorText(errorText!),
      ],
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
    );
  }

  Widget _buildErrorText(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: Text(text, style: TextStyle(color: Colors.red, fontSize: 12)),
    );
  }
}
