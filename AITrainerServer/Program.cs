using AITrainerServer.Data;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

var builder = WebApplication.CreateBuilder(args);


// Добавляем логгирование
builder.Logging.ClearProviders();
builder.Logging.AddConsole();

// Регистрируем зависимости
builder.Services.AddScoped<WorkoutServiceNpgsql>();
builder.Services.AddControllers();
builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.WriteIndented = true;
});

var app = builder.Build();

app.UseMiddleware<RequestLoggingMiddleware>();

// Включаем логгирование запросов в консоль
app.UseRouting();
app.Use(async (context, next) =>
{
    var logger = context.RequestServices.GetRequiredService<ILogger<Program>>();
    logger.LogInformation("Получен запрос: {method} {url}\n\n", context.Request.Method, context.Request.Path);
    await next();
});

app.MapControllers();
app.Run();