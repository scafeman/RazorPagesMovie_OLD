using System;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;

namespace RazorPagesMovie
{
    public class Program
    {
        public static object Args1 => Args2;

        public static object Args2 { get; }

        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }

        private static object GetArgs()
        {
            throw new NotImplementedException();
        }

        private static object CreateWebHostBuilder(object args)
        {
            throw new NotImplementedException();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) => WebHost.CreateDefaultBuilder(args)
                .UseStartup<Startup>();
    }
}
