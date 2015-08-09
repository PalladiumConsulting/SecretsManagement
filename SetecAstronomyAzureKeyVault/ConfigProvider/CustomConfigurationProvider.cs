using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace ConfigProvider
{
    class CustomConfigurationProvider:ProtectedConfigurationProvider
    {
        public override void Initialize(string name, NameValueCollection config)
        {
            base.Initialize(name, config);
        }

        public override XmlNode Decrypt(XmlNode encryptedNode)
        {
            // We'll flesh this out below.
            throw new NotImplementedException();
        }

        public override XmlNode Encrypt(XmlNode node)
        {
            throw new NotImplementedException();
        }
    }
}
