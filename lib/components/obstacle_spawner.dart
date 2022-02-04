import 'dart:math';
import 'package:flame/components.dart';
import 'package:snuffles_run/components/scene.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/components/obstacle.dart';
import 'package:snuffles_run/models/obstacle_model.dart';

enum SpawnState { spawning, notSpawning }

/// A spawn point for game obstacles
class ObstacleSpawner extends PositionComponent
    with HasGameRef<SnufflesGame>
    implements Pausable {
  ObstacleSpawner(this.obstModels)
      : _launcher = Launcher(obstModels: obstModels);

  final Launcher _launcher;
  final List<ObstacleModel> obstModels;

  SpawnState spawnState = SpawnState.notSpawning;
  PausedState state = PausedState.paused;
  double delayMultiplier = 5;
  int waveNumber = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(_launcher);
    _loadWaves();
  }

  void _loadWaves() {
    int numWaves = 50;
    int numObstacles = debugMode ? 1 : 2;
    List<List<double>> waves = [];
    for (var i = 0; i < numWaves; i++) {
      // The first obstacle has zero delay
      waves.add([0]);
      for (var j = 1; j < numObstacles; j++) {
        waves[i].add(Random().nextDouble().clamp(0.3, 0.5));
      }
    }
    _launcher.loadAll(waves: waves);
    nextWave();
  }

  void restart() {
    _launcher._reset();
    waveNumber = 0;
    _loadWaves();
    unpause();
  }

  // Start the spawner
  @override
  void unpause() {
    state = PausedState.unpaused;
    spawnState = SpawnState.spawning;
  }

  // Stop the spawner
  @override
  void pause() {
    state = PausedState.paused;
    spawnState = SpawnState.notSpawning;
  }

  void startSpawning() {
    spawnState = SpawnState.spawning;
  }

  void stopSpawning() {
    spawnState = SpawnState.notSpawning;
  }

  // Load next wave
  void nextWave() {
    _launcher._loadNextWave();
    waveNumber = _launcher._waveNumber;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (state == PausedState.paused) return;

    if (spawnState == SpawnState.spawning) {
      bool waveIsComplete = _launcher._launchWave(dt);
      if (waveIsComplete) {
        spawnState = SpawnState.notSpawning;
      }
    }
  }
}

/// Launcher for obstacles
class Launcher extends PositionComponent with HasGameRef<SnufflesGame> {
  Launcher({
    required this.obstModels,
    this.delayMultiplier = 5,
  });

  List<ObstacleModel> obstModels;
  int _waveNumber = 0;
  double delayMultiplier = 5;
  final List<List<Obstacle>> _curWaves = [];
  final List<Obstacle> _curWave = [];

  // Delay between waves
  final double _waveDelay = 2;
  double _timer = 0;

  // Load launcher with a single list of delays
  void load({required List<double> wave}) {
    _curWaves.add(wave
        .map(
          (delay) => Obstacle(
            model: obstModels.first,
            delayFactor: delay,
          ),
        )
        .toList());
  }

  // Load launcher with several lists of delays representing
  // muliple waves of obstacles
  void loadAll({required List<List<double>> waves}) {
    // Random obstacle model to load
    for (int waveNum = 1; waveNum < waves.length; waveNum++) {
      var index = Random().nextInt(obstModels.length);
      _curWaves.add(
        waves[waveNum]
            .map(
              (delay) => Obstacle(
                model: obstModels[index],
                delayFactor: delay,
                speedScale: waveNum,
              ),
            )
            .toList(),
      );
    }
  }

  /// Add a delay before launching next obstacle
  void _addLaunchDelay(double dt) => _timer -= dt;

  // Load the next wave into launcher
  void _loadNextWave() {
    if (_curWaves.isEmpty) return;
    _addLaunchDelay(_waveDelay);
    _waveNumber++;
    _curWave.addAll(_curWaves.removeAt(0));
  }

  // Launch the obstacle. Returns true if the wave is complete
  bool _launchWave(double dt) {
    if (_curWave.isEmpty) return true;
    _timer += dt;
    if (_timer > _curWave.first.delayFactor * delayMultiplier) {
      // Spawn the obstacle
      var obs = _curWave.removeAt(0);
      obs.isLastInWave = _curWave.isEmpty && _curWaves.isNotEmpty;
      obs.isLastInLevel = _curWave.isEmpty && _curWaves.isEmpty;
      add(obs);
      _timer = 0;
    }
    return _curWave.isEmpty;
  }

  void _reset() {
    // Remove any remaining obstacles in the launch queue
    removeAll(children);
    _timer = 0;
    _curWaves.clear();
    _curWave.clear();
    _waveNumber = 0;
  }
}
