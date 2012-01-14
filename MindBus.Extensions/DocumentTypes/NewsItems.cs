using Vega.USiteBuilder;

namespace MindBus.Extensions.DocumentTypes
{
        [DocumentType(Name = "News overview", IconUrl = "MB-news.png", Thumbnail = "MB-news.png", AllowedTemplates = new[] { "NewsItems" }, DefaultTemplate = typeof(NewsItems), AllowedChildNodeTypes = new[] { typeof(NewsItem), typeof(NewsItems) })]
    public class NewsItems : Overview
    {
    }
}