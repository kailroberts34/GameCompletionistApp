using System.ComponentModel.DataAnnotations;

namespace GameCompletionistApp.Api.Data.Models;

public class AuthModels
{
    public record LoginRequest(string Email, string Password);
    public record CreateUserRequest(string UserName, string email, string password);
    public class User
    {
        public int UserId { get; init; }
        public string Username { get; init; } = string.Empty;
        public byte[] PasswordHash { get; init; } = Array.Empty<byte>();
        public byte[] PasswordSalt { get; init; } = Array.Empty<byte>();
        public string Email { get; init; } = string.Empty;
    }

    public record AuthResults(bool IsSuccess, User? User)
    {
        public static AuthResults Fail() => new(false, null);
        public static AuthResults Success(User user) => new(true, user);
    }

    public class LoginResponse
    {
        [Required]
        public string Token { get; init; } = string.Empty;
    }

    public class LogoutResponse 
    {
        public string Message { get; set; } = "Logged out successfully.";
    }
}
