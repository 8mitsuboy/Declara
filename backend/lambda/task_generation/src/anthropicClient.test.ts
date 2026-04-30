import assert from "node:assert/strict";
import test from "node:test";

import { generateTaskTitlesFromAnthropic } from "./anthropicClient.ts";

test("宣言タイトルを Anthropic に送ってタスク名を返す", async () => {
  const calls: Array<Request> = [];
  const fetchImpl = async (input: RequestInfo | URL, init?: RequestInit) => {
    calls.push(new Request(input, init));
    return new Response(
      JSON.stringify({
        content: [
          {
            text: '["教材を決める", "毎日の学習時間を決める"]',
          },
        ],
      }),
      {
        headers: {
          "content-type": "application/json",
        },
      },
    );
  };

  const tasks = await generateTaskTitlesFromAnthropic({
    apiKey: "test-api-key",
    declarationTitle: "毎日英語を勉強する",
    fetchImpl,
  });

  assert.deepEqual(tasks, ["教材を決める", "毎日の学習時間を決める"]);
  assert.equal(calls.length, 1);
  assert.equal(calls[0].url, "https://api.anthropic.com/v1/messages");
  assert.equal(calls[0].headers.get("x-api-key"), "test-api-key");
});

test("Anthropic のレスポンスに text がない場合はエラーになる", async () => {
  const fetchImpl = async () =>
    new Response(
      JSON.stringify({
        content: [{}],
      }),
      {
        headers: {
          "content-type": "application/json",
        },
      },
    );

  await assert.rejects(
    () =>
      generateTaskTitlesFromAnthropic({
        apiKey: "test-api-key",
        declarationTitle: "毎日英語を勉強する",
        fetchImpl,
      }),
    /Anthropic response does not contain text content\./,
  );
});
