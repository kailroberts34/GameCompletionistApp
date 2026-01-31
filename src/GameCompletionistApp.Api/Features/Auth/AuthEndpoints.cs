using System.Net.NetworkInformation;
using System.Security.Claims;
using static GameCompletionistApp.Api.Data.Models.AuthModels;

namespace GameCompletionistApp.Api.Features.Auth
{
    public static class AuthEndpoints
    {
        public static IEndpointRouteBuilder MapAuthEndpoints(this IEndpointRouteBuilder app)
        {
            var group = app.MapGroup("/auth").WithTags("Auth");

            group.MapPost("login", Login);

            group.MapPost("register", CreateUser);

            group.MapGet("me", me).RequireAuthorization();

            group.MapPost("logout", () => Results.Ok(new LogoutResponse()));

            return app;
        }

        private static async Task<IResult> Login(
            LoginRequest request,
            AuthService authService,
            JwtService jwtService)
        {
            var user = await authService.GetUserByEmailAsync(request.Email, request.Password);

            if (user is null)
            {
                return Results.Unauthorized();
            }

            var token = jwtService.GenerateToken(user);

            var response = new LoginResponse
            {
                Token = token,
                UserId = user.UserId
            };
            return Results.Ok(response);
        }

        private static IResult CreateUser(CreateUserRequest request, AuthService authService, JwtService jwtService)
        {
            try
            {
                var user = authService.CreateUserAsync(
                    request.UserName,
                    request.email,
                    request.password).Result;

                var token = jwtService.GenerateToken(user);

                var response = new LoginResponse
                {
                    Token = token,
                    UserId = user.UserId
                };
                return Results.Ok(response); ;
            }
            catch (InvalidOperationException ex)
            {
                return Results.BadRequest(new { error = ex.Message });
            }
        }

        private static IResult me(ClaimsPrincipal user)
        {
            var email = user.FindFirst(ClaimTypes.Email);
            return Results.Ok(new { email });
        }


    }
}
