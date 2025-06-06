using Microsoft.AspNetCore.Mvc;
using AITrainerServer.Data;
using AITrainerServer.Models;
using System;
using Microsoft.Extensions.Logging;
using System.Linq;

namespace AITrainerServer.Controllers;

[ApiController]
[Route("api/[controller]")]
public class WorkoutController : ControllerBase
{
    private readonly WorkoutServiceNpgsql _service;
    private readonly ILogger<WorkoutController> _logger;

    public WorkoutController(WorkoutServiceNpgsql service, ILogger<WorkoutController> logger)
    {
        _service = service;
        _logger = logger;
    }

    [HttpPost("generate")]
    public async Task<ActionResult<WorkoutResponse>> GenerateWorkout([FromBody] WorkoutRequest request)
    {
        var result = await _service.GenerateWorkoutAsync(request);
        return Ok(result);
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterDto dto)
    {
        var result = await _service.RegisterAsync(dto);

        if (!result.Success)
        {
            // Можно вернуть 409 или 400, в зависимости от текста ошибки
            if (result.ErrorMessage.Contains("зарегистрирован"))
                return Conflict(new { error = result.ErrorMessage });
            else
                return BadRequest(new { error = result.ErrorMessage });
        }

        return Ok(result.Data);
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginDto dto)
    {
        var result = await _service.LoginAsync(dto);
        if (result == null)
        {
            return Ok("\n\nНеверный email или пароль");
        }
        return Ok(result);
    }

    [HttpPost("check")]
    public async Task<IActionResult> CheckEmailExists([FromBody] string email)
    {
        try
        {
            var result = await _service.CheckEmailExistsAsync(email);
            return Ok(new
            {
                exists = result.Exists,
                message = result.Message
            });
        }
        catch (Exception ex)
        {
            
            return StatusCode(500, new
            {
                error = "Internal server error"
            });
        }
    }

    [HttpPost("create")]
    public async Task<IActionResult> CreateWorkout([FromBody] WorkoutCreateRequest request)
    {
        try
        {
            _logger.LogInformation("Получен запрос на создание тренировки: {@Request}", request);

            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values
                    .SelectMany(v => v.Errors)
                    .Select(e => e.ErrorMessage)
                    .ToList();

                _logger.LogWarning("Ошибки валидации: {@Errors}", errors);
                return BadRequest(new { errors });
            }

            var workoutId = await _service.CreateWorkoutAsync(
                request.UserId,
                request.Title,
                request.Description,
                request.Date,
                request.MuscleGroups,
                request.DurationMinutes,
                request.Difficulty
            );

            _logger.LogInformation("Тренировка успешно создана с ID: {WorkoutId}", workoutId);
            return Ok(new { id = workoutId });
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Ошибка при создании тренировки: {Message}", ex.Message);
            return BadRequest(new { error = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Внутренняя ошибка при создании тренировки");
            return StatusCode(500, new { error = "Внутренняя ошибка сервера" });
        }
    }

    [HttpGet("dates/{userId}")]
    public async Task<IActionResult> GetUserWorkoutDates(int userId)
    {
        try
        {
            var workoutDates = await _service.GetUserWorkoutDatesAsync(userId);
            return Ok(workoutDates);
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Ошибка при получении дат тренировок");
            return BadRequest(new { error = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Ошибка при получении дат тренировок");
            return StatusCode(500, new { error = "Внутренняя ошибка сервера" });
        }
    }

    [HttpGet("exercises/{workoutId}")]
    public async Task<IActionResult> GetWorkoutExercises(int workoutId)
    {
        try
        {
            var exercises = await _service.GetWorkoutExercisesAsync(workoutId);
            return Ok(exercises);
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Ошибка при получении упражнений тренировки");
            return BadRequest(new { error = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Внутренняя ошибка при получении упражнений тренировки");
            return StatusCode(500, new { error = "Внутренняя ошибка сервера" });
        }
    }

    [HttpGet("user/{email}")]
    public async Task<IActionResult> GetUserData(string email)
    {
        try
        {
            _logger.LogInformation("Получение данных пользователя по email: {email}", email);
            var userData = await _service.GetUserDataByEmailAsync(email);
            return Ok(userData);
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Ошибка при получении данных пользователя");
            return BadRequest(new { error = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Внутренняя ошибка при получении данных пользователя");
            return StatusCode(500, new { error = "Внутренняя ошибка сервера" });
        }
    }

    [HttpPut("user/{email}")]
    public async Task<IActionResult> UpdateUserData(string email, [FromBody] UserData userData)
    {
        try
        {
            _logger.LogInformation("Обновление данных пользователя: {email}", email);
            
            if (string.IsNullOrWhiteSpace(email))
            {
                return BadRequest(new { error = "Email не может быть пустым" });
            }

            if (userData == null)
            {
                return BadRequest(new { error = "Данные пользователя не могут быть пустыми" });
            }

            // Валидация обязательных полей
            if (userData.Height < 0)
            {
                return BadRequest(new { error = "Рост не может быть отрицательным" });
            }

            if (userData.Weight < 0)
            {
                return BadRequest(new { error = "Вес не может быть отрицательным" });
            }

            if (userData.Age < 0 || userData.Age > 120)
            {
                return BadRequest(new { error = "Некорректный возраст" });
            }

            if (!string.IsNullOrEmpty(userData.Gender) && 
                !new[] { "male", "female", "other" }.Contains(userData.Gender.ToLower()))
            {
                return BadRequest(new { error = "Некорректное значение пола" });
            }

            if (!string.IsNullOrEmpty(userData.Goal) && 
                !new[] { "weight loss", "muscle improvement", "improve physical form", "improve strength" }.Contains(userData.Goal.ToLower()))
            {
                return BadRequest(new { error = "Некорректная цель тренировок" });
            }

            if (!string.IsNullOrEmpty(userData.FitnessLevel) && 
                !new[] { "beginner", "intermediate", "advanced" }.Contains(userData.FitnessLevel.ToLower()))
            {
                return BadRequest(new { error = "Некорректный уровень подготовки" });
            }

            var updatedUserData = await _service.UpdateUserDataAsync(email, userData);
            return Ok(updatedUserData);
        }
        catch (ArgumentException ex)
        {
            _logger.LogWarning(ex, "Ошибка валидации данных пользователя");
            return BadRequest(new { error = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Ошибка при обновлении данных пользователя");
            return BadRequest(new { error = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Внутренняя ошибка при обновлении данных пользователя");
            return StatusCode(500, new { error = "Внутренняя ошибка сервера" });
        }
    }
}