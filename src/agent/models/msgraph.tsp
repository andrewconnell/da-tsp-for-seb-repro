import "@typespec/http";

using TypeSpec.Http;

namespace MicrosoftGraphAPI.Models;

@mediaTypeHint("application/json")
model UserProfile {
  @doc("The unique identifier (Object Id) for the user.")
  id: string;

  @doc("The name displayed in the address book for the user.")
  displayName: string;

  @doc("The user principal name (UPN) of the user.")
  userPrincipalName: string;
}

@doc("PTO Balance item from the SharePoint list")
model PTOBalanceListItemFields {
  @doc("Employee display name")
  Title: string;

  @doc("Employee Entra ID Object ID")
  UserObjectId: string;

  @doc("Total annual PTO hours allocated")
  TotalPTO: integer;

  @doc("PTO hours already used")
  UsedPTO: integer;
}

@doc("A SharePoint list item containing PTO data")
model PTOBalanceListItem {
  @doc("The SharePoint list item ID")
  id: string;

  @doc("The PTO fields for this list item")
  fields: PTOBalanceListItemFields;
}

@mediaTypeHint("application/json")
@doc("Response containing employee PTO data from SharePoint")
model PTODataResponse {
  @doc("Array of PTO list items matching the filter")
  value: PTOBalanceListItem[];
}

@doc("Fields to update for PTO data")
model UpdatePTOFields {
  @doc("The new total used PTO hours")
  UsedPTO: integer;
}

@mediaTypeHint("application/json")
@doc("Request body for updating employee PTO data")
model UpdatePTORequest {
  @doc("The fields to update")
  fields: UpdatePTOFields;
}
