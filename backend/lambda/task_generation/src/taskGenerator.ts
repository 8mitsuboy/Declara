/**
 * AIのレスポンスから生成されたタスクを抽出し、配列として返す
 *
 * @param content AIが返却するJson文字列
 * @returns UIで表示するタスクの配列
 */

export function parseTaskTitles(content: string): string[] {
  const jsonArrayMatch = content.match(/\[[\s\S]*\]/);
  if (jsonArrayMatch === null) {
    throw new Error("AI response does not contain a JSON array.");
  }

  const parsed: unknown = JSON.parse(jsonArrayMatch[0]);
  if (
    !Array.isArray(parsed) ||
    !parsed.every((item) => typeof item === "string")
  ) {
    throw new Error("AI response JSON array must contain only strings.");
  }

  return parsed;
}
