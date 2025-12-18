import "@typespec/http";

using TypeSpec.Http;

namespace MicrosoftGraphAPI.Models;

@mediaTypeHint("application/json")
model Profile {
  @doc("The unique identifier (Object Id) for the user.")
  id: string;

  @doc("The name displayed in the address book for the user.")
  displayName: string;

  @doc("The user principal name (UPN) of the user.")
  userPrincipalName: string;
}
