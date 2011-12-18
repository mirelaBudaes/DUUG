namespace MindBus.Extensions.DocumentTypes
{
    using Vega.USiteBuilder;

    [DocumentType(Name = "Project", IconUrl = "page.png", Thumbnail = "docWithImage.png", AllowedTemplates = new[] { "Project" }, DefaultTemplate = typeof(Project))]
    public class Project : PageSettings
    {
        [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Author", Tab = "Content", Description = "", Mandatory = true)]
        public string Author { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Author email", Tab = "Content", Description = "")]
        public string AuthorEmail { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Website", Tab = "Content", Description = "", Mandatory = true, ValidationRegExp = @"(mailto\:|(news|(ht|f)tp(s?))\://){1}\S+")]
        public string Website { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Umbraco community page", Tab = "Content", Description = "Project page url from our.umbraco.org ")]
        public string UmbracoPage { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Twitter", Tab = "Content", Description = "")]
        public string Twitter { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.TextboxMultiple, Name = "Introduction", Tab = "Content", Description = "Short introduction of the project")]
        public string Introduction { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.RichtextEditor, Name = "Content", Tab = "Content", Description = "")]
        public string BodyText { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Other, OtherTypeName = "Media Picker (DAMP)", Name = "Image gallery", Tab = "Image gallery", Description = "")]
        public string Gallery { get; set; }
    }
}