using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace SynexApi.Models
{
    [Table("stories")]
    public class Stories
    {
        [Column("Id")]
        public int Id { get; set; }

        [Column("UserId")]
        public int UserId { get; set; }

        [Column("Content")]
        public string Content { get; set; }

        [Column("ContentMsg")]
        public string ContentMsg { get; set; }

        [Column("SeenBy")]
        public List<int> SeenBy { get; set; } = new List<int>();

        [Column("CreatedAt")]
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }

}
