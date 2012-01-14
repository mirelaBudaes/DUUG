using System;
using Vega.USiteBuilder;

namespace MindBus.Extensions.DocumentTypes
{
    [DocumentType(Name = "News article", IconUrl = "MB-news.png", Thumbnail = "MB-news.png", AllowedTemplates = new[] { "NewsItem" }, DefaultTemplate = typeof(NewsItem), AllowedChildNodeTypes = new Type[] { })]
    public class NewsItem : PageSettings
    {
        [DocumentTypeProperty(UmbracoPropertyType.DatePicker, Name = "Published date", Tab = "Content", Description = "")]
        public string PublishedDate { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.SimpleEditor, Name = "Intro", Tab = "Content", Description = "This text will appear in the overview")]
        public string Intro { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.RichtextEditor, Name = "Content", Tab = "Content", Description = "")]
        public string BodyText { get; set; }
    }
}