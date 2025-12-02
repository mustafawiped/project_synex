using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.SignalR;
using SynexApi.Data;
using SynexApi.Models;
using SynexApi.Hubs;


namespace SynexApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class MessagesController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IHubContext<ChatHub> _hub;
        private readonly IWebHostEnvironment _env;

        public MessagesController(AppDbContext context, IHubContext<ChatHub> hub, IWebHostEnvironment env)
        {
            _context = context;
            _hub = hub;
            _env = env;
        }

        // Birebir sohbet mesajlarını getir
        [HttpGet("chat/{userId1}/{userId2}")]
        public async Task<IActionResult> GetMessages(int userId1, int userId2)
        {
            var messages = await _context.Messages
                .Where(m => (m.SenderId == userId1 && m.ReceiverId == userId2) ||
                            (m.SenderId == userId2 && m.ReceiverId == userId1))
                .OrderBy(m => m.CreatedAt)
                .ToListAsync();

            return Ok(messages);
        }

        [HttpPost("upload-image")]
        [Consumes("multipart/form-data")]
        public async Task<IActionResult> UploadImage([FromForm] string username, IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("File is missing");
            }

            var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "uploads");
            if (!Directory.Exists(uploadsFolder))
                Directory.CreateDirectory(uploadsFolder);

            var fileName = Guid.NewGuid() + Path.GetExtension(file.FileName);
            var filePath = Path.Combine(uploadsFolder, fileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            var url = $"{Request.Scheme}://{Request.Host}/uploads/{fileName}";
            Console.WriteLine($"File saved! URL: {url}");

            return Ok(new { url });
        }



        [HttpGet("conversation/{conversationId}")]
        public async Task<ActionResult<IEnumerable<Message>>> GetMessages(int conversationId)
        {
            var messages = await _context.Messages
                .Where(m => m.ConversationId == conversationId)
                .OrderBy(m => m.CreatedAt)
                .ToListAsync();

            return Ok(messages);
        }

    }
}
