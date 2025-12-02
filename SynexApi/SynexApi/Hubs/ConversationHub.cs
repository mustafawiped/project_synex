using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using SynexApi.Data;
using SynexApi.Models;

namespace SynexApi.Hubs
{
    public class ConversationHub : Hub
    {
        private readonly AppDbContext _context;

        public ConversationHub(AppDbContext context)
        {
            _context = context;
        }

        public async Task JoinConversation(int userId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, $"conversation_{userId}");
        }
        public async Task LeaveConversation(int userId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"conversation_{userId}");
        }
    }
}
