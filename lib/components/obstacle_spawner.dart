import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:rive/rive.dart';
import 'package:snuffles_run/game.dart';
import 'package:snuffles_run/components/obstacle.dart';
import 'package:snuffles_run/main.dart';
import 'package:snuffles_run/models/obstacle_model.dart';

enum SpawnState { spawning, stopped, started }

/// A spawn point for game obstacles
class ObstacleSpawner extends PositionComponent with HasGameRef<SnufflesGame> {
  ObstacleSpawner(this.obstModels)
      : _launcher = Launcher(obstModels: obstModels);

  factory ObstacleSpawner.initial() {
    return ObstacleSpawner(gameData.scenes.first.obstacles);
  }

  final Launcher _launcher;
  final List<ObstacleModel> obstModels;

  SpawnState spawnState = SpawnState.stopped;
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
    _launcher.reset();
    waveNumber = _launcher._waveNumber;
    // remove all obstacles from game

    _loadWaves();
    start();
  }

  // Start the spawner
  void start() => spawnState = SpawnState.started;

  // Stop the spawner
  void stop() => spawnState = SpawnState.stopped;

  // Load next wave
  void nextWave() {
    _launcher._loadNextWave();
    waveNumber = _launcher._waveNumber;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (spawnState == SpawnState.started) {
      bool waveComplete = _launcher._launchWave(dt);
      if (waveComplete) {
        stop();
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

  double delayMultiplier = 5;
  final List<List<Obstacle>> _curWaves = [];
  final List<Obstacle> _curWave = [];
  int _waveNumber = 0;

  // Delay between waves
  final double _waveDelay = 2;
  double _timer = 0;

  var artboard = Artboard();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    artboard = await loadArtboard(
        RiveFile.asset('assets/images/outdoor/obstacles/stone.riv'));
  }

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
    for (int waveNum = 1; waveNum < waves.length; waveNum++) {
      _curWaves.add(
        waves[waveNum]
            .map(
              (delay) => Obstacle(
                model: obstModels.first,
                delayFactor: delay,
                speedScale: waveNum,
              ),
            )
            .toList(),
      );
    }
  }

  // Add a delay before launching next obstacle
  void addLaunchDelay(double dt) => _timer -= dt;

  void _loadNextWave() {
    if (_curWaves.isEmpty) return;
    addLaunchDelay(_waveDelay);
    _waveNumber++;
    _curWave.addAll(_curWaves.removeAt(0));
  }

  // Launch the obstacle. Returns true if the the wave is complete
  bool _launchWave(double dt) {
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

  void reset() {
    // Remove any remaining obstacles
    removeAll(children.whereType<Obstacle>());
    _timer = 0;
    _curWaves.clear();
    _curWave.clear();
    _waveNumber = 0;
  }
}
