using Microsoft.AspNetCore.Mvc;
using AITrainerServer.Data;
using AITrainerServer.Models;
using System;

namespace AITrainerServer.Controllers;

[ApiController]
[Route("api/[controller]")]
public class WorkoutController : ControllerBase
{
    private readonly WorkoutServiceNpgsql _service;
    public WorkoutController(WorkoutServiceNpgsql service)
    {
        _service = service;
    }

    [HttpPost("generate")]
    public async Task<ActionResult<WorkoutResponse>> GenerateWorkout([FromBody] WorkoutRequest request)
    {
        var result = await _service.GenerateWorkoutAsync(request);
        return Ok(result);
    }

    /*[HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterDto dto)
    {
        if (await _context.Users.AnyAsync(u => u.Email == dto.Email))
            return BadRequest("Email уже используется");

        var user = new User
        {
            Email = dto.Email,
            Username = dto.Username,
            PasswordHash = dto.Password,
            Age = dto.Age,
            Weight = dto.Weight,
            Height = dto.Height,
            Gender = dto.Gender,
            FitnessLevel = dto.FitnessLevel,
            PrimaryGoal = dto.PrimaryGoal
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return Ok("Пользователь зарегистрирован");
    }*/

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


}