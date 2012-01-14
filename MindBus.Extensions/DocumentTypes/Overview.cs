namespace MindBus.Extensions.DocumentTypes
{
    using Vega.USiteBuilder;

    [DocumentType(Name = "Overview", IconUrl = "page.png", Thumbnail = "docWithImage.png", AllowedTemplates = new[] { "Events", "Projects" }, DefaultTemplate = typeof(Events), AllowedChildNodeTypes = new[] { typeof(Event), typeof(Project)})]
    public class Overview : PageSettings
    {
        [DocumentTypeProperty(UmbracoPropertyType.SimpleEditor, Name = "Empty events message", Tab = "Content", Description = "This text will be shown if there are no upcoming events", Mandatory = false)]
        public string EmptyMessage { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Numeric, Name = "Items shown", Tab = "Content", Description = "How many items to show. Empty or 0 means all.", Mandatory = false)]
        public string ItemsShown { get; set; }

        [DocumentTypeProperty(UmbracoPropertyType.Numeric, Name = "Items shown per page", Tab = "Content", Description = "How many item to show per page. Empty or 0 means the list will not be paginated.", Mandatory = false)]
        public string ItemsShownPerPage { get; set; }
    }
}