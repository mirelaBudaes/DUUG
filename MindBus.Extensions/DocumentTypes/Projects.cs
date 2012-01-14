using Vega.USiteBuilder;

namespace MindBus.Extensions.DocumentTypes
{
        [DocumentType(Name = "Projects overview", IconUrl = "MB_project.jpg", Thumbnail = "MB_project.jpg", AllowedTemplates = new[] { "Projects" }, DefaultTemplate = typeof(Projects), AllowedChildNodeTypes = new[] { typeof(Project), typeof(Projects)})]
    public class Projects : Overview
    {
    }
}