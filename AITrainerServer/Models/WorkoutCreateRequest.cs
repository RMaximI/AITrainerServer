namespace AITrainerServer.Models;

using System.ComponentModel.DataAnnotations;

public class WorkoutCreateRequest
{
    [Required(ErrorMessage = "ID пользователя обязателен")]
    [Range(1, int.MaxValue, ErrorMessage = "ID пользователя должен быть положительным числом")]
    public int UserId { get; set; }

    [Required(ErrorMessage = "Название тренировки обязательно")]
    [StringLength(255, ErrorMessage = "Название тренировки не может быть длиннее 255 символов")]
    public string Title { get; set; } = "";

    public string Description { get; set; } = "";

    [Required(ErrorMessage = "Дата тренировки обязательна")]
    public DateTime Date { get; set; }

    [Required(ErrorMessage = "Необходимо указать хотя бы одну группу мышц")]
    [MinLength(1, ErrorMessage = "Необходимо указать хотя бы одну группу мышц")]
    public List<string> MuscleGroups { get; set; } = new();

    [Required(ErrorMessage = "Длительность тренировки обязательна")]
    [Range(1, int.MaxValue, ErrorMessage = "Длительность тренировки должна быть положительным числом")]
    public int DurationMinutes { get; set; }

    [Required(ErrorMessage = "Сложность тренировки обязательна")]
    [RegularExpression("^(easy|medium|hard)$", ErrorMessage = "Сложность должна быть: easy, medium или hard")]
    public string Difficulty { get; set; } = "medium";
} 