import 'package:flutter/material.dart';

class SummaryContainer extends StatelessWidget {
  final List<SummaryItem> items;

  const SummaryContainer({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: item.isLast ? 0 : 12),
                child: item.isDescription
                    ? _buildDescriptionItem(item)
                    : _buildSummaryRow(item.label, item.value),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(value, style: TextStyle(color: Colors.grey[900])),
        ),
      ],
    );
  }

  Widget _buildDescriptionItem(SummaryItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 4),
        Text(item.value, style: TextStyle(color: Colors.grey[900])),
      ],
    );
  }
}

class SummaryItem {
  final String label;
  final String value;
  final bool isDescription;
  final bool isLast;

  const SummaryItem({
    required this.label,
    required this.value,
    this.isDescription = false,
    this.isLast = false,
  });
}
