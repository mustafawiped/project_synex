using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using SynexApi.Data;
using SynexApi.Models;

namespace SynexApi.Hubs
{
    public class WebRTCHub : Hub
    {
        private readonly AppDbContext _context;

        public WebRTCHub(AppDbContext context)
        {
            _context = context;
        }
  
        // Bir kullanıcı odaya katıldığında tetiklenir
        public async Task JoinRoom(string roomId, int userId, int targetUserId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, roomId);

            var existingCall = await _context.ActiveCalls.FirstOrDefaultAsync(x => x.RoomId == roomId);

            if (existingCall == null)
            {
                var newCall = new ActiveCalls
                {
                    CallerId = userId,
                    ReceiverId = targetUserId,
                    RoomId = roomId,
                    Status = "ringing",
                    StartedAt = DateTime.UtcNow
                };

                _context.ActiveCalls.Add(newCall);
                await _context.SaveChangesAsync();

                var callerUser = await _context.Users.FirstOrDefaultAsync(x => x.Id == targetUserId);

                var callerModel = new
                {
                    CallerUsername = callerUser.username,
                    CallerPhoto = callerUser.photo,
                    Call = newCall
                };
                await Clients.Group($"activecallhub_{targetUserId}").SendAsync("IncomingCall", callerModel);

            }
            else
            {
                if (existingCall.ReceiverId == userId)
                {
                    existingCall.Status = "accepted";
                    await _context.SaveChangesAsync();
                }
            }


            await Clients.Group(roomId).SendAsync("UserJoined", Context.ConnectionId);
        }

        // Bir kullanıcı odadan ayrıldığında
        public async Task LeaveRoom(string roomId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, roomId);

            var existingCall = await _context.ActiveCalls.FirstOrDefaultAsync(x => x.RoomId == roomId);

            if (existingCall != null)
            {
                var history = new CallHistory
                {
                    CallerId = existingCall.CallerId,
                    ReceiverId = existingCall.ReceiverId,
                    Status = existingCall.Status,
                    StartedAt = existingCall.StartedAt,
                    EndedAt = DateTime.UtcNow
                };

                _context.CallHistory.Add(history);
                _context.ActiveCalls.Remove(existingCall);
                await _context.SaveChangesAsync();
                if(existingCall.Status == "ringing")
                    await Clients.Group($"activecallhub_{existingCall.ReceiverId}").SendAsync("IncomingCall", null);
            }

            await Clients.Group(roomId).SendAsync("UserLeft", Context.ConnectionId);
        }

        public async Task SendSignal(string roomId, object signal)
        {
            await Clients.OthersInGroup(roomId).SendAsync("SignalReceived", signal);
        }

        public async Task JoinActiveCallsHub(int userId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, $"activecallhub_{userId}");
        }
        public async Task LeaveActiveCallsHub(int userId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"activecallhub_{userId}");
        }
    }
}
