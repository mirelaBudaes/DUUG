
namespace MindBus.Extensions.DocumentTypes
{
    using Vega.USiteBuilder;

    [DocumentType(Name = "Home", IconUrl = "page.png", Thumbnail = "docWithImage.png", AllowedTemplates = new[] { "Home" }, DefaultTemplate = typeof(Home))]
    public class Home : PageSettings
    {
    }
}