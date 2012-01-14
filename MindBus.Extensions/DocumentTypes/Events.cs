using Vega.USiteBuilder;

namespace MindBus.Extensions.DocumentTypes
{
    [DocumentType(Name = "Events overview", IconUrl = "MB_event.jpg", Thumbnail = "MB-event.jpg", AllowedTemplates = new[] { "Events" }, DefaultTemplate = typeof(Events), AllowedChildNodeTypes = new[] { typeof(Event), typeof(DuugDrink), typeof(Events) })]
    public class Events : Overview
    {
        [DocumentTypeProperty(UmbracoPropertyType.Other, OtherTypeName = "Event Type Picker", Name = "Type of events", Tab = "Content", Description = "", Mandatory = true)]
        public string TypeOfEvents { get; set; }
    }
}