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
            "SELECT id, email, password_hash FROM users WHERE email = @Email", conn);
        cmd.Parameters.AddWithValue("@Email", request.Email);

        await using var reader = await cmd.ExecuteReaderAsync();

        if (await reader.ReadAsync())
        {
            int userId = reader.GetInt32(0);
            string dbEmail = reader.GetString(1);
            string dbPassword = reader.GetString(2);

            if (dbEmail == request.Email && dbPassword == request.Password)
            {
                _logger.LogInformation("Пользователь {email} успешно авторизован", request.Email);
                return new LoginDto 
                { 
                    Id = userId,
                    Email = request.Email,
                    Password = request.Password
                };
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
    private int GetMaxExercisesCount(int durationMinutes, string difficulty)
    {
        // Базовое количество упражнений в зависимости от длительности
        int baseCount = durationMinutes switch
        {
            <= 30 => 4,  
            <= 45 => 6,   
            <= 60 => 8,    
            _ => 10       
        };

        // Множитель в зависимости от сложности
        float difficultyMultiplier = difficulty.ToLower() switch
        {
            "easy" => 0.8f,   
            "medium" => 1.0f,  
            "hard" => 1.2f,   
            _ => 1.0f
        };

        return (int)Math.Round(baseCount * difficultyMultiplier);
    }

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

        // Проверяем количество упражнений
        var maxExercises = GetMaxExercisesCount(durationMinutes, difficulty);
        if (workoutResponse.Exercises.Count > maxExercises)
        {
            _logger.LogWarning(
                "Количество упражнений ({count}) превышает максимально допустимое ({max}) для {duration} минут и сложности {difficulty}",
                workoutResponse.Exercises.Count, maxExercises, durationMinutes, difficulty);
            
            // Оставляем только первые maxExercises упражнений
            workoutResponse.Exercises = workoutResponse.Exercises.Take(maxExercises).ToList();
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
            _logger.LogInformation(
                "Тренировка {workoutId} успешно создана с {count} упражнениями", 
                workoutId, workoutResponse.Exercises.Count);

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

    /// <summary>
    /// Получает данные пользователя по email
    /// </summary>
    /// <param name="email">Email пользователя</param>
    /// <returns>Данные пользователя</returns>
    public async Task<UserData> GetUserDataByEmailAsync(string email)
    {
        _logger.LogDebug("Получение данных пользователя по email: {email}", email);

        await using var conn = new NpgsqlConnection(_connectionString);
        await conn.OpenAsync();

        var cmd = new NpgsqlCommand(@"
            SELECT 
                u.id,
                u.email,
                p.username,
                p.height_cm,
                p.weight_kg,
                p.age,
                p.gender,
                p.goal,
                p.level
            FROM users u
            LEFT JOIN profiles p ON u.id = p.user_id
            WHERE u.email = @Email;", conn);

        cmd.Parameters.AddWithValue("@Email", email);

        await using var reader = await cmd.ExecuteReaderAsync();
        if (!await reader.ReadAsync())
        {
            throw new InvalidOperationException($"Пользователь с email {email} не найден");
        }

        var userData = new UserData
        {
            Id = reader.GetInt32(0),
            Email = reader.GetString(1),
            Username = reader.IsDBNull(2) ? "" : reader.GetString(2),
            Height = reader.IsDBNull(3) ? 0 : reader.GetInt32(3),
            Weight = reader.IsDBNull(4) ? 0 : reader.GetInt32(4),
            Age = reader.IsDBNull(5) ? 0 : reader.GetInt32(5),
            Gender = reader.IsDBNull(6) ? "" : reader.GetString(6),
            Goal = reader.IsDBNull(7) ? "" : reader.GetString(7),
            FitnessLevel = reader.IsDBNull(8) ? "" : reader.GetString(8)
        };

        _logger.LogInformation("Данные пользователя {email} успешно получены", email);
        return userData;
    }

    /// <summary>
    /// Обновляет данные пользователя
    /// </summary>
    /// <param name="email">Email пользователя</param>
    /// <param name="userData">Новые данные пользователя</param>
    /// <returns>Обновленные данные пользователя</returns>
    public async Task<UserData> UpdateUserDataAsync(string email, UserData userData)
    {
        _logger.LogDebug("Обновление данных пользователя: {email}", email);

        // Валидация входных данных
        if (string.IsNullOrWhiteSpace(email))
        {
            throw new ArgumentException("Email не может быть пустым", nameof(email));
        }

        if (userData == null)
        {
            throw new ArgumentNullException(nameof(userData), "Данные пользователя не могут быть null");
        }

        // Валидация полей
        if (userData.Height < 0)
        {
            throw new ArgumentException("Рост не может быть отрицательным", nameof(userData.Height));
        }

        if (userData.Weight < 0)
        {
            throw new ArgumentException("Вес не может быть отрицательным", nameof(userData.Weight));
        }

        if (userData.Age < 0 || userData.Age > 120)
        {
            throw new ArgumentException("Некорректный возраст", nameof(userData.Age));
        }

        if (!string.IsNullOrEmpty(userData.Gender) && 
            !new[] { "male", "female", "other" }.Contains(userData.Gender.ToLower()))
        {
            throw new ArgumentException("Некорректное значение пола", nameof(userData.Gender));
        }

        if (!string.IsNullOrEmpty(userData.Goal) && 
            !new[] { "weight loss", "muscle improvement", "improve physical form", "improve strength"}.Contains(userData.Goal.ToLower()))
        {
            throw new ArgumentException("Некорректная цель тренировок", nameof(userData.Goal));
        }

        if (!string.IsNullOrEmpty(userData.FitnessLevel) && 
            !new[] { "beginner", "intermediate", "advanced" }.Contains(userData.FitnessLevel.ToLower()))
        {
            throw new ArgumentException("Некорректный уровень подготовки", nameof(userData.FitnessLevel));
        }

        await using var conn = new NpgsqlConnection(_connectionString);
        try
        {
            await conn.OpenAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ошибка подключения к базе данных");
            throw new InvalidOperationException("Не удалось подключиться к базе данных", ex);
        }

        // Начинаем транзакцию
        await using var transaction = await conn.BeginTransactionAsync();

        try
        {
            // Проверяем существование пользователя
            var checkCmd = new NpgsqlCommand(@"
                SELECT id FROM users WHERE email = @Email;", conn, transaction);
            checkCmd.Parameters.AddWithValue("@Email", email);

            var userId = await checkCmd.ExecuteScalarAsync();
            if (userId == null)
            {
                throw new InvalidOperationException($"Пользователь с email {email} не найден");
            }

            // Проверяем существование профиля
            var checkProfileCmd = new NpgsqlCommand(@"
                SELECT COUNT(*) FROM profiles WHERE user_id = @UserId;", conn, transaction);
            checkProfileCmd.Parameters.AddWithValue("@UserId", userId);

            var profileExists = Convert.ToInt32(await checkProfileCmd.ExecuteScalarAsync()) > 0;

            if (profileExists)
            {
                // Обновляем существующий профиль
                var updateCmd = new NpgsqlCommand(@"
                    UPDATE profiles 
                    SET 
                        username = @Username,
                        height_cm = @Height,
                        weight_kg = @Weight,
                        age = @Age,
                        gender = @Gender,
                        goal = @Goal,
                        level = @FitnessLevel,
                        updated_at = CURRENT_TIMESTAMP
                    WHERE user_id = @UserId;", conn, transaction);

                updateCmd.Parameters.AddWithValue("@UserId", userId);
                updateCmd.Parameters.AddWithValue("@Username", userData.Username ?? (object)DBNull.Value);
                updateCmd.Parameters.AddWithValue("@Height", userData.Height);
                updateCmd.Parameters.AddWithValue("@Weight", userData.Weight);
                updateCmd.Parameters.AddWithValue("@Age", userData.Age);
                updateCmd.Parameters.AddWithValue("@Gender", userData.Gender ?? (object)DBNull.Value);
                updateCmd.Parameters.AddWithValue("@Goal", userData.Goal ?? (object)DBNull.Value);
                updateCmd.Parameters.AddWithValue("@FitnessLevel", userData.FitnessLevel ?? (object)DBNull.Value);

                await updateCmd.ExecuteNonQueryAsync();
            }
            else
            {
                // Создаем новый профиль
                var insertCmd = new NpgsqlCommand(@"
                    INSERT INTO profiles (
                        user_id, username, height_cm, weight_kg, 
                        age, gender, goal, level, created_at, updated_at
                    ) VALUES (
                        @UserId, @Username, @Height, @Weight,
                        @Age, @Gender, @Goal, @FitnessLevel,
                        CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
                    );", conn, transaction);

                insertCmd.Parameters.AddWithValue("@UserId", userId);
                insertCmd.Parameters.AddWithValue("@Username", userData.Username ?? (object)DBNull.Value);
                insertCmd.Parameters.AddWithValue("@Height", userData.Height);
                insertCmd.Parameters.AddWithValue("@Weight", userData.Weight);
                insertCmd.Parameters.AddWithValue("@Age", userData.Age);
                insertCmd.Parameters.AddWithValue("@Gender", userData.Gender ?? (object)DBNull.Value);
                insertCmd.Parameters.AddWithValue("@Goal", userData.Goal ?? (object)DBNull.Value);
                insertCmd.Parameters.AddWithValue("@FitnessLevel", userData.FitnessLevel ?? (object)DBNull.Value);

                await insertCmd.ExecuteNonQueryAsync();
            }

            // Фиксируем транзакцию
            await transaction.CommitAsync();

            // Получаем обновленные данные
            var result = await GetUserDataByEmailAsync(email);
            _logger.LogInformation("Данные пользователя {email} успешно обновлены", email);
            return result;
        }
        catch (PostgresException ex)
        {
            await transaction.RollbackAsync();
            _logger.LogError(ex, "Ошибка базы данных при обновлении данных пользователя");
            
            switch (ex.SqlState)
            {
                case "23505": // unique_violation
                    throw new InvalidOperationException("Нарушение уникальности данных", ex);
                case "23503": // foreign_key_violation
                    throw new InvalidOperationException("Нарушение целостности данных", ex);
                case "23502": // not_null_violation
                    throw new InvalidOperationException("Обязательные поля не могут быть пустыми", ex);
                default:
                    throw new InvalidOperationException("Ошибка при обновлении данных в базе данных", ex);
            }
        }
        catch (Exception ex) when (ex is not InvalidOperationException)
        {
            await transaction.RollbackAsync();
            _logger.LogError(ex, "Непредвиденная ошибка при обновлении данных пользователя");
            throw new InvalidOperationException("Произошла ошибка при обновлении данных пользователя", ex);
        }
    }
}


