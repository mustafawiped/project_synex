using System.ComponentModel.DataAnnotations.Schema;
using System.Numerics;

namespace SynexApi.Models
{
    [Table("messages")]
    public class Message
    {
        [Column("id")]
        public long Id { get; set; }

        [Column("sender_id")]
        public int SenderId { get; set; }

        [Column("receiver_id")]
        public int ReceiverId { get; set; }

        [Column("content")]
        public string Content { get; set; } = null!;

        [Column("was_it_seen")]
        public bool WasItSeen { get; set; } = false;

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }

        [Column("seen_at")]
        public DateTime? SeenAt { get; set; }

        [Column("ConversationId")]
        public long ConversationId { get; set; }

        [Column("message_type")]
        public string MessageType { get; set; } = "text"; 
    }
}
