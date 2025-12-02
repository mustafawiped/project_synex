using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SynexApi.Data;
using SynexApi.Models;

namespace SynexApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly AppDbContext _context;
        public UsersController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/users
        [HttpGet]
        public async Task<IActionResult> GetUsers()
        {
            var users = await _context.Users.ToListAsync();
            return Ok(users);
        }

        // POST: api/users
        [HttpPost]
        public async Task<IActionResult> CreateUser(User user)
        {
            var control = await _context.Users.FirstOrDefaultAsync(u => u.username == user.username);

            if (control != null)
            {
                return BadRequest("Bu kullanıcı adına sahip bir kullanıcı zaten var.");
            }

            _context.Users.Add(user);
            await _context.SaveChangesAsync();
            
            return CreatedAtAction(nameof(GetUserById), new { id = user.Id }, user);
        }

        // GET: api/users/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetUserById(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return NotFound();

            return Ok(user);
        }

        // PUT: api/users/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateUser(int id, User updatedUser)
        {
            if (id != updatedUser.Id)
                return BadRequest("ID eşleşmiyor.");

            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return NotFound();

            user.username = updatedUser.username;
            user.email = updatedUser.email;
            user.password = updatedUser.password;

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/users/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return NotFound();

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        // POST: api/users/auth
        [HttpPost("auth")]
        public async Task<IActionResult> Authenticate([FromBody] LoginRequest login)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.username == login.Username);

            if (user == null)
            {
                return NotFound("Böyle bir kullanıcı yok.");
            }

            if (user.password != login.Password)
            {
                return Unauthorized("Bu kullanıcı adıyla şifre uyuşmuyor.");
            }

            return Ok("Başarıyla hesaba giriş yapıldı!");
        }

        // -------------------
        // Profil fotoğrafı güncelleme
        // -------------------
        [HttpPost("change-photo")]
        public async Task<IActionResult> ChangePhoto([FromBody] ChangeProfileRequest request)
        {
            if (request.Username == "" || request.photoUrl == "")
                return BadRequest("Kullanıcı adı veya fotoğraf url boş");

            var user = await _context.Users.FirstOrDefaultAsync(u => u.username == request.Username);
            if (user == null) return NotFound("Kullanıcı bulunamadı");

            user.photo = request.photoUrl;


            await _context.SaveChangesAsync();
            return Ok("Başarıyla güncellendi");
        }

        // -------------------
        // hakkında değiştirme
        // -------------------
        [HttpPost("change-about")]
        public async Task<IActionResult> ChangeAbout([FromBody] ChangeAboutRequest request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.username == request.Username);
            if (user == null) return NotFound("User not found");
            user.about = request.About;
            await _context.SaveChangesAsync();
            return Ok("About updated");
        }

        // -------------------
        // 3. Title değiştirme
        // -------------------
        [HttpPost("change-title")]
        public async Task<IActionResult> ChangeTitle([FromBody] ChangeTitleRequest request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.username == request.Username);
            if (user == null) return NotFound("User not found");

            user.title = request.Title;
            await _context.SaveChangesAsync();
            return Ok("Title updated");
        }

        // -------------------
        // 4. Şifre değiştirme
        // -------------------
        [HttpPost("change-password")]
        public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequest request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.username == request.Username);
            if (user == null) return NotFound("User not found");

            user.password = request.password;
            await _context.SaveChangesAsync();
            return Ok("Password updated");
        }

        // -------------------
        // 5. Kullanıcı adı değiştirme
        // -------------------
        [HttpPost("change-newusername")]
        public async Task<IActionResult> ChangeUsername([FromBody] ChangeUsernameRequest request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.username == request.Username);
            if (user == null) return NotFound("User not found");

            user.username = request.newusername;
            await _context.SaveChangesAsync();
            return Ok("Username updated");
        }

        // -------------------
        // Kullanıcı bilgisi getir
        // -------------------
        [HttpGet("get-user/{username}")]
        public async Task<IActionResult> GetUser(string username)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.username == username);

            if (user == null)
                return NotFound("User not found");

            return Ok(user);
        }

        [HttpGet("get-all-user/{username}")]
        public async Task<IActionResult> GetAllUsersExcep(string username)
        {
            var users = await _context.Users
                .Where(u => u.username != username) // username hariç tut
                .ToListAsync();

            if (users == null || !users.Any())
                return NotFound("Kullanıcı bulunamadı");

            return Ok(users);
        }


    }

    public class LoginRequest
    {
        public string Username { get; set; } = "";
        public string Password { get; set; } = "";
    }

    public class ChangeAboutRequest
    {
        public string Username { get; set; } = "";
        public string About { get; set; } = "";
    }
    public class ChangeTitleRequest
    {
        public string Username { get; set; } = "";
        public string Title { get; set; } = "";
    }

    public class ChangePasswordRequest
    {
        public string Username { get; set; } = "";
        public string password { get; set; } = "";
    }

    public class ChangeUsernameRequest
    {
        public string Username { get; set; } = "";
        public string newusername { get; set; } = "";
    }

    public class ChangeProfileRequest
    {
        public string Username { get; set; } = "";
        public string photoUrl { get; set; } = "";
    }
}
