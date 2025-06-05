namespace AITrainerServer.Models
{
    public class User
    {
        public int Id { get; set; }
        public string Email { get; set; } = null!;
        public string Username { get; set; } = null!;
        public string PasswordHash { get; set; } = null!;
        public int Age { get; set; }
        public float Weight { get; set; }
        public float Height { get; set; }
        public string Gender { get; set; } = null!;
        public string FitnessLevel { get; set; } = null!;
        public string PrimaryGoal { get; set; } = null!;
    }

}
