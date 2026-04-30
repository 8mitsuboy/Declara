import { SSMClient, GetParameterCommand } from "@aws-sdk/client-ssm";
import { generateTaskTitlesFromAnthropic } from "./anthropicClient.ts";
import { createTaskGenerationHandler } from "./handler.ts";

const ssmClient = new SSMClient({});
let apiKeyPromise: Promise<string> | undefined;

function getDefaultApiKey(): Promise<string> {
  if (!apiKeyPromise) {
    apiKeyPromise = fetchApiKeyFromSsm(getRequiredEnv("CLAUDE_API_KEY_SSM_PATH"));
  }
  return apiKeyPromise;
}

export function createLambdaHandler(dependencies?: {
  generateTasks?: (declarationTitle: string) => Promise<string[]>;
  getApiKey?: () => Promise<string>;
}) {
  const getApiKey = dependencies?.getApiKey ?? getDefaultApiKey;

  const generateTasks =
    dependencies?.generateTasks ??
    (async (declarationTitle: string) => {
      const apiKey = await getApiKey();
      return generateTaskTitlesFromAnthropic({ apiKey, declarationTitle });
    });

  return createTaskGenerationHandler({ generateTasks });
}

export const handler = createLambdaHandler();

async function fetchApiKeyFromSsm(path: string): Promise<string> {
  const command = new GetParameterCommand({
    Name: path,
    WithDecryption: true,
  });
  const response = await ssmClient.send(command);
  const value = response.Parameter?.Value;
  if (!value) throw new Error(`SSM parameter ${path} has no value.`);
  return value;
}

function getRequiredEnv(name: string): string {
  const value = process.env[name];
  if (typeof value !== "string" || value.trim() === "") {
    throw new Error(`${name} is required.`);
  }
  return value;
}
