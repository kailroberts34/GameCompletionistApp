namespace GameCompletionistApp.Api.Data.Models
{
    public class GamesModels
    {
        public record AddGameRequest(int UserId, string Title, string Platform);
        public class GamesForUser
        {
            public int GameId { get; init; }
            public int UserId { get; init; }
            public string GameName { get; init; } = string.Empty;
            public string Platform { get; init; } = string.Empty;
        }
    }
}
