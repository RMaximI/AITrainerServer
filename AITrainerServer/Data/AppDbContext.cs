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
            "SELECT id, name, description, muscle_groups, video_url, image_url FROM workout_exercises WHERE muscle_groups ILIKE @group", conn);
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

    //Команда для регистрации
    //curl -X POST http://192.168.50.141:60225/api/workout/register -H "Content-Type: application/json" -d "{\"email\":\"example@example.com\",\"password\":\"123456\",\"username\":\"JohnDoe\",\"height\":180,\"weight\":75,\"age\":25,\"gender\":\"male\",\"primaryGoal\":\"lose weight\",\"fitnessLevel\":\"intermediate\"}"
    public async Task<RegisterResult> RegisterAsync(RegisterDto request)
    {
        _logger.LogDebug("Регистрация пользователя: email: {email}", request.Email);

        try
        {


            await using var conn = new NpgsqlConnection(_connectionString);
            await conn.OpenAsync();

            var cmd = new NpgsqlCommand(@"
            WITH new_user AS (
                INSERT INTO public.users (email, password_hash)
                VALUES (@Email, @Password)
                RETURNING id
            )
            INSERT INTO public.profiles (
                user_id, username, height_cm, weight_kg, age, gender, goal, level
            )
            SELECT
                id, @Username, @Height, @Weight, @Age, @Gender, @Goal, @ActivityLevel
            FROM new_user;  
        ", conn);

            cmd.Parameters.AddWithValue("@Email", request.Email);
            cmd.Parameters.AddWithValue("@Password", request.Password);
            cmd.Parameters.AddWithValue("@Username", request.Username);
            cmd.Parameters.AddWithValue("@Height", request.Height);
            cmd.Parameters.AddWithValue("@Weight", request.Weight);
            cmd.Parameters.AddWithValue("@Age", request.Age);
            cmd.Parameters.AddWithValue("@Gender", request.Gender);
            cmd.Parameters.AddWithValue("@Goal", request.PrimaryGoal);
            cmd.Parameters.AddWithValue("@ActivityLevel", request.FitnessLevel);

            var rowsAffected = await cmd.ExecuteNonQueryAsync();

            if (rowsAffected > 0)
            {
                _logger.LogInformation("Регистрация прошла успешно для {email}", request.Email);
                return new RegisterResult { Success = true, Data = request };
            }
            else
            {
                _logger.LogWarning("Регистрация не удалась: ни одна строка не добавлена.");
                return new RegisterResult { Success = false, ErrorMessage = "Не удалось зарегистрировать пользователя." };
            }
        }
        catch (PostgresException ex) when (ex.SqlState == "23505") // дубликат email
        {
            _logger.LogWarning("Email уже зарегистрирован: {email}", request.Email);
            return new RegisterResult { Success = false, ErrorMessage = "Такой email уже зарегистрирован." };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Внутренняя ошибка при регистрации.");
            return new RegisterResult { Success = false, ErrorMessage = "Внутренняя ошибка сервера." };
        }
    }

    //Команда для авторизации пользователя
    /*curl -X POST "http://192.168.50.141:60225/api/workout/login" ^
        -H "Content-Type: application/json" ^
        -d "{\"Email\":\"real_existing_user@domain.com\",\"Password\":\"correct_password\"}"*/
    public async Task<LoginDto> LoginAsync(LoginDto request)
    {
        _logger.LogDebug("Проверка пользователя: email: {email}", request.Email);

        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();

        var cmd = new NpgsqlCommand(
            "SELECT email, password_hash FROM users WHERE email = @Email", conn);
        cmd.Parameters.AddWithValue("@Email", request.Email);

        await using var reader = await cmd.ExecuteReaderAsync();

        if (await reader.ReadAsync())
        {
            string dbEmail = reader.GetString(0);
            string dbPassword = reader.GetString(1);

            if (dbEmail == request.Email && dbPassword == request.Password)
            {
                _logger.LogInformation("Пользователь {email} успешно авторизован", request.Email);
                return request;
            }
        }
        else
        {
            _logger.LogWarning("Пользователь {email} не найден", request.Email);
        }

        _logger.LogWarning("Неверные учетные данные для {email}", request.Email);
        return null;

    }
    public async Task<EmailCheckResult> CheckEmailExistsAsync(string email)
    {
        _logger.LogDebug("Проверка существования email: {email}", email);

        try
        {
            await using var conn = new NpgsqlConnection(_connectionString);
            await conn.OpenAsync();

            var cmd = new NpgsqlCommand(
                "SELECT COUNT(1) FROM users WHERE email = @Email",
                conn);

            cmd.Parameters.AddWithValue("@Email", email);
            var count = Convert.ToInt32(await cmd.ExecuteScalarAsync());

            bool exists = count > 0;
            _logger.LogInformation("\n\n\n\nEmail {email} существует: {exists}", email, exists);

            return new EmailCheckResult
            {
                Exists = exists,
                Message = exists ? "Email уже зарегистрирован" : "Email доступен"
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ошибка при проверке email");
            return new EmailCheckResult
            {
                Exists = false,
                Message = "Ошибка сервера при проверке email"
            };
        }
    }

    /// <summary>
    /// Создает новую тренировку и связывает её с выбранными упражнениями
    /// </summary>
    /// <param name="userId">ID пользователя</param>
    /// <param name="title">Название тренировки</param>
    /// <param name="description">Описание тренировки</param>
    /// <param name="date">Дата тренировки</param>
    /// <param name="muscleGroups">Группы мышц для тренировки</param>
    /// <param name="durationMinutes">Длительность тренировки в минутах</param>
    /// <param name="difficulty">Сложность тренировки (easy, medium, hard)</param>
    /// <returns>ID созданной тренировки</returns>
    public async Task<int> CreateWorkoutAsync(
        int userId, 
        string title, 
        string description, 
        DateTime date,
        List<string> muscleGroups,
        int durationMinutes,
        string difficulty = "medium")
    {
        _logger.LogDebug("Создание новой тренировки для пользователя {userId}", userId);

        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();

        // Проверяем существование пользователя
        var userCheckCmd = new NpgsqlCommand(
            "SELECT COUNT(1) FROM users WHERE id = @UserId", conn);
        userCheckCmd.Parameters.AddWithValue("@UserId", userId);
        var userExists = Convert.ToInt32(await userCheckCmd.ExecuteScalarAsync()) > 0;

        if (!userExists)
        {
            throw new InvalidOperationException($"Пользователь с ID {userId} не найден");
        }

        // Генерируем упражнения для тренировки
        var workoutRequest = new WorkoutRequest
        {
            MuscleGroups = muscleGroups,
            DurationMinutes = durationMinutes,
            Difficulty = difficulty
        };

        var workoutResponse = await GenerateWorkoutAsync(workoutRequest);
        if (workoutResponse.Exercises.Count == 0)
        {
            throw new InvalidOperationException("Не удалось подобрать упражнения для тренировки");
        }

        // Начинаем транзакцию
        await using var transaction = await conn.BeginTransactionAsync();

        try
        {
            // Создаем новую тренировку
            var workoutCmd = new NpgsqlCommand(@"
                INSERT INTO workouts (user_id, title, description, date)
                VALUES (@UserId, @Title, @Description, @Date)
                RETURNING id;", conn, transaction);

            workoutCmd.Parameters.AddWithValue("@UserId", userId);
            workoutCmd.Parameters.AddWithValue("@Title", title);
            workoutCmd.Parameters.AddWithValue("@Description", description);
            workoutCmd.Parameters.AddWithValue("@Date", date);

            var workoutId = Convert.ToInt32(await workoutCmd.ExecuteScalarAsync());

            // Добавляем упражнения в шаблон тренировки
            foreach (var exercise in workoutResponse.Exercises)
            {
                var templateCmd = new NpgsqlCommand(@"
                    INSERT INTO workout_template (workout_id, exercise_id)
                    VALUES (@WorkoutId, @ExerciseId);", conn, transaction);

                templateCmd.Parameters.AddWithValue("@WorkoutId", workoutId);
                templateCmd.Parameters.AddWithValue("@ExerciseId", exercise.Id);

                await templateCmd.ExecuteNonQueryAsync();
            }

            // Подтверждаем транзакцию
            await transaction.CommitAsync();
            _logger.LogInformation("Тренировка {workoutId} успешно создана", workoutId);

            return workoutId;
        }
        catch (Exception ex)
        {
            // В случае ошибки откатываем транзакцию
            await transaction.RollbackAsync();
            _logger.LogError(ex, "Ошибка при создании тренировки");
            throw;
        }
    }

    /// <summary>
    /// Получает список дат тренировок пользователя
    /// </summary>
    /// <param name="userId">ID пользователя</param>
    /// <returns>Список дат тренировок</returns>
    public async Task<List<WorkoutDate>> GetUserWorkoutDatesAsync(int userId)
    {
        _logger.LogDebug("Получение дат тренировок для пользователя {userId}", userId);

        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();

        // Проверяем существование пользователя
        var userCheckCmd = new NpgsqlCommand(
            "SELECT COUNT(1) FROM users WHERE id = @UserId", conn);
        userCheckCmd.Parameters.AddWithValue("@UserId", userId);
        var userExists = Convert.ToInt32(await userCheckCmd.ExecuteScalarAsync()) > 0;

        if (!userExists)
        {
            throw new InvalidOperationException($"Пользователь с ID {userId} не найден");
        }

        var cmd = new NpgsqlCommand(@"
            SELECT id, title, description, date
            FROM workouts
            WHERE user_id = @UserId
            ORDER BY date DESC;", conn);

        cmd.Parameters.AddWithValue("@UserId", userId);

        var workoutDates = new List<WorkoutDate>();
        await using var reader = await cmd.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            var workoutDate = new WorkoutDate
            {
                Id = reader.GetInt32(0),
                Title = reader.GetString(1),
                Description = reader.GetString(2),
                Date = reader.GetDateTime(3)
            };
            workoutDates.Add(workoutDate);
        }

        _logger.LogInformation("Найдено {count} тренировок для пользователя {userId}", 
            workoutDates.Count, userId);

        return workoutDates;
    }

    /// <summary>
    /// Получает список упражнений для конкретной тренировки
    /// </summary>
    /// <param name="workoutId">ID тренировки</param>
    /// <returns>Список упражнений тренировки</returns>
    public async Task<List<WorkoutExercise>> GetWorkoutExercisesAsync(int workoutId)
    {
        _logger.LogDebug("Получение упражнений для тренировки {workoutId}", workoutId);

        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();

        // Проверяем существование тренировки
        var workoutCheckCmd = new NpgsqlCommand(
            "SELECT COUNT(1) FROM workouts WHERE id = @WorkoutId", conn);
        workoutCheckCmd.Parameters.AddWithValue("@WorkoutId", workoutId);
        var workoutExists = Convert.ToInt32(await workoutCheckCmd.ExecuteScalarAsync()) > 0;

        if (!workoutExists)
        {
            throw new InvalidOperationException($"Тренировка с ID {workoutId} не найдена");
        }

        var cmd = new NpgsqlCommand(@"
            SELECT e.id, e.name, e.description, e.muscle_groups, e.video_url, e.image_url
            FROM workout_exercises e
            INNER JOIN workout_template wt ON e.id = wt.exercise_id
            WHERE wt.workout_id = @WorkoutId
            ORDER BY e.name;", conn);

        cmd.Parameters.AddWithValue("@WorkoutId", workoutId);

        var exercises = new List<WorkoutExercise>();
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
                ImageUrl = reader.IsDBNull(5) ? "" : reader.GetString(5)
            };
            exercises.Add(exercise);
        }

        _logger.LogInformation("Найдено {count} упражнений для тренировки {workoutId}", 
            exercises.Count, workoutId);

        return exercises;
    }
}


