namespace MindBus.Extensions.DocumentTypes
{
  using Vega.USiteBuilder;

  [DocumentType(Name = "Page Settings", IconUrl = "folder.gif", Thumbnail = "folder.png", AllowedChildNodeTypes = new[] { typeof(TextPage) })]
  public class PageSettings : DocumentTypeBase
  {
    [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Page title", Tab = "Page settings")]
    public string PageTitle { get; set; }

    [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Meta title", Tab = "Page settings")]
    public string MetaTitle { get; set; }

    [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Meta keywords", Tab = "Page settings")]
    public string MetaKeywords { get; set; }

    [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Meta description", Tab = "Page settings")]
    public string MetaDescription { get; set; }

    [DocumentTypeProperty(UmbracoPropertyType.Textstring, Name = "Navigation title", Tab = "Navigation")]
    public string NavigationTitle { get; set; }

    [DocumentTypeProperty(UmbracoPropertyType.TrueFalse, Name = "Hide in navigation?", Tab = "Navigation")]
    public string UmbracoNaviHide { get; set; }

    [DocumentTypeProperty(UmbracoPropertyType.TrueFalse, Name = "Hide in sitemap?", Tab = "Navigation")]
    public string HideInSitemap { get; set; }

    [DocumentTypeProperty(UmbracoPropertyType.TrueFalse, Name = "Show in top navigation?", Tab = "Navigation")]
    public string ShowInTopNavigation { get; set; }

    [DocumentTypeProperty(UmbracoPropertyType.TrueFalse, Name = "Show in main menu?", Tab = "Navigation")]
    public string ShowInMainMenu { get; set; }

    [DocumentTypeProperty(UmbracoPropertyType.TrueFalse, Name = "Show in footer menu?", Tab = "Navigation")]
    public string ShowInFooterMenu { get; set; }
  }
}
