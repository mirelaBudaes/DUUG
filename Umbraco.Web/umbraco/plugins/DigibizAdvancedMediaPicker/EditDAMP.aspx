<%@ Page Language="c#" MasterPageFile="../../masterpages/umbracoDialog.Master" Title="Select media item" CodeBehind="EditDAMP.aspx.cs" Inherits="DigibizAdvancedMediaPicker.EditDamp" AutoEventWireup="True"%>

<asp:Content ContentPlaceHolderID="head" runat="server">

  <script type="text/javascript">
      // Save handlers for IDataFields		
      var saveHandlers = new Array()

      function addSaveHandler(handler) {
          saveHandlers[saveHandlers.length] = handler;
      }

      function invokeSaveHandlers() {
          for (var i = 0; i < saveHandlers.length; i++) {
              eval(saveHandlers[i]);
          }
      }

      function SetNodeId(id) {
          UmbClientMgr.closeModalWindow(id);
      }

  </script>

</asp:Content>
<asp:Content ContentPlaceHolderID="body" runat="server">
  <asp:PlaceHolder ID="plc" runat="server"></asp:PlaceHolder>
  <input id="doSave" type="hidden" name="doSave" runat="server">
  <input id="doPublish" type="hidden" name="doPublish" runat="server">
</asp:Content>