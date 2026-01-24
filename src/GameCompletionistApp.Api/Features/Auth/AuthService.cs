using GameCompletionistApp.Api.Data.Models;
using Microsoft.AspNetCore.Identity;
using System.Security.Cryptography;
using static GameCompletionistApp.Api.Data.Models.AuthModels;
namespace GameCompletionistApp.Api.Features.Auth
{
    public class AuthService
    {
        private readonly AuthRepository _authRepository;
        private readonly PasswordHasher<User> _passwordHasher = new();
        public AuthService(AuthRepository authRepository)
        {
            _authRepository = authRepository;
        }

        public (byte[] Hash, byte[] Salt) HashPassword(string password)
        {
            using var rng = RandomNumberGenerator.Create();
            var salt = new byte[16];
            rng.GetBytes(salt);

            using var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 100_000, HashAlgorithmName.SHA256);

            var hash = pbkdf2.GetBytes(32);
            return (hash, salt);

        }

        public bool VerifyPassword(string password, byte[] storedHash, byte[] storedSalt)
        {
            using var pbkdf2 = new Rfc2898DeriveBytes(password, storedSalt, 100_000, HashAlgorithmName.SHA256);
            var hash = pbkdf2.GetBytes(32);
            return hash.SequenceEqual(storedHash);
        }

        public async Task<User?> GetUserByEmailAsync(string email, string password)
        {
            var user = await _authRepository.GetByEmailAsync(email);
            if (user == null)
            {
                return null;
            }

            var isValid = VerifyPassword(password, user.PasswordHash, user.PasswordSalt);

            return isValid ? user : null;
        }

        public async Task<User> CreateUserAsync(string UserName, string Email, string Password)
        {
            var existing = await _authRepository.GetByEmailAsync(Email);
            if (existing != null)
            {
                throw new Exception("User with this email already exists.");
            }

            var (hash, salt) = HashPassword(Password);

            var userId = await _authRepository.CreateUserAsync(
                UserName,
                Email,
                hash,
                salt
            );

            var createdUser = new User
            {
                UserId = userId,
                Username = UserName,
                Email = Email,
                PasswordHash = hash,
                PasswordSalt = salt
            };

            return (createdUser);
        }
    }
}
