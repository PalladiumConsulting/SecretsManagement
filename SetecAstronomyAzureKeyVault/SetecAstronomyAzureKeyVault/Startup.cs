using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(SetecAstronomyAzureKeyVault.Startup))]
namespace SetecAstronomyAzureKeyVault
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
