import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snuffles_run/components/game.dart';

/// The score text to show on screen
class ScoreText extends TextComponent with HasGameRef<SnufflesGame> {
  final _textRenderer = TextPaint(
    style: const TextStyle(
      fontSize: 50,
      fontFamily: 'Menlo',
      color: Colors.white,
    ),
  );

  var _text = '';
  final offset = 30; // offset from edget of screen

  @override
  Future<void>? onLoad() {
    super.onLoad();
    _text = '0';

    positionType = PositionType.viewport;
  }

  // Format score for display
  String _formatScore(double score) {
    return ((score * 10).floor().toString());
  }

  // Position score text correctly on screen
  void positionText(String text) {
    final textSize = _textRenderer.measureText(_text);
    position =
        Vector2(gameRef.size.x / 2 - textSize.x / 2 - offset, textSize.y / 5);
  }

  @override
  void update(double dt) {
    _text = _formatScore(gameRef.score);
    positionText(_text);
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    _textRenderer.render(canvas, _text, position);
    super.render(canvas);
  }
}
