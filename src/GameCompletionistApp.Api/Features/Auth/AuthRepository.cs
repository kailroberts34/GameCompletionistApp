using GameCompletionistApp.Api.Data;
using Dapper;
using static GameCompletionistApp.Api.Data.Models.AuthModels;
using System.Data;

namespace GameCompletionistApp.Api.Features.Auth;

public class AuthRepository
{
    private readonly IDbConnectionFactory _dbConnectionFactory;

    public AuthRepository(IDbConnectionFactory dbConnectionFactory)
    {
        _dbConnectionFactory = dbConnectionFactory;
    }

    public async Task<User?> GetByEmailAsync(string email)
    {
        using var connection = await _dbConnectionFactory.CreateConnectionAsync();
        return await connection.QuerySingleOrDefaultAsync<User>(
        "Game.GetUserByEmailForAuth",
        new { Email = email },
        commandType: CommandType.StoredProcedure);
    }

    public async Task<int> CreateUserAsync(
        string UserName,
        String Email,
        byte[] PasswordHash,
        byte[] PasswordSalt
        )
    {
        using var connection = await _dbConnectionFactory.CreateConnectionAsync();

        return await connection.ExecuteScalarAsync<int>(
            "game.InsertUserForAuth",
            new
            {
                UserName,
                Email,
                PasswordHash,
                PasswordSalt
            },
            commandType: CommandType.StoredProcedure);
    }

}