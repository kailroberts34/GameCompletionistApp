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
            try
            {
                var games = await gamesService.GetGamesForUserAsync(UserId);
                if (games == null)
                    return Results.NotFound("User not found.");
                if (games.Length == 0)
                    return Results.NotFound($"No games found for UserId: {UserId}.");
                return Results.Ok(games);
            }
            catch (Exception ex)
            {
                return Results.Problem(ex.Message, statusCode: 500);
            }
        }

        private static async Task<IResult> AddGameAsync(
            [FromBody] Data.Models.GamesModels.AddGameRequest request,
            [FromServices] GamesService gamesService)
        {
            if (request == null || 
                string.IsNullOrWhiteSpace(request.GameName) ||
                string.IsNullOrWhiteSpace(request.Platform) ||
                request.ReleaseYear <= 0)
            {
                return Results.BadRequest("Invalid game data.");
            }

            try
            {
                await gamesService.AddGameAsync(request);
                return Results.Ok();
            }
            catch(Exception ex)
            {
                return Results.Problem("An unexpected error occured.", statusCode: 500);
            }
        }
    }
}
