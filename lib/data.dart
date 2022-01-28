/// The scenario type
/// Matches scene type name to folder that contains the parallax images
enum SceneType {
  outdoor,
  forest,
}

/// The game data
class Data {
  static int level = 1;
  static String hero = 'bunny';
  static SceneType scene = SceneType.outdoor;

  // Scene and wave completed for that scene
  // 0 means that scene hasn't been attempted
  // -1 means that scene is locked
  static Map<SceneType, int> completion = {
    SceneType.outdoor: 0,
    SceneType.forest: 0,
  };

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
