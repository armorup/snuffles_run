/// The scenario type
/// Matches scene type name to folder that contains the parallax images
enum SceneType {
  outdoor,
  forest,
}

/// The game data
class Data {
  static String hero = 'bunny';
  static SceneType curScene = SceneType.outdoor;

  static Map<SceneType, Map<String, dynamic>> scenes = {
    SceneType.outdoor: {
      'locked': false,
      'highscore': 0,
    },
  };

  /// Add a scene
  static bool addScene(SceneType sceneType) {
    if (scenes.containsKey(sceneType)) return false;
    scenes.putIfAbsent(sceneType, () => {'locked': true, 'highscore': 0});
    return true;
  }

  /// Unlock a scene
  static bool unlockScene(SceneType sceneType) {
    if (!scenes.containsKey(sceneType)) return false;
    var locked = scenes[sceneType]!['locked'];
    if (!locked) return false;
    scenes[sceneType]!['locked'] = false;
    return true;
  }

  /// Update high score
  static void updateHighscore(SceneType sceneType, int score) {
    final high = Data.scenes[sceneType]!['highscore'];
    if (score > high) {
      Data.scenes[sceneType]!['highscore'] = score;
    }
  }

  // List of file names for each scene
  static Map<SceneType, List<String>> bgFilenames = {
    SceneType.outdoor: [
      '01_ground.png',
      '02_trees and bushes.png',
      '03_distant_trees.png',
      '04_bushes.png',
      '05_hill1.png',
      '06_hill2.png',
      '07_huge_clouds.png',
      '08_clouds.png',
      '09_distant_clouds1.png',
      '10_distant_clouds.png',
      '11_background.png',
    ],
    SceneType.forest: [
      '01_Mist.png',
      '02_Bushes.png',
      '03_Particles.png',
      '04_Forest.png',
      '05_Particles.png',
      '06_Forest.png',
      '07_Forest.png',
      '08_Forest.png',
      '09_Forest.png',
      '10_Sky.png',
    ]
  };
}
