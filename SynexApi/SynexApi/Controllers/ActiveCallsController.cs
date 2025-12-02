using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SynexApi.Data; 
using SynexApi.Models;
using System;
using System.Threading.Tasks;

namespace SynexApi.Controllers
{


    [ApiController]
    [Route("api/[controller]")]
    public class ActiveCallsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ActiveCallsController(AppDbContext context)
        {
            _context = context;
        }

        // Odaya katılım kontrolü (JoinRoom mantığı)
        [HttpGet("isUserInTheCall")]
        public async Task<IActionResult> IsUserInTheCall(int userId)
        {
            var existingCall = await _context.ActiveCalls.FirstOrDefaultAsync(x => (x.CallerId == userId || x.ReceiverId == userId));

            if (existingCall == null)
            {
                return Ok(false);
            }
            else
            {
                return Ok(true);
            }
        }

        // Odaya katılım kontrolü (JoinRoom mantığı)
        [HttpGet("getCalls/{userId}")]
        public async Task<IActionResult> GetCalls(int userId)
        {
            var existingCall = await _context.ActiveCalls.FirstOrDefaultAsync(x => x.ReceiverId == userId);

            if (existingCall == null)
            {
                return Ok(new {});
            }
            else
            {
                var callerUser = await _context.Users.FirstOrDefaultAsync(x => x.Id == existingCall.CallerId);

                var callerModel = new {
                    CallerUsername = callerUser.username,
                    CallerPhoto = callerUser.photo,
                    Call = existingCall
                };

                return Ok(callerModel);
            }
        }

        // Odaya katılım kontrolü (JoinRoom mantığı)
        [HttpGet("getCallHistory/{userId}")]
        public async Task<IActionResult> GetCallHistory(int userId)
        {
            var calls = await _context.CallHistory
                .Where(x => x.ReceiverId == userId || x.CallerId == userId)
                .OrderByDescending(x => x.StartedAt)
                .ToListAsync();

            if (!calls.Any())
            {
                return Ok(new List<object>());
            }
            var result = new List<object>();

            foreach (var call in calls)
            {
                int id = call.CallerId == userId ? call.ReceiverId : call.CallerId;

                var callerUser = await _context.Users.FirstOrDefaultAsync(x => x.Id == id);

                result.Add(new
                {
                    CallerUsername = callerUser?.username,
                    CallerPhoto = callerUser?.photo,
                    Call = call
                });
            }

            return Ok(result);
        }

    }

}
