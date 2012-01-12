namespace MindBus.Extensions.DocumentTypes
{
    using Vega.USiteBuilder;

    [DocumentType(Name = "Site Settings", IconUrl = "sitemap_color.png", Thumbnail = "developer.png", AllowedChildNodeTypes = new[] { typeof(Overview), typeof(TextPage), typeof(Home), typeof(Events) })]
    public class SiteSettings : DocumentTypeBase
    {
        [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Site title", Tab = "Settings", Description = "This will be part of the Meta title.")]
        public string SiteTitle { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.ContentPicker, Name = "Homepage", Tab = "Settings", Description = "The item that you pick here will be the homepage of your site.")]
        public string UmbracoInternalRedirectId { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.TextboxMultiple, Name = "Google Analytics Code", Tab = "Settings", Description = "Paste your Google Analytics code here to get statistics of your website")]
        public string GoogleAnalyticsCode { get; set; }
    }
}
