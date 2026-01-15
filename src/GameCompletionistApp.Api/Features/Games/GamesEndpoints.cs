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
            group.MapPost("/AddGame", AddGameAsync);
            return app;
        }

        private static async Task<IResult> GetGamesForUserAsync(
            int UserId,
            [FromServices]GamesService gamesService)
        {
            var games = await gamesService.GetGamesForUserAsync(UserId);
            return Results.Ok(games);
        }

        private static async Task<IResult> AddGameAsync(
            [FromBody] Data.Models.GamesModels.AddGameRequest request,
            [FromServices] GamesService gamesService)
        {
            await gamesService.AddGameAsync(request);
            return Results.Ok();
        }
    }
}
