using System.ComponentModel.DataAnnotations.Schema;

namespace SynexApi.Models
{
    [Table("call_history")]
    public class CallHistory
    {
        [Column("id")]
        public int Id { get; set; }

        [Column("caller_id")]
        public int CallerId { get; set; }

        [Column("receiver_id")]
        public int ReceiverId { get; set; }

        [Column("status")]
        public required string Status { get; set; } // accepted / missed / rejected

        [Column("started_at")]
        public DateTime StartedAt { get; set; }

        [Column("ended_at")]
        public DateTime EndedAt { get; set; }
    }
}
