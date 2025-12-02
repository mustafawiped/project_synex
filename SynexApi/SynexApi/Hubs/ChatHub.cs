namespace SynexApi.Hubs
{
    using Microsoft.AspNetCore.SignalR;
    using Microsoft.EntityFrameworkCore;
    using SynexApi.Data;
    using SynexApi.Models;

    public class ChatHub : Hub
    {
        private readonly AppDbContext _context;
        private readonly IHubContext<ConversationHub> _conversationHub;

        public ChatHub(AppDbContext context, IHubContext<ConversationHub> conversationHub)
        {
            _context = context;
            _conversationHub = conversationHub;
        }

        public async Task JoinConversation(int conversationId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, $"conversation_{conversationId}");
        }

        public async Task LeaveConversation(int conversationId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"conversation_{conversationId}");
        }

        public async Task SendMessage(Message message)
        {
            if (message == null)
                throw new HubException("Message is null");

            message.CreatedAt = DateTime.UtcNow;
            message.WasItSeen = false;

            try
            {
                _context.Messages.Add(message);
                await _context.SaveChangesAsync();

                // İlgili conversation'ı bul
                var conversation = await _context.Conversations.FindAsync((long)message.ConversationId);
                if (conversation == null)
                    throw new HubException("Conversation not found");

                // Last message id güncelle
                conversation.LastMessageId = message.Id;

                // unread count güncelle
                if (message.SenderId == conversation.User1Id)
                {
                    conversation.UnreadCountUser2 = conversation.UnreadCountUser2 + 1;
                }
                else if (message.SenderId == conversation.User2Id)
                {
                    conversation.UnreadCountUser1 = conversation.UnreadCountUser1 + 1;
                }

                var dto = await _context.Conversations
                    .Where(c => c.Id == conversation.Id)
                    .Select(c => new ConversationDto
                    {
                        Id = c.Id,
                        User1Id = c.User1Id,
                        User2Id = c.User2Id,
                        LastMessageId = message.Id,
                        LastMessage = message,
                        UpdatedAt = c.UpdatedAt,
                        UnreadCountUser1 = conversation.UnreadCountUser1,
                        UnreadCountUser2 = conversation.UnreadCountUser2,
                        OtherUsername = _context.Users
                            .Where(u => u.Id == c.User2Id)
                            .Select(u => u.username)
                            .FirstOrDefault(),
                        OtherPhoto = _context.Users
                            .Where(u => u.Id == c.User2Id)
                            .Select(u => u.photo)
                            .FirstOrDefault()
                    })
                    .FirstOrDefaultAsync();



                var dto2 = await _context.Conversations
                 .Where(c => c.Id == conversation.Id)
                 .Select(c => new ConversationDto
                 {
                     Id = c.Id,
                     User1Id = c.User1Id,
                     User2Id = c.User2Id,
                     LastMessageId = message.Id,
                     LastMessage = message,
                     UpdatedAt = c.UpdatedAt,
                     UnreadCountUser1 = conversation.UnreadCountUser1,
                     UnreadCountUser2 = conversation.UnreadCountUser2,
                     OtherUsername = _context.Users
                         .Where(u => u.Id == c.User1Id)
                         .Select(u => u.username)
                         .FirstOrDefault(),
                     OtherPhoto = _context.Users
                         .Where(u => u.Id == c.User1Id)
                         .Select(u => u.photo)
                         .FirstOrDefault()
                 })
                 .FirstOrDefaultAsync();

                await _conversationHub.Clients.Group($"conversation_{conversation.User1Id}")
                    .SendAsync("ConversationUpdated", dto);

                await _conversationHub.Clients.Group($"conversation_{conversation.User2Id}")
                .SendAsync("ConversationUpdated", dto2);

                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Inner exception: " + ex.InnerException?.Message);
                throw new HubException("Database error: " + ex.Message);
            }

            await Clients.Group($"conversation_{message.ConversationId}")
                         .SendAsync("ReceiveMessage", message);
        }



        public async Task SeenMessage(long messageId, long userId)
        {
            var message = await _context.Messages.FindAsync(messageId);
            if (message == null) return;

            message.WasItSeen = true;
            message.SeenAt = DateTime.UtcNow;

            var conversation = await _context.Conversations.FindAsync(message.ConversationId);
            if (conversation != null)
            {
                if (userId == conversation.User1Id)
                {
                    if(conversation.UnreadCountUser1 != 0)
                    {

                    conversation.UnreadCountUser1 = conversation.UnreadCountUser1 - 1;
                    } else
                    {
                        conversation.UnreadCountUser1 = 0;
                    }
                }
                else if (userId == conversation.User2Id)
                {
                    if (conversation.UnreadCountUser2 != 0)
                    {

                        conversation.UnreadCountUser2 = conversation.UnreadCountUser2 - 1;
                    }
                    else
                    {
                        conversation.UnreadCountUser2 = 0;
                    }
                }
                

                // ConversationDto oluştur
              
                    var dto = await _context.Conversations
                    .Where(c => c.Id == conversation.Id)
                    .Select(c => new ConversationDto
                    {
                        Id = c.Id,
                        User1Id = c.User1Id,
                        User2Id = c.User2Id,
                        LastMessageId = c.LastMessageId,
                        LastMessage = _context.Messages
                             .Where(u => u.Id == c.LastMessageId)
                             .FirstOrDefault(),
                        UpdatedAt = c.UpdatedAt,
                        UnreadCountUser1 = conversation.UnreadCountUser1,
                        UnreadCountUser2 = conversation.UnreadCountUser2,
                        OtherUsername = _context.Users
                            .Where(u => u.Id == c.User2Id)
                            .Select(u => u.username)
                            .FirstOrDefault(),
                        OtherPhoto = _context.Users
                            .Where(u => u.Id == c.User2Id)
                            .Select(u => u.photo)
                            .FirstOrDefault()
                    })
                    .FirstOrDefaultAsync();

                    

                    var dto2 = await _context.Conversations
                     .Where(c => c.Id == conversation.Id)
                     .Select(c => new ConversationDto
                     {
                         Id = c.Id,
                         User1Id = c.User1Id,
                         User2Id = c.User2Id,
                         LastMessageId = c.LastMessageId,
                         LastMessage = _context.Messages
                             .Where(u => u.Id == c.LastMessageId)
                             .FirstOrDefault(),
                         UpdatedAt = c.UpdatedAt,
                         UnreadCountUser1 = conversation.UnreadCountUser1,
                         UnreadCountUser2 = conversation.UnreadCountUser2,
                         OtherUsername = _context.Users
                             .Where(u => u.Id == c.User1Id)
                             .Select(u => u.username)
                             .FirstOrDefault(),
                         OtherPhoto = _context.Users
                             .Where(u => u.Id == c.User1Id)
                             .Select(u => u.photo)
                             .FirstOrDefault()
                     })
                     .FirstOrDefaultAsync();

                await _conversationHub.Clients.Group($"conversation_{conversation.User1Id}")
                    .SendAsync("ConversationUpdated", dto);

                await _conversationHub.Clients.Group($"conversation_{conversation.User2Id}")
                .SendAsync("ConversationUpdated", dto2);

                
            }

            await _context.SaveChangesAsync();

            await Clients.Group($"conversation_{message.ConversationId}")
                         .SendAsync("MessageSeen", new
                         {
                             messageId = message.Id,
                             seenAt = message.SeenAt
                         });
        }

        public async Task MessageDeleted(long messageId, long userId)
        {
            var message = await _context.Messages.FindAsync(messageId);
            if (message == null)
                throw new HubException("Message not found");

            // sadece gönderen silebilsin
            if (message.SenderId != userId)
                throw new HubException("Not authorized to delete this message");

            var conversation = await _context.Conversations.FindAsync((long)message.ConversationId);
            if (conversation == null)
                throw new HubException("Conversation not found");

            // mesajı sil
            _context.Messages.Remove(message);

            // eğer silinen mesaj son mesajsa LastMessageId güncelle
            if (conversation.LastMessageId == message.Id)
            {
                var lastMessage = await _context.Messages
                    .Where(m => m.ConversationId == message.ConversationId && m.Id != message.Id)
                    .OrderByDescending(m => m.CreatedAt)
                    .FirstOrDefaultAsync();

                conversation.LastMessageId = lastMessage?.Id;
            }

            // unread count azalt
            if (!message.WasItSeen)
            {
                if (message.ReceiverId == conversation.User1Id)
                {
                    conversation.UnreadCountUser1 = Math.Max(0, conversation.UnreadCountUser1 - 1);
                }
                else if (message.ReceiverId == conversation.User2Id)
                {
                    conversation.UnreadCountUser2 = Math.Max(0, conversation.UnreadCountUser2 - 1);
                }
            }

            // tek seferde db update
            await _context.SaveChangesAsync();

            // clientlara bildir
            await Clients.Group($"conversation_{message.ConversationId}")
                         .SendAsync("MessageDeleted", messageId);
        }

    }
}
