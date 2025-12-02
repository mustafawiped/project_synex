using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SynexApi.Data;
using SynexApi.Models;

namespace SynexApi.Controllers
{

    [ApiController]
    [Route("api/[controller]")]
    public class ConversationsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ConversationsController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserConversations(int userId)
        {
            var conversations = await _context.Conversations
                .Where(c => c.User1Id == userId || c.User2Id == userId)
                .OrderByDescending(c => c.UpdatedAt)
                .Select(c => new ConversationDto
                {
                    Id = c.Id,
                    User1Id = c.User1Id,
                    User2Id = c.User2Id,
                    LastMessageId = c.LastMessageId,
                    LastMessage = c.LastMessageId != null
                        ? _context.Messages.FirstOrDefault(m => m.Id == c.LastMessageId)
                        : null,
                    UpdatedAt = c.UpdatedAt,
                    UnreadCountUser1 = c.UnreadCountUser1,
                    UnreadCountUser2 = c.UnreadCountUser2,

                    OtherUsername = (c.User1Id == userId
                ? _context.Users.FirstOrDefault(u => u.Id == c.User2Id).username
                : _context.Users.FirstOrDefault(u => u.Id == c.User1Id).username),
                    OtherPhoto = (c.User1Id == userId
                ? _context.Users.FirstOrDefault(u => u.Id == c.User2Id).photo
                : _context.Users.FirstOrDefault(u => u.Id == c.User1Id).photo)
                })
                .ToListAsync();

            return Ok(conversations);
        }

        [HttpPost("get-or-create")]
        public async Task<ActionResult<Conversation>> GetOrCreateConversation(int user1Id, int user2Id)
        {
            var conversation = await _context.Conversations
                .FirstOrDefaultAsync(c =>
                    (c.User1Id == user1Id && c.User2Id == user2Id) ||
                    (c.User1Id == user2Id && c.User2Id == user1Id));

            if (conversation == null)
            {
                conversation = new Conversation
                {
                    User1Id = user1Id,
                    User2Id = user2Id,
                };
                _context.Conversations.Add(conversation);
                await _context.SaveChangesAsync();
            }

            return Ok(conversation);
        }


    }

}
