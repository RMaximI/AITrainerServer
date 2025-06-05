namespace AITrainerServer.Models
{
    public class RegisterResult
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; } // null если успех
        public RegisterDto Data { get; set; }    // null если ошибка
    }

}
