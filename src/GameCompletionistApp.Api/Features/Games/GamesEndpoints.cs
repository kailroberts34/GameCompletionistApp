using Microsoft.AspNetCore.Mvc;
using System.Net.NetworkInformation;
using System.Runtime.CompilerServices;

namespace GameCompletionistApp.Api.Features.Games
{
    public static class GamesEndpoints
    {
        public static IEndpointRouteBuilder MapGamesEndPoints(this IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("/games").WithTags("Games");
            group.MapGet("/user/{UserId}", GetGamesForUserAsync);
            return app;
        }

        private static async Task<IResult> GetGamesForUserAsync(
            int UserId,
            [FromServices]GamesService gamesService)
        {
            var games = await gamesService.GetGamesForUserAsync(UserId);
            return Results.Ok(games);
        }
    }
}
