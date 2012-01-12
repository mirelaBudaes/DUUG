using System;
using Vega.USiteBuilder;

namespace MindBus.Extensions.DocumentTypes
{
    [DocumentType(Name = "Event", IconUrl = "MB_event.jpg", Thumbnail = "MB-event.jpg", AllowedTemplates = new[] { "Event" }, DefaultTemplate = typeof(Event))]
    public class Event : PageSettings
    {
        [DocumentTypeProperty(UmbracoPropertyType.DatePickerWithTime, Name = "Starting time", Tab = "Content", Description = "", Mandatory = true)]
        public string StartingTime { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.DatePickerWithTime, Name = "Ending time", Tab = "Content", Description = "", Mandatory = true)]
        public string EndingTime { get; set; }

        [Obsolete]
        [DocumentTypeProperty(UmbracoPropertyType.TrueFalse, Name = "Is DUUG Drink", Tab = "Content", Description = "", Mandatory = false)]
        public string IsDUUGDrink { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Location Name", Tab = "Content", Description = "", Mandatory = true)]
        public string Location { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Location City", Tab = "Content", Description = "", Mandatory = true)]
        public string LocationCity { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Other, OtherTypeName = "Multiple Textstring", Name = "Location Address", Tab = "Content", Description = "")]
        public string LocationAddress { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Other, OtherTypeName = "Agenda", Name = "Agenda", Tab = "Agenda", Description = "The time of the event")]
        public string Agenda { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.RichtextEditor, Name = "Content", Tab = "Content", Description = "", Mandatory = true)]
        public string BodyText { get; set; }
    }
}