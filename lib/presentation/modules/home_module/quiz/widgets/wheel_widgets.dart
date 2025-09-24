import 'package:flutter/material.dart';
import 'dart:math' as math;

class WheelWidget extends StatelessWidget {
  final bool isSpinning;
  final double size;
  
  const WheelWidget({
    Key? key,
    required this.isSpinning,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: WheelPainter(isSpinning: isSpinning),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final bool isSpinning;
  
  WheelPainter({required this.isSpinning});

  // Çark segmentleri - toplam 15 segment
  final List<WheelSegment> segments = [
    // 10x - 5 adet
    WheelSegment(multiplier: '10x', color: Color(0xFF4CAF50)), // Yeşil
    WheelSegment(multiplier: '10x', color: Color(0xFF4CAF50)),
    WheelSegment(multiplier: '10x', color: Color(0xFF4CAF50)),
    WheelSegment(multiplier: '10x', color: Color(0xFF4CAF50)),
    WheelSegment(multiplier: '10x', color: Color(0xFF4CAF50)),
    
    // 25x - 4 adet
    WheelSegment(multiplier: '25x', color: Color(0xFF2196F3)), // Mavi
    WheelSegment(multiplier: '25x', color: Color(0xFF2196F3)),
    WheelSegment(multiplier: '25x', color: Color(0xFF2196F3)),
    WheelSegment(multiplier: '25x', color: Color(0xFF2196F3)),
    
    // 50x - 3 adet
    WheelSegment(multiplier: '50x', color: Color(0xFF9C27B0)), // Mor
    WheelSegment(multiplier: '50x', color: Color(0xFF9C27B0)),
    WheelSegment(multiplier: '50x', color: Color(0xFF9C27B0)),
    
    // 75x - 2 adet
    WheelSegment(multiplier: '75x', color: Color(0xFFFF9800)), // Turuncu
    WheelSegment(multiplier: '75x', color: Color(0xFFFF9800)),
    
    // 100x - 1 adet
    WheelSegment(multiplier: '100x', color: Color(0xFFFFD700)), // Altın
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    
    // Çark segmentlerini çiz
    final segmentAngle = 2 * math.pi / segments.length;
    
    for (int i = 0; i < segments.length; i++) {
      final startAngle = i * segmentAngle;
      final sweepAngle = segmentAngle;
      
      // Segment boyası
      final paint = Paint()
        ..color = segments[i].color
        ..style = PaintingStyle.fill;
      
      // Segment çiz
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 2),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      // Segment sınırları
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 2),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );
      
      // Metin ekle (sadece büyük çarklarda görünür olsun)
      if (radius > 25) {
        final textAngle = startAngle + sweepAngle / 2;
        final textRadius = radius * 0.7;
        final textCenter = Offset(
          center.dx + math.cos(textAngle) * textRadius,
          center.dy + math.sin(textAngle) * textRadius,
        );
        
        final textSpan = TextSpan(
          text: segments[i].multiplier,
          style: TextStyle(
            color: Colors.white,
            fontSize: math.max(8, radius * 0.2),
            fontWeight: FontWeight.bold,
          ),
        );
        
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        
        textPainter.layout();
        
        canvas.save();
        canvas.translate(textCenter.dx, textCenter.dy);
        canvas.rotate(textAngle + math.pi / 2);
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
        canvas.restore();
      }
    }
    
    // Merkez daire
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.15, centerPaint);
    
    // Merkez sınır
    final centerBorderPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawCircle(center, radius * 0.15, centerBorderPaint);
    
    // Çark dönerken parlama efekti
    if (isSpinning) {
      final glowPaint = Paint()
        ..color = Colors.amber.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      
      canvas.drawCircle(center, radius, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WheelSegment {
  final String multiplier;
  final Color color;
  
  WheelSegment({
    required this.multiplier,
    required this.color,
  });
}