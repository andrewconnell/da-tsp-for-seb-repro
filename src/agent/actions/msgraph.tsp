import "@typespec/http";
import "@microsoft/typespec-m365-copilot";
import "../models/msgraph.tsp";
import "../env.tsp";

using TypeSpec.Http;
using TypeSpec.M365.Copilot.Actions;

@service
@server(MicrosoftGraphAPI.SERVER_URL, MicrosoftGraphAPI.SERVER_DESCRIPTION)
@actions(MicrosoftGraphAPI.ACTIONS_METADATA)
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

  model Authentication is OAuth2Auth<[{
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
  @summary("Get current user profile")
  @doc("Retrieves the profile of the currently signed-in user, including their object ID")
  @returnsDoc("User profile retrieved successfully")
  @useAuth(MicrosoftGraphAPI.Authentication)
  op getCurrentUser(
    @doc("OData select to only get specific fields")
    @example("id,displayName,userPrincipalName")
    @query $select: string = "id,displayName,userPrincipalName"
  ): {
    @statusCode _: 200;
    @body $: MicrosoftGraphAPI.Models.Profile
  };
}
