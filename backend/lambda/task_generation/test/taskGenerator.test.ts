import assert from "node:assert/strict";
import test from "node:test";

import { parseTaskTitles } from "../src/taskGenerator.ts";

test("AIレスポンスにJSON配列が含まれる場合、タスク名の配列を返す", () => {
  const content = `
    以下がタスクです。
    ["教材を決める", "毎日の学習時間を決める", "初回の学習を実行する"]
  `;

  const tasks = parseTaskTitles(content);

  assert.deepEqual(tasks, [
    "教材を決める",
    "毎日の学習時間を決める",
    "初回の学習を実行する",
  ]);
});

test("AIレスポンスにタスクが格納された配列が存在しない場合、エラーを返す", () => {
  const content = "タスクの生成ってめんどくさいですよね。。";

  assert.throws(
    () => parseTaskTitles(content),
    /AI response does not contain a JSON array./,
  );
});

test("AIレスポンスのJSON配列に文字列以外が含まれる場合、エラーを返す", () => {
  const content = '["教材を決める", 123, "初回の学習を実行する"]';

  assert.throws(
    () => parseTaskTitles(content),
    /AI response JSON array must contain only strings./,
  );
});
