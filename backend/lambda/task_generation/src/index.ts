import { generateTaskTitlesFromAnthropic } from "./anthropicClient.ts";
import { createTaskGenerationHandler } from "./handler.ts";

type LambdaEnvironment = {
  CLAUDE_API_KEY?: string;
};

export function createLambdaHandler(dependencies?: {
  generateTasks?: (declarationTitle: string) => Promise<string[]>;
}) {
  const generateTasks =
    dependencies?.generateTasks ??
    (async (declarationTitle: string) => {
      const apiKey = getRequiredEnv("CLAUDE_API_KEY");
      return generateTaskTitlesFromAnthropic({
        apiKey,
        declarationTitle,
      });
    });

  return createTaskGenerationHandler({ generateTasks });
}

export const handler = createLambdaHandler();

function getRequiredEnv(name: keyof LambdaEnvironment): string {
  const value = process.env[name];
  if (typeof value !== "string" || value.trim() === "") {
    throw new Error(`${name} is required.`);
  }

  return value;
}
