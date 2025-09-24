import 'package:flutter/material.dart';

import 'earning_item_model.dart';
import 'flow_info_message.dart';
import 'method_card.dart';

class EarningMethodsList extends StatelessWidget {
  final List<EarningMethod> methods;
  final Function(String) onMethodTap;
  final bool isFollow;
  final Animation<double>? pulseAnimation;

  const EarningMethodsList({
    Key? key,
    required this.methods,
    required this.onMethodTap,
    required this.isFollow,
    this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: methods.map((method) {
          return Column(
            children: [
              MethodCard(
                method: method,
                onTap: () => onMethodTap(method.id),
                isPulsing: method.id == 'ads',
                pulseAnimation: pulseAnimation,
              ),
              if (isFollow && method.id == 'social')
                FollowInfoMessage(
                  message: 'Takip isteğiniz doğrulandıktan sonra elmaslarınız yatırılacaktır.',
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
