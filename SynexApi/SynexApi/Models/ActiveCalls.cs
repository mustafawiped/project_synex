using System.ComponentModel.DataAnnotations.Schema;

namespace SynexApi.Models
{
    [Table("active_calls")]
    public class ActiveCalls
    {
        [Column("id")]
        public int Id { get; set; }

        [Column("room_id")]
        public string RoomId { get; set; } = string.Empty;

        [Column("caller_id")]
        public int CallerId { get; set; }

        [Column("receiver_id")]
        public int ReceiverId { get; set; } 

        [Column("status")]
        public string Status { get; set; } = "ringing"; // ringing, accepted, rejected vs.

        [Column("started_at")]
        public DateTime StartedAt { get; set; } = DateTime.UtcNow;
    }
}
