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


}