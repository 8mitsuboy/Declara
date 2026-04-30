import { parseTaskTitles } from "./taskGenerator.ts";

export type TaskGenerationRequest = {
  body?: string | null;
};

export type TaskGenerationResponse = {
  statusCode: number;
  body: string;
};

type TaskGenerationDependencies = {
  generateTasks: (declarationTitle: string) => Promise<string[]>;
};

export function createTaskGenerationHandler({
  generateTasks,
}: TaskGenerationDependencies) {
  return async function handler(
    event: TaskGenerationRequest,
  ): Promise<TaskGenerationResponse> {
    const declarationTitle = extractDeclarationTitle(event.body);
    if (declarationTitle === null) {
      return jsonResponse(400, {
        message: "declarationTitle is required.",
      });
    }

    const content = await generateTasks(declarationTitle);
    return jsonResponse(200, {
      tasks: content,
    });
  };
}

function extractDeclarationTitle(
  body: string | null | undefined,
): string | null {
  if (body === undefined || body === null) {
    return null;
  }

  const parsedBody: unknown = JSON.parse(body);
  if (
    typeof parsedBody !== "object" ||
    parsedBody === null ||
    !("declarationTitle" in parsedBody)
  ) {
    return null;
  }

  const declarationTitle = (parsedBody as { declarationTitle?: unknown })
    .declarationTitle;
  if (typeof declarationTitle !== "string") {
    return null;
  }

  if (declarationTitle.trim() === "") {
    return null;
  }

  return declarationTitle.trim();
}

function jsonResponse(
  statusCode: number,
  payload: Record<string, unknown>,
): TaskGenerationResponse {
  return {
    statusCode,
    body: JSON.stringify(payload),
  };
}

export function parseGeneratedTasks(content: string): string[] {
  return parseTaskTitles(content);
}
