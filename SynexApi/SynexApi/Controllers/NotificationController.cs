using FirebaseAdmin.Messaging;
using Microsoft.AspNetCore.Mvc;

namespace SynexApi.Controllers
{


    [ApiController]
    [Route("api/[controller]")]
    public class NotificationController : ControllerBase
    {
        private readonly FirebaseMessaging _firebaseMessaging;

        public NotificationController(FirebaseMessaging firebaseMessaging)
        {
            _firebaseMessaging = firebaseMessaging;
        }

        [HttpPost("send")]
        public async Task<IActionResult> SendNotification([FromBody] NotificationRequest request)
        {
            var androidConfig = new AndroidConfig
            {
                Priority = (request.ConversationId == -1)
        ? Priority.High  // arama için yüksek öncelik
        : Priority.Normal,

                Notification = new AndroidNotification
                {
                    Title = request.Title,
                    Body = request.Body,
                    Sound = (request.ConversationId == -1) ? "default" : "default",
                    ChannelId = (request.ConversationId == -1) ? "calls" : "messages",
                    VibrateTimingsMillis = (request.ConversationId == -1)
            ? new long[] { 0, 500, 1000, 500 } // uzun titreşim pattern
            : new long[] { 0, 200, 100, 200 }  // kısa titreşim
                }
            };

            var message = new Message()
            {
                Token = request.DeviceToken, 
                Notification = new FirebaseAdmin.Messaging.Notification
                {
                    Title = request.Title,
                    Body = request.Body
                },
                Data = new Dictionary<string, string>()
                {
                    { "conversationId", request.ConversationId.ToString() }, 
                    { "type", request.Type } 
                },
                Android = androidConfig
            };

            string response = await _firebaseMessaging.SendAsync(message);
            return Ok(new { MessageId = response });
        }
    }

    public class NotificationRequest
    {
        public string DeviceToken { get; set; }
        public string Title { get; set; }
        public string Body { get; set; }
        public int ConversationId { get; set; }
        public string Type { get; set; }
    }

}
