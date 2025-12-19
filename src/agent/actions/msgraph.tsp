import "@typespec/http";
import "@microsoft/typespec-m365-copilot";
import "../models/msgraph.tsp";
import "../env.tsp";

using TypeSpec.Http;
// using TypeSpec.M365.Copilot.Actions;

namespace MicrosoftGraphAPI {
  const SERVER_DESCRIPTION = "Microsoft Graph API v1.0";
  const SERVER_URL = "https://graph.microsoft.com/v1.0";

  const ACTIONS_METADATA = #{
    nameForHuman: "Microsoft Graph API",
    descriptionForHuman: "Subset of the Microsoft Graph REST API for getting a user and working with items in SharePoint lists.",
    descriptionForModel: "Subset of the Microsoft Graph REST API for getting a user and working with items in SharePoint lists.",
    contactEmail: "andrew@voitanos.io"
  };

  alias AUTHORIZATION_ENDPOINT = "https://login.microsoftonline.com/${Environment.TEAMS_APP_TENANT_ID}/oauth2/v2.0/authorize";
  alias TOKEN_ENDPOINT = "https://login.microsoftonline.com/${Environment.TEAMS_APP_TENANT_ID}/oauth2/v2.0/token";

  model PtoRequestAgent_MSGraphOAuth is OAuth2Auth<[{
    type: OAuth2FlowType.authorizationCode;
    authorizationUrl: AUTHORIZATION_ENDPOINT;
    tokenUrl: TOKEN_ENDPOINT;
    refreshUrl: TOKEN_ENDPOINT;
    scopes: [
      "https://graph.microsoft.com/User.Read",
      "https://graph.microsoft.com/Sites.ReadWrite.All"
    ];
  }]>;

  @route("/me")
  @get
  @doc("Retrieves the profile of the currently signed-in user, including their object ID")
  @returnsDoc("User profile retrieved successfully")
  op getCurrentUser(
    @doc("OData select to only get specific fields")
    @example("id,displayName,userPrincipalName")
    @query $select: string = "id,displayName,userPrincipalName"
  ): {
    @statusCode _: 200;
    @body $: MicrosoftGraphAPI.Models.UserProfile
  };

  @route("/sites/{siteId}/lists/{listId}/items")
  @get
  @doc("Retrieves PTO information for an employee based on their Entra ID object ID")
  @returnsDoc("Employee PTO data retrieved successfully")
  op getEmployeePTOData(
    @doc("The SharePoint site ID")
    @path siteId: string,

    @doc("The SharePoint list ID containing PTO data")
    @path listId: string,

    @doc("OData filter to find employee by object ID (UserObjectId field)")
    @example("fields/UserObjectId eq 'user-object-id'")
    @query $filter: string,

    @doc("OData query option to expand the fields collection with selected columns")
    @example("fields($select=Title,UserObjectId,TotalPTO,UsedPTO)")
    @query $expand: string = "fields($select=Title,UserObjectId,TotalPTO,UsedPTO)"
  ): {
    @statusCode _: 200;
    @body $: MicrosoftGraphAPI.Models.PTODataResponse
  };

  @route("/sites/{siteId}/lists/{listId}/items/{itemId}")
  /*
   * TypeSpec's HTTP library version 1.0.0+ changed so @patch operations no longer
   * automatically make the request body optional. What it means: In older
   * versions, @patch would implicitly make body properties optional (since
   * PATCH typically does partial updates). In 1.0.0+, this behavior was removed
   * for explicitness.
   *
   * Because the `UpdatePTORequest` body is already explicitly defined with
   * required fields, the current behavior is fine for this use case. But adding
   * `implicitOptionality:false` to suppress a TSP warning in VSCode.
   */
  @patch(#{ implicitOptionality:false })
  @doc("Updates the UsedPTO field for an employee after PTO request approval")
  @returnsDoc("PTO data updated successfully")
  op updateEmployeePTOData(
    @doc("The SharePoint site ID")
    @path siteId: string,

    @doc("The SharePoint list ID containing PTO data")
    @path listId: string,

    @doc("The SharePoint list item ID to update")
    @path itemId: string,

    @doc("The PTO data to update")
    @body body: MicrosoftGraphAPI.Models.UpdatePTORequest
  ): {
    @statusCode _: 200;
    @body $: MicrosoftGraphAPI.Models.PTOBalanceListItem
  };
}
