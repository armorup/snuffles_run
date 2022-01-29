import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:snuffles_run/game.dart';

class GameText extends TextComponent with HasGameRef<SnufflesGame> {
  GameText(String text) : super(text: text);
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    textRenderer = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 65,
        fontFamily: 'helvetica',
      ),
    );
    anchor = Anchor.center;
    position = Vector2(gameRef.size.x * 0.5, gameRef.size.y * 0.4);

    add(RemoveEffect(delay: 2));
  }
}
