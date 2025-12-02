using System.ComponentModel.DataAnnotations.Schema;

namespace SynexApi.Models
{
    [Table("devicetokens")]
    public class DeviceToken
    {
        [Column("Id")]
        public int Id { get; set; }

        [Column("UserId")]
        public int UserId { get; set; }

        [Column("Token")]
        public string Token { get; set; }
    }

}
