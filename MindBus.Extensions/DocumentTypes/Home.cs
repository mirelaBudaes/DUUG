
namespace MindBus.Extensions.DocumentTypes
{
    using Vega.USiteBuilder;

    [DocumentType(Name = "Home", IconUrl = "MB-home.png", Thumbnail = "docWithImage.png", AllowedTemplates = new[] { "Home" }, DefaultTemplate = typeof(Home))]
    public class Home : PageSettings
    {
    }
}