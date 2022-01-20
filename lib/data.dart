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
  static Map<SceneType, List<String>> bgFilenames = {
    SceneType.outdoor: [
      '01_ground.png',
      '02_trees and bushes.png',
      '03_distant_trees.png',
      '04_bushes.png',
      '05_hill1.png',
      '08_clouds.png',
      '10_distant_clouds.png',
      '11_background.png',
    ],
    SceneType.forest: [
      '01_Mist.png',
      '02_Bushes.png',
      '03_Particles.png',
      '04_Forest.png',
      '09_Forest.png',
      '10_Sky.png',
    ]
  };
}
