using Microsoft.Identity.Client;
using static GameCompletionistApp.Api.Data.Models.GamesModels;

namespace GameCompletionistApp.Api.Features.Games
{
    public class GamesService
    {
        private readonly GamesRepository _gamesRepository;
        public GamesService(GamesRepository gamesRepository)
        {
            _gamesRepository = gamesRepository;
        }

        public async Task<GamesForUser[]?> GetGamesForUserAsync(int UserId)
        {
            var ExistingUser = await _gamesRepository.GetUserByUserIdAsync(UserId);

            if (!ExistingUser.HasValue)
                return null;

            return await _gamesRepository.GetGamesForUser(UserId);
        }

        public async Task AddGameAsync(AddGameRequest request)
        {
            var existingGameId = await _gamesRepository.GetGameIdByTitleAndPlatformAsync(request.GameName, request.PlatformName);
            int gameId;

            if (existingGameId.HasValue)
            {
                gameId = existingGameId.Value;
            }
            else
            {
                // Assuming AddGameForUser returns the new GameId
                await _gamesRepository.AddGameAsync(request.GameName, request.PlatformName, request.ReleaseYear);
                gameId = (await _gamesRepository.GetGameIdByTitleAndPlatformAsync(request.GameName, request.PlatformName)).Value;
            }

            await _gamesRepository.AssignGameToUserAsync(request.UserId, gameId);
        }
    }
}
