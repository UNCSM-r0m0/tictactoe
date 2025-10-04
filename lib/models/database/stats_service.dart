import 'database_helper.dart';
import 'game_stats.dart';

class StatsService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Crear o actualizar estadísticas de un jugador
  Future<void> updatePlayerStats({
    required String playerName,
    required String playerType,
    required String result, // 'won', 'lost', 'drawn'
  }) async {
    final db = await _dbHelper.database;

    // Buscar estadísticas existentes
    final existingStats = await getPlayerStats(playerName, playerType);

    if (existingStats != null) {
      // Actualizar estadísticas existentes
      int newGamesPlayed = existingStats.gamesPlayed + 1;
      int newGamesWon = existingStats.gamesWon;
      int newGamesLost = existingStats.gamesLost;
      int newGamesDrawn = existingStats.gamesDrawn;

      switch (result) {
        case 'won':
          newGamesWon++;
          break;
        case 'lost':
          newGamesLost++;
          break;
        case 'drawn':
          newGamesDrawn++;
          break;
      }

      double newWinRate = newGamesPlayed > 0
          ? (newGamesWon / newGamesPlayed) * 100
          : 0.0;

      await db.update(
        'game_stats',
        {
          'games_played': newGamesPlayed,
          'games_won': newGamesWon,
          'games_lost': newGamesLost,
          'games_drawn': newGamesDrawn,
          'win_rate': newWinRate,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'player_name = ? AND player_type = ?',
        whereArgs: [playerName, playerType],
      );
    } else {
      // Crear nuevas estadísticas
      int gamesWon = result == 'won' ? 1 : 0;
      int gamesLost = result == 'lost' ? 1 : 0;
      int gamesDrawn = result == 'drawn' ? 1 : 0;
      double winRate = result == 'won' ? 100.0 : 0.0;

      await db.insert('game_stats', {
        'player_name': playerName,
        'player_type': playerType,
        'games_played': 1,
        'games_won': gamesWon,
        'games_lost': gamesLost,
        'games_drawn': gamesDrawn,
        'win_rate': winRate,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // Obtener estadísticas de un jugador específico
  Future<GameStats?> getPlayerStats(
    String playerName,
    String playerType,
  ) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'game_stats',
      where: 'player_name = ? AND player_type = ?',
      whereArgs: [playerName, playerType],
    );

    if (maps.isNotEmpty) {
      return GameStats.fromMap(maps.first);
    }
    return null;
  }

  // Obtener todas las estadísticas
  Future<List<GameStats>> getAllStats() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'game_stats',
      orderBy: 'win_rate DESC, games_played DESC',
    );

    return List.generate(maps.length, (i) {
      return GameStats.fromMap(maps[i]);
    });
  }

  // Obtener estadísticas por tipo de jugador
  Future<List<GameStats>> getStatsByType(String playerType) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'game_stats',
      where: 'player_type = ?',
      whereArgs: [playerType],
      orderBy: 'win_rate DESC, games_played DESC',
    );

    return List.generate(maps.length, (i) {
      return GameStats.fromMap(maps[i]);
    });
  }

  // Obtener estadísticas de jugadores humanos
  Future<List<GameStats>> getHumanStats() async {
    return getStatsByType('human');
  }

  // Obtener estadísticas de IA
  Future<List<GameStats>> getAIStats() async {
    return getStatsByType('ai');
  }

  // Eliminar todas las estadísticas
  Future<void> clearAllStats() async {
    final db = await _dbHelper.database;
    await db.delete('game_stats');
  }

  // Eliminar estadísticas de un jugador específico
  Future<void> deletePlayerStats(String playerName, String playerType) async {
    final db = await _dbHelper.database;
    await db.delete(
      'game_stats',
      where: 'player_name = ? AND player_type = ?',
      whereArgs: [playerName, playerType],
    );
  }

  // Obtener estadísticas generales del juego
  Future<Map<String, dynamic>> getOverallStats() async {
    final allStats = await getAllStats();

    int totalGames = 0;
    int totalWins = 0;
    int totalLosses = 0;
    int totalDraws = 0;

    for (var stats in allStats) {
      totalGames += stats.gamesPlayed;
      totalWins += stats.gamesWon;
      totalLosses += stats.gamesLost;
      totalDraws += stats.gamesDrawn;
    }

    return {
      'totalGames': totalGames,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'totalDraws': totalDraws,
      'overallWinRate': totalGames > 0 ? (totalWins / totalGames) * 100 : 0.0,
      'totalPlayers': allStats.length,
    };
  }
}
