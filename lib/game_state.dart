/// Describes the current state of the game.
enum PlayState { paused, playing, loading }

/// State of the game to track global infomration.
class GameState {
  /// Current playing state.
  static PlayState state = PlayState.loading;

  /// Show or hide debug infromation of flame.
  static bool showDebugInfo = false;

  ///Toggle sounds
  static bool playSounds = true;
}
