class GameStats {
  final int? id;
  final String playerName;
  final String playerType; // 'human' o 'ai'
  final int gamesPlayed;
  final int gamesWon;
  final int gamesLost;
  final int gamesDrawn;
  final double winRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  GameStats({
    this.id,
    required this.playerName,
    required this.playerType,
    required this.gamesPlayed,
    required this.gamesWon,
    required this.gamesLost,
    required this.gamesDrawn,
    required this.winRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GameStats.fromMap(Map<String, dynamic> map) {
    return GameStats(
      id: map['id'],
      playerName: map['player_name'],
      playerType: map['player_type'],
      gamesPlayed: map['games_played'],
      gamesWon: map['games_won'],
      gamesLost: map['games_lost'],
      gamesDrawn: map['games_drawn'],
      winRate: map['win_rate'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'player_name': playerName,
      'player_type': playerType,
      'games_played': gamesPlayed,
      'games_won': gamesWon,
      'games_lost': gamesLost,
      'games_drawn': gamesDrawn,
      'win_rate': winRate,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  GameStats copyWith({
    int? id,
    String? playerName,
    String? playerType,
    int? gamesPlayed,
    int? gamesWon,
    int? gamesLost,
    int? gamesDrawn,
    double? winRate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GameStats(
      id: id ?? this.id,
      playerName: playerName ?? this.playerName,
      playerType: playerType ?? this.playerType,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      gamesWon: gamesWon ?? this.gamesWon,
      gamesLost: gamesLost ?? this.gamesLost,
      gamesDrawn: gamesDrawn ?? this.gamesDrawn,
      winRate: winRate ?? this.winRate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'GameStats(id: $id, playerName: $playerName, playerType: $playerType, gamesPlayed: $gamesPlayed, gamesWon: $gamesWon, gamesLost: $gamesLost, gamesDrawn: $gamesDrawn, winRate: $winRate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
