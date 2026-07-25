from __future__ import annotations

import sys
import unittest
from pathlib import Path

TOOLS_DIR = Path(__file__).resolve().parents[1]
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from sync_lean_command_outputs import (  # noqa: E402
    HashCommand,
    annotate_block,
    find_hash_commands,
    output_comment_lines,
    parse_json_messages,
    remove_generated_output_lines,
)


class FindHashCommandsTests(unittest.TestCase):
    def test_ignores_comments_and_finds_multiline_command(self) -> None:
        code = """-- #eval 999
#check Nat
#eval List.map
  (fun n => n + 1)
  [1, 2]
"""
        commands = find_hash_commands(code)
        self.assertEqual([command.name for command in commands], ["check", "eval"])
        self.assertEqual(commands[0].start_line, 1)
        self.assertEqual(commands[0].end_line, 1)
        self.assertEqual(commands[1].start_line, 2)
        self.assertEqual(commands[1].end_line, 4)
        self.assertEqual(
            commands[1].normalized_code,
            "#eval List.map (fun n => n + 1) [1, 2]",
        )


class JsonMessageTests(unittest.TestCase):
    def test_parses_lean_json_diagnostics(self) -> None:
        stdout = (
            '{"severity":"information","pos":{"line":3,"column":0},'
            '"endPos":{"line":3,"column":6},"data":"Nat : Type"}\n'
            '{"severity":"warning","pos":{"line":1,"column":0},"data":"ignored"}\n'
        )
        messages, non_json = parse_json_messages(stdout, Path("sample.lean"))
        self.assertEqual(non_json, [])
        self.assertEqual(
            [(message.line, message.data) for message in messages],
            [(3, "Nat : Type")],
        )

    def test_reports_non_json_stdout(self) -> None:
        messages, non_json = parse_json_messages("raw IO output\n", Path("sample.lean"))
        self.assertEqual(messages, [])
        self.assertEqual(non_json, ["raw IO output"])


class AnnotationTests(unittest.TestCase):
    def command(self, name: str, line: int, code: str) -> HashCommand:
        return HashCommand(
            name=name,
            start_line=line,
            end_line=line,
            indent="",
            normalized_code=code,
        )

    def test_renders_single_and_multiline_outputs(self) -> None:
        self.assertEqual(output_comment_lines("", ["5"]), ["-- 出力: 5"])
        self.assertEqual(
            output_comment_lines("  ", ["foo : Nat → Nat\nsecond line"]),
            ["  -- 出力:", "  --   foo : Nat → Nat", "  --   second line"],
        )

    def test_replaces_generated_comments_idempotently(self) -> None:
        source_commands = [
            (self.command("check", 0, "#check Nat"), ["Nat : Type"]),
            (self.command("eval", 1, "#eval 2 + 3"), ["5"]),
        ]
        block = [
            "#check Nat",
            "-- 出力: stale",
            "#eval 2 + 3",
            "-- 出力: 5",
        ]
        rendered, count = annotate_block(block, source_commands, "sample.lean")
        self.assertEqual(count, 2)
        self.assertEqual(
            rendered,
            [
                "#check Nat",
                "-- 出力: Nat : Type",
                "#eval 2 + 3",
                "-- 出力: 5",
            ],
        )
        rerendered, rerendered_count = annotate_block(rendered, source_commands, "sample.lean")
        self.assertEqual(rerendered_count, 2)
        self.assertEqual(rerendered, rendered)

    def test_removes_legacy_expected_output_hints(self) -> None:
        self.assertEqual(
            remove_generated_output_lines(
                [
                    '#eval 2 + 3  -- => 5',
                    '#eval migrate sample',
                    '-- =>',
                    '-- { id := 1, name := "Ada" }',
                    'def untouched := "-- => inside a string"',
                ]
            ),
            [
                '#eval 2 + 3',
                '#eval migrate sample',
                'def untouched := "-- => inside a string"',
            ],
        )

    def test_removes_multiline_generated_comment(self) -> None:
        self.assertEqual(
            remove_generated_output_lines(
                [
                    "#check foo",
                    "-- 出力:",
                    "--   foo : Nat → Nat",
                    "--   second line",
                    "def x := 1",
                ]
            ),
            ["#check foo", "def x := 1"],
        )


if __name__ == "__main__":
    unittest.main()
