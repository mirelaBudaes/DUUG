namespace MindBus.Extensions.EventHandlers
{
  using System;
  using System.Web;
  using System.Web.UI;

  using umbraco.BusinessLogic;
  using umbraco.cms.businesslogic;
  using umbraco.cms.businesslogic.media;
  using umbraco.cms.businesslogic.web;

  public class RefreshOnUpload : ApplicationBase
  {
    public RefreshOnUpload()
    {
      CMSNode.AfterSave += RedirectIfNeeded;
    }

    private static void RedirectIfNeeded(object sender, SaveEventArgs e)
    {
      if (sender is Document == false && sender is Media == false)
      {
        return;
      }

      // Check if image cropper is specified on this document type
      var hasImageCropper = false;

      var contentType = sender.GetType().ToString();
      switch (contentType)
      {
        case "umbraco.cms.businesslogic.web.Document":
          hasImageCropper = HasImageCropper(sender as Document);
          break;
        case "umbraco.cms.businesslogic.media.Media":
          hasImageCropper = HasImageCropper(sender as Media);
          break;
      }

      // If there's no cropper or else no files uploaded
      if (hasImageCropper == false || HttpContext.Current.Request.Files.Count == 0 || string.IsNullOrEmpty(HttpContext.Current.Request.Files[0].FileName))
      {
        return;
      }

      // If we have gotten so far, a file is being uploaded, make sure there is a redirect!
      if (((Page)HttpContext.Current.Handler).Items.Contains("RedirectUrl"))
      {
        ((Page)HttpContext.Current.Handler).Items.Remove("RedirectUrl");
      }

      ((Page)HttpContext.Current.Handler).Items.Add("RedirectUrl", HttpContext.Current.Request.Url.ToString());
      ((Page)HttpContext.Current.Handler).PreRender += PreRender;
    }

    private static bool HasImageCropper(Content node)
    {
      bool hasImageCropper = false;
      foreach (var p in node.GenericProperties)
      {
        if (p.PropertyType.DataTypeDefinition.DataType.ToString() == "umbraco.editorControls.imagecropper.DataType")
        {
          hasImageCropper = true;
        }
      }

      return hasImageCropper;
    }

    private static void PreRender(object sender, EventArgs e)
    {
      if (((Page)HttpContext.Current.Handler).Items.Contains("RedirectUrl") && string.IsNullOrEmpty((string)((Page)HttpContext.Current.Handler).Items["RedirectUrl"]) == false)
      {
        HttpContext.Current.Response.Redirect((string)((Page)HttpContext.Current.Handler).Items["RedirectUrl"]);
      }
    }
  }
}
