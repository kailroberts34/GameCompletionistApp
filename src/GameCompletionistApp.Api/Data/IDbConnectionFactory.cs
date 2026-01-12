

using System.Data;

namespace GameCompletionistApp.Api.Data;

public interface IDbConnectionFactory
{
    Task<IDbConnection> CreateConnectionAsync();
}
