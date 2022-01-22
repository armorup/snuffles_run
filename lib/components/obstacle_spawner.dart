import 'package:flame/components.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/components/obstacle.dart';

enum SpawnState { spawning, stopped, started }

/// A spawn point for game obstacles
class ObstacleSpawner extends PositionComponent with HasGameRef<SnufflesGame> {
  ObstacleSpawner() : launcher = Launcher();
  Launcher launcher;

  SpawnState spawnState = SpawnState.stopped;
  double delayMultiplier = 5;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(launcher);

    // List of delay times before each obstacle spawn as a fraction
    // of the base delay time
    List<double> testWave = [0, 0.5, 0.9];
    launcher.load(wave: testWave);
    start();
  }

  // Start the spawner
  void start() {
    spawnState = SpawnState.started;
  }

  // Stop the spawner
  void stop() {
    spawnState = SpawnState.stopped;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (spawnState == SpawnState.started) {
      bool waveComplete = launcher.launchWave(dt);
      if (waveComplete) {
        spawnState = SpawnState.stopped;
      }
      //   gameRef.add(GameText('Wave complete!'));
      //   launcher.loadNextWave();
      // }
    }
  }
}

class Launcher extends PositionComponent with HasGameRef<SnufflesGame> {
  Launcher({
    this.delayMultiplier = 5,
  });

  double delayMultiplier = 5;
  List<List<Obstacle>> waves = [];
  List<Obstacle> curWave = [];
  int waveNumber = 0;

  // Delay between waves
  double waveDelay = 2;
  double delay = 0;
  double timer = 0;

  // Load launcher with a single list of delays
  void load({required List<double> wave}) {
    waves.add(wave
        .map(
          (delay) => Obstacle(delayFactor: delay),
        )
        .toList());
    // after loading the wave, put it in the launch queue
    loadNextWave();
  }

  // Load launcher with several lists of delays representing
  // muliple waves of obstacles
  void fullLoad({required List<List<double>> delays}) {
    for (List<double> wave in delays) {
      waves.add(
        wave
            .map(
              (delay) => Obstacle(delayFactor: delay),
            )
            .toList(),
      );
    }
    // after loading the waves, put the first one in the launch queue
    loadNextWave();
  }

  // Add a delay before launching next obstacle
  void addLaunchDelay(double dt) {
    timer -= dt;
  }

  void loadNextWave() {
    if (waves.isEmpty) return;
    addLaunchDelay(waveDelay);
    curWave.addAll(waves.removeAt(0));
  }

  // Launch the obstacle returns true if the the wave is complete
  bool launchWave(double dt) {
    timer += dt;
    if (timer > curWave.first.delayFactor * delayMultiplier) {
      // Spawn the obstacle
      var obs = curWave.removeAt(0);
      obs.isLastInWave = curWave.isEmpty;
      obs.isLastInLevel = curWave.isEmpty && waves.isEmpty;
      add(obs);
      timer = 0;
    }
    return curWave.isEmpty;
  }

  void reset() {
    waveNumber = 0;
    waves.clear();
    curWave.clear();
  }
}
