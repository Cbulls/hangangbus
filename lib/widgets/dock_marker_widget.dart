// lib/utils/icon_marker.dart
//
// kakao_map_plugin은 markerImageSrc로 이미지 URL(문자열)만 받을 수 있고
// Flutter 위젯을 직접 넘길 수 없다. 그래서 Canvas로 배지 모양을 직접 그려
// PNG로 렌더링한 뒤 base64 data URI(문자열)로 변환해 "가짜 URL"처럼 넘긴다.

import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// 아이콘 + 텍스트 라벨이 있는 알약(pill) 모양 마커.
/// 예: 선착장 이름 + 선착장 고유 색상 배지.
Future<String> pillMarkerDataUri({
  required IconData icon,
  required String label,
  required Color backgroundColor,
  Color iconColor = Colors.white,
  Color textColor = Colors.white,
  double width = 90,
  double height = 36,
  double pixelRatio = 3.0, // 레티나 대응 (값이 클수록 선명, 대신 용량↑)
}) async {
  const shadowMargin = 6.0;
  final canvasWidth = (width + shadowMargin * 2) * pixelRatio;
  final canvasHeight = (height + shadowMargin * 2) * pixelRatio;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.scale(pixelRatio);

  final rrect = RRect.fromRectAndRadius(
    Rect.fromLTWH(shadowMargin, shadowMargin, width, height),
    Radius.circular(height / 2),
  );

  // 그림자
  canvas.drawRRect(
    rrect.shift(const Offset(0, 2)),
    Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
  );

  // 배경 알약
  canvas.drawRRect(rrect, Paint()..color = backgroundColor);

  const iconSize = 16.0;
  const fontSize = 13.0;
  const gap = 6.0;

  final iconPainter = TextPainter(
    textDirection: TextDirection.ltr,
    text: TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: iconSize,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: iconColor,
      ),
    ),
  )..layout();

  final textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    text: TextSpan(
      text: label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
    ),
    maxLines: 1,
    ellipsis: '…',
  )..layout(maxWidth: width - 20 - iconPainter.width - gap);

  final contentWidth = iconPainter.width + gap + textPainter.width;
  final startX = shadowMargin + (width - contentWidth) / 2;
  final centerY = shadowMargin + height / 2;

  iconPainter.paint(canvas, Offset(startX, centerY - iconPainter.height / 2));
  textPainter.paint(
    canvas,
    Offset(startX + iconPainter.width + gap, centerY - textPainter.height / 2),
  );

  final picture = recorder.endRecording();
  final image = await picture.toImage(canvasWidth.ceil(), canvasHeight.ceil());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return 'data:image/png;base64,${base64Encode(byteData!.buffer.asUint8List())}';
}

/// 아이콘만 있는 원형 마커 (관광지용, 라벨 없이 심플하게).
Future<String> circleIconMarkerDataUri({
  required IconData icon,
  required Color backgroundColor,
  Color iconColor = Colors.white,
  double size = 32,
  double pixelRatio = 3.0,
}) async {
  const shadowMargin = 6.0;
  final canvasSize = (size + shadowMargin * 2) * pixelRatio;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.scale(pixelRatio);

  final center = Offset(shadowMargin + size / 2, shadowMargin + size / 2);

  canvas.drawCircle(
    center + const Offset(0, 2),
    size / 2,
    Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
  );
  canvas.drawCircle(center, size / 2, Paint()..color = backgroundColor);

  final iconPainter = TextPainter(
    textDirection: TextDirection.ltr,
    text: TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size * 0.55,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: iconColor,
      ),
    ),
  )..layout();

  iconPainter.paint(
    canvas,
    center - Offset(iconPainter.width / 2, iconPainter.height / 2),
  );

  final picture = recorder.endRecording();
  final image = await picture.toImage(canvasSize.ceil(), canvasSize.ceil());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return 'data:image/png;base64,${base64Encode(byteData!.buffer.asUint8List())}';
}
