# Scaffold — ASP.NET Core MVC (.NET 9) + Dapper + SPs

Archivos que el skill copia al repo bajo `src/{{AppPrefix}}.API/` cuando el desarrollador elige este stack.

## Archivos en este scaffold
- `Program.cs` — bootstrap con DI, MSAL, Key Vault, Serilog, CORS, filters
- `ApiResponseVm.cs` — wrapper estándar de respuesta
- `Filters/ValidateModelFilter.cs`
- `Middleware/ExceptionHandlingMiddleware.cs`
- `Middleware/RequestLoggingMiddleware.cs`
- `Repositories/BaseRepository.cs` — wrapper Dapper
- `Project.csproj` — dependencias estándar

Todos los archivos usan placeholders `{{AppPrefix}}` y `{{ProjectName}}` que el skill sustituye antes de escribir en el repo destino.
