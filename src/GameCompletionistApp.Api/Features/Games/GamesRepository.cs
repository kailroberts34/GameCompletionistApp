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
    }
}
