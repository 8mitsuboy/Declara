import assert from "node:assert/strict";
import test from "node:test";

import { createTaskGenerationHandler } from "./handler.ts";

test("有効な宣言タイトルを受け取ると tasks を返す", async () => {
  const handler = createTaskGenerationHandler({
    generateTasks: async (declarationTitle) => {
      assert.equal(declarationTitle, "毎日英語を勉強する");
      return ["教材を決める", "毎日の学習時間を決める"];
    },
  });

  const response = await handler({
    body: JSON.stringify({ declarationTitle: "毎日英語を勉強する" }),
  });

  assert.equal(response.statusCode, 200);
  assert.equal(
    response.body,
    JSON.stringify({ tasks: ["教材を決める", "毎日の学習時間を決める"] }),
  );
});

test("declarationTitle が空なら 400 を返す", async () => {
  const handler = createTaskGenerationHandler({
    generateTasks: async () => {
      throw new Error("should not be called");
    },
  });

  const response = await handler({
    body: JSON.stringify({ declarationTitle: "   " }),
  });

  assert.equal(response.statusCode, 400);
  assert.equal(
    response.body,
    JSON.stringify({ message: "declarationTitle is required." }),
  );
});
