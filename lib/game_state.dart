/// Describes the current state of the game.
enum PlayState { paused, playing, inMenu, gameover, loading }
enum GameMode { story, endless }

/// State of the game to track global infomration.
class GameState {
  /// Current playing state.
  static PlayState state = PlayState.loading;

  static GameMode mode = GameMode.story;

  ///Toggle sounds
  static bool musicOn = true;

  static bool sfxOn = true;
}
