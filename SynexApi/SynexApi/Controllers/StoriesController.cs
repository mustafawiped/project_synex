using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using SynexApi.Data;
using SynexApi.Models;

namespace SynexApi.Controllers
{


    [Route("api/[controller]")]
    [ApiController]
    public class StoriesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public StoriesController(AppDbContext context)
        {
            _context = context;
        }

        [HttpPost("add")]
        public async Task<IActionResult> AddStory([FromBody] Stories story)
        {
            _context.Stories.Add(story);
            await _context.SaveChangesAsync();
            return Ok();
        }

        [HttpGet("getAllStories")]
        public async Task<IActionResult> GetAllStories()
        {
            var groupedStories = await _context.Stories
                .Join(_context.Users,
                      s => s.UserId,
                      u => u.Id,
                      (s, u) => new
                      {
                          s.Id,
                          s.UserId,
                          s.Content,
                          s.ContentMsg,
                          s.SeenBy,
                          s.CreatedAt,
                          u.username,
                          u.photo
                      })
                .GroupBy(s => new { s.UserId, s.username, s.photo})
                .Select(g => new
                {
                    userId = g.Key.UserId,
                    username = g.Key.username,
                    photoUrl = g.Key.photo,
                    storys = g.Select(st => new
                    {
                        st.Id,
                        st.Content,
                        st.ContentMsg,
                        st.SeenBy,
                        st.CreatedAt
                    }).ToList()
                })
                .ToListAsync();

            return Ok(groupedStories);
        }




        [HttpDelete("deleteStory/{storyId}")]
        public async Task<IActionResult> DeleteStory(int storyId)
        {
            var story = await _context.Stories.FindAsync(storyId);
            if (story == null) return NotFound();

            _context.Stories.Remove(story);
            await _context.SaveChangesAsync();
            return Ok();
        }

        [HttpPost("markStoriesAsSeen")]
        public async Task<IActionResult> MarkStoriesAsSeen([FromBody] SeenRequest request)
        {
            var stories = await _context.Stories
                .Where(s => s.UserId == request.storyOwnerId)
                .ToListAsync();

            if (!stories.Any())
                return NotFound("Bu kullanıcıya ait hikaye yok.");

            foreach (var story in stories)
            {
                // SeenBy JSON string'ini listeye çevir
                var seenByList = story.SeenBy;

                if (!seenByList.Contains(request.seeUserId))
                {
                    seenByList.Add(request.seeUserId);
                    story.SeenBy = seenByList;
                }
            }

            await _context.SaveChangesAsync();

            return Ok(new { message = "Kullanıcı tüm hikayeleri görmüş olarak işaretlendi." });
        }

    }

    public class SeenRequest
    {
        public int storyOwnerId { get; set; }
        public int seeUserId { get; set; }
    }
}
