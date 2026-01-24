namespace GameCompletionistApp.Api.Data.Models
{
    public class GamesModels
    {
        public record AddGameRequest(int UserId, string GameName, string Platform, int ReleaseYear);

        public class GamesForUser
        {
            public int GameId { get; init; }
            public int UserId { get; init; }
            public string GameName { get; init; } = string.Empty;
            public int ReleaseYear { get; init; }
            public string PlatformName { get; init; } = string.Empty;
        }

        public class GameDetails
        {
            public int GameId { get; init; }
            public string Title { get; init; } = string.Empty;
            public string Platform { get; init; } = string.Empty;
            public string Description { get; init; } = string.Empty;
        }

        public class Goal
        {
            public int GoalId { get; init; }
            public int GameId { get; init; }
            public string Description { get; init; } = string.Empty;
            public bool IsCompleted { get; init; }
        }
    }
}
