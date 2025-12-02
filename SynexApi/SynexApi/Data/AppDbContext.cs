using Microsoft.EntityFrameworkCore;
using SynexApi.Models;

namespace SynexApi.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<User> Users => Set<User>();
        public DbSet<Message> Messages { get; set; } = null!;
        public DbSet<Conversation> Conversations { get; set; } = null!;
        public DbSet<ActiveCalls> ActiveCalls { get; set; } = null!;
        public DbSet<CallHistory> CallHistory { get; set; } = null!;
        public DbSet<DeviceToken> DeviceTokens { get; set; }
        public DbSet<Stories> Stories { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Message>()
                .Property(m => m.WasItSeen)
                .HasDefaultValue(false);

            modelBuilder.Entity<Message>()
                .Property(m => m.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP");

            modelBuilder.Entity<Conversation>()
                .Property(c => c.UpdatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP");
        }
    }
}
