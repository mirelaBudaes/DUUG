using System;
using umbraco.NodeFactory;

namespace MindBus.Extensions.MasterPages
{
    public partial class Main : System.Web.UI.MasterPage
    {
        protected string CurrentNodeTypeAlias { get; set; }
    
        protected void Page_Load(object sender, EventArgs e)
        {
            Node currentNode = Node.GetCurrent();
            CurrentNodeTypeAlias = currentNode.NodeTypeAlias.ToLower();
        }
    }
}