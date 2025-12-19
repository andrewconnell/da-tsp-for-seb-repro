import "@typespec/http";
import "@typespec/openapi3";
import "@microsoft/typespec-m365-copilot";
import "./actions/msgraph.tsp";
import "./prompts/instructions.tsp";
import "./env.tsp";

using TypeSpec.Http;
using TypeSpec.M365.Copilot.Agents;
using TypeSpec.M365.Copilot.Actions;

@agent(
  "PTO Request (TSP)",
  "A declarative agent that helps manage PTO requests by retrieving employee data and updating used PTO days."
)
@instructions(Prompts.INSTRUCTIONS)

@conversationStarter(#{
  title:"Vacation Request",
  text: "Apply for time off."
})
@conversationStarter(#{
  title: "Vacation Request - Paris, France",
  text: "Request PTO for a long weekend in Paris starting next Friday."
})
@conversationStarter(#{
  title: "PTO - Pyongyang, North Korea",
  text: "Request PTO in Pyongyang."
})

namespace PtoRequestAgent {

  // this won't work due to https://github.com/OfficeDev/microsoft-365-agents-toolkit/issues/15028
  // op pto_policy_doc is AgentCapabilities.OneDriveAndSharePoint<ItemsBySharePointIds = [
  //   { itemId: Environment.SPO_PTO_POLICY_DOC_ID }
  // ]>;
  // ... must use literal :(
  op pto_policy_doc is AgentCapabilities.OneDriveAndSharePoint<ItemsBySharePointIds = [
    { itemId: "00000000-0000-0000-0000-000000000000" }
  ]>;

  @service
  @server(MicrosoftGraphAPI.SERVER_URL, MicrosoftGraphAPI.SERVER_DESCRIPTION)
  @actions(MicrosoftGraphAPI.ACTIONS_METADATA)
  @useAuth(MicrosoftGraphAPI.PtoRequestAgent_MSGraphOAuth)
  namespace MicrosoftGraphApiActions{
    // used to get the current user's EntraIdUser.ObjectId property
    @summary("Get current user profile")
    op getCurrentUser is MicrosoftGraphAPI.getCurrentUser;

    @summary("Get employee PTO data from SharePoint list")
    op getEmployeePTOData is MicrosoftGraphAPI.getEmployeePTOData;

    @summary("Update employee used PTO")
    op updateEmployeePTOData is MicrosoftGraphAPI.updateEmployeePTOData;
  }
}
