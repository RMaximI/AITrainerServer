namespace AITrainerServer.Models;

public class WorkoutRequest
{
    public string DayOfWeek { get; set; } = "";
    public List<string> MuscleGroups { get; set; } = new();
    public int DurationMinutes { get; set; }
    public string Difficulty { get; set; } = "medium";
}