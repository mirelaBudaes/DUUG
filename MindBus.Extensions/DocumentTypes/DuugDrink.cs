using Vega.USiteBuilder;

namespace MindBus.Extensions.DocumentTypes
{
    [DocumentType(Name = "DUUG Drink", IconUrl = "MB_beer.jpg", Thumbnail = "MB_beer.jpg", AllowedTemplates = new[] { "Event" }, DefaultTemplate = typeof(Event))]
    public class DuugDrink : Event
    {
    }
}