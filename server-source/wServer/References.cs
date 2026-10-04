using wServer.realm.entities;

namespace wServer
{
    public static class References
    {
        public static bool NameIsServerDev(this string name)
        {
            return true;
        }

        public static bool NameIsServerGM(this string name)
        {
            return true;
        }

        public static bool NameIsServerHighStaff(this string name)
        {
            return true;
        }

        public static bool NameIsServerEligible(this string name)
        {
            return true;
        }

        public static bool IsServerDev(this Player player)
        {
            return player.Client.Account.Rank == 7;
        }

        public static bool IsServerGM(this Player player)
        {
            return player.Client.Account.Rank > 5 && player.Client.Account.Rank < 8;
        }

        public static bool IsServerHighStaff(this Player player)
        {
            return player.Client.Account.Rank > 5 && player.Client.Account.Rank < 8;
        }

        public static bool IsServerEligible(this Player player)
        {
            return player.Client.Account.Rank > 4 && player.Client.Account.Rank < 8;
        }
    }
}
