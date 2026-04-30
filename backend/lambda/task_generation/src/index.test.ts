import assert from "node:assert/strict";
import test from "node:test";

import { createLambdaHandler } from "./index.ts";

test("Lambda entrypoint は generateTasks で返した tasks をそのまま返す", async () => {
  const handler = createLambdaHandler({
    generateTasks: async () => ["教材を決める"],
  });

  const response = await handler({
    body: JSON.stringify({ declarationTitle: "毎日英語を勉強する" }),
  });

  assert.equal(response.statusCode, 200);
  assert.equal(response.body, JSON.stringify({ tasks: ["教材を決める"] }));
});
