
import 'package:flutter/material.dart';

class RuleCard extends StatelessWidget {
  const RuleCard({
    required this.rules,
    this.isHighlighted=false,
    super.key,
  });

  final List<String> rules;
  final bool isHighlighted ;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: isHighlighted
          ? Colors.orange.shade100.withOpacity(0.3)
          : Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rules
              .map(
                (rule) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          rule,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
