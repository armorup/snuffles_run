/// Describes the current state of the game.
enum PlayState { paused, playing, loading }

/// State of the game to track global infomration.
class GameState {
  /// Current playing state.
  static PlayState state = PlayState.loading;

  ///Toggle sounds
  static bool playSounds = true;
}
