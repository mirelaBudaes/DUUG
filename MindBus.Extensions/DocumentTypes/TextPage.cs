namespace MindBus.Extensions.DocumentTypes
{
  using Vega.USiteBuilder;

  [DocumentType(Name = "Text page", IconUrl = "page.png", Thumbnail = "docWithImage.png", AllowedTemplates = new[] { "TextPage" }, DefaultTemplate = typeof(TextPage))]
  public class TextPage : PageSettings
  {
    [DocumentTypeProperty(UmbracoPropertyType.RichtextEditor, Name = "Content", Tab = "Content", Description = "")]
    public string BodyText { get; set; }
  }
}