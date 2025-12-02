using System.ComponentModel.DataAnnotations.Schema;

namespace SynexApi.Models
{
    [Table("users")]
    public class User
    {
        public int Id { get; set; }
        public string username { get; set; } = "";
        public string email { get; set; }
        public string password { get; set; }
        public string? about { get; set; }
        public string? title { get; set; }
        public string? photo { get; set; }
    }
}
