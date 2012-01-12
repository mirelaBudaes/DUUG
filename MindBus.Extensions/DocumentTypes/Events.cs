using Vega.USiteBuilder;

namespace MindBus.Extensions.DocumentTypes
{
    [DocumentType(Name = "Events overview", IconUrl = "MB_event.jpg", Thumbnail = "MB-event.jpg", AllowedTemplates = new[] { "Events" }, DefaultTemplate = typeof(Events), AllowedChildNodeTypes = new[] { typeof(Event), typeof(DuugDrink) })]
    public class Events : Overview
    {
        [DocumentTypeProperty(UmbracoPropertyType.SimpleEditor, Name = "Empty events message", Tab = "Content", Description = "This text will be shown if there are no upcoming events", Mandatory = false)]
        public string EmptyMessage { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Numeric, Name = "Items shown", Tab = "Content", Description = "How many future events to show. Empty or 0 means all.", Mandatory = false)]
        public string ItemsShown { get; set; }
    }
}