namespace AITrainerServer.Data;

using AITrainerServer.Models;
using Npgsql;
using Microsoft.Extensions.Logging;

public class WorkoutServiceNpgsql
{
    //строка для обращения к ai
    //curl -X POST http://localhost:11434/api/generate -H "Content-Type: application/json" -d "{\"model\":\"deepseek-r1\", \"prompt\":\"Объясни мне, что такое машинное обучение.\", \"stream\":false}"
    private readonly string _connectionString = "Host=localhost;Port=5432;Username=postgres;Password=123;Database=Diplom";
    private readonly ILogger<WorkoutServiceNpgsql> _logger;
    public WorkoutServiceNpgsql(ILogger<WorkoutServiceNpgsql> logger)
    {
        _logger = logger;
    }

    //Команда для генерации тренировок
    //curl -X POST http://localhost:60225/api/workout/generate -H "Content-Type: application/json" -d "{ \"dayOfWeek\": \"Monday\", \"muscleGroups\": [\"квадрицепсы\", \"грудные мышцы\", \"мышцы кора\"], \"durationMinutes\": 45, \"difficulty\": \"medium\" }"
    public async Task<WorkoutResponse> GenerateWorkoutAsync(WorkoutRequest request)
    {
        var selectedExercises = new List<WorkoutExercise>();
        _logger.LogDebug("Генерация тренировки: группы мышц: {muscles}, длительность: {duration}, сложность: {difficulty}",
            string.Join(", ", request.MuscleGroups), request.DurationMinutes, request.Difficulty);

        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();

        var cmd = new NpgsqlCommand(
            "SELECT id, name, description, muscle_groups, video_url, image_url FROM workout_exercises WHERE muscle_groups ILIKE @group LIMIT 5", conn);
        cmd.Parameters.AddWithValue("@group", $"%{request.MuscleGroups[0]}%");

        await using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            var exercise = new WorkoutExercise
            {
                Id = reader.GetInt32(0),
                Name = reader.GetString(1),
                Description = reader.GetString(2),
                MuscleGroups = reader.GetString(3),
                VideoUrl = reader.IsDBNull(4) ? "" : reader.GetString(4),
                ImageUrl = reader.IsDBNull(5) ? "" : reader.GetString(5),
                Sets = request.Difficulty switch
                {
                    "easy" => 2,
                    "medium" => 3,
                    "hard" => 4,
                    _ => 3
                },
                Reps = request.DurationMinutes < 30 ? 10 : 15
            };

            selectedExercises.Add(exercise);
            _logger.LogInformation("Выбрано упражнение: {name}", exercise.Name);
        }

        return new WorkoutResponse { Exercises = selectedExercises };
    }

    public async Task<LoginDto> LoginAsync(LoginDto request)
    {
        var user = new List<LoginDto>();
        _logger.LogDebug("Проверка пользователя: email: {email}", request.Email);

        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();

        var cmd = new NpgsqlCommand(
            "SELECT email, password_hash FROM users WHERE email = @Email", conn);
        cmd.Parameters.AddWithValue("@Email", request.Email);

        await using var reader = await cmd.ExecuteReaderAsync();
        await reader.ReadAsync();

        if (reader.GetString(0) == request.Email && reader.GetString(1) == request.Password)
        {
            _logger.LogInformation("Пользователь {email} успешно авторизован", request.Email);
            return request; // Возвращаем пользователя при успешной авторизации
        }
        else
        {
            _logger.LogWarning("Не удалось авторизовать пользователя: неверный email или пароль");
            return null; // Возвращаем null при неудачной авторизации
        }
    }
}


