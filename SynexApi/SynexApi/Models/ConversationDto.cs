using System.ComponentModel.DataAnnotations.Schema;

namespace SynexApi.Models
{
    [Table("conversations")]
    public class ConversationDto
    {
        [Column("id")]
        public long Id { get; set; }
        
        [Column("user1_id")]
        public int User1Id { get; set; }
        
        [Column("user2_id")]
        public int User2Id { get; set; }
        
        [Column("last_message_id")]
        public long? LastMessageId { get; set; }
        
        public Message LastMessage { get; set; } 
        
        [Column("updated_at")]
        public DateTime UpdatedAt { get; set; }
        
        [Column("unread_count_user1")]
        public int UnreadCountUser1 { get; set; }

        [Column("unread_count_user2")]
        public int UnreadCountUser2 { get; set; }
        public string OtherUsername { get; set; }
        public string OtherPhoto { get; set; }
    }

}
