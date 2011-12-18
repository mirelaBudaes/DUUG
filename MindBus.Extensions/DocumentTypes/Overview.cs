using MindBus.Extensions.MasterPages;

namespace MindBus.Extensions.DocumentTypes
{
    using Vega.USiteBuilder;

    [DocumentType(Name = "Overview", IconUrl = "page.png", Thumbnail = "docWithImage.png", AllowedTemplates = new[] { "Events", "Projects" }, DefaultTemplate = typeof(Events), AllowedChildNodeTypes = new[] { typeof(Event), typeof(Project)})]
    public class Overview : PageSettings
    {
    }
}