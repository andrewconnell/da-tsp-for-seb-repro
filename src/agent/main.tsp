import "@typespec/http";
import "@typespec/openapi3";
import "@microsoft/typespec-m365-copilot";
import "./actions/msgraph.tsp";
import "./prompts/instructions.tsp";
import "./env.tsp";

using TypeSpec.M365.Copilot.Agents;

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

namespace PtoRequest {
  op pto_policy_doc is AgentCapabilities.OneDriveAndSharePoint<ItemsBySharePointIds = [
    { itemId: "00000000-0000-0000-0000-000000000000" }
  ]>;

  op getCurrentUser is global.MicrosoftGraphAPI.getCurrentUser;
}
