namespace AITrainerServer.Models;

public class WorkoutExercise
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public string Description { get; set; } = "";
    public string MuscleGroups { get; set; } = "";
    public string VideoUrl { get; set; } = "";
    public string ImageUrl { get; set; } = "";
    public int Sets { get; set; }
    public int Reps { get; set; }
}