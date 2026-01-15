using Dapper;
using GameCompletionistApp.Api.Data;
using System.Data;
using static GameCompletionistApp.Api.Data.Models.GamesModels;

namespace GameCompletionistApp.Api.Features.Games
{
    public class GamesRepository
    {
        private readonly IDbConnectionFactory _dbConnectionFactory;
        public GamesRepository(IDbConnectionFactory dbConnectionFactory)
        {
            _dbConnectionFactory = dbConnectionFactory;
        }

        public async Task<GamesForUser[]> GetGamesForUser(int UserId)
        {
            using var connection = await _dbConnectionFactory.CreateConnectionAsync();
            var games = await connection.QueryAsync<GamesForUser>(
                "game.GetGamesForUser",
                new { UserId },
                commandType: CommandType.StoredProcedure);
            return games.ToArray();
        }

        public async Task<int?> GetGameIdByTitleAndPlatformAsync(string GameName, string Platform)
        {
            using var connection = await _dbConnectionFactory.CreateConnectionAsync();
            var gameId = await connection.QuerySingleOrDefaultAsync<int?>(
                "game.GetGameByGameNameAndPlatformName",
                new { GameName, Platform },
                commandType: CommandType.StoredProcedure);
            return gameId;
        }

        public async Task AssignGameToUserAsync(int UserId, int GameId)
        {
            using var connection = await _dbConnectionFactory.CreateConnectionAsync();
            await connection.ExecuteAsync(
                "game.AssignGameToUser",
                new { UserId = UserId, GameId = GameId },
                commandType: CommandType.StoredProcedure);
        }

        public async Task AddGameAsync(string GameName, string PlatformName, int ReleaseYear)
        {
            using var connection = await _dbConnectionFactory.CreateConnectionAsync();
            await connection.ExecuteAsync(
                "game.InsertGamesForUser",
                new { GameName = GameName, Platform = PlatformName, ReleaseYear = ReleaseYear },
                commandType: CommandType.StoredProcedure);
        }

        public async Task<int?> GetUserByUserIdAsync(int UserId)
        {
            using var connection = await _dbConnectionFactory.CreateConnectionAsync();
            return await connection.QuerySingleOrDefaultAsync<int?>(
                "dbo.GetUserByUserId",
                new { UserId = UserId },
                commandType: CommandType.StoredProcedure);

        }
    }
}
