import { parseTaskTitles } from "./taskGenerator.ts";

type GenerateTaskTitlesFromAnthropicArgs = {
  apiKey: string;
  declarationTitle: string;
  fetchImpl?: typeof fetch;
};

export async function generateTaskTitlesFromAnthropic({
  apiKey,
  declarationTitle,
  fetchImpl = fetch,
}: GenerateTaskTitlesFromAnthropicArgs): Promise<string[]> {
  const response = await fetchImpl("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
      "x-api-key": apiKey,
    },
    body: JSON.stringify({
      model: "claude-haiku-4-5-20251001",
      max_tokens: 1024,
      messages: [
        {
          role: "user",
          content: buildPrompt(declarationTitle),
        },
      ],
    }),
  });

  if (!response.ok) {
    throw new Error(`Anthropic request failed with status ${response.status}.`);
  }

  const payload: unknown = await response.json();
  const text = extractTextContent(payload);

  return parseTaskTitles(text);
}

function buildPrompt(declarationTitle: string): string {
  return [
    "あなたはタスク分解の専門家です。",
    "以下の宣言を3〜7個の具体的なタスクに分解してください。",
    "JSON配列形式で、各要素は文字列としてタスク名のみを返してください。",
    "説明や番号は不要です。JSON配列のみを返してください。",
    "",
    `宣言: ${declarationTitle}`,
  ].join("\n");
}

function extractTextContent(payload: unknown): string {
  if (
    typeof payload !== "object" ||
    payload === null ||
    !("content" in payload) ||
    !Array.isArray((payload as { content?: unknown }).content)
  ) {
    throw new Error("Anthropic response is missing content.");
  }

  const firstContent = (payload as { content: unknown[] }).content[0];
  if (
    typeof firstContent !== "object" ||
    firstContent === null ||
    !("text" in firstContent) ||
    typeof (firstContent as { text?: unknown }).text !== "string"
  ) {
    throw new Error("Anthropic response does not contain text content.");
  }

  return (firstContent as { text: string }).text;
}
