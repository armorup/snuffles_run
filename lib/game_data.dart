enum HeroType {
  bunny,
  dog,
}

enum BackgroundType {
  outdoor,
  forest,
  backyard,
  kitchen,
}

enum ObstacleType {
  rock,
  fork,
}

/// The scenario type
/// Matches scene type name to folder that contains the parallax images
enum SceneType {
  outdoor,
  forest,
  backyard,
}

/// The game data utilities

class GameData {
  Map<String, dynamic> gameData = {
    'heros': [
      {
        'type': 'bunny',
      },
      {
        'type': 'dog',
      }
    ],
    'scenes': [
      {
        'type': 'outdoor',
        'obstacles': [
          {
            'type': 'rock',
            'filename': 'rock.svg',
          },
        ],
        'background': {
          'type': 'outdoor',
          'filenames': [
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
          ]
        },
      },
      {
        'type': 'forest',
        'obstacles': [
          {
            'type': '',
            'filename': '',
          },
          {
            'type': '',
            'filename': '',
          }
        ],
        'background': {
          'type': 'forest',
          'filenames': [
            '00_ground.png',
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
        },
      },
      {
        'type': 'backyard',
        'obstacles': [
          {
            'type': '',
            'filename': '',
          },
          {
            'type': '',
            'filename': '',
          }
        ],
        'background': {
          'type': 'backyard',
          'filenames': [
            '01_ground.png',
            '02_petals.png',
            '03_bushes.png',
            '04_foregroundtrees.png',
            '05_grass.png',
            '06_backgroundtrees.png',
            '07_clouds.png',
            '08_sky.png',
          ]
        },
      },
      {
        'type': 'kitchen',
        'obstacles': [
          {
            'type': 'fork',
            'filename': '',
          },
          {
            'type': 'spoon',
            'filename': '',
          }
        ],
        'background': {
          'type': 'kitchen',
          'filenames': [
            '01_furniture.png',
            '02_wall.png',
          ]
        },
      },
    ],
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
      '00_ground.png',
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
    ],
    SceneType.backyard: [
      '01_ground.png',
      '02_petals.png',
      '03_bushes.png',
      '04_foregroundtrees.png',
      '05_grass.png',
      '06_backgroundtrees.png',
      '07_clouds.png',
      '08_sky.png',
    ]
  };
}
