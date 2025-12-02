using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SynexApi.Data;
using SynexApi.Models;

namespace SynexApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DeviceTokenController : ControllerBase
    {
        private readonly AppDbContext _context;

        public DeviceTokenController(AppDbContext context)
        {
            _context = context;
        }

        [HttpPost("register")]
        public async Task<IActionResult> RegisterToken([FromBody] RegisterTokenModel tokenModel)
        {
            if (tokenModel == null || string.IsNullOrEmpty(tokenModel.ClientToken) || string.IsNullOrEmpty(tokenModel.Username))
                return BadRequest("Token ya da kullanıcı adı boş olamaz.");


            var user = await _context.Users.FirstOrDefaultAsync(u => u.username == tokenModel.Username);

            if(user == null)
                return NotFound("Kullanıcı adıyla eşleşen veri bulunamadı.");

            var existing = await _context.DeviceTokens
                .FirstOrDefaultAsync(t => t.Token == tokenModel.ClientToken);

            if (existing != null)
            {
                existing.UserId = user.Id; 
                _context.DeviceTokens.Update(existing);
            }
            else
            {
                var newToken = new DeviceToken
                {
                    UserId = user.Id,
                    Token = tokenModel.ClientToken
                };

                await _context.DeviceTokens.AddAsync(newToken);
            }

            await _context.SaveChangesAsync();
            return Ok(true);
        }

        // Kullanıcının tüm tokenlarını listeleme
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetTokens(int userId)
        {
            var tokens = await _context.DeviceTokens
                .Where(t => t.UserId == userId)
                .ToListAsync();

            if (!tokens.Any())
                return NotFound("Token bulunamadı.");

            return Ok(tokens);
        }

        // Kullanıcının tüm tokenlarını silme
        [HttpDelete("user/{userId}")]
        public async Task<IActionResult> DeleteTokens(int userId)
        {
            var tokens = await _context.DeviceTokens
                .Where(t => t.UserId == userId)
                .ToListAsync();

            if (!tokens.Any())
                return Ok(new { message = "Tokenlar silindi." });

            _context.DeviceTokens.RemoveRange(tokens);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Tokenlar silindi." });
        }

    }

    public class RegisterTokenModel
    {
        public string Username { get; set; }
        public string ClientToken { get; set; }
    }

}
