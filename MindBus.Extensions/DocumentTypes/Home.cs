
namespace MindBus.Extensions.DocumentTypes
{
    using Vega.USiteBuilder;

    [DocumentType(Name = "Home", IconUrl = "MB-home.png", Thumbnail = "docWithImage.png", AllowedTemplates = new[] { "Home" }, DefaultTemplate = typeof(Home))]
    public class Home : PageSettings
    {
        [DocumentTypeProperty(UmbracoPropertyType.Numeric, Name = "Projects shown", Tab = "Content",
           Description = "How many projecs to show.", DefaultValue = "2", Mandatory = false)]
        public string ProjectsShown { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Numeric, Name = "Events shown", Tab = "Content", Description = "How many events to show.", Mandatory = false, DefaultValue = "2")]
        public string EventsShown { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Other, OtherTypeName = "Event Type Picker", Name = "Type of events", Tab = "Content", Description = "", Mandatory = true)]
        public string TypeOfEvents { get; set; }
    }
}