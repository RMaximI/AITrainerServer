namespace AITrainerServer.Models;

public class UserData
{
    public int Id { get; set; }
    public string Email { get; set; } = "";
    public string Username { get; set; } = "";
    public int Height { get; set; }
    public int Weight { get; set; }
    public int Age { get; set; }
    public string Gender { get; set; } = "";
    public string Goal { get; set; } = "";
    public string FitnessLevel { get; set; } = "";
} 