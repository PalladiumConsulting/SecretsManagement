using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography.X509Certificates;
using System.Web;
using System.Web.Caching;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace SetecAstronomyConjurAWS
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected async void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            try
            {
                var authURI = "https://54.237.112.94/api/authn/users/"
                + HttpUtility.UrlEncode("host/" + System.Configuration.ConfigurationManager.AppSettings["APIUser"])
                + "/authenticate";
                ServicePointManager.ServerCertificateValidationCallback +=
        (sender, cert, chain, sslPolicyErrors) => true;
                var client = new HttpClient();
                var content = new StringContent(System.Configuration.ConfigurationManager.AppSettings["APIKey"]);
                var resp = await client.PostAsync(authURI, content);

                resp.EnsureSuccessStatusCode();

                var token = await resp.Content.ReadAsStringAsync();
                token = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(token.Replace(Environment.NewLine, "")));

                var variableUri = "https://54.237.112.94/api/variables/TestVariable/value";
                client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Token", "token=\"" + token + "\"");
                resp = await client.GetAsync(variableUri);
                resp.EnsureSuccessStatusCode();

                HttpRuntime.Cache.Insert("SecretTestVariable", await resp.Content.ReadAsStringAsync());
            }
            catch (Exception ex)
            {
                HttpRuntime.Cache.Insert("SecretTestVariable", ex.ToString());
            }
        }

    }
}
