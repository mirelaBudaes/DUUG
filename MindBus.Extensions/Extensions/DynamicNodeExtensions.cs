using umbraco.MacroEngines;

namespace MindBus.Extensions.Extensions
{
    public static class DynamicNodeExtensions
    {
        public static string GetTitle(this DynamicNode dynamicNode)
        {
            dynamic node = new DynamicNode(dynamicNode.Id);

            return Util.Coalesce(node.NavivationTitle.ToString(), node.PageTitle.ToString(), node.Name.ToString());
        }
    }
}